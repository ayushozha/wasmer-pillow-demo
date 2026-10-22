Title: docs: add Wasmer Edge deploy option

**Summary:** Adds a short "👉 Deploy to Wasmer Edge" subsection to the Getting Started part of `readme.md`, between "Deploy to Cloudflare Workers" and "Build and Run With Docker". It follows the existing heading style and links to `https://wasmer.io/apps/create?github=zeon-studio%2Fastroplate`, the Wasmer Edge import page for this repository. README only, 4 added lines. No code or config changes.

**Why this repository:** Astroplate already documents several hosts: `netlify.toml` (`pnpm build`, publish `dist`), a Cloudflare Workers static-assets setup in `wrangler.jsonc`, a GitHub Pages workflow and a Docker image. Its build output is fully static. `astro.config.mjs` has no adapter and no `output` mode, and `pnpm run build` runs the theme and JSON generators, `astro build`, and then `scripts/llmsGenerator.js`, which writes `llms.txt` and `llms-full.txt` from the HTML in `dist`. The Wasmer import serves that folder as-is, so the subsection needs only one sentence and no new config.

**Testing:**
- At `501646d`, on Node 24.22.1 with pnpm 11.17.0 (the version in `packageManager`): `pnpm install --frozen-lockfile && pnpm run build` exited 0. It built 28 pages, and the LLM generator processed 27 pages.
- I served `dist/` locally. `/`, `/about`, `/blog`, `/blog/post-1`, `/contact`, `/404.html`, `/llms.txt` and `/sitemap-index.xml` all returned 200, and every root-relative reference in the 28 HTML pages resolved.
- `markdownlint` with the repo's `.markdownlint.json` passes on `readme.md`. The Prettier script only covers `./src`.

**Limitations:**
- I did not run a deployment from the import link.
- The import page builds the repository named in the URL and does not create a copy. Redeploy-on-push works only for a repository you connect to your own Wasmer app.
- Astro Fonts uses the Google provider, so the build fetches `fonts.google.com`. My build environment had no access to that host. The build still succeeded, but without the Heebo and Signika font files. A build machine with normal internet access downloads them.
- The contact form posts to `params.contact_form_action` in `src/config/config.json`, which defaults to `#`. A static host does not process the submission, so you need a separate form service.
- Wasmer does not apply `netlify.toml` or `wrangler.jsonc`. Neither file sets headers or redirects; they only set the build command and the output folder. The site sets `trailingSlash: "never"` and links to `/about` style URLs, which the static output serves from `about/index.html`.
