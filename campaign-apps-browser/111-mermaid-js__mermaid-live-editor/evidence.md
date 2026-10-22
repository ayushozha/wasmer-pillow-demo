# mermaid-js/mermaid-live-editor: evidence

**Verdict: CONDITIONAL** (re-evaluated 2026-10-22, Staticfile fix). The lane A HOLD (output-dir mismatch, history below) is resolved by a one-line root `Staticfile` with `root: docs`. In a node-static project the Staticfile `root:` becomes `static_dir`, and install and build still run (`crates/anybuild/src/providers/node_static.rs:202-205`, `260-276`). The patched plan still says "Detected static Node.js provider", framework SvelteKit, output `docs` (`plan.txt`), not the copy-only StaticFile provider. The replay passes, receipts are saved, and no policy gate is open.

The only condition is the hosted-server route caveat: `/` is proven. `/edit` and `/view` exist as real prerendered files (`edit.html`, `view.html`), but resolving the extensionless URLs `/edit` and `/view` to them is proven only on local native static-web-server 2.38.0 and on a native x86_64 build of 2.32.2. It is unproven on Wasmer's hosted WASI SWS 2.32.2 package.

**Remaining check for the reviewer:** after a real Wasmer deployment, confirm `GET /edit` and `GET /view` return 200 with the editor HTML, not 404. Shared links are `/edit#pako:...` and `/view#pako:...`. If they return 404, the app still loads from `/` (client-side redirect to `/edit`), but reloads and shared links break. In that case, downgrade to HOLD.

## Repository and policy
- Pinned SHA: `eb4141dd51247259e95ecd890c1bf3dabf314913` on `develop`, committed 2026-10-21.
  - `develop` is the default branch. The PR template task says "targeted `develop` branch".
  - The mermaid contributing guide says maintainers "merge the PR into the `develop` branch".
- Stars / forks: 6,869 / 1,178; not archived (GitHub API, 2026-10-22). Merged PRs since 2025-10-01: 78. Many are maintainers, release bots or knsv-bot, and include fixes and features.
- License: MIT.
- Contribution policy:
  - The PR template (`.github/pull_request_template.md`) links the mermaid contributing guide. I fetched it (`mermaid-js/mermaid@develop:packages/mermaid/src/docs/community/contributing.md`). It says "Contributing process is very simple and straightforward: branch --> changes --> submit", and "We make all changes via Pull Requests (PRs). Open a new one."
  - It has no issue-first or approval-first rule, no CLA (no CLA text, no CLA workflow in this repo), and no AI/agent policy. `AGENTS.md` returns 404 in both repos.
  - `CLAUDE.md` in this repo is developer guidance for an AI assistant (commands, architecture), not a contribution restriction.
  - The README says "Contributors are welcome! … join the Discord channel and contact knsv" (optional).
- Bots: `close-broken-link-issues.yml` (issues only). There is no PR auto-close.
- CI lint runs `prettier --check --cache .`. The patched tree passes both `prettier --check README.md` and `prettier --check .` (`lint-receipt.txt`).
- Duplicates: `wasmer repo:mermaid-js/mermaid-live-editor` returned 0 PRs. Not in `static_excl.txt`.
- Prior "deploy" PRs: only #361 "Skip beta deploy" (member). Third-party README PRs: #1434 merged (2024), #1624 and #1834 closed unmerged (low-quality "Update README" PRs). There were no provider-button precedents.

## Anybuild detection (v0.33.0)
- Unpatched (`plan-unpatched.txt`, `replay-unpatched.log`, lane A): static Node.js, SvelteKit, static dir hard-coded to `build` (`node.rs:355-356`). The result was "STATIC_DIR 'build' MISSING".
- Patched (`plan.txt`): static Node.js provider, SvelteKit, pnpm (pnpm 10.34.7 from `packageManager`), output `docs`.
  - install `pnpm install`; build `pnpm run build`; start `static-web-server --root=/opt/static_app --log-level=info --port=8080`.
  - Staged install inputs: `package.json` and `pnpm-lock.yaml`.
  - pnpm env: `CI=true pnpm_config_minimum_release_age=0 pnpm_config_dangerously_allow_all_builds=true pnpm_config_strict_dep_builds=false`.

## Replay (patched clone): `replay.log`
- Node 24.22.1, pnpm 10.34.7. Install-noise `+ pkg` lines are trimmed.
- `pnpm install`: exit 0.
  - The postinstall `husky install && svelte-kit sync && (git config … || true)` printed ".git can't be found", "No Svelte config file found … using SvelteKit's default configuration" (only package.json and the lockfile are staged at install time) and "fatal: not in a git directory".
  - All of these were non-fatal; the install exited 0. No hooks were disabled.
