Title: docs: add Wasmer Edge deploy option

I work at Wasmer. Wasmer Edge is a cloud hosting platform powered by WebAssembly; it can host this repository’s generated static site. References: [Wasmer Edge docs](https://docs.wasmer.io/edge/), [Git deployments](https://docs.wasmer.io/edge/git/).

## Summary

Adds a short "Deploy to Wasmer Edge" subsection at the end of "Running Locally" in the README. It has a "Deploy to Wasmer" badge that links to `https://wasmer.io/apps/create?github=Yqnn%2Fsvg-path-editor`. The text says:

- to fork first, because the import builds from the repo you pick and does not copy it into your GitHub account;
- that the build is the normal `npm run build`, with output in `dist/svg-path-editor/`;
- that people should remove or replace the Google Analytics tag (`G-1BBJSPSKQ9`) in `src/index.html` before deploying their own copy, so their visitors are not reported to this project's analytics property.

This is a README-only change. There are no code or config changes.

## Why this repository

SVG Path Editor runs entirely in the browser, with no backend, and the default production build works at any root because of `<base href=".">`. Right now the README only covers local Node builds, and the gh-pages script is for the maintainer. The badge gives people a documented way to run their own copy from the stock build. The analytics note covers a real gotcha: the GA tag in `index.html` ships in every build.

## Testing

- Base commit: `937d75a83b6be2bdda11d02b9b3594841315223a`, Node v24.22.1, npm 11.19.1.
- `npm ci` and `npm run build` (`ng build`, production) both exited 0, with only bundle-budget warnings. The output is in `dist/svg-path-editor/`.
- I served the output with a local static checker. `/`, `/manifest.webmanifest`, `/ngsw.json`, `/assets/logo.svg` and `/favicon.ico` returned 200, with no missing references.
- I ran Anybuild 0.33.0's `anybuild plan` on clean checkouts of the base commit and of this branch. Both gave provider `node-static`, framework `angular`, `static_dir` `dist/svg-path-editor`, npm 11. That matches the real output, so no config file is needed.
- I replayed the planned steps (`npm install`, `npm run build`, Node 24, `CI=true`) in a separate clean directory and served the result with static-web-server 2.38.0 using Anybuild's flags. `/`, the hashed `main.*.js`, `/manifest.webmanifest`, `/ngsw.json`, `/ngsw-worker.js`, `/3rdpartylicenses.txt` and `/favicon.ico` all returned 200. Unknown paths return the server's 404, because the app has no `404.html`.

## Limitations

- I did not deploy to Wasmer. Only the local builds and static serving above were tested.
- Redeploy-on-push needs your own fork connected.
- The Angular build inlines Google Fonts at build time, so the builder needs network access to fonts.googleapis.com. At runtime the page loads fonts from fonts.gstatic.com and, unless the tag is removed, Google Tag Manager.
- `npm audit --omit=dev` reports 5 high and 6 moderate advisories in the Angular 17 packages and none critical. They predate this change, which does not touch them.
- The badge image is served by shields.io.
