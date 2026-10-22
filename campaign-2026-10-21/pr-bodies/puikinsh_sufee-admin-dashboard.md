Title: docs: add Wasmer Edge deploy option

## Summary

Adds a short "Deploy" section to the README, between "Getting Started" and "Project Structure". It has one sentence telling readers to fork the repository and import their fork, a note on what Wasmer runs (`npm run build`, then serve `dist/`), and a "Deploy to Wasmer" badge linking to `https://wasmer.io/apps/create?github=puikinsh%2Fsufee-admin-dashboard`. README only, no config files.

## Why this repository

Sufee is a front-end-only Bootstrap 5 dashboard. It has no backend and no API integrations. Vite builds its pages into `dist/`, and the README's own steps end with "Production files will be generated in the `dist/` directory". The runtime partials loader fetches `./partials/*.html` with relative paths "to support subfolder deployments", so the build works as-is on a static host.

## Testing

- Base commit `dda510efcd1116fc8fd3cedf01754b6e4e672deb`, Node v24.22.1, npm 11.19.1.
- `npm ci && npm run build` succeeded.
- I served `dist/` with Python's stdlib HTTP server. These routes all returned 200: `/`, `/index.html`, `/page-login.html`, `/error-404.html`, `/tables-data.html`, `/partials/sidebar.html` and `/partials/header.html`.
- Link checks:
  - The relative-reference scan only reports misses for links inside `partials/*.html`. Those links are written for the page root, where the partials are injected, and every one of them resolves there.
  - One root-relative reference, `/main.js` in `partials/scripts-common.html`, has no file behind it. It is the dev entry, and because it is inserted with `outerHTML` the browser never runs it. That is the same on every host.
  - `"..."` in the components catalog is code sample text, not a link.
- `npx prettier --check README.md` passes (Prettier 3.9.6 with the repo's `.prettierrc.json`).
- I ran Wasmer's open-source build detector (anybuild 0.33.0) on a clean checkout of the patched commit. It picks `node-static` with `npm install`, `npm run build` and `static_dir = dist`.
- I replayed those planned steps in a clean directory on Node 24. The build succeeded, and the routes above returned 200 from `dist/`, both under Python's stdlib server and under static-web-server 2.38.0 (the server Wasmer's builder plans). An unknown path returned 404.

## Limitations

- I have not run a deployment. Wasmer's import page has not yet been checked in a browser for this repository.
- The import link builds this repository and does not copy it into the visitor's GitHub account. To customize the site and redeploy on push, fork it first and import your own repository.
- The login, register, forgot-password and form pages are UI only, with no backend or auth.
- The Google Maps page shows static previews until you add your own key in `src/config/maps.config.js` and rebuild, as the README describes.
- The install step needs network access to the npm registry.
