Title: docs: add Wasmer Edge deploy option

## Summary

Adds one paragraph after the feature summary in the README with a Deploy to Wasmer badge that imports Micro on Wasmer Edge (`https://wasmer.io/apps/create?github=trevortylerlee%2Fastro-micro`). README only.

## Why this repository

Micro builds fully static output to `dist/` with `npm run build` (`astro check && astro build`). That covers MDX, the sitemap, RSS and a Pagefind search index written to `dist/pagefind`. There is no adapter. Giscus comments are optional and configured only through public `PUBLIC_GISCUS_*` variables. `src/components/Giscus.astro` renders the widget only when all four are set, so the build needs no secrets.

## Testing

- At `af69926`, on Node v24.22.1 (matching `engines: 24.x`) and npm 11.19.1, `npm ci && npm run build` passed with no `.env` and no `PUBLIC_GISCUS_*` variables set. `astro check` reported 0 errors and 0 warnings. 20 pages were built, and Pagefind indexed 20 pages.
- I served `dist/` locally and requested `/`, `/blog/`, `/blog/01-getting-started/`, `/projects/project-1/`, `/tags/`, `/404.html`, `/rss.xml`, `/pagefind/pagefind-entry.json` and `/pagefind/pagefind-ui.js`. All returned 200, and all 34 root-relative references across the 20 HTML pages resolved.
- `npx prettier --check README.md` passes (Prettier 3.8.1).

## Limitations

- I did not run a deployment, and Wasmer's detection has not been checked in the import UI.
- The import link builds this public repository. It does not copy it into your GitHub account. To customize your site or redeploy on push, import your own fork or copy.
- The build needs network access for `npm ci`. Giscus comments appear only when the `PUBLIC_GISCUS_*` variables are set at build time.
