# coreui/coreui-free-vue-admin-template: evidence

**Verdict: READY.**

## Repository
- Pinned SHA: `81cc2aef4f2c6a195558fcc414820f2f4fef359f` on branch `main`.
- Stars / forks: 3,408 / 968. The repo is not archived and was last pushed 2026-10-20 (GitHub API, 2026-10-22).
- License: MIT, Copyright (c) 2026 creativeLabs Łukasz Holeczek.
- `.github/CONTRIBUTING.md`:
  - It says: "**Please ask first** before embarking on any significant pull request (e.g. implementing features, refactoring code, porting to a different language)". A README badge is not significant under that definition.
  - It requires semantic commit messages ("docs (changes to documentation) -> git commit -m 'docs: commit-message-here'") and says "By contributing your code, you agree to license your contribution under the MIT License".
  - It tells contributors to open the PR "against the `master` branch", but the default branch is `main`.
- There is no PR template. `.cursorrules`, `ARCHITECTURE.md` and `DEVELOPMENT.md` are AI-assistant context files, not AI contribution bans.
- Workflows: `npm.yml` and `stale.yml`. No bad-PR bot.
- Recent merged PRs since 2025-10-01: 9.
- Duplicate `wasmer` check: 0. Prior deploy PRs: none.
- Existing deploy docs: README "#### Build" only. The patch adds "#### Deploy on Wasmer" right after it, before "## What's included".

## Anybuild detection (v0.33.0)
- Provider: node-static, framework Vite, Strong (60). Package manager: npm 11 (`package-lock.json`). Install runs `npm install` with `package.json` and `package-lock.json` staged. Build runs `npm run build` (`vite build`).
- Static dir: `dist` (Vite default, `providers/node.rs:334`). This matches Vite's default output; `vite.config.mjs` sets no `outDir`.

## Replay (patched clone, Node 24.22.1, npm 11)
- `npm install` succeeded (exit 0). `npm run build` succeeded (exit 0). `static_app` holds 96 files.
- Smoke:
  - `/` returned 200 ("CoreUI Vue.js Admin Template").
  - All 16 referenced assets returned 200.
  - `/#/dashboard` returned 200.
  - `/dashboard` returned 404, which is expected.
- Routing: the app uses hash routing via `createWebHashHistory` (`src/router/index.js:352`), so every in-app route is `/#/...` and reloads hit `/`. There is no SPA deep-link limitation.

## Remaining check for the reviewer
- Verify the badge and import page in a browser; `img.shields.io` and `wasmer.io` are blocked here.
- Use a `docs:` commit message and target `main`.
