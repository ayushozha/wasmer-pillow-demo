<a href="https://wasmer.io/apps/create?github=FreezingMoon%2FAncientBeast"><img src="https://img.shields.io/badge/Deploy%20to-Wasmer-171717?style=for-the-badge&amp;logo=wasmer&amp;logoColor=white&amp;labelColor=171717" alt="Deploy to Wasmer" height="48"></a>

## Summary

Adds a Deploy to Wasmer badge and a short paragraph under the "Contribute" section of the README, and a one-line `Staticfile` (`root: deploy`) so the hosting builder serves the folder the Vite build actually writes. No source, dependency or build changes.

## Why this repo

Ancient Beast is a browser strategy game whose web build is fully static: local matches against bots or hotseat need no server. Community members, streamers running tournaments, schools and contributors who want to share a test build of their branch can get their own copy on a URL they control with one click, without installing Bun or Docker locally. It also gives contributors an easy way to show reviewers a running build of a fork.

The `Staticfile` is needed because `vite.config.mts` sets `outDir: 'deploy'`. Wasmer's builder (Anybuild v0.33.0) detects Vite and otherwise expects `dist/`, so without this line the build succeeds but nothing is served.

## Testing

I replayed what Wasmer's builder generates for `d37961462eb91f97e81710ede456346148cd2522` with this change:

- Detection: static Node.js provider, framework Vite, Bun 1.4.2 (from `packageManager`), output directory `deploy` (from the `Staticfile`).
- `bun install --no-save` exited 0 on Node 24.22.1, with only `package.json` and `bun.lock` staged.
- `bun run build` (Vite 8.3.1) exited 0.
- `deploy/` was served with a local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here):
  - `/` returned 200 ("Ancient Beast v0.6-α").
  - All 727 output files (JS bundles, CSS, fonts, music, sprites, icons) returned 200, and every asset path referenced in the built JS exists in the output.
- Without the `Staticfile`, the same build runs but the builder looks for `dist/`, so nothing is served.

## Limitations

- No deployment was made. The badge image and the Wasmer import page could not be checked from the test environment.
- Checks were HTTP-level; a match was not played in a browser. Online matches rely on PeerJS signalling and were not tested.
- Code is AGPL-3.0 and art/audio are CC-BY-SA 4.0, so publicly hosting the unmodified build is allowed; anyone hosting a modified version must offer the source (AGPL-3.0) and keep the CC-BY-SA attribution.
- The README notes that the "Ancient Beast" name and logo are trademarks of Freezing Moon; a self-hosted copy uses them as shipped.
- Two licence details are outside this PR: the music credits name outside composers but there's no per-track licence file, and the bundled "Play" font has no OFL file in the repo.
- The button opens Wasmer's import page for this public repository, where the user reviews the configuration and clicks Deploy; it does not create a copy of the repository in their GitHub account.
