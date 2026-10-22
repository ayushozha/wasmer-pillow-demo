# hydra-synth/hydra: evidence

**Verdict: CONDITIONAL (maintainer responsiveness).** The technical path is clean: unpatched detection is correct, and the build and assets pass. However, only 1 PR has been merged since 2025-10-01 (#305), while third-party PRs since then were mostly closed unmerged or left open. The repo has no CONTRIBUTING and no PR template. Remaining check: the account owner should decide whether a README PR is likely to be reviewed. Optionally, look at who closed #324, #326 and #318 and why. The comment bodies could not be read here, because the GitHub issue API returns 403 for repos outside this session.

## Repository
- Pinned SHA: `523e0feaf3f49899b759ce0e7afabe0114ddfe2b` on `main`, dated 2026-04-25.
- Stars / forks: 2,732 / 320. Not archived. Last push 2026-04-25 (GitHub API, 2026-10-22).
- License: AGPL-3.0 (`LICENSE`). Hosting a modified version carries source-offer obligations, which `PR_BODY.md` notes.
- Policy files: there is no CONTRIBUTING, PR template, AI policy or `.github/` workflows (and so no bots).
- PRs created since 2025-10-01: 7.
  - Closed unmerged: #326, #324 and #318 (#318 was from a CONTRIBUTOR).
  - Still open: #323, #322, #320 and #316 (#316 is from a MEMBER).
  - Merged since 2025-10-01: 1 (#305).
- Duplicate `wasmer` PRs: 0. Prior "deploy" PRs: 0.
- Deploy docs: the README has "Running locally" (`npm install`, `npm dev`) and explains `VITE_SERVER_URL` for hydra-server. The `publish` script pushes `dist` to gh-pages.

## Anybuild detection (v0.33.0)
- Static Node.js provider, framework Vite (Strong, 60), output directory `dist` (`node.rs:334`). Install is `npm install` with `package.json` and `package-lock.json` staged, using npm 11 and `CI=true NPM_CONFIG_FUND=false`. Build is `npm run build` (`vite build`). Start is `static-web-server --root=/opt/static_app --log-level=info --port=8080`.
- No Staticfile is needed. `dist/` is also committed upstream; the build overwrites it with a fresh build.

## Replay (patched): Node 24.22.1, npm 11.21.1 (as printed in replay.log)
- An earlier replay before 05:45 UTC used host npm 10.9.4 and is superseded; this one used npm 11.21.1.
- `npm install` exited 0 and `npm run build` exited 0. `static_app` holds 30 files.
- Smoke returned 200 for:
  - `/` ("&lt; hydra &gt;").
  - `assets/index-<hash>.js` (about 900 KB).
  - `bundle.js` and `p5.min.js`.
  - All `css/*` files.
  - `webfonts/fa-{solid,regular,brands}-*.woff2`.
  - `images/hydra-landing.png`.
- All 15 webfont URLs referenced in the CSS exist. `/nope` returned 404 (expected).
- Routes: a single page. Sketches are shared via the URL query string, which sws serves on `/`.

## Env vars and external services
- `import.meta.env.VITE_SERVER_URL` (`src/stores/store.js:12`) is optional. When unset, `serverURL = null`, and gallery and signalling are unavailable. It is a public server URL, not a secret.
- External runtime fetches (from the built `index.html` and bundle):
  - cdn.jsdelivr.net: `hydra-synth`.
  - cdnjs: p5 1.4.0.
  - Google Fonts.
  - cdn.glitch.com: favicon.
  - raw.githubusercontent.com: `hydra-synth/l10n` translations and `hydra-extensions`.
- These are disclosed in the PR Limitations.

## Security (runtime deps, lockfile versions)
- 0 advisories: socket.io-client 2.5.0, superagent 7.1.5, simple-peer 9.11.1, hydra-synth 1.3.27, choo 7.1.0, i18next 21.10.0, js-beautify 1.14.8, shortid 2.2.16, acorn 8.9.0 and codemirror 6.0.1.
- i18next-http-backend 1.4.5 has 2 advisories: GHSA-q89c-q3h5-w34g (moderate, path traversal/URL injection via unsanitised lng/ns) and GHSA-xvq9-wjp8-hwqf (low). There is no high or critical issue.

## Remaining checks for the reviewer
1. Assess maintainer responsiveness, as described in the verdict.
2. Verify the badge and import page in a browser; `img.shields.io` and `wasmer.io` are blocked here.
