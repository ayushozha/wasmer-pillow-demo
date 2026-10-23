# mermaid-js/mermaid-live-editor PR #2082 — exact-head validation (local, read-only)

## Head / base
- Expected head `7e34d9be5a614babac246434773411d341018abb`; fresh clone `$S/val-src/mermaid-live-editor`, `git fetch origin pull/2082/head`, checkout → `git rev-parse HEAD` = `7e34d9be…` (git-receipts.txt).
- PR current head: `git ls-remote origin refs/pull/2082/head` = `7e34d9be…` (ls-remote.txt) → head has NOT moved.
- Base branch: `develop` (from the brief; could not be read from the API, see below). `origin/develop` = `eb4141dd51247259e95ecd890c1bf3dabf314913` = merge-base, so the PR is one commit on top of current develop.
- pr.json / pr-files.json / pr-page-403.json: the unauthenticated API and github.com page were refused by this session's egress proxy ("GitHub access to this repository is not enabled for this session"). The raw refusals are kept. **The PR body, title, state and base could not be read**, so every PR-body claim below is unverified. I did not attach the repo (add_repo), because that needs the user's approval.

## Changed files (`git diff --name-status eb4141dd..HEAD`)
| file | status | blob @HEAD | blob @merge-base |
|---|---|---|---|
| `Anybuild` | A (47 lines) | 8be261e62776b44bf40dbc59221745b389adaf09 | — |
| `README.md` | M (+6) | 260b74842b1d650c883f2eb86a52ff18c13e37a7 | ca07db73fb442770d28cb2574a8a373eafbab8ca |

- Lockfile `pnpm-lock.yaml` 45e5cb743e4292fb6e639937a8b7452d94f8eec3, `package.json` e0eba3e2d54c1bf880bc8063d5f6120d8c7e63a7. Both are identical at the merge-base and at HEAD.
- Hooks: `.husky/` tree 96f3185fb179c34279a1bb908f5ec03bc356041e (`pre-commit` → `pnpm pre-commit` = lint-staged) is identical at the merge-base and at HEAD. There is no lefthook, simple-git-hooks or pre-commit config. `git diff --stat eb4141dd..HEAD -- .husky pnpm-lock.yaml package.json .github` is empty.
- The clone has no local modifications (`git status --porcelain` is empty).

## What the PR's Anybuild declares
`nodestatic_config`: pnpm 10.34.7 (matches `packageManager`), node 24, `install = pnpm install --frozen-lockfile`, `build = pnpm run build`, `static_dir = docs` (matches adapter-static `pages: 'docs'`), `node_install_requires_all_files = True`, sws 2.38.0, and an SWS `advanced.rewrites` config in this order: `/_app/**`→`$0`, `/edit`→`/edit.html`, `/view`→`/view.html`, `/**/*.*`→`$0`, `/**`→`/404.html`. No `/embed` rule.

## Anybuild replay
- **Deviation from the harness:** `$S/scripts/replay.sh` always runs `plan --temp-anybuild`, which ignores a committed Anybuild. I ran that first (autodetect/). It detected SvelteKit with `static_dir=build`, install `pnpm install`, and ended with **`STATIC_DIR 'build' MISSING`**: 0 files, every page 404. This shows that auto-detection alone fails for this repo and the committed file is needed.
- Committed-file replay: `replay_committed.sh` is replay.sh with one line changed, `--anybuild-path "$FLAT/Anybuild"` (replay_committed.diff). The plan reports "Using static Node.js provider declared in Anybuild" (plan.txt, plan.json).
  - `node -v` exit 0; `pnpm --version` 10.34.7 exit 0
  - `pnpm install --frozen-lockfile` **exit 0** (lockfile up to date, +750 packages). The postinstall `husky install` ran and printed a deprecation notice.
  - `pnpm run build` **exit 0** (only vite chunk-size warnings)
  - `docs/` → 278 files, 24 MB (file list in static_app-files.txt; the build itself was deleted)
  - replay.log has no INSTALL FAILED, BUILD FAILED or MISSING. smoke.txt: `SUMMARY pages=11 refs_checked=47 failures=0`. The smoke test counts only 2xx, so it also passed the soft-404 described below.

