Title: docs: add Wasmer Edge deploy option

## Summary

This adds a **Wasmer Edge** row to the Deployment host table in `README.md` and `README.zh-CN.md`. The row shows a visible **Deploy to Wasmer** badge linking to `https://wasmer.io/apps/create?github=ColorlibHQ%2Fgentelella`, the Wasmer Edge import page for this repository. Next to the badge, a short note says to keep the default `BASE_PATH=/` and to import your own fork if you want to customize the template and get redeploys on push. Only the README files change.

## Why this repository

The README already says Gentelella v4 is a "Static template — deploy `dist/` anywhere that serves files" with "No backend. No environment variables required". It also keeps a table of hosts with notes (Netlify / Vercel / Cloudflare Pages, GitHub Pages, S3, nginx, R2). `vite.config.js` writes to `dist/` with `base` defaulting to `/`, and since #1001 the build emits a root `index.html`, so a static host serves the dashboard from `/`. A Wasmer Edge row fits into that existing table.

## Testing

At base `02936f9` (master), Node v24.22.1 (`.nvmrc` = 24), npm 11.19.1:

- `npm ci`: exit 0
- `npm run build` (`NODE_ENV=production vite build`, Vite 8.3.0): exit 0, built in about 20s
- I served `dist/` with a local static server and got 200 for `/`, `/production/index.html`, `/production/calendar.html`, `/production/login.html`, `/production/page_404.html`, `/site.webmanifest` and `/sw.js`. Across 60 HTML files, all 35 root-relative refs and all 2,282 relative refs resolve to files.
- `git apply --check` of the patch against `02936f9`: clean.
- `prettier --check` on the READMEs fails on the unpatched base too, and the repo's `format` script only covers `src/`, so I did not reformat the READMEs.

I did not run a Wasmer deployment from the link.

## Limitations

- I have not deployed this to Wasmer. The import page builds the repository it is given. It does not copy the repository into the visitor's GitHub account, and redeploy on push only works for a repository the visitor connects themselves.
- Subpath deploys still need `BASE_PATH`, as the README already explains.
- The per-file cache headers from `scripts/deploy-preview.sh` (R2) are specific to that host and are not applied on Wasmer.
- The build needs no network access beyond the npm registry.
