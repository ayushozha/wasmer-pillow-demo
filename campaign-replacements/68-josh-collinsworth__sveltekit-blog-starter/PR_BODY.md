## Summary

Adds a short "Deploy on Wasmer" subsection at the end of "Building, deploying and hosting" in the README, with a Deploy to Wasmer button and two sentences on what it does.

## Why this repo

This starter is for people who want a Markdown blog on SvelteKit without running a server: every page, the category pages and the RSS feed are prerendered by `adapter-static`. The README already says the `build` folder can go "anywhere a static site can be hosted" and mentions hosts that build on push. Wasmer detects this SvelteKit project, runs the npm build, and serves `build/` directly, so the starter works there without config changes.

## Testing

Local replay of what Wasmer's builder (Anybuild v0.33.0) generates for `6a1873dca5c2912d49ce38ff76242bed9b513b4c` with this change:
- Detection: static Node.js provider, framework SvelteKit, npm, output `build`.
- `npm install` (Node 24.22.1, npm 11.21.1): exit 0.
- `npm run build`: exit 0, "Wrote site to build".
- `build/` served with a local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here): `/`, `/about`, `/blog`, a post page, `/contact`, a category page and `/api/rss.xml` returned 200, and all 26 referenced `_app` assets returned 200.

## Limitations

- `npm audit` on the lockfile reports 11 findings (8 high, 2 moderate, 1 low) in the existing dependencies; the deployed site is prerendered static files, so none of that tooling runs on the server. This PR doesn't change dependencies.
- The build emits literal `*` files from the wildcard prerender entries; that's harmless on Linux (where Wasmer builds) but makes the upstream build fail on Windows. Unchanged by this PR.

- No deployment was made. The badge image and the Wasmer import page could not be checked from the test environment.
- The button opens Wasmer's import page for this public repository, where you review the configuration and click Deploy; it does not create a copy of the repository in your GitHub account. To run your own blog, fork the repository (or copy it into a new one) and import that repository.
