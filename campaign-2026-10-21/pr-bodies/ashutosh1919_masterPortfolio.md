Title: docs: add Wasmer Edge deploy option

## Summary

Adds a short "Deploy on Wasmer Edge" item at the end of the README's "Deployment 📦" section, in the same bold-label-plus-bullet style as the existing options, followed by a "Deploy to Wasmer" badge. The badge links to `https://wasmer.io/apps/create?github=ashutosh1919%2FmasterPortfolio`, the Wasmer Edge import page for this repository. The bullet also tells readers to import their own copy so the deployed site includes their changes. README only; no code or config changes.

The commit went through the repo's own pre-commit hook (Husky, then lint-staged, then `prettier --write`), which also reformatted existing README lines: the table-of-contents indentation and blank lines around a code block. That is why the diff is 18 lines added and 9 removed, not only the new lines.

## Why this repository

masterPortfolio is a Create React App site. `npm run build` (`react-scripts --openssl-legacy-provider build`) writes a static bundle to CRA's default `build/` folder. The GitHub data the pages show comes from JSON committed in `src/shared/opensource/`. `git_data_fetcher.mjs` refreshes that JSON locally with a `GITHUB_TOKEN`, so neither the build nor the deployed site needs a token. The only component that calls `api.github.com/graphql` (`src/containers/projects/Projects.js`) is not imported anywhere. No `api.github.com` URL appears in the built bundle.

## Testing

- Base: `33b04a568a92a44e538a1795d8eab742dac47d81` (`master`).
- `npm ci && npm run build` on Node v24.22.1 / npm 11.19.1 exited 0 ("Compiled successfully"). CI (`nodejs.yml`) uses Node 20.x with the same commands.
- Served `build/` locally and requested `/`, `/404.html`, the main JS and CSS chunks, `/manifest.json` and `/sitemap.xml`. All returned 200, and all 14 root-relative references in the HTML resolve.
- Wasmer's project detector (Anybuild 0.33.0, run locally) chooses its static Node build: CRA, output `build/`. I replayed its planned `npm install` and `npm run build` in a clean directory. `/`, `/404.html`, the actual main chunk (`/static/js/main.1c0df698.chunk.js`) and `/manifest.json` all returned 200.
- The commit was made normally, with the repo's Husky/lint-staged/prettier hook running and passing.

## Limitations

- I did not run a deployment on Wasmer. I only linked to the import page.
- The import page does not copy the repository into your account. Redeploy-on-push works only for a repository you connect to your own Wasmer app.
- The app uses `BrowserRouter`. Deep links such as `/experience` rely on the GitHub Pages trick in `public/404.html`, which redirects to `/?/…`. The built `404.html` encodes the path (`pathSegmentsToKeep = 0`, correct for hosting at the root), and `index.html` decodes it with `history.replaceState`. Wasmer serves static sites with static-web-server, whose documented default serves `404.html` for missing paths. I have not run that server here, so deep links are unverified.
- `public/index.html` loads the author's own Google Ads and Analytics tags. Forks keep them until the user edits `public/index.html`.
- The build needs Node 17+ for `--openssl-legacy-provider`, and react-scripts 3.2.0 is old.
