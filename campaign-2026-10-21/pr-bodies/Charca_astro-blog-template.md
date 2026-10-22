Title: docs: add Wasmer Edge deploy option

## Summary

Adds a short "Deploy to Wasmer Edge" subsection with a "Deploy to Wasmer" badge under "Getting Started", right after the "Open in StackBlitz" button, plus one sentence explaining what the link does. README-only; no config or code changes.

## Why this repository

- The README already uses a one-click button ("Open in StackBlitz") in "Getting Started", so a deploy badge next to it follows the existing pattern.
- `astro.config.mjs` has no adapter and no `output` setting. `npm run build` therefore produces a fully static site in `./dist/`, as the README's command table says. Every route (`/`, `/about/`, `/blog/`, `/blog/<slug>/`) is prerendered to its own `index.html`, so no SPA fallback is needed.

## Testing

- Base commit: `478c018deff7b8adbe4416a30b8d284305dfa5f9`
- Node v24.22.1, npm 11.19.1
- `npm ci` → exit 0; `npm run build` (Astro 5) → exit 0, 5 pages built.
- Served `dist/` with a local static server and requested `/`, `/about/`, `/blog/`, `/blog/hello-world/`, `/blog/markdown-test/` and `/robots.txt`: all 200. All 17 root-relative references in the built HTML resolve.
- Ran Anybuild 0.33.0's detector (`anybuild plan`) on a clean checkout of this branch: provider `node-static`, framework Astro, `npm install` / `npm run build`, static dir `dist`.
- Re-ran those planned steps with Node 24 in a separate clean directory and served the output with static-web-server 2.38.0, the server Anybuild plans. All routes above returned 200, `/blog` returned a 308 redirect to `/blog/` and then 200, and an unknown path returned 404.

## Limitations

- I did not deploy to Wasmer. Only the local builds and static serving above were tested.
- The link imports this public repository so Wasmer can build it. It does not copy the repository into the visitor's GitHub account. Redeploy-on-push needs your own copy or fork, which the README text says.
- `site` in `astro.config.mjs` is `https://astro-blog-template.netlify.app`, so canonical and OpenGraph URLs point there until a user changes it.
- There is no custom 404 page, so unknown paths get the server's default 404.
- The badge image is served by shields.io.
