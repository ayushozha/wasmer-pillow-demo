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
- `npm audit` on the locked dependencies at `478c018` (`logs/Charca_astro-blog-template.npm-audit.json`) reports 17 advisories: 1 low, 2 moderate, 13 high, 1 critical. `--omit=dev` gives the same counts, because every dependency is a production dependency.
  - The critical one is [GHSA-26w7-cxv4-gfx2](https://github.com/advisories/GHSA-26w7-cxv4-gfx2) in `astro` (fixed in 7.2.8; the lockfile has 5.5.2 with sharp 0.33.5). It is "Remote code execution through AVIF image optimization": a `libheif` flaw reached through Astro's default Sharp image service when an attacker can make Astro process an untrusted AVIF image.
  - In this template that path is not reached. There are no AVIF files, `src/` does not use `astro:assets`, `astro.config.mjs` configures no image service or remote image patterns, and the build logs show no image-optimization step. It would become relevant if a user adds `astro:assets` optimization of AVIF images they don't control, for example from a CMS or remote URLs.
  - The other advisories are in `astro`'s server, middleware and dev-server features or in build tooling: vite, rollup, h3, sharp/libvips, postcss and others. The deployed site is prerendered static files served as files, with no Astro server, middleware, image endpoint or dev server, so serving it does not use the affected code.
  - Upgrading astro is a separate maintenance change and is not part of this PR.
