# mermaid-js/mermaid-live-editor: evidence (triage; no patch prepared)

**Verdict: HOLD (Anybuild output-dir mismatch).** Anybuild v0.33.0 hard-codes SvelteKit's static dir as `build` (`crates/anybuild/src/providers/node.rs:355-356`: `NodeFramework::Svelte => "build"`, `NodeFramework::Sveltekit => "build"`). This repo's adapter-static writes to `docs/` (`svelte.config.js`: `adapter({ pages: 'docs', fallback: '404.html' })`; CLAUDE.md: "`docs/` is build output (GitHub Pages convention)"). In the replay, `pnpm install` and `pnpm run build` both exited 0, but then `STATIC_DIR 'build' MISSING`. A Wasmer deployment would serve nothing. Fixing it needs a builder change, or a repo config change that is not README-only. I'm not proposing either here.

## Facts
- Pinned SHA: `eb4141dd51247259e95ecd890c1bf3dabf314913` on `develop` (default). Stars / forks: 6,869 / 1,178 (GitHub API, 2026-10-22). License: MIT.
- PR template: Summary / Design Decisions / Tasks, including "targeted `develop` branch". Node `engines: >=24.16.0`; `packageManager: pnpm@10.34.7`. Replay: Node 24.22.1, pnpm 10.34.7. Staged `package.json` and `pnpm-lock.yaml`.
- Diagnostic only, not the Anybuild path: I served the real output `work/docs` with a local native static-web-server 2.38.0. `/` returned 200, `/edit` and `/view` returned 200 (sws resolved them to the prerendered `edit.html` and `view.html`), and `/nope` returned 404 (404.html). So the app itself is static-host friendly. The only problem is the output dir. Wasmer's hosted WASI static-web-server package was not tested.
- Duplicate `wasmer` PRs: 0.