## HTTP (http-receipts.txt, script http_receipts.sh)
These pages were served with a local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here), with the PR's sws.toml.
- 106 requests: 104 × 200, 2 × 404.
- Pages: `/edit` returns edit.html and `/view` returns view.html (sha256 of each body matches the file on disk). `/edit.html`, `/view.html`, `/embed.html` and `/index.html` return 200. `/`, `/embed`, `/edit/`, `/view/`, `/embed/` return 200, but the body is **404.html** (the SvelteKit SPA fallback), not index.html or embed.html.
- Assets: 53 unique refs from the served HTML of `/`, `/edit`, `/view` and `/embed`, plus 9 `url()` refs from the served CSS, plus all 14 files in `_app/immutable/assets` and all 5 Monaco workers, plus the root files. Every one returns 200. MIME types: JS/workers/service-worker/embed.js `text/javascript`, CSS `text/css`, `font/woff2`, `font/ttf`, `image/svg+xml`, `image/png`, `image/x-icon`. `manifest.json` is served as `application/json`, not `application/manifest+json`; browsers accept it. The build has no `.wasm` files.
- Missing paths: `/_app/immutable/chunks/definitely-missing.js` and `/definitely-missing.css` → **404** (correct). `/definitely-missing-<random>` → **200 text/html with the 404.html body (soft-404)**, caused by the `/**`→`/404.html` rewrite. **The brief's "missing path must be 404" check fails for paths without a file extension.**

## Browser (browser.json, browser.cjs; every request not to 127.0.0.1 was aborted)
- `/edit`: the default flowchart renders (`svg#graph-1`, flowchart-v2, 6 nodes). Sample state taken from `location.hash` (`#pako:eNpV…`, 376 chars).
- `/view#<that state>` renders `svg#graph-1`. `/embed#<that state>` (served by the fallback) renders `svg#embed-graph-1`. Both have 0 console errors and 0 same-origin HTTP errors. Screenshots: shot-edit.png, shot-view.png, shot-embed.png.
- `/` redirects on the client to `/edit#…` and renders. `/edit/#…` renders.
- `/embed.html#…` and `/definitely-missing-q9z` log the console error `Not found: /…` and the app sends them to `/edit`. That is the app's own 404 behaviour.
- Blocked external origins: only `https://mermaid.js.org` (5 requests). `.env` has `MERMAID_ANALYTICS_URL=''`, so no analytics. The build points at `mermaid.ink` (PNG/SVG export), `kroki.io` and Mermaid Chart links; none of them was requested on load. These are optional externals, and the deployment is **not** a fully self-hosted stack.

## Repo's own checks (lint-changed-files.txt)
CLAUDE.md at head: "`pnpm lint` / `pnpm lint:fix` — prettier + eslint"; `lint` = `prettier --check --cache . && eslint .`; lint-staged runs prettier and eslint on `*.{ts,svelte,js,css,md,json}`. Scoped to the PR's files (run in the replay work dir; blob ids were checked identical):
- `prettier --check README.md` exit 0
- `prettier --check Anybuild` exit 2: "No parser could be inferred". The file has no extension, and `prettier --check .` skips such files.
- `prettier --check --ignore-unknown Anybuild README.md` exit 0
- `prettier --check .` (the repo's lint, prettier half) exit 0
- `eslint README.md` and `eslint Anybuild` exit 0, each with a "File ignored" warning
- e2e, unit and svelte-check were not run (out of scope).

## Claims
| claim (source) | result |
|---|---|
| Any claim in the PR body (versions, "tested", counts) | **unverified**: body could not be read (API/page blocked by the proxy) |
| README: "`Anybuild` configuration runs `pnpm run build`" | verified (plan.json; build exit 0) |
| README: "serves `docs/`" | verified (static_dir=docs, 278 files served) |
| README: "including direct links to the editor" | verified natively: `/edit` and `/view` serve their pages, deep link `/view#pako…` and `/embed#pako…` render an SVG. `/embed` works only through the 404.html SPA fallback |
| README: "Renderer, Kroki and analytics settings remain the build-time options" | consistent: the Anybuild sets no `MERMAID_*` env, so `.env` defaults apply (mermaid.ink, kroki.io, analytics off) |
| Commit: "add Wasmer deployment option" | partially verified: native build and serve work. Wasmer hosted runtime **untested** |
| Lockfile and hooks untouched | verified |

## Honest gaps
- PR body and metadata could not be read; head confirmed only through git ls-remote.
- No Wasm or hosted test. The setup depends on the hosted WASI SWS (1.1.0 / 2.32.2, no page fallback) honouring `--config-file` `advanced.rewrites` with `$0` and `/**/*.*` globs. If it does not, `/edit` and `/view` would 404 there. Also untested on hosted: directory/`.html` resolution and MIME for `.json`/`.ttf`.
- With these rewrites, `/` serves 404.html, not index.html (works on the client), and unknown paths without an extension return 200, not 404.
- The deploy button URL was not exercised.
