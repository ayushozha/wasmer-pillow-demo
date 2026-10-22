Title: docs: add Wasmer Edge deploy option

## Summary

Adds a "Deploy to Wasmer" badge next to the existing Vercel and Netlify buttons in the "Deploy your own" section of the README, plus one sentence explaining what the link does. README-only; no config files or code changes.

## Why this repository

- The README already offers one-click deploy buttons ("Deploy your own"), so a Wasmer option fits the existing pattern.
- Astro Nano is a static site: `astro.config.mjs` has no adapter or `output` setting, and `npm run build` (`astro check && astro build`) writes plain files to `./dist/`, as the README's command table says. The generated sitemap and RSS feed are static files too.

## Testing

- Base commit: `66aa017d614828ba5dba02a9e51a1a714850ad31`
- Node v24.22.1, pnpm 8.15.9 (matching the repo's `pnpm-lock.yaml` lockfileVersion 6.0)
- `pnpm install --frozen-lockfile` → exit 0
- `pnpm build` (`astro check && astro build`, Astro 5.0.5) → exit 0, 0 check errors, 14 pages built
- Served `dist/` with a local static server and requested `/`, `/blog/`, `/blog/01-getting-started/`, `/projects/`, `/work/`, `/rss.xml`, `/sitemap-index.xml`: all 200. All 29 root-relative `href`/`src` references in the built HTML resolve to files in `dist/`.

## Limitations

- No deployment to Wasmer was performed; only the local build and static serving above were tested.
- The link imports this public repository so Wasmer can build it. It does not copy the repository into the visitor's GitHub account. Redeploy-on-push requires importing your own copy or fork, which the README text says.
- `site` in `astro.config.mjs` is `https://astro-nano-demo.vercel.app`, so canonical URLs, the sitemap and the RSS feed point at that domain until a user changes it (same as for the existing Vercel/Netlify buttons).
- The badge image is served by shields.io.
