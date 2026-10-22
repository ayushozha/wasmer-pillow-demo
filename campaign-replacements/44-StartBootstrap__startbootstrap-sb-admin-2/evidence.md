# StartBootstrap/startbootstrap-sb-admin-2 — evidence

- Pinned SHA: `f0309881ef82794a1bd6257cd321801bc38a0f3d` (branch `master`, last commit 2021-04-28); shallow clone `$S/rup/StartBootstrap__startbootstrap-sb-admin-2`.
- Stars / forks: 9,864 / 5,660 (GitHub API, 2026-10-22). Not archived; default branch `master`.
- License: MIT (`LICENSE`: "Copyright (c) 2013-2021 Start Bootstrap LLC ... Permission is hereby granted, free of charge, to any person obtaining a copy ... to deal in the Software without restriction").
- Contribution / AI policy: none. No `.github/` directory, no CONTRIBUTING, no PR template, no AGENTS.md, no bad-PR bots. README only says to open issues for bugs.
- Maintainer activity: `is:pr is:merged merged:>2024-01-01 org:StartBootstrap` → **0** (GitHub API 2026-10-22). No merges anywhere in the org since at least 2024-01-01.
- Org-wide `deploy in:title org:StartBootstrap`: 8 results, none merged except an unrelated 2014 Jekyll exclude change. Third-party deploy-button attempt: **startbootstrap-creative#56 "Adds deploy button to README" (2016-12-20, closed unmerged 2017-08-12)**; also resume#323 "Added workflow to deploy static boostrap site" (closed unmerged 2024-12-03). Caller also recorded clean-blog-jekyll#215 (deploy button, closed unmerged).
- Duplicate check: `wasmer` across this repo → 0 PRs.

## Anybuild v0.33.0 detection
- Unpatched: `package.json` with only `"start": "node_modules/.bin/gulp watch"` → **Node provider** (`crates/anybuild/src/providers/mod.rs:428-434`, PackageWithStart 30 beats StaticFile UnbuiltNodeSite/Html 15 because `package.json` exists, `staticfile.rs:188-200`). Generated plan: install `npm install`, start `node_modules/.bin/gulp watch` = BrowserSync dev server (`$S/plans/StartBootstrap__startbootstrap-sb-admin-2.json`). Wrong for production.
- Patched: root `Staticfile` with `root: .` → StaticFile provider score 50 (`mod.rs:445-447`, `staticfile.rs:190-191`); `parse_simple_yaml` (`staticfile.rs:95-125`) yields `{root: "."}` (non-empty, so `load_static_config` at `staticfile.rs:144-155` uses it). Even an empty Staticfile would detect (detection only checks existence) and `staticfile.bzl:37` defaults `source = config.static_dir or "."`; `root: .` was chosen because it states the intent explicitly. No install/build; `copy(".", ".")` then `static-web-server --root=/opt/static_app`.
- The built site lives at the repo root (HTML pages, `css/`, `js/`, committed `vendor/`), which is how the upstream GitHub Pages preview (startbootstrap.github.io/startbootstrap-sb-admin-2) is served.

## Replay (patched clone, `$S/scripts/replay.sh /tmp/claude-0/-home-user-wasmer-pillow-demo/9b68abed-67cb-5023-b672-44f9751def64/scratchpad/rup/StartBootstrap__startbootstrap-sb-admin-2 w8-sb-admin-2 3695 /index.html /charts.html /tables.html /login.html /404.html /does-not-exist`)
- Plan: "Detected static site provider", Output directory `.`, SWS 2.38.0; no install/build steps. `cp -R <flat>//. static_app/` exit=0; 1879 files.
- Smoke (SUMMARY pages=7 refs_checked=24 failures=1 — the one "failure" is the deliberate `/does-not-exist` probe): Pages `/`, `/index.html`, `/charts.html`, `/tables.html`, `/login.html`, `/404.html` = 200; all 24 same-origin refs 200. `/does-not-exist` = 404 with an empty body in this local replay, while `/404.html` itself = 200. The cause was not established (it may depend on the local harness's working directory or static-web-server settings), so the 404 page shown on Wasmer is unverified. Offline link check of every `.html` in static_app: 331 local refs, 0 unresolved.
- No INSTALL/BUILD FAILED/MISSING lines.

## Verdict: READY (technically) — LOW ACCEPTANCE, open one probe PR first
The patch is two files (README subsection + 1-line `Staticfile`) and the replay passes. Acceptance risk is the blocker: zero merged PRs org-wide since 2024 and the earlier third-party deploy-button PR (creative#56) was closed unmerged. Recommendation: send at most one StartBootstrap PR (highest stars: sb-admin-2) as a probe and hold the rest until it gets a response.

Remaining reviewer checks: wasmer.io import page and shields badge render (both blocked from this environment); a real Wasmer import of the patched branch.
