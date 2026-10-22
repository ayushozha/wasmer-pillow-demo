Title: docs: add Wasmer Edge deploy option

I work at Wasmer. Wasmer Edge is a cloud hosting platform powered by WebAssembly; it can host this repository’s generated static site. References: [Wasmer Edge docs](https://docs.wasmer.io/edge/), [Git deployments](https://docs.wasmer.io/edge/git/).

## :bookmark_tabs: Summary

Adds a short "Deploy to Wasmer Edge" section to the README, just before the Docker section. It has a "Deploy to Wasmer" badge that links to `https://wasmer.io/apps/create?github=mermaid-js%2Fmermaid-live-editor`, and it tells people to fork the repo first, since the import builds from the repo they choose and does not copy it into their GitHub account. The section also notes which `MERMAID_*` defaults from `.env` the build picks up and that people change them in their fork's `.env`.

It also adds a one-line root `Staticfile` (`root: docs`). `@sveltejs/adapter-static` here writes to `docs/` (`pages: 'docs'`), but without a hint Wasmer's detector assumes SvelteKit's default `build/` directory.

Resolves: no issue (documentation and deploy hint only).

Why this repository: the README already covers self-hosting. The Docker section explains how to build your own image with your own renderer, Kroki and analytics settings. The app is a prerendered static SvelteKit site (`prerender = true`, `ssr = false`), and diagram state lives in the URL hash. So a fork can run on plain static hosting with no server, and `/edit` and `/view` work as direct links because they are prerendered (`edit.html`, `view.html`).

## :straight_ruler: Design Decisions

- I used a `Staticfile` instead of changing the build output, because `docs/` is the GitHub Pages output that `deploy.yml` uploads. I ran Anybuild 0.33.0's `anybuild plan` on clean checkouts:
  - Base commit `eb4141dd51247259e95ecd890c1bf3dabf314913`: provider `node-static`, framework `sveltekit`, `static_dir` **`build`**. This is wrong, because the real output is `docs/`.
  - With this change: provider `node-static`, framework `sveltekit`, `static_dir` **`docs`**, pnpm 10.34.7 (from `packageManager`), `pnpm install` / `pnpm run build`.
- No build settings change. `.env` defaults stay as they are, and analytics stays off by default.

Testing:

- Normal build at `eb4141dd`: Node v24.22.1, pnpm 10.34.7. `pnpm install --frozen-lockfile` and `pnpm build` both exited 0 ("Wrote site to docs").
- I served `docs/` with a local static checker. `/`, `/edit.html`, `/view.html`, `/404.html`, `/manifest.json` and `/sitemap.xml` all returned 200. All root-relative references resolved, and all 190 relative references resolved.
- I replayed the planned Anybuild steps (`pnpm install`, `pnpm run build`, Node 24, pnpm 10.34.7, `CI=true`) in a separate clean directory on this branch. Exit code was 0.
- I served that output with static-web-server 2.38.0 using Anybuild's flags. `/`, `/edit`, `/view`, `/embed`, `/404.html`, a hashed `/_app/immutable/entry/app.*.js`, `/service-worker.js` and `/manifest.json` all returned 200. An unknown path returned 404 with the app's `404.html`.
- The husky pre-commit hook (lint-staged: prettier and eslint) ran and passed. `prettier --check README.md` passed.

### :clipboard: Tasks

Make sure you

- [ ] :book: have read the [contribution guidelines](https://mermaid.js.org/community/contributing.html)
- [ ] :computer: have added unit/e2e tests (if appropriate). Not applicable: README plus a host hint file, no code changes.
- [x] :bookmark: targeted `develop` branch

Limitations:

- I did not deploy to Wasmer. Only the local builds and static serving above were tested.
- The badge imports this public repository for a build. Redeploy-on-push needs your own fork connected.
- With the default `.env`, the PNG/SVG links call `https://mermaid.ink` and the Kroki link calls `https://kroki.io` when users click them. Mermaid Chart links and the promo banner are on (`MERMAID_IS_ENABLED_MERMAID_CHART_LINKS='true'`).
- The `netlify.toml` redirect (`/index.html` → `/edit`, 301) applies only on Netlify. On Wasmer, `/` serves the prerendered index page.
- The `Staticfile` matters only to Wasmer's detector. Other hosts ignore it.
- The badge image is served by shields.io.
