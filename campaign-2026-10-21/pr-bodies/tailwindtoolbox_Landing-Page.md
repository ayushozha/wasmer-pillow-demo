Title: docs: add Wasmer Edge deploy option

## Summary

Adds a short "Deploy" section to the README, after "Using the Template". It has one sentence telling readers to fork the repository and import their fork, followed by a "Deploy to Wasmer" badge linking to `https://wasmer.io/apps/create?github=tailwindtoolbox%2FLanding-Page`. README only, no config files.

## Why this repository

As the README says, the template is "just a HTML file using a full CDN hosted Tailwind CSS file": a root `index.html` plus `hero.png`, with no `package.json` and no build. It can be served straight from the repository root. "Getting Started" covers downloading, cloning and forking, and the new section covers the next step of putting your copy online.

## Testing

- Base commit `545f89eb26e0997d7cdd15fe77dda35df73e575a`. There is no build step.
- I served the repository root with Python's stdlib HTTP server. `/`, `/index.html` and `/hero.png` returned 200, and the only local reference (`hero.png`) resolves.
- Running Wasmer's open-source build detector (anybuild 0.33.0) on a clean checkout picks the static-site provider and serves the repository root, with no config needed.

## Limitations

- I have not run a deployment. Wasmer's import page has not yet been checked in a browser for this repository.
- The import link builds this repository and does not copy it into the visitor's GitHub account. To customize the page and redeploy on push, fork it first and import your own repository.
- The visitor's browser loads Tailwind CSS 2.2.19 from unpkg.com, jQuery 3.3.1 from cdnjs.cloudflare.com and Source Sans Pro from Google Fonts at runtime. Nothing is bundled.
