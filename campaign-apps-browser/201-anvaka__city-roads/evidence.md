# anvaka/city-roads: evidence

**Verdict: READY** (one reviewer note: the repository has no merged pull requests in its history, so acceptance of outside PRs is unproven; this is not a policy block).

## Repository
- Pinned SHA `35d6497db70debf4508b4d75f17d80c4367d66a6` on `main` (default branch; shallow clone, HEAD). Last pushed 2026-10-10.
- Stars / forks: 9,777 / 754. Not archived (GitHub API, 2026-10-22).
- License: MIT ("MIT License / Copyright (c) 2020-2026 Andrei Kashcha"). README: "The source code is licensed under MIT license".
- Contribution policy: no CONTRIBUTING, AGENTS.md, CLAUDE.md, CLA or PR template. `.github/` holds only `FUNDING.yml`; no workflows, so no bots that auto-close PRs. README "Support": "If you like this work and want to use it in your projects - you are more than welcome to do so!"
- PR history (GitHub search, 2026-10-22): `repo:anvaka/city-roads` returns 1 PR in total (#23 "new mug every time", closed unmerged). `is:merged` returns 0. Maintainer activity is direct commits (last 2026-10-10).
- Duplicate check: `wasmer repo:anvaka/city-roads` returns 0. No prior third-party deploy-button PRs. Not in `static_excl.txt` or any other lane folder.
- Existing deploy docs: README links the live site (https://anvaka.github.io/city-roads/), "Local development" (`npm install`, `npm run dev`, `npm run build`); `deploy.sh` pushes `dist/` to `gh-pages`.

## Anybuild detection (v0.33.0)
- Provider: static Node.js; framework Vite (`vite` dependency); package manager npm (`package-lock.json`); output `dist` (see plan.txt).
- Install inputs staged: `package-lock.json`, `package.json` (`node_install_inputs: ["package.json"]`, not all-files). Env `CI=true NPM_CONFIG_FUND=false`. No `.npmrc`, no workspace files, no `generate` script, so none of the known staging pitfalls apply.
- Generated: install `npm install`, build `npm run build` (`vite build`), start `static-web-server --root=/opt/static_app --log-level=info --port=8080`. No `_redirects`.
- `vite.config.js` sets `base: ''` (relative asset URLs) and no custom outDir, so `dist` matches the plan.

## Replay (patched clone; Node 24.22.1, npm 11.21.1) — replay.log, smoke-receipt.txt
- `npm install` exit 0 (259 packages). npm 11 did not run esbuild 0.14.54's postinstall (allowScripts); the build still succeeded because the platform binary comes from esbuild's optional dependency.
- `npm run build` (vite 2.9.18) exit 0; `dist/` = `index.html`, `assets/index.46c74633.js`, `assets/index.d9d15598.css` (the names the built index.html references).
- Served with a local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here):
  - `/` 200, title "Draw all roads in a city at once".
  - `/assets/index.46c74633.js` 200 (273,782 bytes), `/assets/index.d9d15598.css` 200.
  - `/favicon.ico` 404 (the repo ships no favicon; upstream behaves the same), `/nope` 404.
- Routes: single page; state lives in query parameters (`query-state`), so there are no history-router deep links.

## Runtime services and env vars
- No `import.meta.env` / `process.env` reads in `src/`. No keys.
- At runtime the browser calls public services: Nominatim (`nominatim.openstreetmap.org`), Overpass mirrors (`overpass-api.de`, `overpass.kumi.systems`, ...), the author's city cache (`anvaka.github.io/index-large-cities`, `d2uf7yjjctyxf.cloudfront.net`), and an optional image-upload endpoint used by the "print on a mug" feature (`edi6jgnosf.execute-api.us-west-2.amazonaws.com`). These were not exercised (no browser test); they are the same for any host.

## Security
- `npm audit --omit=dev --json` in the replay work dir: 0 vulnerabilities (npm-audit-prod.json). The 14 (8 moderate, 6 high) reported by the full install are in build-time dev dependencies (vite 2 / esbuild / stylus tooling), not shipped. Shipped runtime: vue 3.5.43, d3-geo, w-gl, pbf, tinycolor2.

## Remaining check for the reviewer
- Badge image and Wasmer import page not reachable from this environment (img.shields.io and wasmer.io blocked). No browser-level test of map rendering.
