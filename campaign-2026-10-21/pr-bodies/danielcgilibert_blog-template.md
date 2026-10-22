Title: docs: add Wasmer Edge deploy option

## Summary

Adds a "Deploy to Wasmer" badge next to the existing Vercel and Netlify buttons in both `README.md` and `README.es.md`. Each README also gets a one-line note in its own language. The badge opens `https://wasmer.io/apps/create?github=danielcgilibert%2Fblog-template`, the Wasmer Edge import page for this repository. README only; no code or config changes.

## Why this repository

OpenBlog is a static Astro blog: `astro.config.mjs` sets no `output` and no adapter. `pnpm build` writes to Astro's default `dist/`, and `postbuild` runs `pagefind --site dist` for client-side search. The README already offers one-click provider buttons, so a matching badge fits there. The Vercel button clones the repository, but the Wasmer import page does not. The note under the buttons says so and tells readers to fork first.

## Testing

- Base: `1d36741c203a8cf4c8b57e481d80a1abe9cf5925` (`main`).
- `pnpm install --frozen-lockfile && pnpm run build` with pnpm 8.15.9 (lockfile v6) on Node v18.20.8 exited 0. That Node version is the closest available to `.nvmrc` 18.17.0. Astro generated the static routes, and Pagefind 1.0.3 indexed 18 pages into `dist/pagefind`.
- Served `dist/` locally and requested `/`, `/post/astro/`, `/tags/`, `/category/category-1/1/`, `/rss.xml` and `/pagefind/pagefind.js`. All returned 200. Two links in the sample posts are broken (`/en/core-concepts/framework-components/` and `/en/reference/directives-reference/`). The demo `.mdx` content copied them from the Astro docs, and they are broken on any host.
- `prettier --check README.md README.es.md` (prettier 3.0.3, repo devDependency) passes.

## Limitations

- I did not run a deployment on Wasmer. I only linked to the import page.
- The import page does not copy the repository into your account. Redeploy-on-push works only for a repository you connect to your own Wasmer app.
- Node version matters. `tinacms` pulls in `better-sqlite3@8.7.0`. On Node 18 it installs from a prebuilt binary that `prebuild-install` downloads at install time. On Node 24 there is no prebuilt binary, the native compile fails, and `pnpm install` fails. The build environment needs Node 18 (per `.nvmrc`) and network access for that download.
- Settings in `netlify.toml` and on Vercel are not applied on Wasmer.
