Title: docs: add Wasmer Edge deploy option

<a href="https://wasmer.io/apps/create?github=cssninjaStudio%2Ffresh"><img src="https://img.shields.io/badge/Deploy%20to-Wasmer-171717?style=for-the-badge&amp;logo=wasmer&amp;logoColor=white&amp;labelColor=171717" alt="Deploy to Wasmer" height="48"></a>

I work at Wasmer. Wasmer Edge is a cloud hosting platform powered by WebAssembly; it can host this repository’s generated static site. References: [Wasmer Edge docs](https://docs.wasmer.io/edge/), [Git deployments](https://docs.wasmer.io/edge/git/).

## Summary

- Adds a fourth step to the README's "Usage" list. It has a Deploy to Wasmer badge linking to the Wasmer Edge import page for this repository (`https://wasmer.io/apps/create?github=cssninjaStudio%2Ffresh`), and a short explanation of what the link does.
- Adds a root `Anybuild` file. Wasmer's builder uses this config file to decide how to build and serve an imported repo.
- No source or build changes.

## Why this repository

- Fresh is a fully static Astro landing page:
  - `astro.config.mjs` is an empty `defineConfig({})`, so the output is static with no adapter.
  - `pnpm build` (`run-s build:*`, which runs `astro build`) writes to `dist/`.
  - The repo's own Docker/nginx setup only serves those files.
- Wasmer's project detector ([Anybuild](https://github.com/wasmerio/shipit) 0.33.1) misreads this repo without a hint.
  - The build script is `run-s build:*` rather than `astro build`, so it only weakly recognises a static Astro build.
  - `"start": "astro dev"` then wins, and the import would run the Astro **dev server**.
  - A `Staticfile` doesn't help either: it would serve `dist/` without building it.
- The added `Anybuild` file was generated with `anybuild generate . --provider node-static`, which selects the static Node build explicitly. It has one edit: `pnpm_version = "8.15.9"` instead of the generated `"10"`. The repo declares no `packageManager`, and pnpm 10 would skip the `lockfileVersion: '6.0'` lockfile.

## Testing

Base commit: `420e73e597569ecf5d812017aeab3e696aef981d`.

`anybuild plan` without this change:
- provider `node`, start `astro dev`.

With this change:
- "Using static Node.js provider declared in Anybuild": Astro, pnpm 8.15.9, `pnpm install`, then `pnpm run build`, serving `dist`.

I ran those planned steps in a clean directory with Node 24.22.1 and pnpm 8.15.9, using the install environment Anybuild sets:
- pnpm reported "Lockfile is up to date, resolution step is skipped". The build exited 0.
- The output contains no dev-server client code.

I served that output with native static-web-server 2.38.0:
- `/`, `/index.html`, `/api/search.json`, `/_astro/index.DJrTxuCU.css` and `/img/illustrations/worker.png` returned 200.
- A missing path returned 404.
- Wasmer runs its own static-web-server build, which I did not test.

The normal build also passes: `pnpm install --frozen-lockfile` and `pnpm build` (Astro 4.7.0, 1 page). All 24 root-relative references in the built HTML resolve.

## Limitations

- I did not deploy to Wasmer.
- The import page builds this repository and does not create a copy. To customize the site and redeploy on push, use the template or fork it, then import your own repository.
- `Anybuild` is read only by Wasmer's builder; other hosts ignore it. Re-running `anybuild generate` would replace it.
- Upstream CI and Docker use Node 20. Wasmer's builder uses Node 24, where the build passes.
- The nginx config's behaviour does not carry over: the `/index.html` fallback for unknown paths, the cache headers, the `X-Frame-Options` override, and POST on `.json`. None of these is needed for this single-page site. Unknown paths return 404, and the site has no custom 404 page.
