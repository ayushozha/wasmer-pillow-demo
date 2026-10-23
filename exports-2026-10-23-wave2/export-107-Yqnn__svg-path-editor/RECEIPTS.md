# Receipts: Yqnn/svg-path-editor (NN 107)

Verdict: READY, with one disclosed limitation the maintainer must accept or decline in review: the upstream Google Analytics tag `G-1BBJSPSKQ9` ships in every deployed copy (not removed; disclosed in PR_BODY.md Limitations). No open test item. Checked 2026-10-23.

## Source
- Fresh `git clone --filter=blob:none` of `master` at 2026-10-23T02:12Z: HEAD `937d75a83b6be2bdda11d02b9b3594841315223a` (2026-06-18). Same as the prior pin, so the identical README patch was applied (byte-identical `upstream.patch`).
- `patch-checks.txt`: `git apply --check` on a clean HEAD worktree exit=0; `git diff --check HEAD` exit=0; 0 added lines with trailing whitespace. sha256 `611f7f466dfc495655cfdad0ec43301e4a9ce53289bef2e18628a7852b0254c8`.

## Policy (`policy-files.txt`)
- Only `.github/FUNDING.yml` exists: no CONTRIBUTING, AGENTS.md, CLAUDE.md, `.cursorrules`, copilot-instructions, PR template, CLA workflow or AI-PR rule. Nothing required to run. Lint/test were not run (not required for a README-only change).
- Activity: 16 commits since 2025-10-01, last 2026-06-18; outside contributions merged (#172 GregOriol, #166 Jae Lee). About four months without commits; acceptance uncertainty only.

## Duplicate check (`duplicate-check.txt`, `dupcheck.sh`)
- 92 PR head refs (open, closed, merged; highest #182). `--grep=wasmer`: 0. `--author=wasmer/ayush`: 0. README.md mentioning wasmer in any PR ref: 0 of 92. No existing Wasmer PR.

## Plan and build (`plan.txt`, `plan.json`, `replay.log`)
- Anybuild v0.33.0: static Node.js, Angular, npm 11, output `dist/svg-path-editor`; `npm install`, `npm run build`, `static-web-server --root=/opt/static_app ...`. No committed Anybuild file.
- Node 24.22.1, npm 11.21.1: `npm install` exit=0 (npm warns 4 install scripts not covered by allowScripts: esbuild, nice-napi, nx); `npm run build` exit=0 (Angular budget warnings only). 29 files.

## HTTP (`http-receipts.txt`, `smoke.txt`; static-web-server 2.38.0 native, port 3931)
- `/`, `/index.html` 200 text/html 40747. All 7 assets referenced by the built HTML 200. All 29 build files 200 with expected MIME. `/nope`, `/svg-path-editor/` 404.

## Browser (`playwright.txt`, `pw.js`, `shot-editor.png`; non-127.0.0.1 blocked)
- `/` 200, editor `svg[app-canvas]` renders the default path, 23 command rows; editing to `M 0 0 L 10 10 L 20 0 Z` gives 4 rows and the same `d`; fresh `/#P=M_0_0_L_10_10_L_20_0_Z` imports that path.
- Blocked origins: `https://www.googletagmanager.com` (1), `https://fonts.gstatic.com` (2). The only console errors are those 3 blocked loads. With fonts.gstatic.com blocked, Material Icons buttons show ligature text ("ex", "sav") in `shot-editor.png`.

## Compatibility finding (`analytics-check.txt`, `router-check.txt`)
- Confirmed at HEAD: `src/index.html:19,24` load gtag and `gtag('config', 'G-1BBJSPSKQ9')`; the built `index.html` keeps it (lines 19, 24). Self-hosted copies report to the maintainer's GA property. Source not edited.
- Angular inlines the Google Fonts CSS at build time (0 `fonts.googleapis` refs left in the build; 29 `fonts.gstatic.com` URLs), so the build fetches fonts.googleapis.com.
- No Angular router (`git grep RouterModule|provideRouter|Routes` = no match): single URL, no deep links.

## Claims table (PR_BODY.md)
| Claim | Receipt |
|---|---|
| HEAD `937d75a`, current `master` | duplicate-check.txt header, patch-checks.txt |
| Static Node.js / Angular / npm / `dist/svg-path-editor` | plan.txt, plan.json |
| `npm install` exit 0, Node 24.22.1, npm 11.21.1 | replay.log |
| `npm run build` exit 0, 29 files | replay.log, http-receipts.txt |
| static-web-server 2.38.0 | replay.log, http-receipts.txt |
| `/`, `/index.html` 200 "SvgPathEditor"; 29/29 files 200; `/nope` 404 | http-receipts.txt, smoke.txt |
| No router; `#P=` fragment import | router-check.txt; `src/app/import/import.component.ts:46` |
| Playwright 1.56.1 canvas, 23 rows, edit to 4 rows, `#P=` import | playwright.txt |
| GA tag `G-1BBJSPSKQ9` in source and build | analytics-check.txt |
| fonts.gstatic.com / googletagmanager blocked, editor still worked, icons as text | playwright.txt, shot-editor.png |
| Fonts CSS inlined at build time | analytics-check.txt |
| Service worker not exercised | pw.js (`serviceWorkers: 'block'`) |
