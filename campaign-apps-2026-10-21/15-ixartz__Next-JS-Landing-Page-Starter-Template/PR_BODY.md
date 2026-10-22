## Summary

Adds a "Deploy to Wasmer" button to the README, in a short `### Deploy to Wasmer` section directly after the existing "Deploy to Netlify" section. README-only; no code, config, dependency or lockfile changes. The Netlify button, the sponsor tables and all attribution links are unchanged.

## Why this repo

This template is a single-page Next.js landing page with no backend, no database and no environment variables, so it is the kind of project people want to see live in one click before they clone and customize it. The README already offers a one-click Netlify path; this adds a second host for people who prefer Wasmer. The new section says what the button actually does (builds this public repo as-is, no fork) and points to the files people edit (`src/utils/AppConfig.ts`, `src/templates/*`) if they want their own copy that redeploys on push.

## Testing

All runs at `cd6694e6c69efad1128c1ed732188389182789df` (master), Linux x64, Node 22.22.0 / npm 10.9.4:

- `npm ci` - exit 0 (560 packages)
- `npm run build` - exit 0 (Next.js 14.1.0; `/` and `/404` prerendered)
- `PORT=3301 npm start` - `/` 200 with `<title>Nextjs Starter</title>` and the "Download Your Free Theme" banner text; `/assets/images/feature.svg` 200; unknown path 404

Wasmer's builder (Anybuild v0.33.0, `wasmerio/shipit`) was built locally and `anybuild plan` was run on this repo: it detects Next.js with npm, and generates `npm install`, `npx -y next-bundle@1.0.0 --build-command 'npm run build'`, and start `node .next-bundle/server.mjs` on Node 24. I ran those commands locally on a clean copy with Node 24.22.1: install and build exit 0, and the bundled server returns 200 for `/` and for static assets.

## Limitations

- No Wasmer deployment was submitted from this environment; the badge image and the wasmer.io create page could not be loaded from it.
- Wasmer does not run `npm start` (`next start`). It builds with `npm run build` through its own Next.js bundler and serves the result with its own Node server. Locally, with `trailingSlash: true`, that server answered an unknown path with a 308 redirect to the same URL (a redirect loop) where `next start` returns 404. Existing pages are not affected.
- The README's "Deploy to production" text says the build writes to `out/`; with the current `next.config.js` (no `output: 'export'`) `npm run build-prod` does not create `out/`. This PR does not change that text.
