# Adrinlol/landy-react-template: evidence

**Verdict: HOLD (maintainer signal).** Technically it passes: the replay builds and serves correctly with a README-only patch. The blocker is a prior vendor deploy-button PR outcome (below).

## Repository
- Pinned SHA: `8c3aa8bfc8fdeddf4c90046594835455b50d6494` on `master` (default). Last push 2026-02-14; not archived.
- Stars / forks: 1,575 / 758 (GitHub API, 2026-10-22).
- License: MIT ("Copyright (c) 2020 Lasha Kakabadze").
- Policy files: only `CODE_OF_CONDUCT.md` and `.github/FUNDING.yml`. No CONTRIBUTING, PR template, AI policy or bad-PR bot.
- Merged PRs since 2025-10-01: **0**. Six Dependabot PRs (#91-#99) are open.
- **Prior deploy-button PRs: #100 and #101 "docs: add Deploy on Hostinger button" (third-party, README-only), both closed unmerged on 2026-02-20, within hours of opening.** The comments could not be read here (GitHub API access for this repo is not enabled in this session). Closing two equivalent vendor-button PRs on the same day is a negative signal for a Wasmer button.
- Duplicate `wasmer` PR search: 0.
- Existing deploy docs: README "## Demo" links a Netlify demo; no deploy instructions.

## Anybuild detection (v0.33.0)
- Provider: node-static, framework Create React App, npm (`package-lock.json` staged with `package.json`), build `npm run build` (`react-scripts build`), output `build` (`plan.txt`). No Staticfile needed.
- Router: `BrowserRouter` (react-router 5). Routes are only `/` and `/home` (`src/router/config.ts`), and no in-app link points to `/home` (all links are `to="/"` or scroll anchors). `/home` returns 404 on a direct load because there is no SPA fallback. This is a minor limitation because the site is a single page.

## Replay (patched clone, Node 24.22.1, npm 11)
- `npm install` exit 0 (npm audit reports build-tool vulnerabilities in react-scripts dev deps; the output is pure static, so no server runtime is affected).
- `npm run build` exit 0 ("Compiled successfully"); 42 files.
- Smoke: `/` 200 ("Landy - React Template"); `/manifest.json`, `/robots.txt` and all 3 referenced assets 200; `/home` 404 (expected, see above).
- Supplementary: all 13 SVGs referenced from `src/` exist in `img/svg/`; a lazy route chunk returned 200.

## Owner comments (root request)
- `commenter:Adrinlol` PR search (GitHub API, 2026-10-22) returns only #79, #77, #66 and #43. **The owner did not comment on #100 or #101.** The 1-2 comments on those PRs came from someone else, and their text and the `closed_by` field could not be read: `issue_read` and `gh api` are refused for repos outside this session's allowlist, and github.com HTML returns 403 through the proxy.
- Searching PRs for deploy/hosting/Netlify/Vercel found nothing else relevant.
- So there is no quotable owner refusal, but two equivalent vendor-button PRs were closed unmerged the same day, and no PR has been merged since 2025-08.

## To unhold
Read PR #100/#101 comments. If they were self-closed by the author or closed for a reason unrelated to vendor buttons, upgrade to READY; if the maintainer declined deploy buttons, drop the target.
