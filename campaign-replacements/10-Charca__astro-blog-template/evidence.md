# Charca/astro-blog-template: evidence

**Verdict: CONDITIONAL.** The exact replay passes. The condition is maintainer inactivity: 0 merged PRs since 2025-10-01, and the repo was last pushed 2025-03-15.

## Repository
- Pinned SHA: `478c018deff7b8adbe4416a30b8d284305dfa5f9` on branch `main`.
- Stars / forks: 533 / 141. The repo is not archived (GitHub API, 2026-10-22).
- License: MIT, Copyright (c) 2022 Maxi Ferreira.
- Policy files: no CONTRIBUTING, no PR template, no AI policy and no bad-PR bot.
- Duplicate `wasmer` PR check: 0. Prior third-party deploy-button PRs (`deploy in:title`): none.
- Existing deploy docs: the README has "## 👩‍🚀 Getting Started" with "### Locally" and "### On StackBlitz". The patch adds "### On Wasmer" next to them. The live demo is on Netlify.

## Anybuild detection (v0.33.0)
- Provider: node-static, framework Astro, Strong (60; `mod.rs:421-426`). Static dir: `dist` (`providers/node.rs:330`).
- Package manager: npm 11 (`package-lock.json`). Install runs `npm install` with `package.json` and `package-lock.json` staged. Build runs `npm run build`.

## Replay (patched clone, Node 24.22.1, npm 11; see replay.log)
- `npm install` succeeded (exit 0). `npm run build` succeeded (exit 0). `static_app` holds 26 files.
- Smoke: `/` (My Astro Blog), `/blog/` and `/about/` returned 200, and all 10 referenced URLs returned 200, including `/blog/hello-world`. Failures: 0.

## Remaining check for the reviewer
- Decide whether a PR to an inactive repo is worth sending.
- Verify the badge and import page in a browser; `img.shields.io` and `wasmer.io` are blocked here.
