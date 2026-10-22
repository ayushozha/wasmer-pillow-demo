# gatsbyjs/gatsby-starter-blog: evidence

**Verdict: CONDITIONAL.** The build and smoke test pass under the exact replay. The condition is low maintainer activity, plus a history of vendor deploy-button PRs being closed (details below).

## Repository
- Pinned SHA: `d75052245100ae3c98807c5f38c6e7ec68910e74` on branch `master`.
- Stars / forks: 3,509 / 2,520. The repo is not archived and was last pushed 2026-05-11 (GitHub API, 2026-10-22).
- License: 0BSD, Copyright (c) 2020 Netlify, Inc. ("Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted").
- Contribution or AI policy files: none in the repo. There is no PR template and no workflows directory.
- Recent merged PRs since 2025-10-01: **0**.
- Duplicate `wasmer` PR check: 0.
- Prior third-party deploy-button PRs, all closed without merge:
  - #204 "Add Deploy on Platform.sh option" (2020)
  - #190 "Add ZEIT Now Deployment" (2020)
  - #102 "Enable Netlify deploy" (2018)
- The README already carries a Netlify one-click section ("## 🚀 Quick start (Netlify)") and a "💫 Deploy" Netlify section. Netlify owns the copyright.

## Anybuild detection (v0.33.0)
- Provider: node-static, framework Gatsby, Strong detection (60; `mod.rs:421-426`).
- Static dir: `public` (`providers/node.rs:336`).
- Package manager: npm 11 (`package-lock.json`). Install runs `npm install` with inputs `package.json` and `package-lock.json`. Build runs `npm run build` (`gatsby build`).

## Replay (patched clone, Node 24.22.1, npm 11; see `replay.log`)
- `npm install` succeeded (exit 0), with peer-dependency warnings only. `npm run build` succeeded (exit 0; "Done building in 36.2 sec").
- `static_app` holds 92 files. Smoke results:
  - `/` returned 200 ("All posts | Gatsby Starter Blog").
  - `/hello-world/` and `/my-second-post/` returned 200.
  - `/rss.xml` returned 200 (text/xml).
  - All 18 same-origin assets returned 200.
- `/does-not-exist` returned a bare 404 with an empty body.
  - `public/404.html` exists, but static-web-server's default `--page404` is resolved relative to the working directory, not `--root`.
  - In this replay the custom 404 page was therefore not served. That is minor and is listed as a limitation.

## Remaining check for the reviewer
- Decide whether to send this, given 0 merges in 12 months and three closed vendor deploy PRs.
- Verify the badge and import page in a browser; `img.shields.io` and `wasmer.io` are blocked from this environment.
