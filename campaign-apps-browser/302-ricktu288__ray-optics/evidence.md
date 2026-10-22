# 302 ricktu288/ray-optics — HOLD (Anybuild runs the webpack dev server as the start command)

## Repo and policy
- Pinned: master @ daf76772c73a85e1a2568c4e2e71613bba1fab77, last commit 2026-10-04 (shallow clone).
- GitHub API, 2026-10-22: 1801 stars, 268 forks, Apache-2.0, not archived, default branch `master`.
- Duplicate check: `wasmer` PR search returned 0 (2026-10-22).
- Policy: CONTRIBUTING.md says "Contributions are welcome" and asks for a discussion first only for "significant changes such as a new framework or a new toolbar design". There is no PR template, AGENTS file or CLA. Policy alone would allow a README PR.

## What Anybuild v0.33.0 runs (plan.txt / plan.json)
- Provider: "Detected Node.js provider" (a server, NOT static). npm 11, Node 24, staged inputs `package.json` + `package-lock.json`.
- install `npm install`; build `npm run build`; start `webpack serve --open simulator/ --mode=development`.
- The start command is the repo's `start` script verbatim. Anybuild takes `scripts.start` (crates/anybuild/src/providers/node.rs:1670-1681, `infer_start_command`).
- `npm run build` = build-pages, build-scenes, build-node, build-images, build-app, build-docs. The README (lines 79-90) says this writes the whole phydemo.app/ray-optics site into `dist/`. It needs node-canvas system deps and "may take about half an hour" because it generates the gallery images.
- What would be served at `/`: the build output is not used as static files. The runtime process is webpack-dev-server in development mode. Per webpack.config.mjs:121-129 it serves `./dist` statically and recompiles the simulator in memory (eval-source-map). It uses a historyApiFallback rewrite that appends `.html`, and `--open` tries to launch a browser. So `/` would be dist's home page and `/simulator/` would be an in-memory development bundle, served by a dev server and not a production server.

## Why HOLD
- A README-only PR would advertise a deployment that runs a development server in production. That deployment would also depend on webpack-dev-server working under Wasmer's runtime, which was not tested here.
- A `Staticfile` cannot fix it: the StaticFile provider copies the tree as-is with no build, and `dist/` is not committed.
- Any fix needs a builder-side change, such as a static-node detection for webpack output, or a repo change to the `start` script. That is out of scope for a README PR.

## Not done (stated plainly)
- No install/build replay. The documented ~30-minute full build with canvas, sharp and jest optional deps did not fit the shared disk budget (about 3 GB free, with a 3 GB minimum to keep). The HOLD rests on the generated plan, which is saved verbatim, plus the source lines cited above. No browser proof was run.

## Remaining check for reviewer
- Only if Anybuild adds webpack-to-static detection: re-plan and replay; `dist/` should then be the static_dir and `/simulator/` should load.
