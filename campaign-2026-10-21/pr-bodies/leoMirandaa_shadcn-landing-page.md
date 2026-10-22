Title: docs: add Wasmer Edge deploy option

## Summary

Adds a short "Deploy" section at the end of the README with a "Deploy to Wasmer" badge and one sentence explaining what the link does. README-only; no config files or code changes.

## Why this repository

- This template is a single-page Vite + React app. `vite.config.ts` sets no `base`, there is no router (navigation uses in-page `#` anchors), and `npm run build` (`tsc && vite build`) writes plain static files to `dist/`. That is the kind of output Wasmer Edge serves as a static site.
- The README has no deployment section today, only "How to install", so a short Deploy section gives users a hosting option for the built site.

## Testing

- Base commit: `ae3716dbce5c8a26815222bb743994b5717938f1`
- Node v24.22.1, npm 11.19.1
- `npm ci` → exit 1: the committed `package-lock.json` is out of sync with `package.json` (for example, the lock has `@radix-ui/react-accordion@1.1.2` and `package.json` asks for `1.3.1`). The README's install step is `npm install`, so I used that.
- `npm install` → exit 0; `npm run build` → exit 0 (Vite, 1666 modules, `dist/index.html` plus hashed JS/CSS/image assets).
- Served `dist/` with a local static server and requested `/`, `/vite.svg`, the built JS and CSS bundles and one image asset: all 200. All root-relative `href`/`src` references in the built HTML resolve to files in `dist/`.
- Ran Anybuild 0.33.0's detector (`anybuild plan`) on a clean checkout of this branch: provider `node-static`, framework Vite, install `npm install`, build `npm run build`, static dir `dist`.
- Re-ran those planned steps (Node 24, `npm install`, `npm run build`, copy `dist`) in a separate clean directory and served the result: `/`, `/vite.svg` and the JS bundle returned 200, with no missing local references.

## Limitations

- I did not deploy to Wasmer. Only the local builds and static serving above were tested.
- The link imports this public repository so Wasmer can build it. It does not copy the repository into the visitor's GitHub account. Redeploy-on-push needs your own copy or fork, which the README text says.
- Because the lockfile is out of sync, `npm install` resolves dependencies fresh, so Wasmer builds are not pinned to the committed lockfile. The same is true of a local `npm install` today.
- The Newsletter form and the Pricing buttons are UI only. Submitting the newsletter form calls `preventDefault()` and logs "Subscribed!" to the console. There is no backend, no email list and no payment.
- The badge image is served by shields.io.
