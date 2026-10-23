<a href="https://wasmer.io/apps/create?github=estevanmaito%2Fwindmill-dashboard"><img src="https://img.shields.io/badge/Deploy%20to-Wasmer-171717?style=for-the-badge&amp;logo=wasmer&amp;logoColor=white&amp;labelColor=171717" alt="Deploy to Wasmer" width="328" height="48"></a>

## Summary

Adds a "Deploy on Wasmer" subsection under Usage in the README, with a Deploy to Wasmer button, and a one-line `Staticfile` (`root: public`). No HTML, CSS or JS files change.

Disclosure: I work at Wasmer. I prepared this change with help from Claude, an AI assistant, and reviewed and tested it before opening this PR.

## Why this repo

The README says "everything you need is inside the `public` folder". The dashboard is plain HTML with a committed, prebuilt `tailwind.output.css`, so it can be hosted as-is. A one-click import lets people try the light/dark, accessible dashboard on their own URL before adopting it.

Why the `Staticfile` is needed: without it, Wasmer's builder (Anybuild 0.33.0) sees `package.json` and plans a Node.js app (`npm install`, `npm run build`, warning "no start or main script found"), which is not a static site. With `root: public` it plans a static site with output directory `public` and no install or build step. Wasmer serves the committed files in `public/` exactly as they are in the repository.

The button opens Wasmer's import page for this public repository, where you review the detected build settings and click Deploy; it does not create a copy of the repository in your GitHub account. To customize the site and redeploy on changes, fork the repository and import your fork instead.

## Testing

All on base `e05267588134ca2f4129087cc65a59c38a9c36b5` (`master`), with this patch applied:

- `anybuild plan` (v0.33.0) without the `Staticfile`: "Detected Node.js provider", install `npm install`, build `npm run build`, no start script. With the `Staticfile`: "Detected static site provider", output directory `public`, no install or build command.
- Replayed the generated steps locally: copy `public/` (28 files, exit 0), served with a local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here).
- `curl` on `/` and all 12 HTML pages (`index`, `forms`, `cards`, `charts`, `buttons`, `modals`, `tables`, `pages/login`, `pages/create-account`, `pages/forgot-password`, `pages/blank`, `pages/404`): all 200 `text/html`.
- Every local asset those pages reference: 200 with the right type (`tailwind.output.css` as `text/css`, 5 scripts as `text/javascript`, 6 images as `image/jpeg`). `/does-not-exist`, `/pages/nope.html` and `/assets/js/nope.js` return 404, and files outside `public/` (`package.json`, `README.md`) are not served.
- Checked that the committed CSS matches the source: `npm ci --ignore-scripts && npm run build` (Node 24.22.1, npm 10.9.4, both exit 0) produces a `tailwind.output.css` byte-identical to the committed one (sha256 `25d861ce…a6e6`). All 12 pages link it.

No Wasmer deployment was made.

## Limitations

- Not deployed. The import page and badge image were not opened from the test environment.
- Routes: every page is a plain `.html` file (for example `/index.html`, `/forms.html`, `/pages/login.html`), and the demo links to those `.html` URLs; there is no client-side router. Unknown paths and repository files outside `public/` return 404.
- The served site is the committed `public/` folder; no build runs on Wasmer. If you change the Tailwind sources you still need `npm run build` and to commit the output, as today.
- The pages load Alpine.js (`alpine@v2.x.x`, a floating tag), Chart.js 2.9.3, Google Fonts and Unsplash demo images from external CDNs without SRI, as the current demo does. The site needs those services at runtime.
- Chart.js 2.9.3 has a high-severity prototype-pollution advisory (GHSA-h68q-55jf-x68w, fixed in 2.9.4). In this demo the charts (`charts-lines.js`, `charts-bars.js`, `charts-pie.js`) use only hard-coded data and options, with no URL, form, storage or fetched input, so the demo does not feed user input to it. Projects that pass user data into chart options should upgrade. The npm advisory database lists none for alpinejs 2.8.2, the latest 2.x. This PR does not change any library.
- Pre-existing and unrelated to hosting: the "Blank" link in `pages/404.html` points to `pages/blank.html`, which resolves to `/pages/pages/blank.html` and returns 404. It is left unchanged here.
- The repository has had little recent maintainer activity, so I understand this may not be reviewed soon.
