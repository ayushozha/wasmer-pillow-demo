# SeanWong17/Future-Style-Periodic-Table: evidence

**Verdict: READY.** Note for the reviewer: 515 stars, just above the ≥500 floor, admitted on fit (client-side chemistry education app, MIT, active).

## Repository
- Pinned SHA `fa32eff8aa40b6a1a31f166017ad590222401482` on `main` (default; shallow clone HEAD). Last pushed 2026-09-23.
- Stars / forks: 515 / 69. Not archived (GitHub API, 2026-10-22).
- License: MIT ("MIT License / Copyright (c) 2025 Sean").
- Contribution policy: no CONTRIBUTING, AGENTS.md, CLAUDE.md, CLA or PR template. Only workflow: `.github/workflows/deploy.yml` (GitHub Pages deploy). README_en: "GitHub is the primary repository. Please submit issues and pull requests on GitHub."
- PR history (GitHub search, 2026-10-22): 3 PRs; merged: #7 "feat: add Docker deployment support" (third party, merged 2026-07-21) and #1 "feat: Add bilingual support" (merged 2026-01-30). #8 closed. The maintainer has accepted an outside deployment-docs PR.
- Duplicate check: `wasmer repo:SeanWong17/Future-Style-Periodic-Table` → 0. Not in exclusions or other lanes.
- Existing deploy docs: "构建部署 / Quality checks and production build" (GitHub Pages via Actions) and "Docker 快捷部署 / Quick deployment with Docker". The patch adds a sibling subsection in both README.md (Chinese) and README_en.md (English).

## Anybuild detection (v0.33.0)
- Provider: static Node.js, framework Vite, npm (`package-lock.json`), output `dist` (plan.txt). `vite.config.ts`: `base: './'`, `outDir: 'dist'` (matches the plan).
- Staged before install: `package-lock.json`, `package.json`. Env `CI=true NPM_CONFIG_FUND=false`. No `.npmrc`, workspace or `generate` script.
- Generated: `npm install`; `npm run build`; start `static-web-server --root=/opt/static_app --log-level=info --port=8080`. No `_redirects`.

## Replay (patched clone; Node 24.22.1, npm 11.21.1) — replay.log, smoke-receipt.txt
- `npm install` exit 0 (npm 11 skipped esbuild's postinstall; the build still works via esbuild's platform package). `npm run build` (vite 6.4.3) exit 0; output `index.html`, `assets/index-CFAAkAlt.js`, `assets/index-CeJkRRve.css` (the names the built index.html references).
- Local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here): `/` 200 (title "宇宙的5%"); JS 200 (300,023 bytes); CSS 200. `/favicon.ico` 404 (none in repo), `/nope` 404.
- Routes: single page, no router. Element data is bundled; no runtime network calls besides links.

## Env vars / security
- No `import.meta.env` / `process.env` use; no keys or backend.
- `npm audit --omit=dev`: 0 vulnerabilities (npm-audit-prod.json). There are no runtime `dependencies`; everything shipped is the app's own code.

## Remaining check for the reviewer
- Badge and import page unverifiable here (img.shields.io / wasmer.io blocked). No browser-level test of the 3D atom view. The Chinese README text was written for this PR; a native speaker may want to polish it.
