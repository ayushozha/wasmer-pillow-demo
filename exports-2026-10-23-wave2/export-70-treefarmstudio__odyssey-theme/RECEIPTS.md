# Receipts: treefarmstudio/odyssey-theme (NN=70)

Verdict: **READY to open** (with disclosed acceptance uncertainty: low maintainer activity). No controlling rule found.

## Source
- Fresh `git clone --filter=blob:none` of `main` on 2026-10-23: HEAD `d191e5715a2519e25be4629b933189c421b30a1a` (2024-09-24, "Merge pull request #49").
- Prior pin: `d191e5715a2519e25be4629b933189c421b30a1a`. Upstream has not moved. Change re-made fresh on HEAD as the badge line only inside "## Deploy" (prior subsection and paragraph dropped; forms caveat moved to PR body).

## Policy (policy-files.txt)
- No CONTRIBUTING, AGENTS.md, CLAUDE.md, `.cursorrules`, copilot-instructions, PR template, CLA or AI/agent rule. `git grep` for AI/CLA/issue-first terms: no matches. (`classic-hero.jpg` matched "cla" only by filename.)
- README "## Support": "Please feel free to post issues or submit PRs to this repo and we will do our best to respond in a timely manner, keeping in mind this template is offered for free as is on GitHub."
- `.github/workflows/deploy.yml` runs on `pull_request` and uploads to Deno Deploy (`id-token: write`). Not a gate on contributions, but its check may fail on a fork PR; disclosed.
- No lint script; `format` (`npx prettier -w .`) not required by any rule; not run (README-only).

## Duplicate check (duplicate-check.txt)
- 31 PR refs fetched (all states). `--grep=wasmer`: 0. `--author=wasmer|ayush`: 0. README.md wasmer hits across 31 refs: 0.

## Build (plan.txt, plan.json, replay.log)
- Anybuild v0.33.0: `node-static`, astro, npm 11, `npm install` (package.json + lockfile staged), `npm run build`, static_dir `dist`. Committed `netlify.toml` (publish `dist/`) agrees; no Anybuild file in repo.
- Node v24.22.1, npm 11.21.1. `npm install` exit=0 (545 packages). `npm run build` exit=0 ("18 page(s) built"). static_app: 76 files.
- Harmless warnings: npm `Unknown project config "shamefully-hoist"` (from `.npmrc`), Node DEP0180, Vite "empty chunk hoisted".

## HTTP (http-receipts.txt, smoke.txt; SWS 2.38.0, 127.0.0.1:3943)
- Pages: 13 x 200; 4 x 404 (`/sitemap-index.xml`, `/rss.xml`, `/no-such-page-xyz/`, `/missing.html`), each served with the theme's `404.html` body (15711 B). The site emits `sitemap.xml` (200 text/xml) and has no RSS feed.
- `/blog/tags/` is 200 but 15 bytes (`<!DOCTYPE html>`): `src/pages/blog/tags/index.astro` is a 0-byte file upstream. Pre-existing, unrelated; not claimed in PR body.
- Assets: 60 unique same-origin refs from 18 HTML + url() in 2 CSS: 45 x 200, 15 x 308 -> 200 after one hop. Types: png, jpeg, webp, woff, woff2, css, js.
- Forms: POST `/contact-thank-you` and `/newsletter-thank-you` -> 405; GET -> 404.

## Compatibility review
- Build-time remote fetches: none. astro-icon uses local `@iconify-json/{ic,mdi}`; fonts are local woff/woff2; external-refs.txt has no CSS url() to remote hosts. Not FAIL_ENV.
- Trailing slash / .html: directory format; `/x/` 200, `/x` 308 -> `/x/` (10 variants), `/x/index.html` 200. Internal links mostly slashless, so one redirect per navigation. Works.
- outDir/base: config sets `site`, `sitemap: true` and integrations only; no `outDir`/`base`/`trailingSlash`.
- External scripts/analytics (external-refs.txt): no external `<script src>`. "Google Analytics" in HTML is only an HTML comment placeholder from `BaseHead.astro`. Outbound links: github.com, twitter.com, youtube.com, astro.build, npmjs.com; canonical/sitemap to odyssey-theme.sapling.supply via `site`.
- Runtime limit: forms need an external endpoint on any static host (disclosed).

## Patch (patch-check.txt)
- README.md +2 lines. `git diff --check` exit=0; `git apply --check` on clean HEAD exit=0; 0 trailing-whitespace lines.
- sha256 `fb7b517ce8c54229707a980d0fbef4625397e1e8fab3b5c5ed12c81d7a9a16c1`.

## Open item
- Acceptance uncertainty only: last commit 2024-09-24. Badge image and wasmer.io import page not opened here.

## Claims table (PR_BODY sentence -> receipt)
| Claim | Receipt |
|---|---|
| Two-line change in "Deploy" after Astro guide link | upstream.patch |
| Detected static Node.js, Astro, npm 11, `dist` | plan.txt, plan.json |
| SHA d191e57 is current main | duplicate-check.txt, replay.log line 1, patch-check.txt |
| Node 24.22.1, npm 11.21.1, package.json + lockfile staged | replay.log |
| install exit 0; build exit 0; 18 pages, 76 files | replay.log |
| SWS 2.38.0 | http-receipts.txt line 1, replay.log |
| Listed pages 200; missing paths 404 with theme 404.html | http-receipts.txt `## pages` |
| 60 refs from 18 HTML + 2 CSS; 45 x 200, 15 x 308 -> 200 | http-receipts.txt `## assets` |
| Forms POST -> 405 | http-receipts.txt `## form targets` |
| `site` -> demo domain; sitemap.xml, no RSS | external-refs.txt; http-receipts.txt |
| No third-party scripts; GA placeholder only; local fonts | external-refs.txt; http-receipts.txt font lines |
| Deploy workflow runs on PRs to Deno Deploy | policy-files.txt |
| Last commit on main 2024-09-24 | policy-files.txt (`git log -5`) |

## Update 2 (README paragraph added at root's request)
- `upstream.patch` now adds the badge plus one paragraph. The paragraph says what Wasmer builds and serves (`npm install`, `npm run build`, `dist/`, all from `plan.json`). It also says the button opens the import page, where you review and, if needed, correct the preset or build settings before clicking Deploy, with no instant-deploy claim. Finally it covers the no-copy and own-fork semantics.
- The old patch sha256 `fb7b517ce8c54229707a980d0fbef4625397e1e8fab3b5c5ed12c81d7a9a16c1` is superseded by `b2cf778c280dd697bb209dc49f9caefb2285e666e6bc183f5f22518c337a017f`. The summary and claims-table rows that describe the line count refer to the old patch; `PR_BODY.md` Summary is updated.
- The change touches only README.md, which the build does not read, so the replay above still applies. Apply and whitespace checks on a fresh clean HEAD are in `patch-check-update2.txt`.

## Update 3: critical-advisory applicability (`audit/advisories.md`, root request)
- Ran at the pinned SHA with Node 24.22.1, npm 11.21.1 and `CI=true npm install`, as Anybuild does. The `npm audit` counts match the Anybuild install log. The build exits 0 and produces static output only.
- Each critical is listed in `audit/advisories.md` with its package@version, GHSA, `npm explain` path, dev/prod flag, a dist grep and a build-time usage note.
- Verdict: not HOLD. No critical is emitted to `dist`, and the static runtime runs no Node. None is reachable by untrusted input at runtime. The build only processes the deployer's own repository content.
- Full advisory texts could not be fetched here (GitHub and OSV are blocked). The reasoning uses advisory titles, affected ranges and the installed code.
