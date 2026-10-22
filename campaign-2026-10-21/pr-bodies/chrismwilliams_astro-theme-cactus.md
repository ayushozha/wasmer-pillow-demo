Title: docs: add Wasmer Edge deploy section

#### What kind of changes does this PR include?

- Something else! (README documentation only)

#### Description

**Summary:** Adds a "Wasmer Edge" subsection under Deploy, next to the existing Cloudflare Workers notes. It has one sentence and a Deploy to Wasmer badge linking to `https://wasmer.io/apps/create?github=chrismwilliams%2Fastro-theme-cactus`, the Wasmer Edge import page for this repository. No code or config changes.

**Why this repository:** The README already says the theme prerenders all pages and endpoints to `./dist` and needs no adapter, and the Deploy section has per-host subsections. A fully static build is what the Wasmer import serves, so no extra config is needed. The text tells readers to import their own copy of the repository to deploy a customized site. The import page builds the repository given in the URL and does not create a copy.

**Testing:**
- At `728f1f4`, `pnpm install --frozen-lockfile && pnpm run build` passed with pnpm 10 on Node 24.22.1, including the Pagefind `postbuild` step.
- I served `dist/` locally. `/`, `/posts/`, `/notes/`, `/about/`, `/404.html`, `/pagefind/pagefind.js`, `/rss.xml` and `/manifest.webmanifest` all returned 200, and every root-relative reference in the 22 HTML pages resolved.

**Limitations:**
- Opening the import link shows the repository, the `main` branch and a static (`node-static`) build preset, with Deploy enabled. I did not run a deployment from it.
- The build needs pnpm 10 or newer, because `pnpm-workspace.yaml` uses `allowBuilds`.
- Redeploy-on-push works only for a repository you connect to your own Wasmer app.
