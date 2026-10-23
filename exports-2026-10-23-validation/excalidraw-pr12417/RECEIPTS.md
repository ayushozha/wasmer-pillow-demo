# excalidraw/excalidraw PR #12417 — exact-head validation (local, read-only)

## Head / base
- Expected head `2a0620cb104a5a53d0ebf9e6b4edd730ac8837dc`; `git rev-parse HEAD` after `git fetch origin pull/12417/head` + checkout = **2a0620cb104a5a53d0ebf9e6b4edd730ac8837dc (match)**. Clone: `git clone --filter=blob:none`. Receipt: `git-receipts.txt`.
- Base branch: **master** (repo default branch; the API does not confirm it, see below). merge-base(origin/master, HEAD) = `1d4dc2c0e6e476911d0760e9c3cf3694f2d43384` (2026-10-21). PR = 1 commit `2a0620cb build: add Wasmer deployment option` (commit message body is empty).
- `pr.json` / `pr-files.json`: the unauthenticated API call returned **HTTP 403 from this session's egress proxy** ("GitHub access to this repository is not enabled for this session"). The raw responses are kept as they came back. The PR **body, state and API head SHA could not be fetched**, so no API head-SHA comparison was possible. The github.com PR page and `.patch` were blocked the same way. Credentials were not attached, per the brief. The file list below comes from git.

## Files changed by the PR (`git diff --name-status 1d4dc2c0..HEAD`): 2 files, +25/-0
| file | status | blob at HEAD | blob at merge-base |
|---|---|---|---|
| `Anybuild` | A (+17) | `4ed8b63a54c7cb9369c48a5146c2f33ae2886e46` | — |
| `README.md` | M (+8) | `dcb1989f5253321eeaae528b27fed803a15c7d37` | `48b9d1de9fbb1c74406407e89e2471a01b1f28de` |

- Lockfile `yarn.lock` blob `e2eb9e911b805274a3e3e83a372a82a1e7f621bf` (same at HEAD and merge-base). The PR does not change it. `package.json` `c91ee030…` is also unchanged.
- Hooks: `.husky/` tree `cc4e59e1…` (only `.husky/pre-commit` `ab2a5ac5…`, whose `yarn lint-staged` line upstream has commented out) and `.lintstagedrc.js` `612d4c39…`. Both are identical at HEAD and merge-base. `git diff 1d4dc2c0..HEAD -- .husky .lintstagedrc.js yarn.lock package.json` = 0 lines. No lefthook, simple-git-hooks or pre-commit config exists. Nothing was committed and no hook was bypassed. `husky install` ran during `yarn install` (the `prepare` script), printed `fatal: not a git repository` (Anybuild's work dir has no `.git`), and exited 0.
- Committed `Anybuild`: `nodestatic_config(install "yarn --frozen-lockfile", yarn 1.22.22, node_version "24", node_build_command "yarn build:app:docker", node_install_requires_all_files=True, static_dir "excalidraw-app/build")` + `staticfile_serve(..., provider="node-static")`.

## Anybuild replay (Anybuild v0.33.0, `$S/w/anybuild-v0.33.0`)
1. **Harness as-is** (`scripts/replay.sh`, which runs `plan --temp-anybuild` and so IGNORES the committed Anybuild file): auto-detect gives provider `node` (server), install `yarn install`, build `yarn run build`, start `yarn --cwd ./excalidraw-app start`. The harness reported `NOT A STATIC PROVIDER`, so nothing was built and `/` returned 404. Receipts: `plan-autodetect-temp.{json,txt}`, `replay-autodetect-temp.log`, `smoke-autodetect-temp.txt`. This shows the PR's file is what makes the deploy static.
2. **Committed-file plan (the path a deploy of this repo takes)**: `replay-committed.sh` is `replay.sh` with one change, `plan --wasmer` without `--temp-anybuild`, so Anybuild reads the existing `Anybuild` file. The file's sha1 was the same before and after the plan. `plan.txt`: "Using static Node.js provider declared in Anybuild, Framework: Vite, Output directory: excalidraw-app/build". `plan.json`: provider `node-static`, install `yarn --frozen-lockfile`, build `yarn build:app:docker`, start `static-web-server --root=/opt/static_app …`, `yarn_version 1.22.22`, `node_install_requires_all_files: true`.
   - **Workspace input gap?** No. `node_install_inputs` lists all 11 workspace `package.json` files, and `node_install_requires_all_files=true` stages the full tree before install. The replay used the full tree, which is the Anybuild path here, not a workaround.
   - `node -v` v24.22.1 (exit 0); `yarn --version` 1.22.22 (exit 0).
   - `yarn --frozen-lockfile`: **exit 0** (Done in 122.05s; only peer-dependency and resolution warnings).
   - `yarn build:app:docker` (`cross-env VITE_APP_DISABLE_SENTRY=true vite build`, vite 5.0.12): **exit 0** ("✓ built in 43.47s"). WARN: `./Assistant-{Regular,Medium,SemiBold,Bold}.woff2 referenced in packages/excalidraw/fonts/fonts.css didn't resolve at build time`. See the 404s below.
   - No INSTALL FAILED, BUILD FAILED or MISSING. static_app has **506 files** (47 MB: 124 js, 123 map, 233 woff2, 1 css …), list in `static_app-filelist.txt`. 0 precompressed (.gz/.br) files.
   - Raw output: `replay.log`, `replay-run.out`, `smoke.txt`, `sws-replay.log`.

## HTTP (`http-receipts.txt`, script `http-check.sh`, server log `sws-http.log`)
Served with a local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here).
- 380 requests: `/` and `/index.html` 200 text/html. Every local ref in index.html is 200: 3 icons, the entry JS, the modulepreload JS, the CSS, sitemap, and `manifest.webmanifest` (application/manifest+json). `sw.js`, `workbox-3631b453.js` and `service-worker.js` are 200 text/javascript. All 10 manifest icons/screenshots are 200 image/png. **All 124 JS chunks are 200 text/javascript**, the CSS is 200 text/css, and **all 233 self-hosted `.woff2` are 200 font/woff2**.
- `/definitely-missing-q7x3k9` returns **404** (text/html, 106 B). That is correct. smoke.txt lists it as "FAIL" only because the smoke script expects every extra path to be a page.
- Routes: the app is a single URL (state lives in `#json=`/`#room=` hashes and localStorage). The manifest declares a `share_target` POST `/web-share-target`, which the service worker handles. Without the service worker it returns 404 on the static server. Vercel-only redirects (`/webex/*`, vscode host) and `_headers`/`vercel.json` headers are not part of a static deploy.
- Untested native-vs-Wasm gaps: MIME mapping for `.woff2`, `.webmanifest` and `.js` on the WASI SWS 2.32.2 package, and its 404/no-page-fallback behaviour. The local `_headers` file (`Access-Control-Allow-Origin: *`) is not read by SWS.

