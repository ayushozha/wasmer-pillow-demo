# piskelapp/piskel: evidence

**Verdict: READY.** One caveat for the reviewer: the patch adds a one-line `Staticfile`, so it is slightly more than "documentation only". The README's contribution guidance accepts small changes of "only a few words or lines"; it is the reviewer's call whether to mention the Staticfile up front, as the PR body does.

## Repository
- Pinned SHA: `d828941fa9fe76464d69d91d5fd862067c98c02c` on `master`. The commit is from 2026-10-21. `master` is the default branch and the branch CI runs on.
- Stars / forks: 12,858 / 924. Not archived. Last push 2026-10-21 (GitHub API, 2026-10-22).
- License: Apache-2.0 (`LICENSE`; the README states "Licensed under the Apache License, Version 2.0").
- Contribution policy is in the README ("About PR contributions"). There is no separate CONTRIBUTING, PR template, AI policy or CLA.
  - It accepts: "Small, straightforward fixes (documentation updates, typos, incorrect strings, minor bugs): only a few words or lines."
  - It is unlikely to merge: "Pull requests that modify the user experience or introduce new features".
  - This patch is 7 README lines plus a 1-line `Staticfile`.
- Workflows: `ci.yml` only (biome lint and Playwright e2e). There is no bot that auto-closes PRs.
- Merged PRs since 2025-10-01: 11. Duplicate `wasmer` PR check: 0. Prior PRs with "deploy" in the title: 0, so there are no owner comments on provider buttons to weigh.

## Anybuild detection (v0.33.0)
- Unpatched (`plan-unpatched.txt`): static Node.js provider, framework Vite (Strong, score 60), output directory `dist`, which is the Vite default (`node.rs:334`). The build script has no `vite build --outDir` argument (`node_static.rs:525-536`), and `vite.config.js` sets `outDir: dest/prod`. The build runs, then "STATIC_DIR 'dist' MISSING" and `/` returns 404 (`replay-unpatched-summary.txt`).
- Patched: a `Staticfile` with `root: dest/prod`. In a node-static project the Staticfile `root:` becomes `static_dir` and the build still runs (`node_static.rs:202-205`, `260-276`). The node-static provider (score 60) still wins over StaticFile (score 50). Plan: install `npm install`, build `npm run build`, start `static-web-server --root=/opt/static_app --log-level=info --port=8080`, output `dest/prod`.
- Staged install inputs: `package.json` and `package-lock.json` (`node.bzl:95-140`). npm env: `CI=true NPM_CONFIG_FUND=false`.

## Replay (patched clone): Node 24.22.1, npm 11.21.1 (as printed in replay.log)
- `npm install` exited 0 (499 packages).
  - `prepare` runs `husky`, which printed ".git can't be found" and was non-fatal. No hooks were disabled.
  - npm 11 reported "install-scripts not yet covered by allowScripts" for `puppeteer@24.40.0` and `nw-builder@4.17.5`, so their postinstalls did not run: no Chrome or NW.js download. Neither is needed for `npm run build`.
- `npm run build` exited 0: `build:sprites`, then `vite build` (vite 8.0.7), then `scripts/partials.js` ("Generating Website partials..."). `static_app` holds 117 files.
- Smoke:
  - `/` returned 200 (title "Piskel").
  - `/nope` returned 404 (expected; single page).
  - `{{src}}` is a template placeholder inside an inline template, so its 404 is a smoke-tool false positive.
- Full asset check (`asset-check-list.txt`, 40 URLs, all 200 from sws 2.38.0):
  - JS and CSS: `js/piskel-packaged(-min)-<date>.js` and `css/piskel-style-packaged-<date>.css`.
  - Fonts: `css/fonts/icomoon.{eot,svg,ttf,woff}`.
  - Icons and sprites: every `img/cursors/*`, `img/icons/tools/*` and minimap image referenced by the CSS, plus `img/icons.png` and `img/icons@2x.png`.
  - Other: `logo.png` and `piskelapp-partials/main-partial.html`.
  - The GIF worker is built at runtime from a blob URL (`WorkerUtils.createWorkerURL`, `workerScript: window.GifWorkerURL`), so there is no separate worker file.
- Routes: single page, no router. Unknown paths return 404.

## Hosted-site difference and own-hosting rationale
- The README says this is "the editor used in piskelapp.com". The repo contains no server code. Hosted-site account and gallery features live outside this repo. I could not open piskelapp.com from here (blocked), so this is inferred from the repo contents. The OSS editor saves to browser storage and exports local files (.piskel, PNG, GIF, ZIP).
- Rationale: classrooms, game jams and teams can run an account-free editor on their own URL.

## Security
- The only runtime npm dependency is `minimist@1.2.8` (0 advisories). Shipped browser libraries are vendored in `src/js/lib`:
  - jquery 1.8.0: 5 moderate XSS advisories (APIs given untrusted HTML).
  - jquery-ui 1.10.3: 5 moderate.
  - bootstrap-tooltip (Bootstrap 2.x era; I assumed version 2.3.2 for the lookup): 6 moderate.
  - jszip 2.1.1.
- None of these are high or critical. They are moderate XSS issues that need attacker-controlled HTML passed into those APIs. The editor renders no third-party content, but these are long-standing upstream debts and should be noted.
- `npm audit` reported 41 issues (7 critical), all in dev/build tooling (karma, nw-builder, request, and others). None of it is shipped to the browser.

## Remaining checks for the reviewer
1. Verify the badge and import page in a browser; `img.shields.io` and `wasmer.io` are blocked here.
2. Optionally, open the deployed editor and draw, then export a GIF.
