# coreui/coreui-free-react-admin-template: evidence

**Verdict: CONDITIONAL.** The build passes with a one-line root `Staticfile` (`root: build`). The condition is that maintainers must accept that extra file.

## Repository
- Pinned SHA: `2609f5995035973e00c16ec723165a5fff87cceb` on branch `main`.
- Stars / forks: 4,960 / 2,556. The repo is not archived and was last pushed 2026-10-20 (GitHub API, 2026-10-22).
- License: MIT, Copyright (c) 2026 creativeLabs Łukasz Holeczek.
- `.github/CONTRIBUTING.md`:
  - It says: "**Please ask first** before embarking on any significant pull request (e.g. implementing features, refactoring code, porting to a different language)". A README badge is not significant under that definition.
  - It requires semantic commit messages ("docs (changes to documentation) -> git commit -m 'docs: commit-message-here'") and says "By contributing your code, you agree to license your contribution under the MIT License".
  - It tells contributors to open the PR "against the `master` branch", but the default branch is `main`.
- There is no PR template. `.cursorrules`, `ARCHITECTURE.md` and `DEVELOPMENT.md` are AI-assistant context files, not AI contribution bans.
- Workflows: `npm.yml` and `stale.yml`. No bad-PR bot.
- Recent merged PRs since 2025-10-01: 16.
- Duplicate `wasmer` check: 0. Prior deploy PRs: #463 "deploy the project" (2025-11-22, closed unmerged 2026-01-28; it does not look like a vendor button PR).
- Existing deploy docs: README "#### Build" only. The patch adds "#### Deploy on Wasmer" right after it, before "## What's included".

## Anybuild detection (v0.33.0)
- Provider: node-static, framework Vite, Strong (60). Package manager: npm 11 (planned; executed 11.21.1) (`package-lock.json`). Install runs `npm install` with `package.json` and `package-lock.json` staged. Build runs `npm run build` (`vite build`).
- **Without the patch, the plan says static_dir `dist`.** Anybuild does not read Vite `build.outDir` (`get_static_dir`, `node_static.rs:454-488`, falls to the framework default `dist`, `node.rs:334`). This repo sets `outDir: 'build'` (`vite.config.mjs`), and `build/` is not committed. So the unpatched Wasmer build would copy a MISSING `dist`.
- **The fix is a root `Staticfile` containing `root: build`.**
  - The StaticFile provider only scores 50 (`mod.rs:442-449`), while node-static scores 60 (Strong, Vite).
  - So node-static still wins and **still builds**. It reads the Staticfile `root:` as its static_dir (`node_static.rs:202-205,260-276`, `staticfile_config_root` at 289-315).
  - Plan with the patch: "Detected static Node.js provider, Framework: Vite, Output directory: build" (`plan.txt`).
  - This answers the coordinator's concern that "StaticFile does not build": the StaticFile provider is not selected here.

## Replay (patched clone, Node 24.22.1, npm 11)

> Correction (2026-10-22): the first replay of this target (`replay-npm10-host-superseded.log`) ran the host's npm 10.9.4 because of a harness bug, although this evidence said npm 11. Re-ran on the exact planned toolchain (Node 24.22.1, **npm 11.21.1**, staged `package.json` + `package-lock.json`); install/build exit 0 and smoke 0 failures — `replay.log` is that run.
- `npm install` succeeded (exit 0). `npm run build` succeeded (exit 0). `static_app` holds 107 files.
- Smoke:
  - `/` returned 200 ("CoreUI Free React.js Admin Template").
  - All 4 referenced assets returned 200.
  - `/#/dashboard` returned 200.
  - `/dashboard` returned 404, which is expected.
- Routing: the app uses hash routing via `HashRouter` (`src/App.jsx:18,87`), so every in-app route is `/#/...` and reloads hit `/`. There is no SPA deep-link limitation.

## Remaining check for the reviewer
- Verify the badge and import page in a browser; `img.shields.io` and `wasmer.io` are blocked here.
- Use a `docs:` commit message and target `main`.
