# Receipts: mhyfritz/astro-landing-page (NN=11)

Verdict: **READY to open** (with disclosed acceptance uncertainty: low maintainer activity). No controlling rule found.

## Source
- Fresh `git clone --filter=blob:none` of `main` on 2026-10-23: HEAD `987617a50863d31bb865ee531391a191d74a878a` (2024-11-24, "update dependencies").
- Prior pin: `987617a50863d31bb865ee531391a191d74a878a`. Upstream has not moved. Change re-made fresh on HEAD as a "## Deploy" section with the badge only (prior explanatory paragraph dropped; button semantics are in the PR body).

## Policy (policy-files.txt)
- No `.github/` directory, CONTRIBUTING, AGENTS.md, CLAUDE.md, `.cursorrules`, copilot-instructions, PR template, CLA or AI/agent rule. `git grep` for AI/CLA/issue-first terms: no matches.
- No lint script; `format` (prettier --write) exists but nothing requires it. Not run; README-only change.
- Commit style is lowercase imperative ("update dependencies", "swap badge"), so the title is lowercase.

## Duplicate check (duplicate-check.txt)
- 11 PR refs fetched (all states). `--grep=wasmer`: 0. `--author=wasmer|ayush`: 0. README.md wasmer hits across 11 refs: 0.

## Build (plan.txt, plan.json, replay.log)
- Anybuild v0.33.0: `node-static`, astro, npm 11, install `npm install` (package.json + lockfile staged), build `npm run build`, static_dir `dist`.
- Node v24.22.1, npm 11.21.1. `npm install` exit=0 (509 packages). `npm run build` exit=0 ("1 page(s) built"). static_app: 37 files.
- Build log `[WARN] Astro.request.headers is unavailable in "static" output mode`: harmless at build, page renders.

## HTTP (http-receipts.txt, smoke.txt; SWS 2.38.0, 127.0.0.1:3942)
- Pages: `/` and `/index.html` 200 (text/html, 49845 B). `/nope`, `/missing/`, `/missing.html`, `/missing`, `/missing/index.html` 404. `/robots.txt`, `/sitemap-index.xml` 404 (the template has neither; expected).
- Assets: 35 unique same-origin refs from the 1 HTML file and url() in the 1 CSS file: 35 x 200 (1 js text/javascript, 1 css text/css, 7 woff2 font/woff2, 25 webp image/webp, 1 svg image/svg+xml).
- smoke.txt: 4 paths, 10 refs, only failure is the intended `/nope` 404.

## Compatibility review
- Build-time remote fetches: none. `astro-icon` loads icons from local `@iconify-json/*` packages ("Loaded icons from src/icons, fa-brands, mdi"); fonts from `@fontsource-variable/inter`; images from `src/`. Not FAIL_ENV.
- Trailing slash / .html: single page at `/index.html`; no sub-routes, so no deep-link or slash issue.
- outDir/base: `astro.config.mjs` sets only `site` and integrations; `dist` matches static_dir.
- External scripts/analytics (external-refs.txt): no external `<script src>`; one inline theme script (localStorage dark-mode); no analytics strings. Outbound links only (astro.build, github.com, twitter.com, showcase sites). `og:url`/`og:image` point to astro-moon-landing.netlify.app via `site`.

## Patch (patch-check.txt)
- README.md +4 lines. `git diff --check` exit=0; `git apply --check` on clean HEAD exit=0; 0 trailing-whitespace lines.
- sha256 `fcac9d9243aa2f5591211a447d10994f2105371586869c9426c52e78d8cf9c28`.

## Open item
- Acceptance uncertainty only: last commit 2024-11-24. Badge image and wasmer.io import page not opened here.

## Claims table (PR_BODY sentence -> receipt)
| Claim | Receipt |
|---|---|
| Four-line "Deploy" section between Commands and Credits | upstream.patch |
| Detected static Node.js, Astro, npm 11, `dist` | plan.txt, plan.json |
| SHA 987617a is current main | duplicate-check.txt, replay.log line 1, patch-check.txt |
| Node 24.22.1, npm 11.21.1, package.json + lockfile staged | replay.log |
| install exit 0; build exit 0; 1 page, 37 files | replay.log |
| SWS 2.38.0 | http-receipts.txt line 1, replay.log |
| `/`, `/index.html` 200; 35 refs 200 by type; 3 missing paths 404 | http-receipts.txt |
| `site` -> Netlify demo for og:url/og:image | external-refs.txt; astro.config.mjs |
| No third-party scripts/analytics; fonts bundled | external-refs.txt; http-receipts.txt woff2 lines; replay.log |
| Last commit on main 2024-11-24 | policy-files.txt (`git log -5`) |

## Update 2 (README paragraph added at root's request)
- `upstream.patch` now adds the badge plus one paragraph. The paragraph says what Wasmer builds and serves (`npm install`, `npm run build`, `dist/`, all from `plan.json`). It also says the button opens the import page, where you review and, if needed, correct the preset or build settings before clicking Deploy, with no instant-deploy claim. Finally it covers the no-copy and own-fork semantics.
- The old patch sha256 `fcac9d9243aa2f5591211a447d10994f2105371586869c9426c52e78d8cf9c28` is superseded by `b17f57db6a179c523d7892dd88102afef0e64c2765a55d75d496f08826d2aaa6`. The summary and claims-table rows that describe the line count refer to the old patch; `PR_BODY.md` Summary is updated.
- The change touches only README.md, which the build does not read, so the replay above still applies. Apply and whitespace checks on a fresh clean HEAD are in `patch-check-update2.txt`.
