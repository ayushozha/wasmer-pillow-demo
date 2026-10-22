# sh-dv/hat.sh: evidence

**Verdict: HOLD (inactive maintainer; patch ready).** The Wasmer path builds and serves correctly, but the project shows no maintainer activity since 2022: last commit on `master` is 2022-06-18 (`v2.3.6`), the newest merged PR is #68 (2022-05-18), and there are 0 merged PRs since 2025-10-01. A README PR is unlikely to be reviewed. If the reviewer wants to open it anyway, it is technically ready (treat as CONDITIONAL on accepting that risk).

## Repository
- Pinned SHA: `540d3ccfd2a12b4ed96b78a776c764f899678b6c` on `master` (default branch and CI branch; the only branch). Commit date 2022-06-18.
- Stars / forks: 2,289 / 271. Not archived. `pushed_at` 2024-07-17 (GitHub API, 2026-10-22; `github-receipt.txt`).
- License: MIT ("Copyright (c) 2021 sh-dv").
- No CONTRIBUTING, PR template, AGENTS/CLAUDE file, CLA or AI policy. `TRANSLATION.md` covers translations only. Workflows: CodeQL, Node.js CI (`npm install && npm run build` on Node 12/14/16), Snyk. No auto-close bot.
- Duplicate `wasmer` PR check: 0. Prior PRs with "deploy" in the title: 0.
- The README's "Offline Use" section already invites self-hosting ("The app can be easily self hosted"), and the README lists three official instances (hat.sh, hat.now.sh, hat.vercel.app).

## Anybuild detection (v0.33.0, `plan.txt`)
- Static Node.js provider, framework Next.js, output directory `out`. `next.config.js` has `trailingSlash: true` and the build script runs `next build && next export` (Next 12.1.6), so pages are written as `out/<page>/index.html`.
- Staged install inputs: `package.json` + `package-lock.json`. npm 11.21.1 (plan pins npm 11), Node 24.22.1, env `CI=true NPM_CONFIG_FUND=false`.
- Generated commands: install `npm install`, build `npm run build`, start `static-web-server --root=/opt/static_app --log-level=info --port=8080`.
- README-only patch; no Staticfile needed.

## Replay (patched clone; `replay.log`, receipt `smoke-receipt.txt`)
- `npm install` exit 0 (400 packages). npm 11 did not run `core-js-pure`'s postinstall (allowScripts); not needed.
- `npm run build` exit 0: browserify bundles `service-worker/sw.js` into `public/service-worker.js`, `next build`, `next export`, then `postbuild` copies `out/404/index.html` to `out/404.html`. The repo's committed `.env` only sets `NEXT_TELEMETRY_DISABLED=1`.
- Served with a local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here):
  - `/`, `/about/`, `/about`, `/generate-keys/` returned 200.
  - `/service-worker.js` returned 200 (1.3 MB; libsodium is bundled inside it). The service worker is registered relative to the origin and intercepts `<origin>/file` for streamed downloads; `/file` returns 404 from the server, which is expected because only the service worker answers it in a browser.
  - All 23 referenced `_next/static` JS/CSS chunks, the favicon and images returned 200.
  - `/404.html` exists (200). An unknown path returns a bare 404 because the generated start command sets no 404 page.
- Routes: Next.js static export with trailing slashes, so every page has its own `index.html`; no history-router fallback is needed.

## Environment variables
None are read by the client build. No keys.

## Security (`advisories-receipt.txt`)
- `next@12.1.6`: 14 advisories incl. 2 critical (middleware authorization bypass; image-optimization RCE) and 2 high (rewrites SSRF, authorization bypass). All concern Next's server runtime (middleware, image optimizer, rewrites, cache). A `next export` site served by a static server runs none of that code, so these do not apply to the deployed site; they are upstream debt.
- Shipped browser libraries: `libsodium-wrappers@0.7.10` 0, `react-dom@17.0.2` 0, `marked@4.0.16` 0, `react-dropzone@14.2.1` 0, `zxcvbn@4.4.2` 0, `prismjs@1.28.0` 1 moderate (DOM clobbering; Prism highlights the app's own docs only).
- `npm audit --omit=dev`: high/critical = next (server-side, above), postcss/nanoid/source-map-js (build-time).

## Remaining checks for the reviewer
1. Decide whether to open a PR on an inactive repo (see verdict).
2. Verify the badge and import page in a browser (img.shields.io and wasmer.io are blocked here).
3. In a browser on the deployed HTTPS URL, encrypt and decrypt a small file (service-worker streaming was not exercised here).
