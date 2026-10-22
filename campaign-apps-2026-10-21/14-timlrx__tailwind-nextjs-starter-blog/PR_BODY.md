## Summary

Adds a Deploy to Wasmer button next to the existing Deploy with Vercel button, and a short "Wasmer" subsection under "Deploy" (between Vercel and Netlify). README-only; no code, dependency, lockfile or config changes.

The subsection says that Wasmer runs the project's `build` script (`yarn run build`: Contentlayer, `next build` and the RSS postbuild script) and serves the production build with Node, and not `yarn start`, which is `next dev`. It explains that the button builds this public repo as-is, so personalizing `data/siteMetadata.js` and `data/blog` and redeploying on push needs a fork connected from the Wasmer dashboard. It notes that no environment variables are required and that the comment and newsletter variables from `.env.example` are optional, with `NEXT_PUBLIC_*` values read at build time.

## Why this repo

This is one of the most widely used Next.js blog starters, and its README already documents several hosts (GitHub Pages, Vercel, Netlify, static export). Self-hosters mostly need two things: to know that production is `yarn build` + `yarn serve`, since `yarn start` is the dev server, and to know that comments (Giscus/Utterances/Disqus) and newsletter providers are optional env vars. A build-from-source button with that information is a natural addition to the existing Deploy section.

## Testing

From a copy of `main` at `b45bef66b40c63b6f57c15ee8cd090682238df4c`, Node v22.22.0, Yarn 3.6.1 (from `.yarnrc.yml` `yarnPath`):

- `yarn install --immutable` - exit 0
- `yarn build` - exit 0 (Contentlayer generated, Next.js 15.5.12 build, "RSS feed generated...")
- `PORT=3205 yarn serve` (`next start`); `trailingSlash: true`, so unslashed paths 308 as expected:
  - `/` 200 (site title present), `/blog/` 200, `/blog/code-sample/` 200 (post title present), `/blog/guide-to-using-images-in-nextjs/` 200, `/tags/markdown/` 200
  - `/feed.xml` 200 `application/xml` with 10 items, `/sitemap.xml` 200
  - `/static/images/ocean.jpeg` 200, `/_next/image/?url=%2Fstatic%2Fimages%2Focean.jpeg&w=640&q=75` 200 `image/jpeg`
  - `/api/newsletter/` without a provider key: 500 (optional feature, no key configured)
- `yarn prettier --check README.md` passes before and after the change.

## Limitations

- No Wasmer deployment was submitted, and detection and runtime were not verified from my environment.
