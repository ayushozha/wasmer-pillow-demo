Title: docs: add Wasmer Edge deploy option

## Summary

Getting Started step 4 already shows Deploy to Netlify and Deploy to Vercel buttons. This adds a Deploy to Wasmer badge next to them, linking to `https://wasmer.io/apps/create?github=radishzzz%2Fastro-theme-retypeset`, the Wasmer Edge import page for this repository.

It also adds one paragraph. The paragraph says the button imports this repository rather than creating a copy, so readers should import their own fork. It then lists the `src/config.ts` settings to change before publishing:
- `site.url`
- the demo's Waline comment server (`comment.waline.serverURL`), or set `comment.enabled: false`
- analytics: `seo.umamiAnalyticsID` and `preload.customUmamiAnalyticsJS`
- the site verification codes (`seo.verification`)
- the image host (`preload.imageHostURL`)

README only; no code or config changes.

## Why this repository

Retypeset is a static Astro blog theme with no adapter, and its README already offers one-click deploy buttons for other hosts. Wasmer's project detector (Anybuild 0.33.0, run locally with `anybuild plan`) chooses its static Node build: Astro, output `dist/`, using the repo's declared pnpm 10.33.0. No config file is needed.

The defaults in `src/config.ts` point at the demo site's own comment server, analytics and image host. A fork deployed without changes would send comments and analytics there. That is why the added paragraph names each setting.

## Testing

At `a636b6d`, with Node 24.22.1 and pnpm 10.33.0, `pnpm install --frozen-lockfile` and `pnpm run build` exited 0:
- `astro check`: 59 files, 0 errors, warnings or hints.
- 103 pages built, plus 16 optimized WebP images.
- `apply-lqip` processed 16 cached images across 108 image instances in the HTML.

I served the built site locally:
- `/`, `/en/`, `/en/posts/markdown-extended-features/` and `/ja/posts/rashomon/` returned 200.
- The sitemap, the favicon and the hashed CSS, JS and WebP assets returned 200.
- A missing route returned 404.

On the commit itself:
- The repo's pre-commit hook (`simple-git-hooks` running `pnpm lint-staged`) ran when committing. It found no staged files matching its patterns and exited 0.
- `anybuild plan` gives the same result with and without this change.

## Limitations

- I did not run a deployment from the import link.
- The build fetches remote images from the configured image host (`image.radishzz.cc` by default) to optimize them and generate placeholders, so it needs network access to that host.
- The comment system and analytics are third-party services that need the reader's own setup.
- The import page builds the repository given in the URL and does not create a copy. To customize and redeploy on push, import your own fork.
