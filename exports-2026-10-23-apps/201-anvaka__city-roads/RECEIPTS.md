# anvaka/city-roads — public receipts

- **Status: CLEARED (READY)** for a README-only PR.
- Pin: `35d6497db70debf4508b4d75f17d80c4367d66a6` (default branch `main`). Patch: `upstream.patch` (README.md only).
- Licence: MIT ("MIT License / Copyright (c) 2020-2026 Andrei Kashcha").
- Contribution policy: no CONTRIBUTING, AGENTS.md, CLA or PR template; `.github/` holds only `FUNDING.yml`; no workflows. History shows no merged outside PRs (maintainer commits directly) — acceptance is the maintainer's call.
- Hooks: none (no `.husky`, lefthook or pre-commit config).
- Build (exact Anybuild v0.33.0 replay, `plan.txt`, `replay.log`): static Node.js provider, Vite, npm, output `dist`; Node 24.22.1 / npm 11.21.1; only `package.json` + `package-lock.json` staged for install; `npm install` and `npm run build` exit 0.
- Runtime (`smoke-receipt.txt`): `dist` served by a local native static-web-server 2.38.0 (the version Anybuild's plan pins); `/`, the JS and CSS bundles return 200. Wasmer's hosted WASI static-web-server was not tested. No browser test of road loading/rendering.
- Shipped dependencies: `npm-audit-prod.json` — 0 vulnerabilities.
- Third-party services a self-hosted copy uses (disclosed in the PR body): Nominatim and Overpass (OpenStreetMap), the author's CloudFront city cache, the author's Google Analytics tag in `index.html`, and the optional "Onto a mug" upload to the author's endpoint with a Zazzle referral.
