# alam00000/bentopdf: evidence

**Verdict: HOLD (wrong app detected, plus CLA).**

## Wrong app detected
Anybuild detects **VitePress**, because `vitepress` is in package.json and `PURE_STATIC_DEPENDENCIES` includes it (`node_static.rs:110-135`). For VitePress with a `docs:build` script, `get_build_command` returns `npm run docs:build` (`node_static.rs:894-900`), and the output directory becomes `docs/.vitepress/dist` (see `plan.txt`).

A one-click deploy would therefore publish the **documentation site, not the PDF toolkit**. The real app build is `npm run build`: blog and SEO generators, `tsc`, `vite build`, i18n pages and similar, writing to `dist/`. A Staticfile can change only the output directory, not the build command, so the result would still be wrong. This is not fixable in the README.

## CLA
- The repo runs CLA Assistant (`.github/workflows/cla.yml`, contributor-assistant v2.6.1). It asks PR authors to comment "I have read the CLA Document and I hereby sign the CLA".
- CLA signature required by the account owner: unresolved. Even if the build were fixable, the verdict could be at most CONDITIONAL.

## Repository
- Pinned SHA: `4a7dc7675b7234933eb30c5a3fdfe4c8414cf66b` on `main`.
- Stars / forks: 16,113 / 1,424. Last push 2026-10-21 (GitHub API, 2026-10-22).
- License: AGPL-3.0, with `CCLA.md` and `ICLA.md`.
- `STATIC-HOSTING.md` documents Netlify and other static hosts using release zips or a fork.
- No replay was run. The plan alone shows the mis-detection, and the repo is 331 MB, which matters given the disk limits here.
