Title: docs: add Wasmer Edge deploy option

## Summary

Adds a "Deploying to Wasmer Edge" subsection after "Creating a production build", with a matching table-of-contents entry and a Deploy to Wasmer badge linking to `https://wasmer.io/apps/create?github=madrilene%2Feleventy-excellent`, the Wasmer Edge import page for this repository. It also adds a one-line `Staticfile` at the repository root:

```yaml
root: dist
```

## Why this repository

Eleventy Excellent builds a fully static site, and `eleventy.config.js` sets `dir.output: 'dist'`. `netlify.toml` and `vercel.json` publish the same folder. Wasmer's project detector (Anybuild 0.33.0) recognizes Eleventy but assumes Eleventy's default `_site/`. The `Staticfile` points it at `dist/` and keeps `npm run build` as the build step; `anybuild plan` gives output `_site` without the file and `dist` with it. No existing files change.

## Testing

At `69f0948`, with Node 24.22.1 and npm 11.19.1:
- `npm ci` and `npm run build` exited 0: 55 files in 10.42 s, 73 images, 26 from cache. The build-time `api.github.com` fetch worked.
- I served `dist/` locally. `/`, `/blog/`, `/blog/post-with-an-image/`, `/about/`, `/404.html`, `/feed.xml` and `/sitemap.xml` all returned 200.
- A scan of root-relative links found one missing target among 318 references in 34 HTML files: `/blog/built-with/`. It already exists upstream; the actual page is `/built-with/`. This PR doesn't touch it.
- `prettier --check readme.md` passes. The repo has no git hooks configured.

## Limitations

- I did not run a deployment from the import link.
- The headers in `netlify.toml` and `vercel.json` are not applied on Wasmer.
- The Netlify-style `_redirects` file that `src/common/_redirects.njk` generates is not applied either. Wasmer's detector reads `_redirects` only from the source tree when it plans the build, and this file exists only in `dist/` after the build.
- The build calls `api.github.com` and processes images, so it needs network access.
- `npm audit` reports 8 advisories (6 high, 2 moderate, 0 critical), all in build tooling (glob, braces, PostCSS). The deployed site is static files with no server endpoint.
- The import page builds this repository and does not create a copy. To customize the site and redeploy on push, fork it and import your fork.
