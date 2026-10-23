# Receipts: Bowen7/regex-vis (NN 109)

Verdict: READY, with disclosed limitations. The core flow (`/` and `/?r=...`, including direct load, typing and reload) works. The secondary page `/samples` returns 404 on reload or direct load (in-app navigation works), and the upstream Cloudflare Web Analytics beacon ships in every deployed copy. Both are stated in PR_BODY.md Limitations; no fallback was added. Checked 2026-10-23.

## Source
- Fresh `git clone --filter=blob:none` of `main` at 2026-10-23T02:12Z: HEAD `a6d920601ca44ab2d4e9cd02306510ab6d5e4b38` (2026-05-06). Same as the prior pin, so the identical README patch was applied (byte-identical `upstream.patch`).
- `patch-checks.txt`: `git apply --check` on a clean HEAD worktree exit=0; `git diff --check HEAD` exit=0; 0 added lines with trailing whitespace. sha256 `5a4923f6aa8ac0c3b254d1734adec0603dee4f3b96a61ce109f17e361dac7133`.

## Policy (`policy-files.txt`)
- `.github/CONTRIBUTING.md`, "Open a PR": "1. Fork this project to your own account. 2. Checkout to a new branch. 3. Run `pnpm install` to install dependencies. ... 6. Run `pnpm test`. Make sure to pass all test cases. 7. Submit your code." Ran it: `pnpm-test.txt`, `CI=true pnpm test` 18 files / 53 tests passed, exit=0 (Node 24.22.1, pnpm 10.34.7, replay work dir).
- No AGENTS.md, CLAUDE.md, `.cursorrules`, copilot-instructions, PR template, CLA or AI-PR rule. Workflow `test.yml` only (pnpm 9 / Node 18 `pnpm test` on PRs).
- Activity: 4 commits since 2025-10-01, last 2026-05-06; outside PRs merged (#162, #163, #158). About 5.5 months without commits; acceptance uncertainty only.

## Duplicate check (`duplicate-check.txt`, `dupcheck.sh`)
- 130 PR head refs (open, closed, merged; highest #171). `--grep=wasmer`: 0. `--author=wasmer/ayush`: 0. README.md mentioning wasmer in any PR ref: 0 of 130. No existing Wasmer PR.

## Plan and build (`plan.txt`, `plan.json`, `replay.log`)
- Anybuild v0.33.0: static Node.js, Vite, pnpm 10, output `dist`; staged `package.json` + `pnpm-lock.yaml`; `pnpm install`, `pnpm run build`, `static-web-server --root=/opt/static_app ...`. No committed Anybuild file.
- Node 24.22.1, pnpm 10.34.7: `pnpm install` exit=0; `pnpm run build` exit=0 (chunk-size and caniuse warnings only). 12 files.

## HTTP (`http-receipts.txt`, `smoke.txt`; static-web-server 2.38.0 native, port 3932)
- `/`, `/?r=%2F%5Ba-z%5D%2B%2F`, `/index.html` 200 text/html 1024. 3 assets referenced by the built HTML 200. All 12 build files 200 with expected MIME.
- 404: `/samples`, `/samples/`, `/samples?x=1`, `/playground`, `/nope`.

## Router enumeration (`router-check.txt`)
- `src/App.tsx` `BrowserRouter`; `src/routes.tsx`: `/` (Home), `/samples` (Samples), `/playground` (only when `MODE === 'development'`). Links: header `/` and `/samples`; samples link to `/?r=...`. Home writes the regex with `setSearchParams`. Upstream `vercel.json` rewrites `/(.*)` to `/`.

## Browser (`playwright.txt`, `pw.js`; non-127.0.0.1 blocked)
| Route | Direct load / reload | In-app |
|---|---|---|
| `/` | 200, input + legend graphs | works |
| `/?r=/[a-z]+\d{2,}/` | 200, input filled, graph drawn | typing `a\|b+` sets `/?r=a%7Cb%2B`; reload restores it |
| `/samples` | 404 (direct, `/samples/`, and reload while on it) | header link opens it, 12 sample links; clicking a sample opens `/?r=...` |
| `/playground` | 404 (dev-only route, absent in production) | n/a |
- Blocked origins: `https://static.cloudflareinsights.com` (6, one per page load). Console errors: blocked beacon loads and the 404s.

## Compatibility finding (`analytics-check.txt`)
- `index.html:21` (inside `<% if (!isDev) %>`) loads `static.cloudflareinsights.com/beacon.min.js` with token `f684c9449da14b2396a0a944c9acb39f`; the built `index.html:23` keeps it. Source not edited.
- `/samples` deep link breaks; it is a secondary page, not the core flow, so the verdict is not CONDITIONAL under the brief.

## Claims table (PR_BODY.md)
| Claim | Receipt |
|---|---|
| HEAD `a6d9206`, current `main` | duplicate-check.txt header, patch-checks.txt |
| Static Node.js / Vite / pnpm / `dist` | plan.txt, plan.json |
| `pnpm install` exit 0, Node 24.22.1, pnpm 10.34.7, staged files | replay.log |
| `pnpm run build` exit 0, 12 files | replay.log, http-receipts.txt |
| `pnpm test` 18 files / 53 tests, exit 0 | pnpm-test.txt |
| static-web-server 2.38.0 | replay.log, http-receipts.txt |
| `/`, `/?r=...`, `/index.html` 200 "Regex Vis"; 12/12 files 200 | http-receipts.txt, smoke.txt |
| Playwright 1.56.1 flows (direct `?r=`, typing, reload, Samples link, sample click) | playwright.txt |
| Routes `/`, `/samples`, dev-only `/playground`; `vercel.json` rewrite | router-check.txt |
| `/samples`, `/samples/` 404 on direct load and reload | http-receipts.txt, playwright.txt |
| Cloudflare beacon token in source and build; blocked, app worked | analytics-check.txt, playwright.txt |
| Last commit 2026-05-06 | policy-files.txt |
| Dockerfile and vercel.json exist | router-check.txt |