## Browser (Playwright/Chromium; every non-127.0.0.1 request aborted). `browser-receipt.txt`, `browser-text-fonts.txt`, `browser-rectangle.png`
- `/` returned 200, title "Excalidraw Whiteboard", 2 canvases. Pressing `r` and dragging gave localStorage `excalidraw` = 1 element `{type: rectangle, 200×150, isDeleted:false}`: **rectangle_created=true**. The service worker `/sw.js` registered. 0 page errors.
- 12 console errors. 8 are `ERR_FAILED` from the blocked externals. 4 are 404s for `/assets/Assistant-{Regular,SemiBold,Medium,Bold}.woff2`: the UI font fallback URL points at `/assets/`, but those files are not emitted there. The cause is upstream, in `fonts.css`/the Vite config, not in the PR. On excalidraw.com the CDN serves these fonts.
- Blocked external origins: `excalidraw.nyc3.cdn.digitaloceanspaces.com` (7 requests, font preloads, because `window.EXCALIDRAW_ASSET_PATH` lists the upstream CDN first) and `scripts.simpleanalyticscdn.com` (1 request, analytics loaded whenever PROD). Adding a text element made the canvas font fall back to the local copy: `200 /fonts/Excalifont/Excalifont-Regular-a88b….woff2`.
- Upstream service defaults baked into the JS (`external-origins.txt`): oss-collab.excalidraw.com (live collaboration websocket), Firebase project excalidraw-room-persistence (collab/share storage), json.excalidraw.com (shareable links), libraries.excalidraw.com, oss-ai.excalidraw.com (AI), plus.excalidraw.com and app.excalidraw.com, a sentry.io DSN (disabled at runtime by `VITE_APP_DISABLE_SENTRY=true`, and no request was seen), the DO CDN, and simpleanalytics. The test flow did not touch collab, share, AI or libraries. These are optional externals. **A static deploy hosts only the editor and is NOT a full self-hosted stack.** Live collaboration and shareable links depend on excalidraw's hosted services.

## Repo's own checks
None were requested for this target. `AGENTS.md` at HEAD contains only coding-style guidance, which does not apply because there are no code changes.

## PR body claims → status
The PR body was not retrievable (API 403), so every claim made **in the PR body is UNVERIFIED** and could not be compared. These are the claims the PR makes in its own README text:
| claim (README.md added by PR) | status |
|---|---|
| Anybuild file configures a static deployment | **verified** (plan: provider node-static, static-web-server start) |
| `yarn --frozen-lockfile` installs dependencies | **verified** (exit 0, yarn 1.22.22, Node 24.22.1) |
| `yarn build:app:docker` builds the editor | **verified** (exit 0, 506 files) |
| `excalidraw-app/build` contains the output | **verified** (index.html + assets present; served 200) |
| run these from the repository root | **verified** (root scripts delegate with `--cwd`; replay ran at root) |
| "hosts the web editor; collaboration, cloud storage, and AI features still depend on separately configured services" | **verified, but incomplete**. The build also loads its fonts from the upstream DigitalOcean CDN first (with a local fallback) and loads simpleanalytics by default. These are not mentioned. |
| Deploy button opens Wasmer import page for the repo | **unverified** (not tested: no hosted calls) |
| Works on Wasmer Edge (WASI SWS) | **unverified** (native SWS 2.38.0 only) |
| anything else in the PR body (versions, counts, "tested") | **unverified**: body not fetched |
