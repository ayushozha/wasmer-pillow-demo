Title: docs: add Wasmer Edge deploy option

## Summary

Adds one plain-text line to the README's "Deployment 📦" section, matching its existing prose style. The line points to `https://wasmer.io/apps/create?github=cobiwave%2Fsimplefolio`, the Wasmer Edge import page for this repository. It says that `npm run build` outputs the site to `dist/` and that readers should import their own fork or copy to publish a customized portfolio. README only; no code or config changes.

## Why this repository

Simplefolio is a single-page template. `package.json` sets `"source": "src/index.html"`, and `npm run build` runs `parcel build`, which writes plain static files to Parcel's default `dist/`. The site has no server code, no API calls and no secrets. The Deployment section already sends readers to a static host (Netlify), so a second static option fits there. The output directory is the Parcel default, so no extra config file is needed.

## Testing

- Base: `af03c0cb90d03844de2b5a4cf2045aa0f72c2442` (`master`).
- `npm ci && npm run build` on Node v24.22.1 / npm 11.19.1 exited 0. Parcel 2.8 bundled the site into `dist/` (index.html, hashed CSS/JS, images, `assets/resume.pdf`). This passes even though `.nvmrc` pins 16.14.2.
- Served `dist/` locally and requested `/`, `/assets/resume.pdf` and the hashed JS, CSS and profile image. All returned 200. All 6 root-relative references in the built HTML resolve.
- `npx prettier --check README.md` (prettier 2.8.1, repo devDependency) passes.

## Limitations

- I did not run a deployment on Wasmer. I only linked to the import page.
- The import page builds the repository you point it at. It does not copy the repository into your GitHub account. Redeploy-on-push works only for a repository you connect to your own Wasmer app, so import your own fork to customize.
- Under npm 11, `npm ci` warns that `@parcel/watcher`, `lmdb` and `msgpackr-extract` have install scripts it did not run. The build still succeeded with their prebuilt binaries.
- `.github/workflows/gh-pages.yml` triggers on `main`, but the default branch is `master`, so that workflow does not run. I mirrored its `npm` build commands by hand.
