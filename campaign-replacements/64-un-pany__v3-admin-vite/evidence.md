# un-pany/v3-admin-vite (64): HOLD, not built

- Pinned `c2c895d71d571e9c18c2453fa85469a479c79fc6` (main); 7,064 stars / 1,212 forks (GitHub API 2026-10-22); MIT. Last push 2026-07-11.
- Anybuild v0.33.0 plan (unpatched): node-static, Vite, pnpm, `pnpm install` + `pnpm run build` (`vue-tsc && vite build`), output `dist`. There is no `pnpm-workspace.yaml`, so the catalog gap does not apply. Router is hash mode (`.env` `VITE_ROUTER_HISTORY = hash`; `src/router/config.ts:34`), which is fine.
- Blocker, base path: `.env.production` sets `VITE_PUBLIC_PATH = /v3-admin-vite/` (for its GitHub Pages demo), and `vite.config.ts:19` uses it as `base`. A Wasmer build serves `dist/` at the domain root, so every asset URL would point at `/v3-admin-vite/...` and 404. Making it work needs a source change to `.env.production`, which changes the maintainers' Pages deploy. That is outside a README-only PR.
- Also: login and data use an external Apifox mock (`VITE_BASE_URL=https://apifoxmock.com/...`), which this environment cannot verify.
- Unhold only if maintainers accept a base-path change (e.g. move the Pages path into their workflow, as yulimchen/vue3-h5-template does with `sed`).
