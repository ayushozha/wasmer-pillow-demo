# Wasmer/next-bundle compatibility investigation for next 16.3.8 (2026-10-22)

Base: upstream `main` @ `5ef12e4c8bd0de3e22e89c2181ee77a35925ec8b`. Path replayed exactly as before (`replay_next.sh`: Anybuild v0.33.0 plan → staged `pnpm install` (pnpm 10.34.7, only `package.json` + `pnpm-lock.yaml`, node.bzl env) → `pnpm dlx next-bundle@1.0.0 --build-command 'pnpm run build'` → `node .next-bundle/server.mjs`, Node 24.22.1). Routes checked: `/`, `/blog`, all 7 posts, `/does-not-exist`, and up to 60 same-origin assets per page.

## Verdict
**Found a small, supported fix: `security-fix-wasmer-compat.patch`. All routes return 200 (the 404 route returns 404 as expected). OG image routes were not requested here. They were already 500 on base because outbound fetch is blocked in this sandbox.**

The patch is `security-fix.patch` plus two lines:
- `package.json`: `"@swc/helpers": "0.5.23"`. This is the exact version next 16.3.8 depends on, and the lockfile already includes it.
- `next.config.mjs`: `transpilePackages: ["shiki"]`. This documented Next option bundles shiki instead of loading it through Turbopack's hashed external alias.

`git apply --check` passes on a clean 5ef12e4 checkout. Diff stat: next.config.mjs +1, package.json +2/−2 (+1 dep), pnpm-lock.yaml (same lock as `security-fix-with-swc-helpers.patch`). The staged `pnpm install` (frozen lockfile, CI=true) passed.

This is still a workaround for two next-bundle@1.0.0 bugs. PR46 stays **DRAFT/HOLD** until root decides whether to take the extra two lines upstream. Both bugs should still be reported to wasmerio (see below). Nothing here is marked READY.

## Results
| candidate | change on top of `security-fix.patch` | `/` | `/blog` | 7 posts | log |
| --- | --- | --- | --- | --- | --- |
| prior | none | 200 | 500 (@swc/helpers) | 500 | `replay-sec-magicui.log` |
| prior | `@swc/helpers` dep | 200 | 200 | 5×200, 2×500 (shiki) | `replay-swc-magicui.log` |
| C2 | `transpilePackages: ["shiki"]` only | 200 | 500 (@swc/helpers) | 500 | `replay-compat-transpile-only-magicui.log` |
| C3 | `output: "standalone"` only | 200 | 500 (@swc/helpers) | 500 | `replay-compat-standalone-magicui.log` |
| **C1** | `@swc/helpers` dep + `transpilePackages: ["shiki"]` | **200** | **200** | **7×200** | `replay-compat-swc-transpile-magicui.log` |

Control: running `next start` on the C1 build serves all the same routes with 200 and returns 404 for the missing page (`next-start-compat.log`). The shiki code blocks are highlighted client-side (`code-block.tsx` is `"use client"` and calls `codeToHtml` in `useEffect`), so the SSR HTML is the same as before. The shiki chunks are served as static assets.

## Why each option does or does not help
- **@swc/helpers (`/blog` 500).** `next/dist/client/lib/console.js` requires `@swc/helpers/_/_interop_require_default` through the pnpm symlink `.pnpm/next@…/node_modules/@swc/helpers`. next-bundle's `materializeCoveredNodeModulesSymlinks` (bin/build.mjs) only scans directories that contain traced *files*. The scope dir `.pnpm/next@…/node_modules/@swc` contains only symlinks, so the link is never recreated. A direct dependency adds a top-level `node_modules/@swc/helpers` link, which the bundle does preserve.
  - `transpilePackages`/`serverExternalPackages` cannot fix this: the require comes from Next's own prebuilt runtime, not app code.
  - `outputFileTracingIncludes` was not adopted. It only feeds per-page traces, not the next-server trace, and it would need a fragile `.pnpm/next@<peer-hash>` glob.
- **shiki (`Cannot find package 'shiki-<hash>'`, also on 16.1.1).** shiki is on Next's default server-external list, so Turbopack emits a hashed external alias that next-bundle does not resolve. `transpilePackages: ["shiki"]` makes Turbopack bundle it, so no alias is needed. Next accepted this without a conflict warning.
- **`output: "standalone"`.** No effect. next-bundle hardcodes `standalone: false` and always reads `.next/next-server.js.nft.json`. Its only documented options are `--output`, `--project-root`, `--build-command`, `--install-command` and `--skip-build`.
- **pnpm `package.json` field.** pnpm 10.34.7's `getOptionsFromRootManifest` reads only allowNonAppliedPatches, allowBuilds, allowUnusedPatches, allowedDeprecatedVersions, auditConfig, configDependencies, executionEnv, ignorePatchFailures, ignoredBuiltDependencies, ignoredOptionalDependencies, neverBuiltDependencies, onlyBuiltDependencies(File), overrides, packageExtensions, patchedDependencies, peerDependencyRules, requiredScripts, supportedArchitectures and updateConfig. `publicHoistPattern`, `shamefullyHoist` and `nodeLinker` would have to go in `.npmrc` or `pnpm-workspace.yaml`, and Anybuild stages neither, so this was not tested.

## Advisory floor recheck
`adv.py next@16.3.8 next@16.4.2` (npm bulk advisory endpoint), run 2026-10-22T05:30Z: both return 0 advisories (`npm-advisories-recheck-2026-10-22.txt`). 16.3.8 is still the floor.

## Upstream bugs to report to wasmerio/next-bundle
1. Symlinks inside scoped directories that hold only symlinks (pnpm `.pnpm/<pkg>/node_modules/@scope/<dep>`) are not materialized, so `@swc/helpers` cannot be resolved with next ≥16.3.
2. Turbopack hashed external aliases (`<pkg>-<hash>`) are not resolved in the bundle. This also affects the 16.1.1 base.
