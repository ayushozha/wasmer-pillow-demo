# Wave 2 exports (2026-10-23)

Each target here was prepared earlier. This wave did a fresh exact-source clone, a policy re-read, an all-state duplicate check over `refs/pull/*/head` (git only, no API) and a targeted compatibility review.

All HTTP results were served with a local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here).

Each folder's `RECEIPTS.md` is the entry point. "Update 2" sections there record the corrections from root's review. Every `PR_BODY.md` starts with the button image carrying `width="328" height="48"`.

| Folder | HEAD | Status | upstream.patch sha256 |
|---|---|---|---|
| `export-30-yaoyao-liu__minimal-light/` | `dd114c3fef2d97adc1c6b6d46901e0d96ab83a7c` | READY. Concise README with review/correct-before-Deploy wording. Limitations cover the single-page routes and the generic 404, the author's GA ID, and the missing lockfile. | `08dff7ab375d11949580d81ac379eb16e1cffa5ec7f0e03b2c142dac0ae69ab8` |
| `export-51-estevanmaito__windmill-dashboard/` | `e05267588134ca2f4129087cc65a59c38a9c36b5` | READY. Same README wording fix. Limitations cover the `.html`-only routes, the fact that files outside `public/` 404, the Chart.js 2.9.3 advisory and low activity. | `999ca7fd04b2d1cf251e8e6f8934b6d66a508014a86699954bdf76e553780191` |
| `export-109-Bowen7__regex-vis/` | `a6d920601ca44ab2d4e9cd02306510ab6d5e4b38` | READY after the routing fix. A committed `Anybuild` adds literal rewrites for `/samples` and `/samples/` only, with no catch-all. 21/21 HTTP checks pass, including 10 negatives that 404. Direct loads and reloads of `/samples` work in the browser, and `pnpm test` passes 53/53. The README-only version is kept as `…-SUPERSEDED-readme-only/`. | `b088cf04a8eaf60a2a10f580494d3dff1e62fb521baca29dfe1b731eb0a60b41` |
| `export-09-markhorn-dev__astro-sphere/` | `f7e3a40f20e1267d7fbbb7b6dd868df1845e1d82` | READY. The README now adds one paragraph after the badge: Wasmer runs npm install and build and serves `dist/`; you review and correct the preset before Deploy; no copy is made; fork to customize. | `1a2a94479d7abeddd276c67ce90d0e083485c750d177fe13ec4d49c7b0018b71` |
| `export-11-mhyfritz__astro-landing-page/` | `987617a50863d31bb865ee531391a191d74a878a` | READY. Same README paragraph. | `b17f57db6a179c523d7892dd88102afef0e64c2765a55d75d496f08826d2aaa6` |
| `export-70-treefarmstudio__odyssey-theme/` | `d191e5715a2519e25be4629b933189c421b30a1a` | READY. Same README paragraph. The forms need an external service. | `b2cf778c280dd697bb209dc49f9caefb2285e666e6bc183f5f22518c337a017f` |
| `export-23-barryclark__jekyll-now/` | `12cb8a2e97c3b63c4bc92d2a1ab050b35bf946b7` | READY after the plugin fix. A committed `Anybuild` keeps the detected install and overrides only the build: `bundle add jekyll-feed jekyll-sitemap --group jekyll_plugins && jekyll build`. Root's `bundle exec` variant fails on Ruby 3.4.7 with a csv LoadError; that run is kept in `attempt1-…/`. `/feed.xml` and `/sitemap.xml` return 200 and are valid XML, all 16 files return 200, and the negatives 404. The README-only version is kept as `…-SUPERSEDED-readme-only/`. | `4ec2a5c887b03dd7f8b5b32accc302fea330243d7fc79c0a767ece9bc367d32a` |
| `export-107-Yqnn__svg-path-editor/` | `937d75a83b6be2bdda11d02b9b3594841315223a` | Evidence complete (`audit/advisories.md`). No critical ships to the browser. Shipped Angular 17.3.12 has 12 high advisories, none reachable by another party's input; these are disclosed in Limitations. Publish only if root accepts that. | `611f7f466dfc495655cfdad0ec43301e4a9ce53289bef2e18628a7852b0254c8` |

`tools/` holds the duplicate-check and HTTP scripts for 23 and 30. `tools-astro/` holds the scripts for 09, 11 and 70.
