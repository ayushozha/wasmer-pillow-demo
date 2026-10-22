# vue-zone/vue3-vant-mobile (63): HOLD, not built

- Pinned `8a46a5a41473ba3a638e2249b4c4e48b8ef7ddea` (main); 2,073 stars / 385 forks (GitHub API 2026-10-22); MIT.
- Anybuild v0.33.0 plan (unpatched): node-static, Vite, pnpm, install `pnpm install` with only `pnpm-lock.yaml` + `package.json` staged, build `pnpx vite build` (no `build` script; package.json has only `build:dev`/`build:pro`), output `dist`.
- Blocker 1, SPA routing: `createWebHistory(import.meta.env.VITE_APP_PUBLIC_PATH)` (`src/router/index.ts:1,16`). Wasmer's static build has no SPA fallback; Anybuild only converts `_redirects` 301/302 rules (`providers/staticfile.rs:293-330`). The repo relies on `netlify.toml` for its rewrite, so deep links and reloads would 404.
- Blocker 2, workspace/catalog input gap: `pnpm-workspace.yaml` carries settings (`overrides: vite: ^8.3.4`, `allowBuilds`, `trustPolicy`, `minimumReleaseAgeExclude`, `shamefullyHoist`). That file is not staged for the install (`node.bzl` stages only the lockfile + `node_install_inputs`), so the lockfile/config would mismatch. `packageManager: pnpm@12.11.2`.
- Also: the production API is an external demo service (`VITE_APP_API_BASE_URL=https://easyapi.devv.zone/api`).
- Not worth a README-only PR: fixing it needs a routing change plus builder support for workspace settings.
