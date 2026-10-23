# 51 estevanmaito/windmill-dashboard: receipts (2026-10-23)

## Source
- Fresh `git clone --filter=blob:none`, `master` HEAD `e05267588134ca2f4129087cc65a59c38a9c36b5` (last commit 2020-08-05). Prior pin is the same SHA, so upstream has not moved. The prior change was re-applied, with one README sentence adjusted to the required button wording. `upstream.patch` sha256 `7f54f49c4e5fc9066421392f06c06efae4b0aa772e9d4277987f5b40d60394cc`. `git apply --check` on a clean HEAD exit 0, `git diff --check` exit 0.

## Policy (policy-files.txt)
- No CONTRIBUTING, AGENTS.md, CLAUDE.md, `.cursorrules`, `.github/` (no copilot instructions, PR template or CLA workflow), and no AI/agent rule at HEAD. README Usage: "Clone or download this repo and everything you need is inside the `public` folder."
- No lint/test script exists, so no rule required a command. The `build` script was run for the CSS check (below).

## Duplicates (duplicate-check.txt)
- 24 PR refs fetched (`refs/pull/*/head`, all states, #3 to #55). `--grep=wasmer`: none. `--author=wasmer/ayush`: none. README.md/Staticfile containing "wasmer" in any PR ref: none. No PR ref adds a Staticfile.

## Plan (plan-without-staticfile.*, plan.*)
- Without the Staticfile (Anybuild 0.33.0): "Detected Node.js provider", `npm install` / `npm run build`, warnings "no start or main script found in package.json" and no entry file. This is not a static deployment.
- With `Staticfile` `root: public`: "Detected static site provider", output directory `public`, SWS 2.38.0, no install or build. Start command is `static-web-server --root=/opt/static_app`.
- Wasmer serves the committed `public/` folder verbatim. Nothing is built.

## Replay (replay.log, smoke.txt)
- `$S/scripts/replay.sh <patched clone> val2-windmill 3961 / <12 pages> /does-not-exist /pages/nope.html`. Copy step exit=0 (28 files). No install/build step exists for this provider.

## HTTP (http-receipts.txt, refs.txt via enum_refs.py)
- `/` and all 12 `.html` files in the served dir return 200 `text/html`.
- 25 unique local href/src targets: 24 are 200 (css `text/css`, 5 js `text/javascript`, 6 jpeg `image/jpeg`, 12 html). 1 is 404: `/pages/pages/blank.html`. This is a pre-existing upstream bug (`public/pages/404.html:557` uses `href="pages/blank.html"`) and does not come from the hosting.
- 4 unreferenced files in the served dir return 200 (png and svg with correct types). The missing paths `/does-not-exist`, `/pages/nope.html` and `/assets/js/nope.js` return 404. `/package.json`, `/Staticfile`, `/README.md` and `/tailwind.config.js` return 404, because they are outside `public/`.
- Total: 41 x 200, 8 x 404 (1 upstream bug + 3 missing + 4 outside-root).

## Compatibility review
- CSS in sync (css-sync.log): `git archive HEAD`, then `npm ci --ignore-scripts` exit 0 and `npm run build` exit 0 (Node 24.22.1, npm 10.9.4). The rebuilt `tailwind.output.css` is byte-identical to the committed one (sha256 25d861ce…a6e6, 28597 B). All 12 pages reference it. node_modules was deleted afterwards.
- Libraries (libs-advisories.txt): `adv.py chart.js@2.9.3` reports 1 high, GHSA-h68q-55jf-x68w (<2.9.4, prototype pollution). `alpinejs@2.8.2` reports 0. Alpine is loaded as `alpine@v2.x.x`, a floating tag. jsDelivr returns 403 through the proxy, so 2.8.2 is the highest 2.x on npm, taken as a proxy. Chart.js loads on 2 pages. All three `new Chart(...)` configs are hard-coded object literals. The chart scripts contain no location, fetch, storage, form or JSON input. `init-alpine.js` reads only `localStorage['dark']` (theme), and there is no `x-html`. No user input reaches chart options in the shipped demo. No SRI anywhere (0 `integrity=`). External: cdnjs, jsDelivr, Google Fonts, Unsplash.
- Deep links: none needed. This is a multi-page site with real `.html` files, and no rewrites were added.

## Verdict: READY (with disclosed limitations)
- Open items are disclosures, not blockers: Chart.js 2.9.3 advisory (not reachable with demo data), CDN deps without SRI, pre-existing broken "Blank" link in 404.html, and low maintainer activity (last commit 2020-08-05).
- The import page and badge were not opened from this environment. No deployment was made.

## Claims table (PR_BODY.md -> receipt)
| Claim | Receipt |
|---|---|
| No HTML/CSS/JS changes; README subsection + one-line Staticfile | upstream.patch |
| README says everything is in `public` | policy-files.txt |
| Without Staticfile: Node.js provider, npm install / npm run build, no start script | plan-without-staticfile.txt/.json |
| With Staticfile: static provider, output `public`, no install/build | plan.txt, plan.json, replay.log |
| Served verbatim, copy 28 files exit 0, SWS 2.38.0 | replay.log |
| Base SHA e0526758… on master | policy-files.txt, replay.log, duplicate-check.txt |
| `/` + 12 pages 200 text/html | http-receipts.txt |
| css/5 js/6 jpeg 200 with types; 3 missing paths 404; package.json/README.md not served | http-receipts.txt |
| npm ci/build exit 0, Node 24.22.1, npm 10.9.4, byte-identical CSS, 12 pages link it | css-sync.log |
| CDN libs, floating Alpine tag, no SRI | libs-advisories.txt |
| Chart.js GHSA-h68q-55jf-x68w high, fixed 2.9.4; alpinejs 2.8.2 none, latest 2.x | libs-advisories.txt |
| Charts use only hard-coded data; no URL/form/storage/fetch input | libs-advisories.txt |
| 404.html Blank link -> /pages/pages/blank.html 404 | http-receipts.txt, refs.txt |
| Low maintainer activity | policy-files.txt (last commit 2020-08-05) |
