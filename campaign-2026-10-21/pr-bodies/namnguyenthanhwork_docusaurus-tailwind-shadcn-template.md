Title: docs: add Wasmer Edge deploy option

I work at Wasmer. Wasmer Edge is a cloud hosting platform powered by WebAssembly; it can host this repository’s generated static site. References: [Wasmer Edge docs](https://docs.wasmer.io/edge/), [Git deployments](https://docs.wasmer.io/edge/git/).

## Summary

Adds a "Wasmer Edge" subsection with a "Deploy to Wasmer" badge to the README's **Deployments** section, between "Cloudflare Pages" and "Netlify and Others". README-only; no config or code changes.

The text says that `bun install && bun run build` produces static files in `build/` and that the button imports this repository without copying it into the visitor's GitHub account, so readers should fork first and import their fork. It also lists what a fork should change: `url`/`editUrl` in `docusaurus.config.ts` and `backend.repo` in `static/admin/config.yml`. It notes that `/admin` CMS sign-in off Netlify needs your own GitHub OAuth proxy, and links to the README's existing Admin CMS section.

## Why this repository

- The README already has a **Deployments** section with per-host instructions (Vercel button, Cloudflare Pages build settings, Netlify). This adds one more entry in the same format.
- `docusaurus.config.ts` uses `baseUrl: '/'` and a placeholder `url`. The project has no server code: `bun run build` emits a fully prerendered site (docs, blog, OpenAPI reference pages, `about-me`, `404.html`, `search-index.json` for the local search plugin, and the static `/admin` CMS page). Every route has its own `index.html`, so no SPA fallback is needed.
- The Admin CMS note matters for any host other than Netlify. The README already explains that only Netlify handles the OAuth login automatically, so the new subsection points readers there.

## Testing

All on base commit `c913b4787022b6d666bf116b3fc1a33f3d512e17` and on this branch.

- Normal build: Node v24.22.1, Bun 1.4.2. `bun install --frozen-lockfile` exited 0 and `bun run build` exited 0 (`Generated static files in "build"`).
- Served `build/` locally and requested `/`, `/docs/intro/`, `/docs/tutorial-basics/create-a-page/`, `/blog/`, `/blog/first-blog-post/`, `/about-me/`, `/blog/rss.xml`, `/search-index.json`, `/404.html` and `/admin/`. All returned 200. All 103 distinct root-relative `src`/`href` references in the built HTML resolve to files.
- Ran Anybuild 0.33.0's detector (`anybuild plan`) on clean checkouts of the base commit and of this branch. Both gave the same result: provider `node-static`, framework Docusaurus, package manager Bun (`bun_version` 1), `bun install --no-save` / `bun run build`, static dir `build`.
- Replayed those planned steps in a separate clean directory with Node 24 and Bun 1.4.2. Install and build both exited 0.
- Served that output with static-web-server 2.38.0 using Anybuild's planned flags. `/`, `/docs/intro/`, `/docs/tutorial-basics/create-a-page/`, `/docs/petstore_versioned/add-pet/`, `/blog/`, `/blog/first-blog-post/`, `/about-me/`, `/blog/rss.xml`, `/search-index.json`, `/sitemap.xml`, `/404.html`, `/admin/`, `/assets/js/main.*.js` and `/assets/css/styles.*.css` returned 200. `/docs/intro` returned a 308 redirect to `/docs/intro/` and then 200. An unknown path returned 404 with the site's own `404.html`.

## Limitations

- I did not deploy to Wasmer. Only the local builds and static serving above were tested.
- The badge links to an import of this public repository. It does not copy the repository into the visitor's GitHub account. Redeploy-on-push needs the visitor's own fork, which the README text says.
- `url` is the placeholder `https://your-docusaurus-site.example.com` until a user sets it. Canonical URLs and the sitemap use that value.
- The `/admin` page is only the CMS front end, loaded from unpkg.com at runtime. Production sign-in needs a GitHub OAuth client or proxy (`backend.base_url`), and Wasmer does not provide one. Without it, the deployed `/admin` can only show the login screen. Local editing (`local_backend: true`) is unaffected.
- The OpenAPI pages' "Send API Request" panel calls the API from the visitor's browser, against the example Petstore spec's servers. There is no proxy on the host.
- `bun audit --prod` reports 4 critical, 37 high, 29 moderate and 5 low advisories. Nearly all are in Docusaurus's build and dev-server toolchain: webpack-dev-server/express (`proxy-addr`, `shell-quote`), `tinypool` (SSG workers), `sharp`, `svgo`, `js-yaml`, `undici`, `follow-redirects` and similar. None of that code runs when the built files are served statically. One high advisory is in code that ships to the browser: `@faker-js/faker@5.5.3` (via `postman-collection`, used for the OpenAPI code samples). Its `helpers.fake` issue needs attacker-controlled template strings, and here the input is the site's own OpenAPI spec. Dependency upgrades are not part of this PR.
