Title: docs: add Wasmer Edge deploy option

## Summary

Adds a fourth step to the README's "Usage" list linking to a Wasmer Edge import of this repository, with one sentence explaining what the link does. README-only; no config files or code changes.

## Why this repository

- Fresh is a fully static Astro landing page: `astro.config.mjs` is an empty `defineConfig({})` (static output, no adapter), and `pnpm build` (`run-s build:*` → `astro build`) writes to `dist/`.
- The repo's own production setup confirms there is no server requirement: the `Dockerfile` builds `dist/` and copies it into an nginx image, and `nginx/alpinejs.conf` only serves files (cache headers, `try_files $uri $uri/ /index.html`). Nothing in the app needs a runtime server.

## Testing

- Base commit: `420e73e597569ecf5d812017aeab3e696aef981d`
- Node v24.22.1, pnpm 8.15.9 (matching `pnpm-lock.yaml` lockfileVersion 6.0 and `engines.pnpm >=8`). Upstream CI/Docker uses Node 20; this was not re-run on Node 20.
- `pnpm install --frozen-lockfile` → exit 0
- `pnpm build` (Astro 4.7.0) → exit 0, 1 page built
- Served `dist/` with a local static server and requested `/`, `/api/search.json`, `/_astro/index.DJrTxuCU.css`, `/img/illustrations/worker.png`: all 200. All 24 root-relative `href`/`src` references in the built HTML resolve to files in `dist/`.

## Limitations

- No deployment to Wasmer was performed; only the local build and static serving above were tested.
- The link imports this public repository so Wasmer can build it. It does not copy the repository into the visitor's GitHub account. To customize the site and redeploy on push, import your own copy (the repo is a GitHub template) or fork, which the README text says.
- The nginx config's behaviour is not carried over: its `/index.html` fallback for unknown paths, its `Cache-Control`/`expires` rules, the `X-Frame-Options` override, and allowing POST on `.json` files. The site is a single page and nothing in `src/` requests `/api/search.json`, so none of these is needed for the page to work. Without the fallback, unknown paths return a 404 instead of the home page.
- The site has no custom 404 page.
