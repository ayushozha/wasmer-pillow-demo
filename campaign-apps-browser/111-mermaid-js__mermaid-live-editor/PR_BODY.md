## :bookmark_tabs: Summary

This adds a "Deploy on Wasmer" section to the README, next to the Docker instructions, with a Deploy to Wasmer badge and two sentences. It also adds a one-line `Staticfile` (`root: docs`) so the hosting builder serves the folder adapter-static actually writes. There are no source, dependency or build-config changes.

No issue is linked; this is a small documentation addition.

## :straight_ruler: Design Decisions

**Why this repo.** The README already documents self-hosting via Docker, with build-time `MERMAID_*` settings for the renderer, Kroki, analytics and Mermaid Chart links. That fits teams who want the editor on an internal URL for architecture diagrams, runbooks or docs reviews, where diagram source (shared in the URL hash) shouldn't be routed through the public site. The app is fully static (adapter-static), so a one-click build from source gives these users an instance without running Docker or a Node toolchain.

**Why a `Staticfile`.** `svelte.config.js` sets `adapter({ pages: 'docs', fallback: '404.html' })`. Wasmer's builder (Anybuild v0.33.0) detects SvelteKit and otherwise expects `build/`. Without this line, install and build succeed but nothing is served. With it, the builder still uses its Node.js static provider, runs `pnpm install` and `pnpm run build`, and serves `docs/`. It is not the copy-only static mode.

**Configuration.** A deployment built this way uses the committed `.env` defaults: renderer `https://mermaid.ink`, Kroki `https://kroki.io`, Mermaid Chart links enabled, analytics disabled. That matches what the README says about the published Docker image.

**Testing.** I replayed the steps Wasmer's builder generates for `eb4141dd51247259e95ecd890c1bf3dabf314913` (`develop`) with this change:

- Detection: static Node.js provider, framework SvelteKit, pnpm 10.34.7 (from `packageManager`), output directory `docs` (from the `Staticfile`).
- `pnpm install` exited 0 on Node 24.22.1 with only `package.json` and `pnpm-lock.yaml` staged. The postinstall's `husky install` and `git config` printed "not a git directory" messages, which are non-fatal.
- `pnpm run build` (embed build, then `vite build`) exited 0, with "Wrote site to "docs"". 278 files.
- Served with a local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here):
  - `/`, `/edit`, `/view`, `/embed` and their `.html` files returned 200.
  - Unknown paths returned 404 with the app's `404.html`.
  - All 57 assets referenced by the built HTML and all 252 resolvable chunk/worker/CSS imports in the built JS returned 200. That includes the five Monaco workers.
- The same checks gave identical results on a native x86_64 build of static-web-server 2.32.2.
- `prettier --check .` passes.

### :clipboard: Tasks

Make sure you

- [x] :book: have read the [contribution guidelines](https://mermaid.js.org/community/contributing.html)
- [x] :computer: have added unit/e2e tests (if appropriate) (not applicable: README and `Staticfile` only)
- [x] :bookmark: targeted `develop` branch

**Limitations.**

- No deployment was made. The badge image and the Wasmer import page could not be checked from the test environment.
- `/` was verified on every server tested. Direct loads and reloads of `/edit` and `/view` (the shared-link URLs) rely on the server resolving `/edit` to `edit.html`. Both local static-web-server builds do this, but Wasmer's hosted WASI build was not tested.
- The checks were HTTP-level; editing and rendering were not exercised in a browser.
- The button opens Wasmer's import page for this public repository, where the user reviews the configuration and clicks Deploy; it does not create a copy of the repository in their GitHub account.
