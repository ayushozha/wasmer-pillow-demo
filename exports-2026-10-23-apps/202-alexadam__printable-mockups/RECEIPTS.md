# alexadam/printable-mockups — public receipts

- **Status: CONDITIONAL** — technically passing; the repo has never merged an outside PR (32 PRs, all dependabot; 0 merged) and sits near the 500-star floor (537). Publish only if root accepts that acceptance risk.
- Pin: `4ac3ff3042cddb12c764c1706388df9ddd2532c9` (default branch `master`). Patch: `upstream.patch` (README.md only).
- Licence: MIT ("MIT License / Copyright (c) 2019 Alex Adam"); bundled GoldenLayout copy is MIT upstream.
- Contribution policy: no CONTRIBUTING, AGENTS.md, CLA, PR template, workflows or `.github/`.
- Hooks: none.
- Build (`plan.txt`, `replay.log`): static Node.js provider, Vite, npm, output `dist`; Node 24.22.1 / npm 11.21.1; staged install + build exit 0.
- Runtime (`smoke-receipt.txt`, `lazy-chunks-receipt.txt`): local native static-web-server 2.38.0 — `/` and all built files including lazy chunks return 200. Hosted WASI server not tested.
- Shipped dependencies: `npm-audit-prod.json` — 1 low (DOMPurify), disclosed in the PR body.
- Network: only Google Fonts. No free-text input; export features produce fixed text.
