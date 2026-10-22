## Summary

Adds a short "部署到 Wasmer Deploy on Wasmer" section to the README, after "运行项目" and before "文档引导", with a Deploy to Wasmer button and two sentences on what it does.

## Why this repo

This template is a starting point for mobile H5 projects. People evaluating it usually want a running instance they can open on a phone before cloning. The build is plain Vite output with hash routing and `VITE_PUBLIC_PATH = "/"` in `.env.production`, so it runs on a static host at the domain root without rewrites or path changes. The README currently links only the GitHub Pages demo, and the Pages workflow has to rewrite the public path.

## Testing

Local replay of what Wasmer's builder (Anybuild v0.33.0) generates for `95816e6001f6039782166c4299e485884d73fab2` with this change:
- Detection: static Node.js provider, framework Vite, pnpm, output `dist`.
- `pnpm install` (pnpm 10.34.7, Node 24.22.1): exit 0.
- `pnpm run build` (`vite build` + `vue-tsc --noEmit`): exit 0.
- `dist/` served with static-web-server 2.38.0: `/`, `/#/tools`, `/#/about` returned 200, and all referenced JS/CSS assets returned 200.

## Limitations

- No deployment was made. The badge image and the Wasmer import page could not be checked from the test environment.
- Mock data is only available in the dev server, so the mock-API demo on the tools page does not return data on a static deployment (same as the GitHub Pages demo).
- The button opens Wasmer's import page for this public repository, where you review the configuration and click Deploy; it does not create a copy of the repository in your GitHub account. To customize, fork or use the template and import your own repository.
