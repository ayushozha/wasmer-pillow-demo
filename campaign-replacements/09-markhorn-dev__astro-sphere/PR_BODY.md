## Summary

Adds a Deploy to Wasmer badge to the README, placed with its existing Vercel and Netlify buttons. It comes with one sentence on how the site is built and one on what the button does. There are no code or config changes.

## Why this repo

This portfolio and blog theme is mostly used by people who want their own copy online quickly. A one-click deploy from source gives them a live URL without any setup. Wasmer detects Astro, runs `npm install` and `npm run build`, and serves `dist/` as static files, which matches the build the README already documents.

## Testing

I ran a local replay of what Wasmer's builder (Anybuild v0.33.0) generates for `f7e3a40f20e1267d7fbbb7b6dd868df1845e1d82` with this change.

Detection:
- Provider: static Node.js.
- Framework: Astro.
- Package manager: npm.
- Output directory: `dist`.

Commands and results:
- `npm install` on Node 24.22.1 with npm 11.21.1 exited 0. Only `package.json` and `package-lock.json` were staged, as the builder does.
- `npm run build` exited 0.
- `dist/` was served with a local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here).

Smoke test: `/`, `/blog/`, `/blog/01-astro-sphere-file-structure/`, `/projects/`, `/search/` and `/rss.xml` returned 200, and all 24 referenced URLs returned 200.

## Limitations

- No deployment was made. The badge image and the Wasmer import page could not be checked from the test environment.
- The button opens Wasmer's import page for this public repository, where the user reviews the configuration and clicks Deploy; it does not create a copy of the repository in their GitHub account. To customize and redeploy on push, they import their own copy of the repo.
