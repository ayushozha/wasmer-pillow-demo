Title: docs: add Wasmer Edge deploy option

## Summary

Adds a short "Deploy" section after "Getting started" with a Deploy to Wasmer badge. The badge opens `https://wasmer.io/apps/create?github=incluud%2Faccessible-astro-starter`, the Wasmer Edge import page for this repository. README only; no code or config changes.

## Why this repository

Accessible Astro Starter is a static Astro starter: "Getting started" says `npm run build` writes the site to `./dist/`, and there is no adapter. The README has no hosting instructions yet. The root build produces the site only; the `create-accessible-astro-starter` CLI in `packages/` builds separately through `build:cli`, so the import deploys the site, not the CLI.

## Testing

At `3fc28ca`, with Node 24.22.1 and npm 11.19.1:
- `npm ci` and `npm run build` passed and built 135 pages in 18.21 s.
- The build-time fetch of demo posts from `jsonplaceholder.typicode.com` succeeded.
- `npx eslint .` exited 0. The repo has no `npm run lint` script.
- I served `dist/` locally, and the 8 routes I checked all returned 200.
- The minified HTML uses unquoted attributes, which my link checker does not parse. So this does not claim full asset coverage.
- `prettier --check README.md` passes.
- Wasmer's project detector (Anybuild 0.33.0, run locally) chooses its static Node build with output `dist`.

## Limitations

- I did not run a deployment from the import link.
- The build fetches demo blog posts from `jsonplaceholder.typicode.com`, so it needs outbound network access, and the demo blog shows that placeholder content until you replace it.
- The contact form posts to `/thank-you`. A static host does not process form submissions, so the form needs a separate form service.
- `npm audit` reports 25 advisories in build-time dependencies: 3 moderate, 21 high, 1 critical. The critical one concerns AVIF image decoding and applies only if untrusted AVIF files are processed during the build. The deployed site is static files with no server endpoint.
- The import page builds this repository and does not create a copy. To customize the site and redeploy on push, fork it and import your fork.
