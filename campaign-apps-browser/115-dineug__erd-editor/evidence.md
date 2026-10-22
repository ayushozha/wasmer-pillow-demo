# dineug/erd-editor: evidence (triage; no patch prepared)

**Verdict: HOLD (monorepo output dir).** From the root, Anybuild v0.33.0 detects static Node.js/Vite with output `dist`. The plan sets `node_install_requires_all_files: true`, so the whole tree is staged and the pnpm catalogs in `pnpm-workspace.yaml` resolve. `pnpm install` (pnpm 10.34.3) and `pnpm run build` (`vp run -r build`, 39 workspace tasks) both exited 0. But the web app is written to `packages/app/dist`, and there is no root `dist`: the replay reports `STATIC_DIR 'dist' MISSING` and the smoke test gets 404 on `/`. A Wasmer deployment would serve nothing. Fixing it needs a builder or config change, not a README PR.

## Facts
- Pinned SHA: `921e3103de9c2e37581aa9cf8a115e078f79f68a` on `main` (2026-10-22). Stars / forks: 1,728 / 158 (GitHub API, 2026-10-22). License: MIT (Copyright (c) 2022 SeungHwan-Lee).
- The repo has an `AGENTS.md`, which was not evaluated because of the technical HOLD. Duplicate `wasmer` PRs were not checked, for the same reason.
- During install, pnpm printed "Ignored build scripts: core-js, esbuild" despite `pnpm_config_dangerously_allow_all_builds=true`. The build still succeeded. Flagging per BRIEF2 (build-script policy), but it was not blocking.
- `packages/app/dist` contents are listed in replay.log (index.html, manifest, icons, `_headers`, `_routes.json` for Cloudflare).
