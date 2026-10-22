# midudev/minimalist-portfolio-json: evidence

**Verdict: READY** (README-only patch; replay passes).

## Repository
- Pinned SHA: `02749efb52cae4e1628e5c2e971b9bfac855b8d9` on `main` (default). Last commit 2026-10-17; not archived.
- Stars / forks: 948 / 414 (GitHub API, 2026-10-22). Under the 1k preference, but a strong fit: it is a "use this repo as a template" CV/portfolio (README step 1), and users edit one JSON file.
- License: `LICENSE.txt` MIT ("Permission is hereby granted, free of charge ... to use, copy, modify, merge, publish, distribute"). The copyright line still holds the placeholder "[year] [fullname]"; README says "[MIT](LICENSE.txt) - Creado por midudev". This differs from midudev/porfolio.dev (replacement 06, CC BY-NC); this repo is plain MIT.
- No CONTRIBUTING, PR template, AI policy or `.github/` directory, so no bots.
- Maintainer activity: 3 PRs merged on 2026-10-16 (#35, #41, #45); others were closed the same day as part of a triage pass. Merged since 2025-10-01: 3.
- Deploy-related PRs: none. Duplicate `wasmer` PR search: 0.
- Existing deploy docs: none. The README covers template creation (`pnpm create astro --template ...`), dev and build only.

## Anybuild detection (v0.33.0)
- Provider: node-static, framework Astro, pnpm (plan pins 10; `pnpm-lock.yaml` + `package.json` staged; no `pnpm-workspace.yaml`), build `pnpm run build` (`astro check && astro build`), output `dist` (`plan.txt`).
- Astro `output: "static"`: 2 prerendered pages, `/` (Spanish) and `/en/`. There is no client router.

## Replay (patched clone, Node 24.22.1, pnpm 10.34.7)
- `pnpm install` exit 0; `pnpm run build` exit 0 (`astro check`: 0 errors); 7 files.
- Smoke: `/` 200, `/en/` 200, `/en` 200; favicon, fonts, `me.webp` and the JS bundle 200.
- `/404.html` 404 (observed): the template has no 404 page, so sws returns an empty 404 for unknown paths.

## Remaining check for the reviewer
- Verify badge and import page in a browser (img.shields.io / wasmer.io blocked here).
- README is in Spanish; the added section is in Spanish to match.

## README wording correction (root, 2026-10-22)
- The README now tells forkers to personalise both `cv.json` and `cv_english.json` (the site has Spanish and English versions).
- README blob: base `63581bf10a2dbde0a21fcba3b52d047dd66f8b70` → patched `35813ac7672acb4c5fda10bdbcb488227c345184`; `upstream.patch` regenerated, `git apply --check -R` ok.
