## Summary

Adds a "Quick start (Wasmer)" section to the README, next to the existing Netlify quick start. It has a Deploy to Wasmer badge and two sentences: one on how Wasmer builds the starter, and one on what the button does. There are no code or config changes.

## Why this repo

This is the starter that `gatsby new` and the Gatsby docs point people to for a Markdown blog. Many of those people want a live URL before they change anything. The README already offers a one-click Netlify path. This adds a second host that builds the same repository from source with no configuration: Wasmer detects Gatsby, runs `npm install` and `npm run build`, and serves `public/`.

## Testing

I ran a local replay of what Wasmer's builder (Anybuild v0.33.0) generates for this repo at `d75052245100ae3c98807c5f38c6e7ec68910e74` with this README change.

Detection:
- Provider: static Node.js.
- Framework: Gatsby.
- Package manager: npm.
- Output directory: `public`.

Commands and results:
- `npm install` on Node 24.22.1 with npm 11.21.1 exited 0. Only `package.json` and `package-lock.json` were staged, as the builder does.
- `npm run build` exited 0.
- `public/` was served with a local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here).

Smoke test:
- `/`, `/hello-world/` and `/my-second-post/` returned 200 with the expected titles.
- `/rss.xml` returned 200.
- All 18 referenced same-origin assets returned 200.

## Limitations

- No deployment was made. The badge image and the Wasmer import page could not be checked from the test environment.
- The button opens Wasmer's import page for this public repository, where you review the configuration and click Deploy; it does not create a copy of the repository in your GitHub account. To customize the blog and redeploy on push, users fork the starter and import their own repository.
- In the local replay, unknown paths returned a plain 404 rather than the starter's `404.html`.
