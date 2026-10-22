# aykutkardas/regexlearn.com: evidence

**Verdict: CONDITIONAL (policy and analytics).** The technical replay passes. Three things need a human call before opening:

1. **Advertising concern.** The README sells logo placement ("Sponsorship puts your brand in front of a worldwide audience... Want your logo up there? Get in touch"). A provider badge may be read as unpaid advertising. Compare 2048 PR326, where a badge was rejected as an advertisement.
2. **Analytics.** `src/pages/_document.tsx:18,42` hardcodes Google Tag Manager `GTM-WMNH2QX` for non-development builds. Every third-party deployment would send pageviews into the owner's GTM/GA. The PR discloses this, and the owner may still dislike it.
3. **Prior deploy PR.** #359 "add dockerfile .dockerignore" (a third party, 2024) was closed unmerged. I could not read the comments here (the GitHub issue API returns 403 outside this session).

## Repository
- Pinned SHA: `ab2419c23777017f83ec9ca75c2155bbca5bc0ca` on `main`, dated 2026-10-04.
  - `main` is the default branch, and `git ls-remote` shows only `main` (the `develop` branch used for the v3 PRs has been deleted).
  - The README says: "Please target the **`main`** branch with your pull requests."
- Stars / forks: 4,112 / 271. Not archived. Last push 2026-10-04 (GitHub API, 2026-10-22).
- License: MIT (`LICENCE`, Copyright (c) 2021 Aykut Kardaş).
- Contribution text (README): "Spotted a typo, a bug, or an awkward translation? A small pull request is all it takes..." and "`main` is production: every pull request merged into it is deployed to regexlearn.com automatically, so please make sure `npm run build` passes before opening one."
  - There is no CONTRIBUTING file, PR template, AI policy or CLA. `.github/` has only `FUNDING.yml`, so there are no bots.
- Merged PRs since 2025-10-01: 21, all by the OWNER (v3 refresh, translations).
- Duplicate `wasmer` PRs: 0. Deploy-related PRs: #359 (Dockerfile, NONE, closed unmerged 2024-07-29).
- Lane note: this is a regex learning course (learning/typing lane), not a developer utility like regexper.

## Anybuild detection (v0.33.0)
- Static Node.js provider, Next.js with `output: 'export'` (`node_static.rs` NEXT_STATIC_EXPORT_PATTERN), output directory `out`.
- Install: `npm install` with `package.json` and `package-lock.json` staged, using npm 11 and `CI=true NPM_CONFIG_FUND=false`.
- Build: `npm run build`. Start: `static-web-server --root=/opt/static_app --log-level=info --port=8080`. No Staticfile is needed.

## Replay (patched): Node 24.22.1, npm 11.21.1 (from replay.log)
- `npm install` exited 0. `npm run build` exited 0 (`next build`, then the postbuild `next-sitemap` and `html-lang-fixer`). There are 133 HTML files.
- Smoke (local sws 2.38.0):
  - 200: `/`, `/learn`, `/learn/regex101`, `/cheatsheet`, `/playground`, `/en`, `/en/learn`, `/tr`, `/tr/learn`, `/tr/cheatsheet`, `/Open%20Source.webp`, `/sitemap.xml`, `/robots.txt`, and 24 `_next/static` and image refs.
  - `/learn/basic-matchers` returned 404. That was my guessed path; the only lesson pages exported are `regex101` and `regex-for-seo`, and the course itself runs on `/learn`.
  - `/nope` returned 404.
  - The smoke tool reports a failure for `/Open Source.webp` because Python's urllib rejects the space. The URL-encoded fetch returned 200.
- Routes: pages are fully pre-rendered, so deep links reload fine **on sws 2.38.0**. sws resolves `/cheatsheet` to `cheatsheet.html` and `/learn` to `learn/` and then `learn.html` (see sws.log). Whether Wasmer's hosted static server (SWS 2.32.2 WASI) does the same extension resolution was not tested. It is disclosed in the PR.
- The `rewrites`/`redirects` in `next.config.js` are ignored by `output: 'export'`. The site works without them (`/` and `/en` are both exported).
- `public/_headers` (CSP, HSTS and similar) is copied but not interpreted by sws.

## Env vars
- `process.env.NEXT_PUBLIC_BASE_URL` (`src/pages/_app.tsx:29`) defaults to `https://regexlearn.com` and is used for canonical and OG URLs. It is public and not a secret. The core works with it unset (tested unset).

## Security (runtime deps, lockfile versions; npm advisory bulk API)
- 0 advisories: next 16.3.8, react and react-dom 19.3.0, react-intl 12.1.3, @headlessui/react 2.2.10, canvas-confetti 1.9.4, clsx 2.1.1, lookie 1.1.0 and react-icomoon 2.6.2.

## Remaining checks for the reviewer
1. The advertising and sponsorship judgement and the GTM concern above. If either is unacceptable, this becomes a policy HOLD.
2. Read the #359 comments.
3. Verify the badge and import page in a browser.
4. Optionally, check extensionless `.html` resolution on a real Wasmer deploy.
