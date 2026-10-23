# Receipts: sadanandpai/frontend-mini-challenges (NNN 302)

Verdict: HOLD. Controlling rule: `.github/pull_request_template.md` says "Please make sure issue number is mention in Pull Request else PR will not be merged." That is an issue-first rule, and opening an issue is outside this worker's scope. A tested draft is in `draft/` (upstream.patch, PR_TITLE.txt, PR_BODY.md with `ISSUE_NUMBER_REQUIRED` placeholders). Once an issue exists, the remaining open items are the maintainer accepting a committed `Anybuild` file and the GoatCounter disclosure. Checked 2026-10-23.

## Source
- Fresh `git clone --filter=blob:none` of `main` at 2026-10-23T02:37Z: HEAD `48b7dae8bae41e4c69b904c7793bb8a4f892f337` (2026-10-20). This equals the root-supplied pin, and there was no prior prep folder.
- `patch-checks.txt`: `git apply --check` exit=0 on a clean HEAD, `git diff --check` exit=0, 0 trailing-whitespace lines, 2 files and 37 insertions. sha256 `42e1b58fb5e25c010fe6907173d5c9ce967ce16ad4b8dd9f2a97f54f47b29e57`.

## Policy (`policy-files.txt`)
- PR template: issue number required (quoted above), plus a checklist. CONTRIBUTING covers challenge contributions only and has no AI rule. There is no AGENTS.md, CLAUDE.md, `.cursorrules`, copilot-instructions or CLA workflow.
- `.husky/pre-commit` runs `npm run prettify` (pretty-quick --staged), `npm run lint` and `npm run unit:test`. In `hook-checks.txt`, lint exit=0 and unit:test exit=0. Prettier leaves the new README section unchanged, but pretty-quick formats whole staged files, so a real commit would also reformat pre-existing README header lines 6-18 (9 diff lines).
- Activity: 13 commits since 2026-04-01, the latest 2026-10-20. Outside commits were merged (Richard Jansma, roocogit00). Whether the issue rule is enforced in practice was not verified (no API access).

