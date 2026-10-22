# markhorn-dev/astro-sphere: evidence

**Verdict: CONDITIONAL.** The exact replay passes. The condition is maintainer inactivity: 0 merged PRs since 2025-10-01, and the repo was last pushed 2025-06-16.

## Repository
- Pinned SHA: `f7e3a40f20e1267d7fbbb7b6dd868df1845e1d82` on branch `main`.
- Stars / forks: 691 / 188. The repo is not archived (GitHub API, 2026-10-22).
- License: MIT, Copyright (c) 2024 Mark Horn.
- Policy files: no CONTRIBUTING, no PR template, no AI policy and no bad-PR bot. Workflows: `stale.yaml` only.
- Duplicate `wasmer` PR check: 0. Prior third-party deploy-button PRs (`deploy in:title`): none.
- Existing deploy docs: the README has "## 🚀 Deploy your own" with Vercel and Netlify buttons. The patch adds the Wasmer badge below them.

## Anybuild detection (v0.33.0)
- Provider: node-static, framework Astro, Strong (60; `mod.rs:421-426`). Static dir: `dist` (`providers/node.rs:330`).
- Package manager: npm 11 (planned; executed 11.21.1) (`package-lock.json`). Both `package-lock.json` and `pnpm-lock.yaml` are committed; Anybuild picked npm. Install runs `npm install` with `package.json` and `package-lock.json` staged. Build runs `npm run build`.

## Replay (patched clone, Node 24.22.1, npm 11; see replay.log)

> Correction (2026-10-22): the first replay of this target (`replay-npm10-host-superseded.log`) ran the host's npm 10.9.4 because of a harness bug, although this evidence said npm 11. Re-ran on the exact planned toolchain (Node 24.22.1, **npm 11.21.1**, staged `package.json` + `package-lock.json`); install/build exit 0 and smoke 0 failures — `replay.log` is that run.
- `npm install` succeeded (exit 0). `npm run build` succeeded (exit 0). `static_app` holds 45 files.
- Smoke: `/` (Home | Astro Sphere), `/blog/`, `/blog/01-astro-sphere-file-structure/`, `/projects/`, `/search/` and `/rss.xml` all returned 200, and all 24 referenced same-origin URLs returned 200. Failures: 0.

## Remaining check for the reviewer
- Decide whether a PR to an inactive repo is worth sending.
- Verify the badge and import page in a browser; `img.shields.io` and `wasmer.io` are blocked here.
