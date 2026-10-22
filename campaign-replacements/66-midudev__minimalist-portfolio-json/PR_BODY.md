## Summary

Adds a short "Desplegar en Wasmer" section to the README, before "Comandos", with a Deploy to Wasmer button and two sentences (in Spanish, like the rest of the README) on what it does.

## Why this repo

This repo is meant to be used as a template: you edit `cv.json` and get a printable CV/portfolio. Many of the people who use it are learners who want their CV online quickly. The README explains how to create the project and run it locally, but not how to publish it. The build is a fully static Astro site (two prerendered pages, `/` and `/en/`), so Wasmer can serve it directly after `pnpm run build`.

## Testing

Local replay of what Wasmer's builder (Anybuild v0.33.0) generates for `02749efb52cae4e1628e5c2e971b9bfac855b8d9` with this change:
- Detection: static Node.js provider, framework Astro, pnpm, output `dist`.
- `pnpm install` (pnpm 10.34.7, Node 24.22.1): exit 0.
- `pnpm run build` (`astro check && astro build`): exit 0, 0 check errors, 2 pages.
- `dist/` served with static-web-server 2.38.0: `/` and `/en/` returned 200, and the favicon, fonts, photo and script returned 200.

## Limitations

- No deployment was made. The badge image and the Wasmer import page could not be checked from the test environment.
- The button opens Wasmer's import page for this public repository, where you review the configuration and click Deploy; it does not create a copy of the repository in your GitHub account. To publish your own CV, create a repository from this template, edit `cv.json`, and import that repository.
