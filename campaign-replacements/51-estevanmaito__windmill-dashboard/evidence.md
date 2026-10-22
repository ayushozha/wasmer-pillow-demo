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


## Security review of what the static demo ships (2026-10-22)
Third-party scripts are loaded from CDNs in every page (e.g. `public/index.html:13-24`), with no Subresource Integrity attributes:
- Chart.js `2.9.3` from cdnjs (`Chart.min.js`, `Chart.min.css`). Official npm advisory data: **GHSA-h68q-55jf-x68w (high, prototype pollution, `<2.9.4`)**. Input path in this repo: the charts are created only in `public/assets/js/charts-lines.js`, `charts-pie.js`, `charts-bars.js` with hard-coded labels/data and options; no URL parameter, form field, storage value or fetched data reaches Chart.js options. So the vulnerable merge path is not fed untrusted input in the demo as shipped. It would become relevant if someone wires user-controlled data into chart options; the fix is Chart.js ≥2.9.4.
- Alpine.js from jsDelivr `gh/alpinejs/alpine@v2.x.x` — a floating range that resolves to the latest v2 tag at request time. `alpinejs` 2.x has no npm advisories. Directives in the pages are static markup (`x-data` etc.); no `x-html` is used.
- `init-alpine.js` reads/writes only `localStorage['dark']` (JSON boolean) for the theme toggle.
- Anything else is static HTML/CSS. No backend, forms submit nowhere.
Not done (not requested): no library upgrade or rewrite in this PR; behaviour of the floating Alpine range and CDN availability are third-party dependencies.

Live import check (root, 2026-10-22): the unpatched upstream shows Node (node-base), as predicted; the `Staticfile` in this patch is what switches it to static `public/` hosting.

## Verdict: CONDITIONAL — technically passing; ships Chart.js 2.9.3 (high advisory, not reachable with the demo's hard-coded data) via CDN without SRI; low maintainer activity. Root decides whether to promote with the disclosed limitation.
Remaining check for root: open https://wasmer.io/apps/create?github=estevanmaito%2Fwindmill-dashboard and confirm it shows a static site with `public` (after the patch is merged it is detected from the default branch; before merge the import shows the unpatched Node detection — so the import-page check is only meaningful on the patched source).
