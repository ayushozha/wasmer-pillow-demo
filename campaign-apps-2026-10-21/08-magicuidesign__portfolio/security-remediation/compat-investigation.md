# Wasmer/next-bundle compatibility investigation for next 16.3.8 (2026-10-22)

Base: upstream `main` @ `5ef12e4c8bd0de3e22e89c2181ee77a35925ec8b`. Path replayed exactly as before (`replay_next.sh`: Anybuild v0.33.0 plan → staged `pnpm install` (pnpm 10.34.7, only `package.json` + `pnpm-lock.yaml`, node.bzl env) → `pnpm dlx next-bundle@1.0.0 --build-command 'pnpm run build'` → `node .next-bundle/server.mjs`, Node 24.22.1). Routes checked: `/`, `/blog`, all 7 posts, `/does-not-exist`, and up to 60 same-origin assets per page.

## Verdict
**Found a small, supported fix for the page routes: `security-fix-wasmer-compat.patch`. `/`, `/blog` and all 7 posts return 200 (the 404 route returns 404 as expected). The three OG image routes still return 500 on the next-bundle path. That is a module/runtime failure in next-bundle's packaging of `runtime = "edge"` functions, present on base 16.1.1 too, and it happens before any network fetch (see "OG image routes" below).**

> Correction (2026-10-22): an earlier version of this file said the OG 500s were caused by blocked outbound fetches, and the C1 run never requested the OG routes. That was wrong for the next-bundle path. The raw server logs show a `require` ReferenceError in all three OG functions.

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

## OG image routes (corrected; re-run 2026-10-22)
Routes from `src/app`: `opengraph-image.tsx`, `blog/opengraph-image.tsx`, `blog/[slug]/opengraph-image.tsx`, all `export const runtime = "edge"`. Requested: `/opengraph-image`, `/blog/opengraph-image`, `/blog/api-design-principles/opengraph-image`, `/blog/typescript-best-practices/opengraph-image`.

Earlier runs already showed the module error in all three OG functions:
- base 16.1.1, `replay-base-magicui.log` lines 199-204:
  `ReferenceError: require is not defined in ES module scope, you can use import instead`
  `    at <unknown> (.next-bundle/functions/opengraph-image.func/index.js:2:33)` (same for `blog/opengraph-image.func` line 202 and `blog/[slug]/opengraph-image.func` line 204)
- 16.3.8, `replay-sec-magicui.log` lines 233-238: the same ReferenceError, `at <unknown> (.next-bundle/functions/opengraph-image.func/index.js:2:49)` (and `blog/…` line 236, `blog/[slug]/…` line 238).

| run | `/`, `/blog`, 7 posts | 4 OG requests | class | evidence |
| --- | --- | --- | --- | --- |
| C1 candidate, exact replay (`security-fix-wasmer-compat.patch` + README diff) | 200 | 500 | **(a)** module/runtime error before any fetch | `replay-compat-og-magicui.log` lines 210-217: `ReferenceError: require is not defined in ES module scope` at `functions/opengraph-image.func/index.js:2:49`, `functions/blog/opengraph-image.func/index.js:2:49`, `functions/blog/[slug]/opengraph-image.func/index.js:2:49` (twice). No fetch is logged. |
| control: `next start` on the same build | 200 | no response (connection closed) | **(b)** remote fetch, egress blocked | `next-start-compat-og.log` line 22 `Can't load image https://dillion.io/me.png: fetch failed`, then line 26 `Image size cannot be determined`. Line 13: Node 24 `fetch("https://dillion.io/me.png")` → `getaddrinfo ENOTFOUND dillion.io`. |
| experiment: C1 + `runtime = "nodejs"` + `dynamic = "force-dynamic"` in the 3 OG files (`og-nodejs-runtime-experiment.diff`) | 200 | no response | **(b)**, module error gone | `replay-compat-og-nodejs-runtime-magicui.log` line 217 `Can't load image https://dillion.io/me.png: fetch failed`, line 225 `Image size cannot be determined`. New: line 211-212 `Failed to load fonts: [TypeError: fetch failed] … not implemented... yet...` |

No run returned (c) 200 for an OG route, because no environment here has egress to `dillion.io`.

Why (a): `@vercel/next` emits edge functions as `v8-worker` bundles whose `index.js` starts with `const wasm_… = require("/wasm/wasm_….wasm")` (resvg/yoga for next/og). next-bundle@1.0.0's local `server.mjs` treats only edge *middleware* as edge (`loadMiddleware`, `vcConfig.runtime !== "edge"`). Every other function goes through `getFunctionHandler`, which does `require(handlerPath)`. Node loads that `index.js` as an ES module, so `require` is undefined. The C1 changes (`@swc/helpers`, `transpilePackages`) do not touch this, and it affects base 16.1.1 the same way. So the error is not a Next upgrade regression, and it is separate from, and earlier than, any network fetch.

Config-level fix tested: switching the OG routes to the Node.js runtime is supported (route segment config). It removes the module error under the exact replay. Then the routes fail later, on the egress-blocked avatar fetch, just like the `next start` control. However:
- Removing `runtime = "edge"` without `dynamic = "force-dynamic"` makes Next prerender the OG images at build time. That build then fails here on the same remote fetch (`Export encountered an error on /blog/opengraph-image/route`).
- Under the Node.js runtime, the routes' `fetch(new URL("../../public/fonts/…", import.meta.url))` font loading fails (`not implemented... yet...`). The code catches the error and falls back to the default font. This is a visual regression even with egress. Fixing it means rewriting font loading (e.g. `readFile`), which is app code, not config.

So no config-only change makes the OG routes correct on next-bundle. The nodejs-runtime experiment is **not** folded into `security-fix-wasmer-compat.patch`. This should be reported to wasmerio as bug 3 below.

Caveat: the replay serves `.next-bundle/server.mjs` with native Node 24.22.1 on Linux. Wasmer's hosted runtime binaries may load edge/v8-worker functions differently, so the hosted result for OG routes is unverified either way.

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
3. Non-middleware `runtime = "edge"` functions (e.g. next/og `opengraph-image`) are loaded with `require()` by `server.mjs`. The v8-worker `index.js` then fails with `ReferenceError: require is not defined in ES module scope`. This also affects 16.1.1.
