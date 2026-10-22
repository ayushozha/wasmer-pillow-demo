Title: docs(readme): add Wasmer Edge deploy option

## Summary

This adds one bullet to the "📚 Documentation & Resources" list in `README.md`, right after the Deployment Guide link. The bullet shows a visible **Deploy to Wasmer** badge linking to `https://wasmer.io/apps/create?github=puikinsh%2FBootstrap-Admin-Template`, the Wasmer Edge import page for this repository. Its note gives the build command (`npm run build`) and the static output folder (`dist-modern/`), and says to import your own fork to customize the template and get redeploys on push. Only `README.md` changes.

## Why this repository

Metis is a static Vite multi-page admin template. `vite.config.js` builds `src-modern/` into `dist-modern/` with `base: './'`, and there is no server runtime. The README already links a Deployment Guide (`docs/deployment.md`) that covers static hosts (Netlify, Vercel, GitHub Pages, S3/CloudFront, Firebase). This adds a direct Wasmer Edge option next to that link, plus a one-line `Staticfile` at the repository root (`root: dist-modern`).

**Why the `Staticfile` is needed:** Wasmer's project detector (Anybuild 0.33.0, run locally with `anybuild plan`) recognizes the Vite build but assumes Vite's default `dist/`. The `Staticfile` points it at `dist-modern/` and keeps the `npm run build` step. I replayed Anybuild's planned `npm install` and `npm run build` in a clean directory and served `dist-modern/`: `/`, `/analytics.html`, `/calendar.html`, `/login.html`, `/404.html` and `/settings.html` all returned 200.

## Testing

At base `3ee4694` (master), Node v24.22.1 (`.nvmrc` = 24), npm 11.19.1:

- `npm ci`: exit 0
- `npm run build` (`vite build`): exit 0, built in about 9s, writing 30 HTML pages to `dist-modern/`
- I served `dist-modern/` with a local static server and got 200 for `/`, `/analytics.html`, `/calendar.html`, `/login.html`, `/404.html` and `/settings.html`. The pages use relative URLs (`base: './'`). A relative-ref scan checked 879 refs and found 0 missing files. It also flagged 28 Alpine.js bindings (`:src="user.avatar"`, `:href="result.url"`), which are not file paths.
- `prettier --check README.md` already fails on the unpatched base. Prettier's diff contains no changes on the added line.
- `git apply --check` of the patch against `3ee4694`: clean.

I did not run a Wasmer deployment from the link.

## Limitations

- I have not deployed this to Wasmer. The import page builds the repository it is given. It does not copy the repository into the visitor's GitHub account, and redeploy on push only works for a repository the visitor connects themselves.
- The output folder is `dist-modern/`, not the usual `dist/`. If Wasmer's import does not pick it up automatically, set the output directory to `dist-modern` in the import settings.
- The build needs no network access beyond the npm registry.
