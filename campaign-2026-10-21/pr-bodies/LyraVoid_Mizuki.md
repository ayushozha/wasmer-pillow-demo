Title: docs: add Wasmer Edge deploy option

## Type of change

- [ ] Bug fix (a non-breaking change that fixes an issue)
- [ ] New feature (a non-breaking change that adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [x] Other (please describe): documentation only. Adds one deploy option to the README deployment list.

## Checklist

- [ ] I have read the [**CONTRIBUTING**](https://github.com/saicaca/fuwari/blob/main/CONTRIBUTING.md) document.
- [x] I have checked to ensure that this Pull Request is not for personal changes.
- [x] I have performed a self-review of my own code.
- [x] My changes generate no new warnings.

## Related Issue

None.

## Changes

Adds a "Wasmer Edge" item with a "Deploy to Wasmer" badge to the "🚀 部署 / Deployment" list. The item goes in all four READMEs (`README.md`, `README.en.md`, `README.ja.md`, `README.tw.md`), in each file's language, right after the Cloudflare Pages item. Each item says the button imports this repository and builds it as a static site from `dist`, and that users who want to customize the site should import their own copy or fork. This is one line per file. There are no code or config changes.

Why this repository: the README already says Mizuki can be deployed "to any static hosting platform" and lists Vercel, Netlify, GitHub Pages and Cloudflare Pages. `astro.config.mjs` sets `output: "static"` with `base: "/"`, and `vercel.json` uses `outputDirectory: "dist"`, so the site is plain static files that Wasmer Edge can serve.

## How To Test

- Base commit: `c06f0003089ca040d5b599b37f0ad0ae65726e95`
- Node v24.22.1, pnpm 11.5.3 (from `packageManager`)
- `pnpm install --frozen-lockfile` → exit 0
- `pnpm run build` (sync-content, update-anime, `astro build`, style check, `pagefind --site dist`, font check) → exit 0. 27 HTML files, Pagefind indexed 10 pages, and the font loading check passed.
- Served `dist/` with a local static server and requested `/`, `/posts/guide/`, `/archive/`, `/about/`, `/rss.xml`, `/404.html`, `/pagefind/pagefind.js` and `/sitemap-index.xml`: all 200. All 190 root-relative references in the built HTML resolve.
- Ran Anybuild 0.33.0's detector (`anybuild plan`) on a clean checkout of this branch: provider `node-static`, framework Astro, `pnpm install` / `pnpm run build`, static dir `dist`, pnpm 11.5.3.
- Re-ran those planned steps with Node 24 and pnpm 11.5.3 in a separate clean directory and served the result. The routes above returned 200, with no missing references.

## Screenshots (if applicable)

N/A (README only).

## Additional Notes

- I did not deploy to Wasmer. Only the local builds and static serving above were tested.
- The badge link imports this public repository so Wasmer can build it. It does not copy the repository into the visitor's GitHub account. Redeploy-on-push needs your own copy or fork, which the README line says.
- My sandbox could not reach `api.fontsource.org`, so Astro's font provider logged fetch errors and a "No data found for font family JetBrains Mono" warning during the build. The build still exited 0. A builder with normal network access should not see this.
- The `vercel.json` headers/`cleanUrls` settings and the generated `dist/_headers` file are host-specific and are not applied on Wasmer. Pages are emitted as `dir/index.html`, so clean URLs still resolve.
- As the README already says, `siteURL` in `src/config/siteConfig.ts` should be updated before publishing.
- Pre-existing and unrelated to this change: the demo post `/posts/guide/` links to `../../../../docs/CONTENT_AUTHORING.md`, which is not part of the built site on any host.
- The badge image is served by shields.io.
