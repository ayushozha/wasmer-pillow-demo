Title: docs: add Wasmer Edge deploy option

## Summary

Adds a sixth step to "Getting started" with a Deploy to Wasmer badge that imports a repository on Wasmer Edge (`https://wasmer.io/apps/create?github=jktrn%2Fastro-erudite`). The step tells readers to import the repository they created from the template. README only.

## Why this repository

astro-erudite is a template repository: "Use this template" is step 1. The build (`astro check && astro build`) writes plain static output to `dist/`. There is no adapter, the CSS is native, and nothing runs on a server, so a static host can serve it as is. `dist` is Astro's default output folder and the one the README's command table names.

## Testing

- At `1926b88`, on bun 1.4.2 (`bun install --frozen-lockfile`, then `bun run build`), the build passed. `astro check` reported 0 errors, 0 warnings and 0 hints, and 18 pages were written to `dist/`. Node v24.22.1 was on PATH; `engines` requires `>=22.12.0`.
- I served `dist/` locally and requested `/`, `/blog/`, `/blog/introducing-v2/`, `/tags/`, `/404.html`, `/rss.xml` and `/sitemap-index.xml`. All returned 200.
- 46 of 48 root-relative references resolved. Two links written into the sample posts point at old v1 paths, `/blog/2024-post` and `/blog/rehype-patch`, while the posts now live under `/blog/v1-posts/`. They break the same way on any host and are not related to this change.
- Biome does not process `README.md` (`files.ignoreUnknown`). `bun run format:check` fails at the base commit on `src/components/TableOfContents.astro`, which this change does not touch.

## Limitations

- I did not run a deployment, and Wasmer's detection has not been checked in the import UI.
- The import link builds this public template. It does not copy it into your GitHub account. Redeploy-on-push needs your own repository connected.
- The build needs network access for `bun install`.
