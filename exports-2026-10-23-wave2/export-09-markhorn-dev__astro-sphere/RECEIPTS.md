# Receipts: markhorn-dev/astro-sphere (NN=09)

Verdict: **READY to open** (with disclosed acceptance uncertainty: low maintainer activity). No controlling rule found.

## Source
- Fresh `git clone --filter=blob:none` of `main` on 2026-10-23: HEAD `f7e3a40f20e1267d7fbbb7b6dd868df1845e1d82` (committer date 2025-06-16, "Merge pull request #29").
- Prior pin: `f7e3a40f20e1267d7fbbb7b6dd868df1845e1d82`. Upstream has not moved. The change was re-made fresh on HEAD and reduced to the badge line only (the prior explanatory README paragraph was dropped; the button semantics live in the PR body).

## Policy (policy-files.txt)
- No CONTRIBUTING, AGENTS.md, CLAUDE.md, `.cursorrules`, copilot-instructions, PR template, CLA workflow or AI/agent rule in the tree. `git grep` for AI/CLA/issue-first terms in README and .github: no matches.
- Only workflow: `.github/workflows/stale.yaml` ("Close inactive issues"; `days-before-pr-stale: -1`, so PRs are not auto-closed).
- `package.json` has `lint: eslint .`, but no rule requires it and eslint is not a dependency. Not run; the change is README-only.

## Duplicate check (duplicate-check.txt)
- 25 PR refs fetched (`refs/pull/*/head`, all states). `--grep=wasmer`: 0. `--author=wasmer|ayush`: 0. README.md at each of 25 refs containing "wasmer": 0.

## Build (plan.txt, plan.json, replay.log)
- Anybuild v0.33.0 plan: provider `node-static`, framework astro, npm 11, install `npm install` (inputs: `package.json` + lockfile), build `npm run build`, static_dir `dist`, start static-web-server.
- Node v24.22.1, npm 11.21.1. `npm install` exit=0 (603 packages). `npm run build` exit=0 (`astro check`: 0 errors, 0 warnings, 2 hints). static_app: 45 files.

## HTTP (http-receipts.txt, smoke.txt; SWS 2.38.0, 127.0.0.1:3941)
- Pages: 12 x 200, 2 x 404 (`/no-such-page-xyz/`, `/missing.html`, both SWS default 404 body, 106 B).
- Assets: 40 unique same-origin refs from all 17 built HTML files (href/src/srcset/content/astro-island urls) and url() in the 1 built CSS file: 24 x 200, 16 x 308 -> 200 after one hop.
- MIME: html `text/html`, css `text/css`, js `text/javascript`, rss/sitemap `text/xml`, svg `image/svg+xml`, webp `image/webp`, woff `application/font-woff`.
- smoke.txt: 11 paths, 23 refs, the only failure is the intended 404.

## Compatibility review
- Build-time remote fetches: none seen. Fonts are local (`/fonts/atkinson-*.woff`); no Google Fonts; no remote images in content. Build passed in this container, so not FAIL_ENV.
- Trailing slash: Astro default `build.format: directory` writes `x/index.html`. SWS serves `/x/` 200 and answers `/x` with 308 to `/x/` (7 variants checked); `/x/index.html` 200. Site links use the slashless form, so every internal navigation costs one redirect. Works; not an issue.
- Vite/Astro outDir/base: `astro.config.mjs` sets only `site` and integrations; no `outDir`, `base` or `trailingSlash`. `dist` matches Anybuild static_dir.
- External scripts/analytics in built HTML (external-refs.txt): no external `<script src>`; no analytics strings. Outbound non-script links: github.com, twitter.com, www.linkedin.com, astro-sphere-demo.vercel.app (canonical/OG via `site`), plus doc links on one post.
- Disclosed: `site` points to the Vercel demo, so canonical/OG/RSS/sitemap URLs reference it until changed.

## Patch (patch-check.txt)
- README.md +2 lines. `git diff --check` exit=0; `git apply --check` on clean HEAD exit=0; 0 trailing-whitespace lines.
- sha256 `287158c467fd5bd54966bda38b958a05c9ea7be0084baa6202d77770f894f9d6`.

## Open item
- Acceptance uncertainty only: last merge 2025-06-16. Badge image and wasmer.io import page not opened here.

## Claims table (PR_BODY sentence -> receipt)
| Claim | Receipt |
|---|---|
| Two-line README change below Vercel/Netlify | upstream.patch |
| Detected static Node.js, Astro, npm 11, `dist` | plan.txt, plan.json |
| SHA f7e3a40 is current main | duplicate-check.txt header, replay.log line 1, patch-check.txt |
| Node 24.22.1, npm 11.21.1, only package.json + lockfile staged | replay.log (`node -v`, `npm --version`, `# staged before install`) |
| `npm install` exit 0; `npm run build` exit 0, 0 errors; 45 files | replay.log |
| SWS 2.38.0 | http-receipts.txt line 1, replay.log |
| 12 paths 200, 2 paths 404 | http-receipts.txt `## pages` |
| 40 refs from 17 pages; 24 x 200, 16 x 308 -> 200 | http-receipts.txt `## assets` |
| `site` points to Vercel demo | external-refs.txt; astro.config.mjs at HEAD |
| No third-party scripts/analytics | external-refs.txt |
| No custom 404 page | http-receipts.txt (106 B default body) |
| Last commit on main 2025-06-16 | policy-files.txt (`git log -5`) |
