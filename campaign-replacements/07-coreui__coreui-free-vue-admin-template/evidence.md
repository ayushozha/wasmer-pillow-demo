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

## Replay (patched clone, Node 24.22.1, npm 11 — see correction below)
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

## Correction and re-run (2026-10-22, root review)
- The first replay (now `replay-npm10-host-superseded.log`) actually ran the host's npm 10.9.4, while this evidence said npm 11 — a harness bug (it only installed the planned version for non-npm managers). Fixed the harness and re-ran on the exact planned toolchain: plan `npm_version` = 11 (Anybuild default, `providers/node.rs:1150-1157`), executed with **Node 24.22.1 and npm 11.21.1**; staged before install: `package.json` + `package-lock.json`; `npm install`, `npm run build` exit 0; 96 files in `dist`. `replay.log` is this run.
- Smoke: `/`, `/index.html`, `/favicon.ico` 200; 16 referenced assets 200 (incl. `/assets/index-*.js`, `/assets/index-*.css`, `/manifest.json`). Every one of the 96 built files (all lazy route chunks) fetched over HTTP from static-web-server 2.38.0: 96/96 = 200.
- Routing: `src/router/index.js:26,352` uses `createWebHashHistory` — every route lives after `#`, so the server only ever serves `/` and static assets; reloads/deep links work without an SPA fallback.
- No runtime server: Anybuild's node-static path copies `dist` into the static app and serves it with static-web-server (`node_static.bzl`, `staticfile.bzl:58-87`); `vite`/`vite preview` never run on Wasmer.
- Audit applicability (`npm audit` in the replay install, npm 11.21.1): 2 packages, high 2 — `vite` 8.3.0–8.3.2 (GHSA-587h-7wmj-h5pm, GHSA-r825-w8mm-5pxw, GHSA-698v-4r3x-3vcv: `launch-editor` in the dev server; GHSA-rq7h-c2jc-7f22, GHSA-vfpm-58rq-9qcg, GHSA-9jrq-w75r-8gcw: dev-server `server.fs`/middleware) and `source-map-js` <1.2.2 (GHSA-68fv-2mgg-jv7q, build-time source-map parsing DoS). All are dev-server or build-time; none of these packages is in the shipped `dist` (`grep -rl source-map-js dist` → none) and no Vite server runs on Wasmer. Not applicable to the deployed static site; maintainers can bump vite separately.
- Live import (root, 2026-10-22): `main`, node-static, Deploy enabled.
