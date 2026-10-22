# treefarmstudio/odyssey-theme: evidence

**Verdict: CONDITIONAL** (README-only patch; replay passes). The condition is maintainer activity: the last maintainer-merged PR was #49 (2024-09-25), and later outside PRs (#54-#64) are open or closed unmerged.

## Repository
- Pinned SHA: `d191e5715a2519e25be4629b933189c421b30a1a` on `main` (default). Last commit 2024-09-24; not archived.
- Stars / forks: 785 / 212 (GitHub API, 2026-10-22).
- License: MIT ("Copyright (c) 2024 Treefarm Studio LLC").
- README "## Support": "Please feel free to post issues or submit PRs to this repo and we will do our best to respond in a timely manner, keeping in mind this template is offered for free as is on GitHub." No CONTRIBUTING, PR template or AI policy. `.github/workflows/deploy.yml` deploys the maintainers' demo to Deno Deploy on push/PR, so it is not a PR-closing bot.
- PRs: 31 total. Merged since 2025-10-01: 0. No deploy-button/provider PRs. Duplicate `wasmer`: none. Not in the campaign's existing PR list.
- Existing deploy docs: README "## Deploy" says "Feel free to deploy and host your site on your favorite static hosting service such as Netlify, Firebase Hosting, Vercel, GitHub Pages, etc." The patch adds a "### Deploy on Wasmer" subsection at the end of that section.

## Anybuild detection (v0.33.0)
- Provider: node-static, framework Astro, npm (plan pins npm 11; `package-lock.json` + `package.json` staged), `npm install` / `npm run build`, output `dist` (`plan.txt`). Astro static output (no adapter).

## Replay (patched clone, Node 24.22.1, npm 11.21.1)
- `npm install` exit 0; `npm run build` exit 0; 76 files.
- Smoke: `/`, `/blog`, `/company/about`, `/company/contact`, `/landing-pages/landing-1`, `/theme/style-guide`, `/404.html` 200 with the expected titles; 25 refs from `/` 200.
- `/sitemap-index.xml` and `/rss.xml` 404 (observed). These were my guesses; the build emits `/sitemap.xml` (200, supplementary) and has no RSS feed.
- Supplementary: all 36 unique local `href`/`src` across every HTML page returned 200 (directory URLs without a trailing slash return 308 to the slash form, then 200).
- **Forms:** the contact/newsletter forms `POST` to `/contact-thank-you` / `/newsletter-thank-you` (`src/components/forms/*.astro`). static-web-server returns 405 for POST (observed). The README says the forms are set up "for Netlify, Formspree, Formspark, etc.", so on Wasmer they need an external form endpoint. The README sentence says so.
- Astro 4 is build-time only (static output); no server runtime is deployed.

## Remaining check for the reviewer
- Verify badge and import page in a browser (img.shields.io / wasmer.io blocked here).
- Accept low maintainer activity.
