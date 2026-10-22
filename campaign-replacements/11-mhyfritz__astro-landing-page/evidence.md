# mhyfritz/astro-landing-page: evidence

**Verdict: CONDITIONAL.** The exact replay passes. The condition is maintainer inactivity: 0 merged PRs since 2025-10-01, and the repo was last pushed 2024-11-24.

## Repository
- Pinned SHA: `987617a50863d31bb865ee531391a191d74a878a` on branch `main`.
- Stars / forks: 679 / 223. The repo is not archived (GitHub API, 2026-10-22).
- License: MIT, Copyright (c) 2022-present Markus Hsi-Yang Fritz.
- Policy files: no CONTRIBUTING, no PR template, no AI policy and no bad-PR bot.
- Duplicate `wasmer` PR check: 0. Prior third-party deploy-button PRs (`deploy in:title`): none.
- Existing deploy docs: none (only a Commands table). The patch adds a short "## Deploy on Wasmer" before "## Credits".

## Anybuild detection (v0.33.0)
- Provider: node-static, framework Astro, Strong (60; `mod.rs:421-426`). Static dir: `dist` (`providers/node.rs:330`).
- Package manager: npm 11 (`package-lock.json`). Install runs `npm install` with `package.json` and `package-lock.json` staged. Build runs `npm run build`.

## Replay (patched clone, Node 24.22.1, npm 11; see replay.log)
- `npm install` succeeded (exit 0). `npm run build` succeeded (exit 0). `static_app` holds 37 files.
- Smoke: `/` (Astro Landing Page) returned 200 and all 11 referenced assets returned 200. `/nope` returned 404, which is expected for this single-page site.

## Remaining check for the reviewer
- Decide whether a PR to an inactive repo is worth sending.
- Verify the badge and import page in a browser; `img.shields.io` and `wasmer.io` are blocked here.
