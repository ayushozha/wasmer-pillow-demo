Title: Add Wasmer Edge deploy option to README

## Summary

This adds a short **Deploy** subsection to `README.md` between "Build commands" and "Release and publication". It says that `npm run build` (or `npm run release:minified`) writes a static site to `dist/`, and it links the existing deployment guide at adminator.colorlib.com. Below that it shows a visible **Deploy to Wasmer** badge linking to `https://wasmer.io/apps/create?github=puikinsh%2FAdminator-admin-dashboard`, the Wasmer Edge import page for this repository, and a one-line note to import your own fork to customize the dashboard and get redeploys on push. Only `README.md` changes.

## Why this repository

Adminator builds 18 static HTML pages plus hashed JS/CSS into `dist/` with webpack, and it needs no server or environment variables. Its deployment guide (merged in #324 and now hosted at adminator.colorlib.com/docs/deployment/) already covers static hosting, but the README itself does not say where the output goes or how to host it. This subsection adds that, plus a Wasmer Edge option.

## Testing

At base `4c76854` (master), Node v24.22.1 (`.nvmrc` = 24), npm 11.19.1:

- `npm ci`: exit 0
- `npm run build` (clean, webpack production build, then `verify:build`): exit 0. webpack compiled successfully and printed "Verified 18 pages and local asset references".
- I served `dist/` with a local static server and got 200 for `/`, `/calendar.html`, `/email.html`, `/signin.html`, `/404.html` and `/charts.html`. All 25 relative refs in the HTML resolve. There are no root-relative refs.
- `git apply --check` of the patch against `4c76854`: clean.

I did not run a Wasmer deployment from the link.

## Limitations

- I have not deployed this to Wasmer. The import page builds the repository it is given. It does not copy the repository into the visitor's GitHub account, and redeploy on push only works for a repository the visitor connects themselves.
- `npm run build` produces the unminified build. A host that runs the default build script gets that output. `npm run release:minified` produces the minified one.