## Duplicate check (`duplicate-check.txt`)
- 368 PR head refs (highest #540). `--grep=wasmer`: 0. The 12 `--author=ayush` hits are unrelated contributors (Ayush Varshney, Rakesh, Dutt Sharma, Chauhan). README mentions of wasmer: 0 of 368. No Wasmer PR exists.

## Plan (Anybuild v0.33.0)
- HEAD as-is (`plan-unpatched-HEAD.*`): provider "Node.js" (server), `npm install` / `npm run build`, no start command, no static_dir ("no start or main script found"). The root `package.json` has no static-framework dependency (node_static.rs STATIC_FRAMEWORK_DEPENDENCIES), so the button as-is would plan an app that cannot start. This is a real detection gap, not a build error and not FAIL_ENV.
- Staged install: `node_install_requires_all_files=True`, with all 11 workspace package.json files in the inputs and one lockfile. There is no workspace input gap. `unpatched-build.log`: `npm install` exit=0, `npm run build` exit=0 (Nx, 6 projects). It produced no root `dist`.
- Root-note corrections: `build` does not copy. The separate `copy-to-dist` script (also run by `.github/workflows/main.yml`) assembles `dist` from host + css + javascript + react + vue + angular. There is no Svelte app. All apps are built with base `/frontend-mini-challenges/`, and the cross-app links are absolute under it.
- Proposed config (draft `Anybuild`, `plan.txt`/`plan.json`): `nodestatic_config`, with build `npm run build && npm run copy-to-dist && rm -rf wasmer-site && mkdir wasmer-site && cp -R dist wasmer-site/frontend-mini-challenges`, static_dir `wasmer-site`, and one literal redirect `/` -> `/frontend-mini-challenges/` (302). There is no catch-all. Justification: `http-control-dist-at-root.txt` shows that serving `dist` at `/` returns 404 for all 10 referenced assets.

## Build and HTTP (`replay.log`, `replay.sh` = harness plus `--anybuild-path`; `http-receipts.txt`, `http.sh`; static-web-server 2.38.0 native)
- Node 24.22.1, npm 11.21.1. `npm install` exit=0 (husky: ".git can't be found"; 11 install scripts not in allowScripts). The build command exit=0 and produced 308 files. `package-lock.json` is unchanged.
- `/` returns 302 to `/frontend-mini-challenges/` (200). The react/vue/angular indexes, 3 CSS and 3 JS challenge dirs, and their `index.html` forms all return 200. The 29 referenced assets return 200 (14 JS, 14 CSS, 1 base href). All 308 build files return 200 with the expected MIME types. `/nope`, `/frontend-mini-challenges/nope`, `/react/counter`-style paths, `/index.html` and `/assets/x.js` return 404.

## Routing and browser (`playwright.txt`, `pw.js`, screenshots; non-127.0.0.1 blocked)
- Routers: host and react use `createHashRouter`, vue uses `createWebHashHistory`, angular uses `withHashLocation`. CSS/JS are multi-page HTML. There are no history-router deep links, so no rewrite is needed.
- Direct load and reload both return 200 and render: the portal, `#/javascript`, `#/leaderboard`, CSS accordion, JS 25-5-clock and atm-simulator, React counter and anagram-checker, Vue counter and accordion, Angular counter and todo-list. There were no same-origin >=400 responses.
- Console: blocked-request errors only, plus "Error fetching contributors: AxiosError: Network Error" (api.github.com blocked). A challenge opened as `.../dialog/index.html` throws "reading 'title'". That is an upstream navbar quirk: `navbar.ts` parses the trailing-slash URL that the portal links to, so this is host-independent (inferred from the code; GitHub Pages was not tested).
- Blocked origins: gc.zgo.at, fonts.googleapis.com, fonts.gstatic.com, api.github.com, github.com, avatars.githubusercontent.com, cdnjs.cloudflare.com, raw.githubusercontent.com.
- Analytics: `apps/host/index.html:62-64` has GoatCounter `sadanandpai.goatcounter.com`, which ships in the build. This is disclosed in the draft body.

## Shipped deps (`audit-omit-dev.txt/json`, `shipped-deps-check.txt`)
- `npm audit --omit=dev --package-lock-only` (exact lock) exit=1: 4 high, 0 critical.
- Shipped: axios 1.18.1 (portal plus React emoji-picker and infinite-scroll; fixed URLs, no viewer-controlled config). @angular/router 22.1.4 (advisories are SSR-only; no SSR).
- Not shipped (no markers in the 308 files): follow-redirects 1.16.0, source-map-js 1.2.1.

## Claims table (draft/PR_BODY.md)
| Claim | Receipt |
|---|---|
| HEAD `48b7dae`, current `main` | duplicate-check.txt, patch-checks.txt |
| Without Anybuild: Node.js server, no start command | plan-unpatched-HEAD.txt/.json |
| Static Node provider from Anybuild, npm 11, `wasmer-site`, 302 redirect | plan.txt, plan.json, sws.toml |
| install exit 0 (Node 24.22.1, npm 11.21.1); lockfile unchanged | replay.log, patch-checks.txt |
| build exit 0, Nx 6 projects, 308 files | replay.log, http-receipts.txt |
| static-web-server 2.38.0 | replay.log, http-receipts.txt |
| `/` 302; portal/app indexes/6 challenges 200; 29 assets; 308/308; 404s | http-receipts.txt |
| Hash routing in all five apps; no catch-all | RECEIPTS routing section (git grep), plan.json |
| Base path `/frontend-mini-challenges/` | apps/*/vite.config.ts, http-control-dist-at-root.txt |
| Playwright 1.56.1 renders + reloads | playwright.txt |
| lint / unit:test exit 0 | hook-checks.txt |
| GoatCounter tag in build | shipped-deps-check.txt |
| External origins blocked, contributors network error | playwright.txt |
| 4 high; axios / @angular/router shipped; others not | audit-omit-dev.txt, shipped-deps-check.txt |