- `pnpm run build`: exit 0. `build:embed`, then `vite build`, then adapter-static "Wrote site to "docs"". `static_app` holds 278 files.
- Smoke (sws 2.38.0): `/`, `/edit`, `/view`, `/edit.html`, `/view.html`, `/404.html` and `/embed` returned 200. 44 assets referenced from `/` returned 200. `/nope` returned 404, as expected.
- `asset-check-receipt.txt` (same build, local native SWS 2.38.0 and native x86_64 SWS 2.32.2, identical results):
  - Routes: `/`, `/edit`, `/view`, `/embed`, `/edit/` and their `.html` files returned 200. `/nope` and `/edit/nope` returned 404, with the `404.html` body (1904 bytes).
  - Part 1: all 57 `_app/immutable/*` and `./` refs in the built HTML/JS returned 200.
  - Part 2: 296 paths (extractor script included in the receipt). 252 returned 200, including the 5 Monaco workers and 28 CSS files. The 44 non-200 paths are not fetch URLs: 42 are bundler CJS-wrapper module ids for vscode-jsonrpc/languageserver-protocol, and 2 are elkjs browserify module-map keys. Context excerpts are in the receipt.
  - `service-worker.js` is a no-op fetch listener.
- Routes:
  - `src/routes/+layout.ts` sets `prerender = true` and `ssr = false`. `(app)/+page.svelte` does a client-side `goto(buildRedirectUrl(...))` to `/edit` (`src/lib/util/redirect.ts`).
  - The prerendered pages are `index.html`, `edit.html`, `view.html` and `embed.html`. The adapter's SPA fallback `404.html` is served by SWS for unknown paths, with status 404.
  - Proven on hosted: nothing (not testable). Proven locally: as above.
- Env vars (`src/lib/util/env.ts`, `MERMAID_*` via `import.meta.env`, build-time and baked into public JS; none are secrets):
  - The defaults in the committed `.env` apply: renderer `https://mermaid.ink`, Kroki `https://kroki.io`, `MERMAID_IS_ENABLED_MERMAID_CHART_LINKS='true'`, analytics and domain empty (disabled).
  - The core editor works with these defaults. No keys.

## Security (`audit-receipt.txt`)
- `pnpm audit --prod`: 31 (9 low, 17 moderate, 5 high), 0 critical.
  - Highs: 4 in `devalue@5.9.2` (via svelte; the advisories concern `stringify`/`uneval` serialization, used at prerender/build time) and `braces` (via @zenuml/core → tailwindcss → chokidar, a build/watch tool).
  - Moderates are mostly `dompurify@3.2.7` pinned by `monaco-editor@0.55.1` (used by Monaco's markdown/hover renderer). Mermaid itself uses `dompurify@3.4.15`, which has 2 low advisories about IN_PLACE mode.
  - All are the same as what the project ships on mermaid.live today. There is no high/critical client-side XSS.
- `adv.py`: mermaid@12.2.0, monaco-editor@0.55.1, svelte, codemirror, lodash-es, pako, katex, d3, cytoscape and others have 0 advisories. `@sveltejs/kit@2.69.1` has 1 moderate (an Accept-header ReDoS on the server side, so not applicable to a static deployment).
- Third-party input: diagram state from shared URLs goes through `sanitizeConfig` (per `CLAUDE.md`) and mermaid's own sanitizer. I did not review this beyond the audit. It is identical to upstream's own hosted site.

---
## History: lane A triage (original text, superseded)
### mermaid-js/mermaid-live-editor: evidence (triage; no patch prepared)

**Verdict: HOLD (Anybuild output-dir mismatch).** Anybuild v0.33.0 hard-codes SvelteKit's static dir as `build` (`crates/anybuild/src/providers/node.rs:355-356`: `NodeFramework::Svelte => "build"`, `NodeFramework::Sveltekit => "build"`). This repo's adapter-static writes to `docs/` (`svelte.config.js`: `adapter({ pages: 'docs', fallback: '404.html' })`; CLAUDE.md: "`docs/` is build output (GitHub Pages convention)"). In the replay, `pnpm install` and `pnpm run build` both exited 0, but then `STATIC_DIR 'build' MISSING`. A Wasmer deployment would serve nothing. Fixing it needs a builder change, or a repo config change that is not README-only. I'm not proposing either here.

## Facts
- Pinned SHA: `eb4141dd51247259e95ecd890c1bf3dabf314913` on `develop` (default). Stars / forks: 6,869 / 1,178 (GitHub API, 2026-10-22). License: MIT.
- PR template: Summary / Design Decisions / Tasks, including "targeted `develop` branch". Node `engines: >=24.16.0`; `packageManager: pnpm@10.34.7`. Replay: Node 24.22.1, pnpm 10.34.7. Staged `package.json` and `pnpm-lock.yaml`.
- Diagnostic only, not the Anybuild path: I served the real output `work/docs` with a local native static-web-server 2.38.0. `/` returned 200, `/edit` and `/view` returned 200 (sws resolved them to the prerendered `edit.html` and `view.html`), and `/nope` returned 404 (404.html). So the app itself is static-host friendly. The only problem is the output dir. Wasmer's hosted WASI static-web-server package was not tested.
- Duplicate `wasmer` PRs: 0.
(lane A diagnostic receipt: receipt-checks.txt; lane A replay: replay-unpatched.log, plan-unpatched.txt)
