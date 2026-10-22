Title: docs: add Wasmer Edge deploy option

**Summary:** Adds a Deploy to Wasmer badge under the existing Deploy to Netlify button at the top of the README. It links to `https://wasmer.io/apps/create?github=JustGoodUI%2Fdante-astro-theme`, the Wasmer Edge import page for this repository. A one-sentence note below the badge explains how it differs from the Netlify button. README only, 4 added lines. No code, config or license changes.

**Why this repository:** The README leads with a one-click Netlify deploy button. The theme builds to a plain static site: `astro.config.mjs` has no adapter and no `output` mode, and `npm run build` (`astro build`) writes the pages, RSS feed and sitemap to `dist/`. That static output is what the Wasmer import serves, so no extra config file is needed. The Netlify button creates a new repo for the visitor, and the Wasmer import does not. The note says this and tells readers to import their own fork to deploy a customized site.

**Testing:**
- At `83ff8f4`, on Node 24.22.1 with npm 11.19.1: `npm ci && npm run build` exited 0 and built 36 pages to `dist/`.
- I served `dist/` locally. `/`, `/blog/`, `/blog/post-1/`, `/projects/`, `/about/`, `/rss.xml` and `/sitemap-index.xml` all returned 200, and every root-relative reference in the 36 HTML pages resolved.
- `npx prettier --check README.md` passes with the repo's `.prettierrc`.

**Limitations:**
- I did not run a deployment from the import link.
- The import page builds the repository named in the URL and does not create a copy. Redeploy-on-push works only for a repository you connect to your own Wasmer app.
- `package.json` requires Node >=22.12.0.
- The theme has no custom 404 page, so unknown URLs get the host's default 404 response.
- The newsletter form posts to `subscribe.form.action` in `src/data/site-config.ts`, which defaults to `#`. You need a separate provider (Mailchimp, Formspree, ConvertKit or similar). That works the same on any static host.
