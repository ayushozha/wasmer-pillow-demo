Title: docs: add Wasmer Edge deploy option

**Summary:** Adds a Wasmer Edge button to the "Deploy this template" section of the README, directly below the existing Vercel and Netlify buttons, in the same "Click here to deploy on ...:" format. The button links to `https://wasmer.io/apps/create?github=surjithctly%2Fastroship`, the Wasmer Edge import page for this repository. README only, 4 added lines. No code, config or license changes.

**Why this repository:** Astroship is published as a GitHub template and its README already offers one-click hosting options (Vercel and Netlify) under "Deploy this template". The site is a plain static Astro build: `astro.config.mjs` sets no `output` mode and no adapter, `pnpm build` runs `astro build` and writes everything (pages, blog posts, sitemap, 404 page) to `dist/`. That static output is what the Wasmer import serves, so no extra config file is needed.

The existing section says the buttons clone the template into your GitHub account. The Wasmer import does not do that, so the added sentence says so and tells readers to import their own fork to customize the site.

**Testing:**
- At `da1272b`, on Node 24.22.1 with pnpm 10.34.7 (the lockfile is v9, and there is no `packageManager` field): `pnpm install --frozen-lockfile && pnpm run build` exited 0 and built 10 pages to `dist/`.
- I served `dist/` locally. `/`, `/about/`, `/pricing/`, `/blog/`, `/blog/kitchensink/`, `/404.html`, `/sitemap-index.xml` and `/robots.txt` all returned 200, and every root-relative reference in the 10 HTML pages resolved.

**Limitations:**
- I did not run a deployment from the import link.
- The import page builds the repository named in the URL and does not create a copy. Redeploy-on-push works only for a repository you connect to your own Wasmer app.
- `.npmrc` sets `engine-strict=true` and `package.json` requires Node >=22.12.0, so the build image needs a current Node.
- The contact form posts to Web3Forms and needs your own access key (`YOUR_ACCESS_KEY_HERE` in `src/components/contactform.astro`). That works the same on any static host.
