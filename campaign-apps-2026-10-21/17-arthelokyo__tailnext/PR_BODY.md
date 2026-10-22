## Summary

Adds a "Deploy to Wasmer" button next to the existing Vercel and Netlify buttons in the README's Deploy section, plus one short paragraph on what it does and where `NEXT_PUBLIC_SITE_ORIGIN` goes on Wasmer. README-only; no code, config, dependency or lockfile changes.

## Why this repo

TailNext already says the build "runs anywhere Next.js does" and offers one-click buttons for two hosts. The site needs no backend and no secrets; its only setting is the optional `NEXT_PUBLIC_SITE_ORIGIN`, which the README already asks deployers to set. The new paragraph says that on Wasmer this variable goes in the app's Environment Vars and is read at build time (it is a `NEXT_PUBLIC_` value inlined by `next build`), and points to `src/config.ts`, `src/shared/data` and `src/content` for people who fork to customize and redeploy on push.

## Testing

All at `bad459314c915bc1424045523a23360eee2aed6e` (main), Linux x64, Node 22.22.0 (inside `engines` `>=20.9.0`; `.nvmrc` pins 24) / npm 10.9.4:

- `npm ci` - exit 0; `sharp` 0.35.4 loads (libvips 8.18.6)
- `npm run build` - exit 0 (Next.js 16.3.4, 20 routes)
- `PORT=3321 npm start` - `/` 200 with the TailNext title, `/blog/demo-post-1` 200, `/sitemap.xml` 200 `application/xml`; `/_next/image?url=<static camera-back.jpg>&w=640&q=50` 200 (9,842-byte JPEG from a 156,914-byte source; WebP with an `Accept: image/webp` header); `q=80` (not in `images.qualities`) 400 as intended
- `npm run prettier:check`, `npm run typegen && npm run typecheck`, `npm run lint` - all exit 0 with this README change
- `npm test` (Storybook stories in headless Chromium) was not run: it needs a Playwright Chromium download. This PR only changes the README.

Wasmer's builder (Anybuild v0.33.0) was built locally; `anybuild plan` on this repo detects Next.js with npm and Node 24 and generates `npm install`, `npx -y next-bundle@1.0.0 --build-command 'npm run build'`, start `node .next-bundle/server.mjs`. Running exactly that on a clean copy with Node 24.22.1: install and build exit 0; the bundled server returns 200 for `/`, `/blog/demo-post-1`, `/sitemap.xml` and the image URL above, and 404 for an unknown path.

## Limitations

- No Wasmer deployment was submitted from this environment; the badge image and the wasmer.io create page could not be loaded from it.
- Wasmer serves the build with its own Node server rather than `npm start`. Locally, that server answered `/_next/image` with its own optimizer: the response was a 147,038-byte WebP (against 9,842 bytes from `next start`), and it did not reject a quality value missing from `images.qualities`. Pages and images render, but image optimization on Wasmer may not match `next start`, and whether `sharp`'s native binary is used there is not verified.
