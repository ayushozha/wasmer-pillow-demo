Title: docs: add Wasmer Edge deploy option

## Summary

Adds one paragraph to the README's "Usage" section, right after the existing "build the site locally, and copy the output to wherever you'd like to host the site" note. It gives Wasmer Edge as an alternative host to GitHub Pages, shows the import URL pattern for your own repository (`https://wasmer.io/apps/create?github=<owner>%2F<repo>`), and adds a Deploy to Wasmer badge for previewing this template. README-only; no config files, workflow or code changes. Credits and the CC BY-SA 4.0 attribution are unchanged.

## Why this repository

- The README already says the site can be built with `npm run build` into `./dist/` and hosted anywhere. This adds one concrete option.
- The site is fully static: `astro.config.ts` has no adapter or `output` setting and no `base`, and `src/pages/index.astro` prefixes public assets with `import.meta.env.BASE_URL`. A root-path host works without changes: the GitHub Pages workflow's `--site`/`--base` flags are only needed for project-page subpaths.

## Testing

- Base commit: `0e90d4f36bad6ee0af330964bdf0002fe451283d`
- Node v24.22.1 (README asks for Node 24+; the workflow uses Node 24), npm 11.19.1
- `npm ci` → exit 0
- `npm run build` (`astro check && astro build`, Astro 6.3.5) → exit 0; `astro check` 0 errors, 1 page built
- Served `dist/` with a local static server (base `/`) and requested `/`, `/favicon.svg`, `/BoxVertexColors.glb`, `/screenshot-light.png`: all 200. All 37 root-relative `href`/`src`/`srcset` references in the built HTML resolve to files in `dist/`, and there are no stray relative asset paths.
- `npx prettier --check README.md` → passes.

## Limitations

- No deployment to Wasmer was performed; only the local build and static serving above were tested.
- The link points at this template repository. It does not copy the repository into the visitor's GitHub account. Users should import their own copy (made with "Use this template") so their paper content gets deployed and pushes redeploy, which the README text says.
- The build needs network access: the Astro Fonts Google provider fetches `fonts.google.com` at build time. In my sandbox that host was blocked. The build still exited 0, but Noto Sans was not bundled and the page used fallback fonts. A normal build host with internet access should not hit this.
- Without `site` set (the GitHub Pages workflow passes `--site`), `og:image` stays root-relative (`/screenshot-light.png`). Users who want absolute social-preview URLs on Wasmer should set `site` in `astro.config.ts`.
