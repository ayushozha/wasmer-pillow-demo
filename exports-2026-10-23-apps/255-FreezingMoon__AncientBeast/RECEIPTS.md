# FreezingMoon/AncientBeast — public receipts

- **Status: CLEARED (READY)** for README + one-line `Staticfile` (`root: deploy`).
- Pin: `d37961462eb91f97e81710ede456346148cd2522` (default branch `master`). Patch: `upstream.patch` (README.md + new `Staticfile`).
- Licences: code AGPL-3.0 (`LICENSE.md`, `AGPL.txt`); artwork and audio CC-BY-SA 4.0 (README "License"); README notes the "Ancient Beast" name and logo are trademarks of Freezing Moon. Publicly hosting the unmodified build is permitted; modified hosted copies carry AGPL source-offer and CC-BY-SA share-alike duties (stated in the PR body). Upstream gaps noted in the PR body: no per-track music licence file, no OFL file for the bundled "Play" font.
- Contribution policy: `CONTRIBUTING.md` — "feel free to create patches and propose them by making a Pull Request". No CLA or agent policy. Active: 43 PRs merged since 2025-10-01 (`github-receipt.txt`); no prior third-party deploy-button PRs; no existing Wasmer PR.
- Hooks: `.husky/pre-commit` runs `npm run lint-staged` (no such script is defined; the hook is inactive until `husky install`). Campaign rule: never bypass hooks; if a hook blocks a commit, stop and report.
- Why the `Staticfile`: `vite.config.mts` writes to `deploy/`; without it Anybuild expects `dist/` and serves nothing (`replay-unpatched-summary.txt`).
- Build (`plan.txt`, `replay.log`): static Node.js provider, Vite, Bun 1.4.2 (from `packageManager`), output `deploy` (from the `Staticfile`); Node 24.22.1; `bun install --no-save` (only `package.json` + `bun.lock` staged) and `bun run build` exit 0.
- Runtime (`smoke-receipt.txt`, `asset-check-receipt.txt`): local native static-web-server 2.38.0 — `/` 200 ("Ancient Beast v0.6-α"); all 727 built files 200; every asset path referenced in the built JS exists. Hosted WASI server not tested; no match played in a browser; online play (PeerJS) untested.
- Advisories (`advisories-receipt.txt`): shipped runtime libraries checked against the npm advisory endpoint.
