# StartBootstrap/startbootstrap-resume — evidence

- Pinned SHA: `c6fbe5ef431642984d0f17960194632f20cf67bc` (branch `master`, last commit 2023-03-25); shallow clone `$S/rup/StartBootstrap__startbootstrap-resume`.
- Stars / forks: 2,179 / 2,842 (GitHub API, 2026-10-22). Not archived; default branch `master`.
- License: MIT (`LICENSE`: "Copyright (c) 2013-2023 Start Bootstrap LLC ... Permission is hereby granted, free of charge, to any person obtaining a copy ... to deal in the Software without restriction").
- Contribution / AI policy: none. No `.github/` directory, no CONTRIBUTING, no PR template, no AGENTS.md, no bad-PR bots. README only says to open issues for bugs.
- Maintainer activity: `is:pr is:merged merged:>2024-01-01 org:StartBootstrap` → **0** (GitHub API 2026-10-22). No merges anywhere in the org since at least 2024-01-01.
- Org-wide `deploy in:title org:StartBootstrap`: 8 results, none merged except an unrelated 2014 Jekyll exclude change. Third-party deploy-button attempt: **startbootstrap-creative#56 "Adds deploy button to README" (2016-12-20, closed unmerged 2017-08-12)**; also resume#323 "Added workflow to deploy static boostrap site" (closed unmerged 2024-12-03). Caller also recorded clean-blog-jekyll#215 (deploy button, closed unmerged).
- Duplicate check: `wasmer` across this repo → 0 PRs.

## Anybuild v0.33.0 detection
- Unpatched: `package.json` has `build` and `start: "npm run build && node scripts/start.js"` → **Node provider** (score 30, `mod.rs:428-434`). Plan: install `npm install`, build `npm run build`, start `npm run build && node scripts/start.js` = BrowserSync dev server with file watching (`scripts/start.js`). Wrong for production.
- Patched: root `Staticfile` `root: dist` → StaticFile provider score 50 (`mod.rs:445-447`, `staticfile.rs:190-191`); `parse_simple_yaml` (`staticfile.rs:95-125`) → `static_dir = "dist"` (`staticfile.rs:144-155`); `staticfile.bzl:32-56` copies `dist` into `/opt/static_app`, no install/build; served by static-web-server 2.38.0.
- `dist/` is committed and is the supported output: README "Basic Usage" says "simply edit the HTML and CSS files included with `dist` directory. These are the only files you need to worry about"; `npm run build` "builds ... into `dist`".

## Replay (patched clone, `$S/scripts/replay.sh /tmp/claude-0/-home-user-wasmer-pillow-demo/9b68abed-67cb-5023-b672-44f9751def64/scratchpad/rup/StartBootstrap__startbootstrap-resume w8-sb-resume 3692 /index.html`)
- Plan: "Detected static site provider", Output directory `dist`, SWS 2.38.0; no install/build steps. `cp -R <flat>/dist/. static_app/` exit=0; 5 files.
- Smoke (SUMMARY pages=2 refs_checked=4 failures=0): `/` and `/index.html` 200; 4 same-origin refs checked, all 200. External CDN refs (Bootstrap, Font Awesome, Google Fonts) are not fetched by the smoke test.
- No INSTALL/BUILD FAILED/MISSING lines.

## Verdict: READY (technically) — LOW ACCEPTANCE, open one probe PR first
The patch is two files (README subsection + 1-line `Staticfile`) and the replay passes. Acceptance risk is the blocker: zero merged PRs org-wide since 2024 and the earlier third-party deploy-button PR (creative#56) was closed unmerged. Recommendation: send at most one StartBootstrap PR (highest stars: sb-admin-2) as a probe and hold the rest until it gets a response.

Remaining reviewer checks: wasmer.io import page and shields badge render (both blocked from this environment); a real Wasmer import of the patched branch.
