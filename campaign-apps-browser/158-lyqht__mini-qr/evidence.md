# lyqht/mini-qr: evidence

**Verdict: HOLD (Anybuild input gap, `.npmrc` not staged).** The `vite build` fails with: `[vite-plugin-pwa:build] Rollup failed to resolve import "workbox-window" from "/@vite-plugin-pwa/virtual:pwa-register"`.

The cause:
- `workbox-window` is only an indirect dependency (of vite-plugin-pwa).
- The repo makes it resolvable through `.npmrc`: `public-hoist-pattern[]=workbox-window`.
- Anybuild's staged install copies only the lockfile and `node_install_inputs` (`package.json`) before running `pnpm install` (`node.bzl:95-140`). `.npmrc` is therefore absent at install time, and pnpm does not hoist the package.

Classification: an install-config input gap, the same family as the known `pnpm-workspace.yaml` gap. A minimal repo fix exists (add `workbox-window` to devDependencies), but it is a code change, not a README change, so this is HOLD.

## Repository
- Pinned SHA: `fe46504853c597e44b2e39d3decb5df2184c6605` on `main`.
- Stars / forks: 2,432 / 298. Last push 2026-10-01.
- License: GPL-3.0.
- Has `CONTRIBUTING.md`, a PR template and `SELF_HOSTING.md` (Docker and nginx).
- Duplicate `wasmer` PR check: not run, because the target was held on the build result.

## Replay (unpatched): Node 24.22.1, pnpm 10.0.0 (from `packageManager`)
- Staged before install: `package.json` and `pnpm-lock.yaml`.
- `pnpm install` exited 0. It warned "build scripts that were ignored: esbuild, sharp, vue-demi". pnpm 10.0.0 predates `pnpm_config_dangerously_allow_all_builds`, so that env var has no effect on this version. That is a build-script-policy observation for the lead.
- `pnpm run build` exited 1 with the workbox-window error above. `/` returned 404.

## Note for the lead
- Two builder gaps: (a) `.npmrc` is not in `node_install_inputs`; (b) with `packageManager: pnpm@10.0.0`, the allow-all-builds env var is ignored. Point (b) did not cause this failure but could affect others.
