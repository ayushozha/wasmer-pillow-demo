## Summary

Adds a short "Deploy on Wasmer" subsection under "Development" in the README, with a Deploy to Wasmer badge and two sentences. No code or config changes. The PR targets `main`, as the Contributing section asks.

## Why this repo

RegexLearn is a static Next.js export: the whole course, cheatsheet and playground run in the browser. Bootcamps, university courses and company onboarding programmes sometimes want the course on their own URL. Examples are an internal training portal, a pinned version for a semester, or a network where the public site is blocked. The README documents `npm run build` producing `out/`. A one-click deploy from source gives these users their own copy without a local Node setup.

## Testing

I replayed what Wasmer's builder (Anybuild v0.33.0) generates for `ab2419c23777017f83ec9ca75c2155bbca5bc0ca` with this change:

- Detection: static Node.js provider, framework Next.js (`output: 'export'`), npm, output directory `out`. Only `package.json` and `package-lock.json` were staged for install.
- `npm install` exited 0 on Node 24.22.1 with npm 11.21.1.
- `npm run build` exited 0. That is `next build` followed by `next-sitemap` and the html-lang fixer, producing 133 HTML pages.
- `out/` was served with a local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here).
- These returned 200: `/`, `/learn`, `/learn/regex101`, `/cheatsheet`, `/playground`, `/en`, `/en/learn`, `/tr`, `/tr/learn`, `/tr/cheatsheet`, `/sitemap.xml`, `/robots.txt` and every referenced `_next/static` chunk and image.

## Limitations

- No deployment was made. The badge image and the Wasmer import page could not be checked from the test environment.
- Extensionless URLs such as `/cheatsheet` resolved to `cheatsheet.html` on static-web-server 2.38.0. I did not check that Wasmer's hosted static server resolves them the same way.
- The `rewrites`/`redirects` in `next.config.js` do not apply to a static export, and `public/_headers` (CSP and similar) is not read by static-web-server. Both are the same on any plain static host.
- The production build includes the site's Google Tag Manager container, so a copy hosted elsewhere will load it too unless it is removed in a fork.
- The button opens Wasmer's import page for this public repository, where the user reviews the configuration and clicks Deploy; it does not create a copy of the repository in their GitHub account.
