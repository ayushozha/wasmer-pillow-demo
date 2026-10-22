## Summary

Adds a "Deploy to Wasmer" button next to the existing "Deploy with Vercel" button in the README title, plus a short "Deploy on Wasmer" section before "License". README-only; no code, dependency, lockfile or config changes.

The section explains that Wasmer runs the project's `build` script (`pnpm run build`) and serves the production build with Node, that the button builds this public repo as-is without forking it, and that to customize `src/data/resume.tsx` (and posts in `content/`) and redeploy on push you fork and connect the fork from the Wasmer dashboard. No environment variables are required.

## Why this repo

This template is meant to be cloned by developers who edit one file (`src/data/resume.tsx`) and publish a personal site. It has no database, no API keys and no runtime environment variables, so a one-click build from source is a complete deployment: the home page, `/blog` and every MDX post in `content/` are prerendered at build time and served by `next start`. Offering a second hosting option next to Vercel lets people try the template without first setting up an account-linked clone, and the section is explicit that a fork is needed to keep their own edits and get redeploys.

## Testing

Run locally from a copy of `main` at `5ef12e4c8bd0de3e22e89c2181ee77a35925ec8b`, Node v22.22.0, pnpm 10.28.0:

- `pnpm install --frozen-lockfile` - exit 0 (pnpm 10 skipped `esbuild` / `sharp` install scripts as it does by default; the build did not need them)
- `pnpm build` - exit 0 (content-collections built 1 collection / 7 documents, Next.js 16.1.1, 12 static pages)
- `PORT=3201 pnpm start` (`next start`), then:
  - `GET /` - 200, contains the configured name from `src/data/resume.tsx`
  - `GET /blog` - 200
  - `GET /blog/api-design-principles` - 200, contains the post title
  - `GET /does-not-exist` - 404
- Wasmer's build path, reproduced locally: `pnpm dlx next-bundle@1.0.0 --build-command 'pnpm run build'` - exit 0, then `node .next-bundle/server.mjs` from a directory holding only `.next-bundle`: `/` 200, `/blog` 200, `/blog/api-design-principles` 200, `/does-not-exist` 404

`/opengraph-image` failed in this sandbox because it fetches the avatar from the configured site URL (`https://dillion.io/me.png`) and outbound access to that host is blocked here; this is unrelated to this change.

## Limitations

- No Wasmer deployment was submitted. Wasmer's Next.js detection and runtime, and the shields.io badge rendering, were not verified from the test environment (wasmer.io and img.shields.io were unreachable there).
- The button points at `magicuidesign/portfolio`; the existing Vercel button and clone instructions still reference `dillionverma/portfolio`, which GitHub redirects. I left those untouched.
