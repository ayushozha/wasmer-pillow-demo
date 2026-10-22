Title: docs: add Wasmer Edge deploy option

## Summary

Adds a short "Deploy" section to the README, after the installation options and before "Community Mazer-based open sources". It has one sentence telling readers to fork the repository and import their fork, a note on what Wasmer runs (`yarn build`, then serve `dist`), and a "Deploy to Wasmer" badge linking to `https://wasmer.io/apps/create?github=zuramai%2Fmazer`. README only, no config files.

## Why this repository

Mazer builds to a fully static multi-page site. Vite and Nunjucks turn `src/*.html` into `dist/` with `base: './'`, and the repository's own workflow publishes `dist/` to GitHub Pages. The README already lists several ways to run the template: a prebuilt release, building it yourself, Docker and a CDN. It has no option for hosting your own customized build, which is the gap this section fills.

## Testing

- Base commit `6ea47abbd5bd60e28b98164e52ada52776e36aca`, Node v24.22.1, yarn 1.22.22.
- `yarn install --frozen-lockfile && yarn build` succeeded and produced 76 entries in `dist/`.
- I served `dist/` with Python's stdlib HTTP server. These routes all returned 200: `/`, `/index.html`, `/auth-login.html`, `/error-404.html`, `/application-checkout.html`, `/assets/compiled/css/app.css` and `/assets/compiled/js/app.js`. There are no root-relative references.
- A scan of 7,323 relative references found 11 misses. None of them is caused by the host:
  - The RTL stylesheets (`app.rtl.css`, `app-dark.rtl.css`) used by `layout-rtl.html`. They come only from `yarn rtl`, which your Pages workflow runs after `yarn build`.
  - A few image paths in `application-email.html` that also fail in the source.
- I ran Wasmer's open-source build detector (anybuild 0.33.0) on a clean checkout of the patched commit. It picks `node-static` with `yarn install`, `yarn run build` and `static_dir = dist`.
- I replayed those planned steps in a clean directory on Node 24. The build succeeded, and the routes above returned 200 from `dist/`, both under Python's stdlib server and under static-web-server 2.38.0 (the server Wasmer's builder plans). An unknown path returned 404.

## Limitations

- I have not run a deployment. Wasmer's import page has not yet been checked in a browser for this repository.
- The import link builds this repository and does not copy it into the visitor's GitHub account. To customize the site and redeploy on push, fork it first and import your own repository.
- Wasmer runs `yarn build` only, not `yarn rtl`. The RTL demo page therefore has no RTL stylesheet unless you add `rtl` to your build.
- The login, register, checkout, chat and email pages are frontend demos only, with no backend, payments or auth.
- Some demo images and libraries load from CDNs at runtime.
- The install step needs network access to the npm registry.
