> **HELD_POLICY (root, 2026-10-22) — DO NOT PUBLISH.** In drawdb-io/drawdb PR #57 the owner (1ilit) explicitly declined deployment buttons to keep the README clean: https://github.com/drawdb-io/drawdb/pull/57#issuecomment-2090613834 . No README button, no alternative account, no replacement venue. The technical replay below is kept as evidence only.

# drawdb-io/drawdb: evidence

**Verdict: HELD_POLICY (owner declined deploy buttons, PR #57).** There is also a technical HOLD: the build and the root page pass, but drawDB uses `BrowserRouter` and the editor lives on history-router URLs (`/editor`, `/editor/diagrams/:id`, `/editor/templates/:id`). static-web-server as Anybuild v0.33.0 starts it has no SPA fallback, so reloading or opening any of those URLs directly returns a bare 404. That breaks the main workflow (opening a saved diagram navigates to `/editor/diagrams/<id>`, so a refresh there shows a 404), not an edge case.

## Repository
- Pinned SHA: `7683bdf90a8db5d284dc6b2bc545831aa4b6dd76` on `main` (shallow clone; HEAD checked).
- Stars / forks: 40,100 / 3,330. Not archived. Last pushed 2026-10-15 (GitHub API, 2026-10-22).
- License: AGPL-3.0 ("GNU AFFERO GENERAL PUBLIC LICENSE Version 3, 19 November 2007"). A README-only PR is fine. Anyone hosting a modified version must offer its source to network users (AGPL section 13).
- `CONTRIBUTING.md`, "Submitting Pull Requests": "Make sure the pull request you work on is atomic... Fork the repository and create your branch from `main`... Write clear, descriptive commit messages." Commit style: "Use the present tense... Use the imperative mood". It asks contributors to contact the maintainer first only for "a big feature that has not been discussed before". There is no PR template and no AI policy.
- Workflows: `build.yml` (npm install, lint, build on Node 20/22) and `docker.yml`. There is no bot that auto-closes PRs.
- Merged PRs since 2025-10-01: 216 (GitHub search, 2026-10-22). The repo is very active.
- Duplicate check: the search `wasmer repo:drawdb-io/drawdb` returns 0 PRs.
- Earlier deploy-button PR: #57 "Adding one-click deploy template to README.md" (cosark, 2024). Its body: "Adding section enabling community access to one-click deployment templates at cloud hosting services". It was closed unmerged on 2024-05-02 with 2 comments. This session has no API access to the repo, so I could not read those comments. The root reviewer confirmed that the owner (1ilit) declined deploy buttons to keep the README clean (https://github.com/drawdb-io/drawdb/pull/57#issuecomment-2090613834), which makes this HELD_POLICY. Other "deploy" PRs (#305/#310 Electron, #667/#668 base path) are unrelated.
- Existing deploy docs: the README has "Build" and "Docker Build" sections, plus optional sharing via [drawdb-server] and `VITE_BACKEND_URL`. The repo's own hosting configures an SPA fallback in both places: `vercel.json` rewrites `/(.*)` to `/`, and the Dockerfile's nginx uses `try_files $uri /index.html`.

## Anybuild detection (v0.33.0)
- Provider: static Node.js; framework Vite; package manager npm (`package-lock.json`). Output dir: `dist`.
- Install inputs staged: `package-lock.json` and `package.json` (`node_install_inputs: ["package.json"]`). Env: `CI=true NPM_CONFIG_FUND=false`.
- Generated commands: install `npm install`, build `npm run build` (`vite build`), start `static-web-server --root=/opt/static_app --log-level=info --port=8080`. There is no `_redirects` file, so there is no redirects config.
- The plan pins npm 11. The replay ran npm 11.21.1 (the `npm --version` line in replay.log).

## Replay (patched clone, Node 24.22.1, npm 11.21.1)
- `npm install` exited 0. `prepare` ran husky, which printed ".git can't be found" and did not fail. `npm run build` exited 0 (Vite 8.1.0). `static_app` holds 28 files.
- Smoke:
  - `/` returned 200 ("drawDB | Online database diagram editor and SQL generator").
  - `/assets/index-CQwdX5nN.js` (17.2 MB) returned 200.
  - `/assets/index-CyUba-Ct.css` returned 200.
  - `/config.js`, `/robots.txt` and `/favicon.ico` returned 200.
- Routes:
  - `/editor`, `/templates`, `/editor/templates/1`, `/editor/diagrams/1` and `/bug-report` returned **404**, with an empty body (no 404.html).
  - `/nope` returned 404.
  - Client-side navigation from `/` to the editor works in principle (React Router), but I did not test it in a browser.
- Extra check (local native static-web-server 2.38.0 only): a scratch copy of the output with `index.html` duplicated as `404.html` returned that page with status 404 for `/editor`. This is recorded as a fact about the local server, not as a proposed fix. Wasmer's hosted server (`wasmer/static-web-server@=1.1.0`, SWS 2.32.2 for WASI, per root) has no page-fallback option and was not tested here, and no SPA-fallback configuration is proposed.

## Env vars read by the client
- `import.meta.env.VITE_BACKEND_URL` and `VITE_GIST_BACKEND_URL` (`src/config/index.js`). Runtime override: `window.__DRAWDB_CONFIG__` from `public/config.js`, which is `{}` in the repo. Without either, sharing and gist calls go to `http://localhost:5000` and fail. Diagram editing, SQL import/export and IndexedDB storage are local, so the core works with no vars. Any `VITE_*` value is baked into public JS. These are URLs, not secrets.

## Security (shipped code)
- `npm audit --omit=dev`: 1 high, in `follow-redirects` (via axios; credential header stripping). It is a Node-only transport, and the built bundle contains no follow-redirects code. It is not shipped to the browser.
- Runtime versions shipped: react 18.3.1, react-router 7.18.2, axios 1.20.0, jspdf 4.2.1, dexie 3.2.7, lodash 4.18.1. There are no other prod advisories.

## Receipts
- `replay.log` (install, build and smoke output, plus any diagnostic runs, labelled), and `receipt-*.txt` (audit, advisory lookups and other checks), saved verbatim.

## Remaining check for the reviewer
- None. The target is dropped: the owner declined deploy buttons in PR #57. The upstream.patch and PR text are kept only as a record of the technical replay and must not be submitted.
