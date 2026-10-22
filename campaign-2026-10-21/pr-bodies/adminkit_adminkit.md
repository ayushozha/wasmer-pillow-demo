Title: Add Wasmer Edge deploy option to README

- [x] I have followed (at least) the [PR section of the contributing guide](https://github.com/adminkit/adminkit/blob/HEAD/.github/CONTRIBUTING.md#submitting-a-pull-request).

## Summary

This adds a short **Deploy** subsection to `README.md` under "Build tools". It says the compiled demo pages are in `static/`, a folder any static host can serve. Below that it shows a visible **Deploy to Wasmer** badge linking to `https://wasmer.io/apps/create?github=adminkit%2Fadminkit`, the Wasmer Edge import page for this repository, and a one-line note to import your own fork to customize the template and get redeploys on push. It also adds a one-line `Staticfile` at the repository root (`root: static`). There are no UI changes, so I have no screenshots.

**Why the `Staticfile` is needed:** without it, Wasmer's project detector (Anybuild 0.33.0, run locally with `anybuild plan`) picks its plain Node provider and would start `webpack serve`, the dev server. With `root: static` it serves the committed `static/` folder as a static site with no build step. I replayed that from a clean checkout and served the result: `/`, `/pages-profile.html`, `/charts-chartjs.html`, `/pages-sign-in.html`, `/js/app.js` and `/css/app.css` all returned 200.

## Why this repository

AdminKit is a static Bootstrap 5 template. The committed `static/` folder holds the 13 HTML pages along with their compiled `css/` and `js/`, and `vercel.json` already publishes that folder as-is (`"outputDirectory": "static"`). The README explains how to build but does not say how to host the result, so a small Deploy subsection fills that gap.

## Testing

At base `5b06097` (main), Node v24.22.1, npm 11.19.1:

- `npm install`: exit 0. The repo has no lockfile, so the resolved versions may differ from other machines.
- `npm run build` (webpack 5): exit 0, "compiled successfully". The build rewrites the tracked `static/js/app.js` and the source maps, and I reverted those before committing.
- I served `static/` with a local static server and got 200 for `/`, `/pages-profile.html`, `/charts-chartjs.html`, `/pages-sign-in.html`, `/js/app.js` and `/css/app.css`. All 282 relative refs across the 13 HTML files resolve.
- `git apply --check` of the patch against `5b06097`: clean.

I did not run a Wasmer deployment from the link.

## Limitations

- I have not deployed this to Wasmer. The import page builds the repository it is given. It does not copy the repository into the visitor's GitHub account, and redeploy on push only works for a repository the visitor connects themselves.
- The site is served from `static/`, not from the repository root or `dist/`. If the Wasmer import does not pick that folder, set it as the output or public directory.
- The `cleanUrls` setting in `vercel.json` (extension-less URLs) is Vercel-specific and does not apply on Wasmer. The `.html` URLs keep working.
