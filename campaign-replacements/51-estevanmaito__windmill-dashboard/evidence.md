# estevanmaito/windmill-dashboard (replacement 51)

- Upstream: https://github.com/estevanmaito/windmill-dashboard, default `master`, pinned `e05267588134ca2f4129087cc65a59c38a9c36b5`.
- Popularity (GitHub API, 2026-10-22): 3,032 stars, 478 forks, not archived. License MIT (`LICENSE`, © 2020 Estevan Maito).
- Policy: no CONTRIBUTING / PR template / AI policy. README "Usage": "Clone or download this repo and everything you need is inside the `public` folder." PR history: 24 PRs, many dependabot left open; #55 (Tailwind v4 update) closed 2026-04-25 → low maintainer activity; acceptance risk moderate.
- Duplicates: no `wasmer` PRs (batch search 2026-10-22); no prior deploy-button PRs.
- Not on the static session's ledger (`static_excl.txt`).

## Anybuild v0.33.0
- Unpatched: plan = Node provider (`npm install`, `npm run build`, no start) → not a static deployment (`replay` r-windmill: every page 404).
- Patched with `Staticfile` `root: public`: StaticFile provider (score 50, `providers/mod.rs:444-448`; detection `staticfile.rs:190`; root read `staticfile.rs:140-160`), build = copy `public/` (`staticfile.bzl:32-56`), serve static-web-server 2.38.0.

## Replay (patched): see replay.log — 13 pages + 4 local assets 200; `/does-not-exist` 404.

## Verdict: READY (technical) — moderate acceptance risk (low maintainer activity)
Remaining check for root: open https://wasmer.io/apps/create?github=estevanmaito%2Fwindmill-dashboard and confirm it shows a static site with `public` (after the patch is merged it is detected from the default branch; before merge the import shows the unpatched Node detection — so the import-page check is only meaningful on the patched source).
