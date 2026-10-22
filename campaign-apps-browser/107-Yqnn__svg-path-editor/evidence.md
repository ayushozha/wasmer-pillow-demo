# Yqnn/svg-path-editor: evidence

**Verdict: CONDITIONAL.** The build and smoke pass, and it is a single-URL app with no router, so no deep links break. The open question is a privacy one: `src/index.html` hard-codes the maintainer's Google Analytics tag (`gtag('config', 'G-1BBJSPSKQ9')`), and the built `index.html` keeps it. Every Wasmer-deployed copy would report page views to the upstream author's GA property. It would also load Roboto and Material Icons font files from fonts.gstatic.com: Angular inlines the Google Fonts CSS at build time, which also means the build itself fetches fonts.googleapis.com (receipt-checks.txt). The reviewer, or the maintainer in review, should decide whether a deploy button is appropriate while that tag is present. The PR text discloses it, and the README patch does not claim privacy or offline use.

## Repository
- Pinned SHA: `937d75a83b6be2bdda11d02b9b3594841315223a` on `master`. The last commit is 2026-06-18.
- Stars / forks: 5,339 / 423. Not archived (GitHub API, 2026-10-22).
- License: Apache License 2.0 (`LICENSE`).
- Policy: there is no CONTRIBUTING, PR template, AI policy or bot (`.github/` holds only `FUNDING.yml`). The README has no deploy section. It has "Running Locally" (npm install / npm start / `npm run build` into `dist/`) and links the GitHub Pages instance.
- Merged PRs since 2025-10-01: 6. That includes outside contributors (#172 by GregOriol, #166 by shiro-el); the rest are by the owner Yqnn. The maintainer reviews and merges external PRs.
- Duplicate `wasmer` PRs: 0. Prior deploy-button PRs: none (the only "deploy" hit is #28 "Fix Issue 26", 2021).

## Anybuild detection (v0.33.0)
- Provider: static Node.js; framework Angular; npm (`package-lock.json`). Output dir: `dist/svg-path-editor`, which matches `angular.json:20` `"outputPath": "dist/svg-path-editor"`.
- Install inputs staged: `package-lock.json` and `package.json` (`node_install_inputs: ["package.json"]`). Env: `CI=true NPM_CONFIG_FUND=false`.
- Commands: `npm install`, then `npm run build` (`ng build`), then `static-web-server --root=/opt/static_app --log-level=info --port=8080`. There is no `_redirects` file.

## Replay (patched clone, Node 24.22.1, npm 11.21.1)
- `npm install` exited 0. npm warned that 4 packages' install scripts (esbuild, nx, nice-napi) are "not yet covered by allowScripts". The build still succeeded.
- `npm run build` exited 0 and produced 13 files. The output was served with a local native static-web-server 2.38.0, the version Anybuild's plan pins. Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here.
- Smoke results (all 200):
  - `/` ("SvgPathEditor", 40.7 KB).
  - `main.c2644f28e3f13a72.js`, `polyfills.*.js`, `runtime.*.js` and `styles.*.css`.
  - `favicon.ico`, `manifest.webmanifest` and `assets/icons/icon-152x152-cropped.png`.
  - The Angular service worker files: `ngsw-worker.js`, `ngsw.json`, `safety-worker.js` and `worker-basic.min.js`.
  - `3rdpartylicenses.txt`.
- `/nope` returned 404 (expected).
- Routes: there is no Angular router (no `RouterModule` or `provideRouter`). `window.location.hash` is read only by `src/app/import/import.component.ts:46` for importing path data. The fragment never reaches the server, which only serves `/` and the assets.
- I did not test editing or the PWA service worker in a browser.

## Env vars
- None. The source has no `process.env` or `import.meta.env` reads.

## Security (shipped code)
- `npm audit --omit=dev`: 11 issues (5 high, 6 moderate, 0 critical), all in Angular 17.3.12. Angular 17 is out of support.
- Applicability review of the high advisories against this app's code:
  - i18n XSS (GHSA-prjf / g93w / jj27): the app does not use i18n or `$localize`.
  - SVG script-attribute XSS (GHSA-jrmj): there are no `<script>` bindings. The only URL binding is `[attr.xlink:href]="im.data"` for a locally uploaded image, which the user supplies themselves.
  - Hydration and HttpTransferCache issues: these are SSR only, and the app has no SSR.
  - XSRF token leakage: HttpClient is only used for local icon SVGs, with no XSRF tokens.
  - Service worker header leakage on cross-origin redirects: the app makes no credentialed cross-origin requests.
  - Router SSR DoS: SSR only.
- None of these looks exploitable in this app. A reviewer may still prefer to note that it ships an EOL Angular.

## Receipts
- `replay.log`: install, build and smoke output. `receipt-audit.txt`: npm audit. `receipt-adv.txt`: advisory lookups. `receipt-checks.txt`: the GA tag and inlined fonts in the built `index.html`.

## Remaining check for the reviewer
- Decide on the GA tag (above). If acceptable, the PR text already discloses it.
- Verify the badge and import page in a browser; `img.shields.io` and `wasmer.io` are blocked here.
