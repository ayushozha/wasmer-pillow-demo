# ColorlibHQ/AdminLTE — evidence

- Pinned SHA: `e13df78a4d0c287e5fa57308e293f63e44e9dd0f` (branch `master`); clone `$S/rup/ColorlibHQ__AdminLTE`.
- Stars / forks: 45,663 / 18,130 (GitHub API, 2026-10-22). Not archived.
- License: MIT (`LICENSE`: "The MIT License (MIT) Copyright (c) 2014-2023 ColorlibHQ ... Permission is hereby granted, free of charge ...").
- `AGENTS.md` (AI agent guidance): "`dist/` and `src/html/public/`: generated output. Edit source files; exclude compiled `dist/` changes from contributor PRs." / "Follow the prevalent `type(scope): summary` commit format ... Keep PRs focused, describe the behavior change, link relevant issues, and report validation commands/results." No AI ban.
- `.github/CONTRIBUTING.md`: "When you contribute, you agree to give a non-exclusive license to AdminLTE.io ..."; "Do not make changes in `./dist/**`". Our patch does not touch `dist/`.
- No PR template. No bad-PR bot workflows (workflows: a11y, bundlewatch, codeql, docs, lint, release, tests).
- **`SECURITY.md` "What NOT to Deploy": "Do not deploy these to production: ... Example/demo HTML files (`index.html`, `index2.html`, `index3.html`, etc.)"**; README "Security & production deployment": "Deploy only the compiled production assets (`dist/js/adminlte.min.js`, `dist/css/adminlte.min.css`) and your own application files — never `node_modules/`, the demo HTML pages, or the `src/` directory." with the disputed CVE-2021-36471 note (demo pages exposed in production).
- Existing deploy: `netlify.toml` publishes committed `dist` ("The dist/ folder is committed to the repo ... the production deploy just publishes those static files") for adminlte-v4.netlify.app; README shows a Netlify status badge. So `dist/` is the supported built demo output.
- Recent merged PRs: `is:merged merged:>2025-10-01` → 43 (incl. dependabot; maintainers puikinsh/dfsmania active, outside contributors merged e.g. #6083).
- Prior deploy PRs: `deploy in:title` → only #5348 "deploy github pages for actions" (collaborator, closed unmerged 2026-03-10). Duplicate `wasmer` → 0.

## Anybuild v0.33.0 detection
- Unpatched plan (`$S/plans/ColorlibHQ__AdminLTE.json`): "Detected Node.js provider, Framework: Astro, Server: Node.js" → install `npm install`, build `npm run build`, start `npm run dev` (= `npm-run-all --parallel watch docs-serve`, the Astro dev server). Wrong for production.
- Patched: `Staticfile` `root: dist` → StaticFile provider score 50 (`providers/mod.rs:445-447`, `staticfile.rs:144-155,190-191`), `staticfile.bzl:32-56` copies `dist`, no build.

## Replay (patched clone, `replay.sh <clone> w8-adminlte 3696 /index.html /index2.html /docs/ /layout/fixed-sidebar.html /UI/general.html /pages/`)
- Plan: static provider, output `dist`, SWS 2.38.0; copy exit=0; 185 files, 17 MB.
- Smoke: `/`, `/index.html`, `/index2.html`, `/docs/`, `/layout/fixed-sidebar.html`, `/UI/general.html` 200; 51 refs all 200. `/pages/` 404 is my guessed path (no index in `dist/pages/`), not a site link.
- Offline link check of all 91 `.html` files: 5,148 local refs, 1 unresolved — `css/adminlte-colors.css` from `docs/faq.html` (stale upstream page; the source `faq.mdx` was removed in #6099 but `dist/docs/faq.html` remains). Upstream issue, not caused by the patch.

## Verdict: HOLD (policy/positioning conflict)
Technically the replay passes. But the button would publish exactly what the project's `SECURITY.md` says not to deploy (the demo `index.html`/`index2.html`/`index3.html` pages), and the maintainers have already fielded a disputed CVE about demo pages being publicly deployed. AdminLTE is a UI kit consumed via npm/CDN/Composer, not a site users deploy; a one-click "deploy the demo" has little user value and a high chance of being read as contradicting their security guidance. The draft README wording ("Deploy the demo on Wasmer", pointing at the security section) is provided in `upstream.patch` in case the reviewer wants to ask the maintainers in an issue first.

Exact remaining check: ask maintainers (issue/discussion) whether a demo-deploy button is welcome given SECURITY.md; only then open the PR.
