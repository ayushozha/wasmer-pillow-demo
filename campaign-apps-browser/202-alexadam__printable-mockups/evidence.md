# alexadam/printable-mockups: evidence

**Verdict: CONDITIONAL.** Technical path is clean (build passes, every built file returns 200). Two reviewer checks before opening: (1) the repo has never merged a pull request (all 32 PRs are Dependabot, closed unmerged), so acceptance of outside PRs is unproven; (2) at 537 stars it sits just above the ≥500 floor, admitted on fit (a pure client-side design/wireframing tool).

## Repository
- Pinned SHA `4ac3ff3042cddb12c764c1706388df9ddd2532c9` on `master` (default; shallow clone HEAD). Last pushed 2026-08-07 (Vite 8 / React 19 migration).
- Stars / forks: 537 / 24. Not archived (GitHub API, 2026-10-22).
- License: MIT ("MIT License / Copyright (c) 2019 Alex Adam").
- Contribution policy: no CONTRIBUTING, AGENTS.md, CLAUDE.md, CLA, PR template or workflows (no `.github/`). No bots.
- PR history (GitHub search, 2026-10-22): 32 PRs, all by dependabot; `is:merged` returns 0. One open (#33, vite bump). Maintainer works by direct commits.
- Duplicate check: `wasmer repo:alexadam/printable-mockups` → 0. No prior deploy-button PRs. Not in exclusions or other lanes.
- Existing deploy docs: README "How to run it on your machine" (`npm install`, `npm run dev`); live demo at printablemockups.com. No hosting docs.

## Anybuild detection (v0.33.0)
- Provider: static Node.js, framework Vite, package manager npm (`package-lock.json`), output `dist` (plan.txt).
- Staged before install: `package-lock.json`, `package.json` (`node_install_inputs: ["package.json"]`). Env `CI=true NPM_CONFIG_FUND=false`. No `.npmrc`, no workspace, no `generate` script; `vite.config.js` has no `build.outDir`.
- Generated: `npm install`; `npm run build` (`vite build`); start `static-web-server --root=/opt/static_app --log-level=info --port=8080`. No `_redirects`.

## Replay (patched clone; Node 24.22.1, npm 11.21.1) — replay.log, smoke-receipt.txt, lazy-chunks-receipt.txt
- `npm install` exit 0. npm 11 skipped core-js's postinstall (a donation banner; harmless).
- `npm run build` (vite 8.2.0) exit 0; 6 files: `index.html`, `assets/index-EEthew8B.js`, `assets/index-yusnO53H.css`, and lazy chunks `index.es-D-slkgG_.js`, `html2canvas-DLgjU1lF.js`, `purify.es-BlKBIatO.js` (jsPDF's dynamic imports).
- Local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here):
  - `/` 200 ("Printable Mockups"); the JS and CSS that the built `index.html` references returned 200 (smoke-receipt.txt).
  - All six built files, including the three lazy chunks, returned 200 with correct types (lazy-chunks-receipt.txt).
  - `/favicon.ico` 404 (none in repo; same as upstream build), `/nope` 404.
- Routes: single page, no router.

## Env vars / services
- No `import.meta.env` / `process.env` use in `src/`. No keys, no backend. PDF export runs in the browser (jsPDF). jsPDF contains a cdnjs URL for `pdfobject`, only used by an output mode the app does not appear to call (not exercised).

## Security
- `npm audit --omit=dev`: 1 low — dompurify 3.4.13 (via jspdf's optional html support), "IN_PLACE: node-removing afterSanitize hook leaves detached subtree event handlers armed". Shipped (lazy chunk `purify.es-*.js`), low severity, applies only to the IN_PLACE mode with custom hooks. No high/critical. Shipped runtime: react 19.2.6, react-dom 19.2.6, jquery 4.0.0, jspdf 4.2.1, react-modal 3.16.3.

## Remaining checks for the reviewer
- Decide whether a repo with zero merged PRs is worth a PR (non-blocking).
- Badge and import page unverifiable here (img.shields.io / wasmer.io blocked). No browser test of drawing/PDF export.
