# zhengkyl/qrframe: evidence

**Verdict: HOLD (builder: SolidStart is always classified as a Node server).** QRFrame is a fully static app in practice: `vite.config.ts` uses `solidStart({ ssr: true })` with `nitro({ preset: "static", prerender: { crawlLinks: true } })`, and the README's "Self-hosting" section says "The static files are available in `.output/public`". Anybuild v0.33.0 does not see that:

- `@solidjs/start` is in `RUNTIME_DEPENDENCIES` (`crates/anybuild/src/providers/node_static.rs:159-174`), so the plan (`plan.txt`) picks the **Node.js provider**, framework SolidStart, `node_server: node` (Edge.js), with install `pnpm install`, build `pnpm run build`, start `vite start` (taken from the repo's `start` script).
- `vite start` is not a Vite subcommand: the Vite CLI treats `start` as the project root and launches the dev server for a non-existent `./start` directory. The prerendered `.output/public` would not be served. (Not run on Wasmer; inferred from the plan and Vite's CLI.)
- A `Staticfile` with `root: .output/public` does not help: with `@solidjs/start` present the StaticFile provider wins outright and copies `.output/public` from the repo without building (verified with `anybuild plan`: "Detected static site provider, Output directory: .output/public", start only, no install/build). `.output` is not committed, so nothing would be served.
- No README-only fix exists; a fix needs either Anybuild to honour Nitro's `preset: "static"` or a repo change (e.g. a different start script), which is out of scope.

## Repository
- Pinned SHA: `a2ff5d83fe2e86a4516e01c3995cbc923005c3e2` on `main`, 2026-09-29.
- Stars / forks: 3,374 / 109; pushed 2026-09-30; MIT (GitHub API, 2026-10-22).
- No CONTRIBUTING, PR template or AI policy files at the root (fetched via raw.githubusercontent.com).
- Duplicate `wasmer` PR check: not run, because the target was held on the plan result.

## Note for the lead
Builder gap worth reporting upstream: SolidStart (and other Nitro-based) apps configured with `preset: "static"` should map to node-static with output `.output/public`.
