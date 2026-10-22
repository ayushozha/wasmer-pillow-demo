Title: docs: add Wasmer Edge deploy option

I work at Wasmer. Wasmer Edge is a cloud hosting platform powered by WebAssembly; it can host this repository’s generated static site. References: [Wasmer Edge docs](https://docs.wasmer.io/edge/), [Git deployments](https://docs.wasmer.io/edge/git/).

## Summary

Adds a "Deploy to Wasmer" badge and one short Chinese paragraph to the 介绍 section of the README, right after the sentence that already invites readers to Fork the repo or deploy it with Vercel. README-only; no config or code changes.

The paragraph says that `pnpm build` produces static files in `build`, that the button imports this repository and does not copy it into the reader's GitHub account (fork first and import your own copy to customize), and which settings a forker should change before deploying: `url` in `data/site.ts`, plus the Algolia, Giscus and Google Analytics (`gtag`) settings in `docusaurus.config.ts`.

## Why this repository

- The README explicitly presents the project as something to reuse: "如果你想要搭建一个类似的站点，可直接 Fork 本仓库使用", and it already offers Vercel, Netlify and StackBlitz buttons. Wasmer Edge is one more option in that same list.
- `docusaurus.config.ts` sets `baseUrl: '/'` and the site has no server code: `pnpm build` emits a fully prerendered Docusaurus site (216 HTML pages, including `404.html`, `blog/atom.xml`, `sitemap.xml` and the PWA `sw.js`). Every route has its own `index.html`, so no SPA fallback is needed.
- The new paragraph lists the owner-specific IDs a fork inherits (site URL, GA tracking ID, Algolia index, Giscus repo). That is useful for anyone forking the template, whichever host they use.

## Testing

All on base commit `5300b9e2f3306b425bd584f75fad39271239be67` and on this branch.

- Normal build: Node v24.22.1, pnpm 9.15.4 (from `packageManager`). `pnpm install --frozen-lockfile` exited 0 and `pnpm build` exited 0 (`Generated static files in "build"`).
- Served `build/` locally and requested `/`, `/blog/`, `/blog/2025-year-end-summary/`, `/docs/docusaurus-guides/`, `/project/`, `/about/`, `/blog/atom.xml`, `/404.html` and a hashed JS chunk. All returned 200. All 252 distinct root-relative `src`/`href` references in the built HTML resolve to files.
- Ran Anybuild 0.33.0's detector (`anybuild plan`) on clean checkouts of the base commit and of this branch. Both gave the same result: provider `node-static`, framework Docusaurus, pnpm 9.15.4, `pnpm install` / `pnpm run build`, static dir `build`.
- Replayed the planned steps in a separate clean directory with Node 24 and pnpm 9.15.4, using the pnpm environment Anybuild sets (`CI=true`, `pnpm_config_dangerously_allow_all_builds=true`, `pnpm_config_minimum_release_age=0`, `pnpm_config_strict_dep_builds=false`). The plan copies the whole source tree before install, so `.npmrc` (`shamefully-hoist=true`) applies. Install and build both exited 0.
- Served that output with static-web-server 2.38.0 using Anybuild's planned flags. `/`, `/blog/`, `/blog/2025-year-end-summary/`, `/docs/docusaurus-guides/`, `/project/`, `/about/`, `/blog/archive/`, `/blog/atom.xml`, `/sitemap.xml`, `/404.html`, `/manifest.json`, `/sw.js`, `/assets/js/main.*.js` and `/assets/css/styles.*.css` returned 200. `/blog` and `/about` returned a 308 redirect to the trailing-slash URL and then 200. An unknown path returned 404 with the site's own `404.html`.

## Limitations

- I did not deploy to Wasmer. Only the local builds and static serving above were tested.
- The badge links to an import of this public repository. It does not copy the repository into the visitor's GitHub account. Redeploy-on-push needs the visitor's own fork, which the README text says.
- A fork keeps the owner's settings until they are changed: `url: 'https://kuizuo.me'` (canonical and OpenGraph URLs), the `gtag` tracking ID `G-S4SD5NXWXF`, the Algolia DocSearch app/index (`GV6YN1ODMO` / `kuizuo`; this is a public search-only key, so search returns this blog's content), and the Giscus repo and category IDs (comments go to this repo's Discussions).
- `@docusaurus/plugin-vercel-analytics` is enabled in `auto` mode. Away from Vercel, its client script request to `/_vercel/insights/…` gets a 404. This is harmless, but it shows up in the browser console.
- The MiSans stylesheets load from cdn.jsdelivr.net at runtime.
- `pnpm audit --prod` on the lockfile reports 5 critical, 60 high, 42 moderate and 9 low advisories. All of them are in Docusaurus's build and dev-server toolchain: webpack-dev-server/sockjs/express, tinypool (SSG workers), sharp (ideal-image), workbox-build, svgo/postcss and similar. None of that code runs when the built files are served statically. The one high advisory in browser code is `path-to-regexp@1.8.0` (ReDoS) via react-router 5. It only matches against the site's own route patterns. Dependency upgrades are not part of this PR.
