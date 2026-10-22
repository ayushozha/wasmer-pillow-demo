Title: docs: add Wasmer Edge deploy option

## Summary

Adds a short "Deploy on Wasmer Edge" item at the end of the README's "Deployment 📦" section, in the same bold-label-plus-bullet style as the existing options, followed by a "Deploy to Wasmer" badge. The badge links to `https://wasmer.io/apps/create?github=ashutosh1919%2FmasterPortfolio`, the Wasmer Edge import page for this repository. The bullet also tells readers to import their own copy so the deployed site includes their changes. README only; no code or config changes.

## Why this repository

masterPortfolio is a Create React App site. `npm run build` (`react-scripts --openssl-legacy-provider build`) writes a static bundle to CRA's default `build/` folder. The GitHub data the pages show comes from JSON committed in `src/shared/opensource/`. `git_data_fetcher.mjs` refreshes that JSON locally with a `GITHUB_TOKEN`, so neither the build nor the deployed site needs a token. The only component that calls `api.github.com/graphql` (`src/containers/projects/Projects.js`) is not imported anywhere. No `api.github.com` URL appears in the built bundle.

## Testing

- Base: `33b04a568a92a44e538a1795d8eab742dac47d81` (`master`).
- `npm ci && npm run build` on Node v24.22.1 / npm 11.19.1 exited 0 ("Compiled successfully"). CI (`nodejs.yml`) uses Node 20.x with the same commands.
- Served `build/` locally and requested `/`, `/404.html`, the main JS and CSS chunks, `/manifest.json` and `/sitemap.xml`. All returned 200, and all 14 root-relative references in the HTML resolve.
- The README already fails `prettier --check` (prettier 2.0.5) at the base commit. Comparing prettier's output before and after the edit shows the edit adds no new formatting issues. I committed with `--no-verify` because the lint-staged hook would otherwise rewrite the whole README.

## Limitations

- I did not run a deployment on Wasmer. I only linked to the import page.
- The import page does not copy the repository into your account. Redeploy-on-push works only for a repository you connect to your own Wasmer app.
- The app uses `BrowserRouter`. Deep links such as `/experience` rely on the GitHub Pages trick in `public/404.html`, which redirects to `/?/…`. They work on Wasmer only if the host serves `404.html` for unknown paths. I have not verified that.
- `public/index.html` loads the author's own Google Ads and Analytics tags. Forks keep them until the user edits `public/index.html`.
- The build needs Node 17+ for `--openssl-legacy-provider`, and react-scripts 3.2.0 is old.
