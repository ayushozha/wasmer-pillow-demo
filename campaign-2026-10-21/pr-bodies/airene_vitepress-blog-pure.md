Title: docs: add Wasmer Edge deploy option

I work at Wasmer. Wasmer Edge is a cloud hosting platform powered by WebAssembly; it can host this repository’s generated static site. References: [Wasmer Edge docs](https://docs.wasmer.io/edge/), [Git deployments](https://docs.wasmer.io/edge/git/).

## Summary

This adds a short `## 部署` section to the README, written in Chinese like the rest of the file. It holds a visible **Deploy to Wasmer** badge that links to `https://wasmer.io/apps/create?github=airene%2Fvitepress-blog-pure`, plus a few lines of import guidance:

- The build command is `bun run build` and the output directory is `.vitepress/dist`.
- The import does not copy this repository into the visitor's GitHub account. Anyone who wants to customize the site, or get redeploys on push, should fork first and import their own fork.
- Before deploying, change the site title, `website`, `socialLinks` and the giscus `comment` settings in `.vitepress/config.ts`. By default these point at this repository.

Only `README.md` changes (+6 lines). No config files are added.

## Why this repository

- The repo root is a complete VitePress blog, not just a theme package. It ships `.vitepress/` (theme and config), `pages/` (archives, tags, category, about), sample `posts/`, and local search (`search.provider: 'local'`). `vitepress build` turns all of it into a plain static site with `base: '/'`.
- The README asks users to take these files as the starting point for their own blog ("使用方法"). A badge gives them a quick way to see the default site running on their own hosting.
- The README has no deploy section today. The only deploy automation is `.github/workflows/deploy.yml`, which builds with bun and publishes `.vitepress/dist` to GitHub Pages, and it only triggers on a `fake` branch. The new section uses that same build command and output directory.
- Everything the site needs at runtime is static: HTML, JS chunks and the local search index. Comments use giscus, which runs in the browser and needs no server.

## Testing

All runs used the base commit `ff1f46f3e0f53e56c3777616e2def7570cf8b25d`, or the patched commit on top of it.

- **Normal build:** Node v24.22.1 and bun 1.4.2. `bun install --frozen-lockfile` exited 0 (303 packages). `bun run build` (`cross-env NODE_ENV=production vitepress build`, VitePress v1.6.4) exited 0 and rendered 9 HTML pages.
- **Static smoke check on the build output:** these routes all returned 200:
  - `/`
  - `/pages/archives.html`, `/pages/tags.html`, `/pages/about.html`
  - `/posts/vitepress-first.html`, `/posts/2025/vitepress-second.html`
  - `/404.html`
  - the local search index chunk

  The check found 21 root-relative refs with 0 missing, and 0 relative (`./`) refs.
- **Anybuild 0.33.0 `plan`:** ran on clean worktrees of both the base and the patched commit. Both gave the same result: provider `node-static`, framework `vitepress`, static_dir `.vitepress/dist`, package manager bun (`bun_version` 1), install `bun install --no-save`, build `bun run build`. The `static_dir` matches the real VitePress output directory.
- **Replay of the planned Anybuild steps:** ran in a non-nested temp directory with Node 24 and bun 1.4.2. Install and build both exited 0. The output is file-for-file identical to the normal build.
- **static-web-server 2.38.0 with Anybuild's planned flags:** served the replay output. These all returned 200:
  - `/`
  - `/pages/archives.html`, `/pages/tags.html`, `/pages/category.html`, `/pages/about.html`
  - `/posts/vitepress-first.html`, `/posts/2025/vitepress-second.html`
  - `/404.html`, `/hashmap.json`
  - `/assets/app.C71ov7gz.js`, `/assets/chunks/@localSearchIndexroot.Bq9MgPzV.js`

  A missing path returned 404 with the site's `404.html`.
- **Prettier:** `prettier --check README.md` with the repo's `.prettierrc.json` (prettier 3.9.10) passes.

## Limitations

- No deployment was performed. The detection and build results above come from running Anybuild's `plan` and replaying its planned commands locally, not from Wasmer's hosted builder.
- The import link builds this public repository. It does not create a copy in the visitor's account. To customize the site, or to redeploy on push, fork the repository and import the fork.
- Comments are giscus, and the defaults (`repo`, `repoId`, `categoryId`) point at `airene/vitepress-blog-pure`. A deployed copy shows this repo's discussions until the values are replaced with your own from https://giscus.app/. giscus loads from a third-party origin.
- The build needs network access to the npm registry. Nothing is fetched at runtime apart from giscus.
- `cleanUrls` is not enabled, so pages are served at `.html` paths, which is how VitePress links them by default.
- `bun audit` reports 11 advisories: 3 high, 7 moderate, 1 low, 0 critical. They are in `vite`, `esbuild`, `braces` (via globby) and `sprintf-js` (via gray-matter). All of them affect the dev server or the build-time tooling, not the static files that get served.
