# Receipts: themeselection/sneat-bootstrap-html-admin-template-free

Verdict: all gates pass (READY for reviewer, with the merge-likelihood caveat below). Checked 2026-10-23.

## Pinned SHA
- `de094c2bf89e602054b7c14f46c9a3a5b9f6cac9` = current `main` HEAD on a fresh `git clone --depth 1` (commit date 2026-03-20). Unchanged from the earlier pin; the patch was re-applied and re-validated on the fresh clone.

## Policy (current default branch)
- No CONTRIBUTING file, AGENTS.md, PR template or CLA bot. Policy lives in README.md "Contributing":
  - "Contributions are always welcome and recommended! Here is how: Fork the repository ... Make your changes ... Create a pull request"
  - "When you contribute, you agree to give a non-exclusive license to ThemeSelection to use that contribution in any context as we (ThemeSelection) see appropriate." (implied grant on submission, no signature; the account owner accepts it by opening the PR)
  - "Contributions are only accepted through Github pull requests."
  - "contributed code must work in all supported browsers" (README/config only; no code change).
- README "License": MIT; "We just need an attribution from your end." The deployed demo is unmodified, so the footer attribution stays.
- Workflows `handle-new-issue.yml`, `handle-new-issue-comment.yml`, `issue-staler.yml` act on issues only.
- No issue-first rule.

## Duplicate check
- Unauthenticated `curl https://api.github.com/search/issues?q=wasmer+repo:...+is:pr` (and `deploy in:title`) returned HTTP 403 from this session's proxy; raw bodies in `duplicate-search/`. Repo-scoped `/pulls` also 403.
- Fallback GitHub search (MCP `search_pull_requests`), raw in `duplicate-search/mcp-*.json`: `wasmer`: 0; `deploy in:title`: 0.

## Plan (Anybuild v0.33.0) and commands
- Unpatched (`receipts/plan-unpatched.txt`/`.json`): Node.js server provider, yarn, `yarn install` + `yarn run build`, "Warning: no start or main script found in package.json", no start command.
- Patched (`plan.txt`/`plan.json`): static site provider, output `.`, SWS 2.38.0, no install/build. Replay step `cp -R <flat>/. static_app/` exit=0; 231 files.

## HTTP receipts (local native static-web-server 2.38.0; hosted WASI server not tested)
- `receipts/smoke.txt`: 10 HTML pages 200 with titles (list in PR_BODY.md) plus `/assets/vendor/css/core.css` (text/css) and `/assets/js/main.js` (text/javascript); 46 refs from `/` 200; the 2 FAIL lines are the intended 404 probes (`/this-path-does-not-exist`, `/html/nope.html`).
- `receipts/allrefs.txt`: 115 unique local refs from all HTML pages and their CSS `url()`s: 115/115 200 (42 text/html, 17 text/javascript, 8 text/css, 46 image/png, 1 image/jpeg, 1 image/x-icon).
- `receipts/http-receipt.txt`: `/`, `/html/`, `/html/index.html`, `/assets/vendor/fonts/iconify-icons.css` 200; missing paths 404 `text/html; charset=utf-8`; `/Staticfile` 200 (served because root is `.`).

## Audit
- No install runs under the StaticFile provider, so `npm audit` of a work dir does not apply. Shipped browser libs (vendored in `assets/vendor`, versions from `yarn.lock`) checked against the npm bulk advisory endpoint: `receipts/audit-shipped.txt`, 0 advisories for all 7 (high/critical: none).

## Patch checks
- `git apply --check upstream.patch` on a clean fresh clone of the pinned SHA: exit 0.
- `git diff --check` after applying (with `git add -N Staticfile`): exit 0; no added line has trailing whitespace.

## Limitations
- Merge likelihood is low: per earlier GitHub data the repo has only member branch-merge PRs and one outside README PR (#4, 2022) still open; 0 merges since 2025-10-01 (not re-queried today).
- With `root: .`, source files (`package.json`, `gulpfile.js`, `scss/`, `tasks/`) are publicly served; already public on GitHub.
- Auth pages are demo screens (`<form ... action="index.html">`).
- No deployment; img.shields.io and wasmer.io not reachable from this environment.
