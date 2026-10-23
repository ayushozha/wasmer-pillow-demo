# Receipts: coreui/coreui-free-react-admin-template

Verdict: all gates pass (READY for reviewer, pending the remaining checks below). Checked 2026-10-23.

## Pinned SHA
- `2609f5995035973e00c16ec723165a5fff87cceb` = current `main` HEAD on a fresh `git clone --depth 1` (commit date 2026-09-23). Unchanged from the earlier pin, so no re-pin was needed; the patch was re-applied and re-validated on the fresh clone anyway.

## Policy (current default branch)
- `.github/CONTRIBUTING.md`: "**Please ask first** before embarking on any significant pull request (e.g. implementing features, refactoring code, porting to a different language)". A README section plus a one-line config file is not in that class; no issue-first rule for documentation.
- Same file: "Open a Pull Request ... with a clear title and description against the `master` branch." The repository has no `master`; the default branch is `main`, so target `main`.
- Same file: "Please use following commit message format ... docs (changes to documentation) -> git commit -m 'docs: commit-message-here'". PR title/commit: `docs: add Deploy to Wasmer button`.
- Same file: "**IMPORTANT**: By submitting a patch, you agree to allow the project owners to license your work under the terms of the [MIT License](LICENSE)." No CLA signature or CLA bot.
- No PR template, no AGENTS.md. `.cursorrules` is an "AI Assistant Rules" coding guide (e.g. "Modify build configuration without clear reason" under "What AI Should NOT Do"); it contains no ban on agent-opened PRs. The `Staticfile` is a deploy-only file, not a change to the Vite build configuration.
- Workflows: `npm.yml`, `stale.yml`; no PR auto-close bot.

## Duplicate check
- Unauthenticated `curl https://api.github.com/search/issues?q=wasmer+repo:...+is:pr` (and `deploy in:title`) returned HTTP 403 from this session's proxy; raw bodies saved in `duplicate-search/`. Repo-scoped `/pulls` also 403.
- Fallback GitHub search (MCP `search_pull_requests`), raw in `duplicate-search/mcp-*.json`: `wasmer` in this repo: 0. `deploy in:title`: 1, #463 "deploy the project" (gmk05, closed unmerged), not a provider button.
- Sibling: coreui/coreui-free-vue-admin-template#337 "docs: add optional Wasmer deployment instructions" (open, opened 2026-10-22 by the campaign). Disclosed in PR_BODY.md.

## Plan (Anybuild v0.33.0) and commands
- `plan.txt` / `plan.json`: provider node-static, framework Vite, npm 11, install `npm install` (inputs `package.json` + lockfile), build `npm run build`, static_dir `build` (from `Staticfile root: build`; unpatched plan = `dist` (receipt: `receipts/plan-unpatched.txt`/`.json`), which the build never creates because `vite.config.mjs` sets `outDir: 'build'`).
- Replay (`replay.log`): Node 24.22.1, npm 11.21.1; `npm install` exit=0; `npm run build` exit=0; 107 files in static_app.

## HTTP receipts (local native static-web-server 2.38.0; hosted WASI server not tested)
- `receipts/http-receipt.txt`: `/`, `/#/dashboard`, `/#/login`, `/index.html`, `/manifest.json`, `/favicon.ico` 200; `/dashboard`, `/login`, `/no-such-path` 404 (expected: HashRouter). `/Staticfile` 404 (not in build output).
- `receipts/asset-all-files.txt`: all 107 files 200 (90 text/javascript, 2 text/css, 10 image/jpeg, 2 image/webp, 1 image/x-icon, 1 application/json, 1 text/html).
- `receipts/asset-entry-refs.txt`: 25/25 chunks referenced by the same build's entry bundle 200.
- `receipts/smoke.txt`: harness smoke (FAIL lines are the three intended 404 probes).

## Audit
- `receipts/npm-audit-omit-dev.json` (npm 11.21.1, replay work dir): 0 vulnerabilities in production deps (shipped to browser).
- `receipts/npm-audit-all.json`: 2 high, both dev/build-time only: `vite` 8.3.0-8.3.2 (launch-editor advisories, dev server on Windows) and `source-map-js` (DoS on crafted source maps). Not shipped to the browser.

## Patch checks
- `git apply --check upstream.patch` on a clean fresh clone of the pinned SHA: exit 0.
- `git diff --check` after applying (with `git add -N Staticfile`): exit 0; no added line has trailing whitespace.

## Limitations / observations
- npm 11.21.1 printed "install-scripts 2 packages have install scripts not yet covered by allowScripts" (`@parcel/watcher` build-from-source, `core-js` postinstall banner); those scripts did not run, and install/build still exited 0. Recorded for the builder team; not a repo failure.
- Vite warns about chunks > 500 kB (Flags icon set 3.1 MB); unchanged upstream behaviour.
- No deployment; img.shields.io and wasmer.io not reachable from this environment, so the badge and import page are unverified here.
