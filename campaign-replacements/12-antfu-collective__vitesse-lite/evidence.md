# antfu-collective/vitesse-lite: evidence

**Verdict: HOLD.** There are two problems:
1. The staged `pnpm install` fails with a workspace/catalog input gap (`pnpm-workspace.yaml` is not staged).
2. Deep links break, because history-mode SPA routes 404 under static-web-server.

## Repository
- Pinned SHA: `0b352977755e1f7f6399698e308777760409ca71` on branch `main`.
- Stars / forks: 1,253 / 241. The repo is not archived and was last pushed 2026-09-08 (GitHub API, 2026-10-22).
- License: MIT, Copyright (c) 2020-PRESENT Anthony Fu.
- Policy files: none. There is no CONTRIBUTING, no PR template and no AI policy. The only workflow is `test.yml`.
- Recent merged PRs since 2025-10-01: 1.
- Duplicate `wasmer` check: 0. Prior deploy-button PRs: none in this repo. In the sibling repo `vitesse`, the Hostinger button PR #561 was closed and #562 is still open.
- Existing deploy docs: "☁️ Deploy on Netlify, zero-config". `netlify.toml` has `[[redirects]] from = "/*" to = "/index.html" status = 200`.

## Anybuild detection (v0.33.0)
- Provider: node-static, Vite. Package manager: pnpm 12.3.4 (from `packageManager`). Install runs `pnpm install` with only `package.json` and `pnpm-lock.yaml` staged (`node.bzl:111-139`). Build runs `pnpm run build` (`vite build`). Static dir: `dist`.

## Replay (patched clone; rerun by me to own the log)
- The staged files before install were `package.json` and `pnpm-lock.yaml`.
- `pnpm install` failed with exit 1:
  `ERR_PNPM_LOCKFILE_CONFIG_MISMATCH ... The current "catalogs" configuration doesn't match the value found in the lockfile`.
  The catalogs live in `pnpm-workspace.yaml`, which is not staged.
- `pnpm run build` then exited 0, but only because pnpm re-installed once the full tree (including `pnpm-workspace.yaml`) was copied in. **This masks the install failure.** On Wasmer the install step fails first, so this still counts as a FAIL.
- Smoke on the masked output:
  - `/` returned 200.
  - `/about` returned 404 and `/hi/test` returned 404.
  - The router is `createWebHistory` (`src/main.ts:12`), with no SSG and no fallback. Static-web-server has no SPA fallback configured, so reloads or deep links 404, where Netlify's `/* -> /index.html` rewrite would serve the app.
- Classification: **workspace/catalog input gap**, plus a **SPA history-routing limitation**.

## Remaining check for the reviewer
- Unblock only once Anybuild stages `pnpm-workspace.yaml` and supports an SPA fallback, or converts `netlify.toml` redirects. Even then, deep links would need re-testing.
- `upstream.patch` is prepared but must not be submitted. No PR_TITLE or PR_BODY was written.
