# gatsbyjs/gatsby-starter-default (replacement 53) — HOLD

- Pinned `e75499fb47c626b252879f37cadc4d5167dfd59e`; 1,396 stars / 956 forks (GitHub API 2026-10-22); 0BSD/MIT per repo.
- Anybuild v0.33.0: static Node.js provider, `npm install` / `npm run build`, output `public`.
- Replay: install/build exit 0; `/`, `/page-2/`, `/using-typescript/`, `/404/` 200, all assets 200. But the starter's home page links to its **SSR** and **DSG** demo pages (`/using-ssr/`, `/using-dsg/`), which Gatsby renders on a Gatsby server; with static hosting they return **404** (replay.log smoke).
- gatsbyjs repos: earlier vendor deploy PRs on the sibling gatsby-starter-blog were closed unmerged (see replacement 02 evidence).

## Verdict: HOLD
Reason: the starter's own demo features (SSR/DSG) break on a static deployment; a README-only button would ship a demo with broken links.
