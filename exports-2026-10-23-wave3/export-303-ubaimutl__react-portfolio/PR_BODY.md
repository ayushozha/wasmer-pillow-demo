<a href="https://wasmer.io/apps/create?github=ubaimutl%2Freact-portfolio"><img src="https://img.shields.io/badge/Deploy%20to-Wasmer-171717?style=for-the-badge&amp;logo=wasmer&amp;logoColor=white&amp;labelColor=171717" alt="Deploy to Wasmer" width="328" height="48"></a>

## Summary

Adds a "Deploy on Wasmer" section to the README, with a Deploy to Wasmer button, and a small `Anybuild` file (Wasmer's build config). No source file, `vite.config.js`, `package.json` or lockfile changes, so `npm run dev`, `npm run build` and `npm run deploy` (GitHub Pages) behave exactly as before.

Disclosure: I work at Wasmer. I prepared this change with help from Claude, an AI assistant, and reviewed and tested it before opening this PR.

## Why this repo

It is a popular, MIT-licensed portfolio template whose README already walks people through building it. A one-click import lets someone see the template on their own URL before customizing it.

Why the `Anybuild` file is needed: `vite.config.js` sets `base: "/react-portfolio/"` for GitHub Pages. Wasmer serves an app from the domain root, so with auto-detection the built `index.html` loads its script and stylesheet from `/react-portfolio/assets/...`, which return 404 there, and the page stays blank. The `Anybuild` file keeps the detected settings (Node 24, npm, Vite, output `dist`) and only changes the build command to `npm run build -- --base=/`, using Vite's own `--base` CLI option. The router already reads `import.meta.env.BASE_URL`, so it follows the same base. It also serves `index.html` for exactly `/about`, `/portfolio` and `/contact`, so those links work when opened directly or reloaded (GitHub Pages gets the same effect from the `404.html` copy in `predeploy`). There is no catch-all: other unknown paths still return 404.

The button opens Wasmer's import page for this public repository, where you review the detected build settings and click Deploy; it does not create a copy of the repository in your GitHub account. To customize the site and redeploy on changes, fork the repository and import your fork instead.

## Testing

All on base `ceb60ff0b3786a4be66841978906648d21808830` (`master`), with this patch applied:

- `anybuild plan --wasmer` (v0.33.0) with the committed `Anybuild`: static Node.js provider (Vite, npm 11, output `dist`), install `npm install`, build `npm run build -- --base=/`, start `static-web-server` with the generated rewrites config. Without the file it detects the same provider with build `npm run build`.
- Replayed the generated steps locally with Node 24.22.1 and npm 11.21.1: `npm install` exit 0 (229 packages), `npm run build -- --base=/` exit 0 (Vite 8.2.0), 5 files in `dist`. Served with a local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here).
- `curl`: `/`, `/about`, `/portfolio`, `/contact` and `/index.html` return 200 `text/html`; the built JS and CSS return 200 `text/javascript` and `text/css`; `/manifest.json` and `/robots.txt` return 200. `/does-not-exist`, `/about/`, `/react-portfolio/`, `/assets/nope.js` and `/package.json` return 404.
- Control: the same build without `--base=/` references `/react-portfolio/assets/...`, which returns 404 when served from the root.
- Headless Chromium against the local server: direct loads of all four routes render their page heading (About me, Portfolio, Contact Me), menu navigation works, reloading `/contact` returns 200, no page errors and no same-origin errors apart from the deliberate 404 probe.
- `npm run lint` exit 0.

No Wasmer deployment was made.

## Limitations

- Not deployed. The import page and badge image were not opened from the test environment.
- The contact form uses EmailJS with the placeholder IDs in `src/content_option.js` (`YOUR_SERVICE_ID`, `YOUR_TEMPLATE_ID`, `YOUR_USER_ID`); it reads no environment variables. With the placeholders, the rest of the site works and submitting the form shows the existing "Faild to send!" alert. To make it send, a user sets their own EmailJS IDs in a fork. Anything in this file ends up in the public JavaScript bundle, so only the EmailJS public key belongs there, never a private key.
- The site loads Google Fonts and demo images from picsum.photos and images.unsplash.com at runtime; these were blocked in the browser test and are unchanged by this PR.
- Only the four routes in `src/app/routes.jsx` are served as the app; a trailing-slash form such as `/about/` returns 404. If more routes are added, add them to `Anybuild` too.
- `npm install` reports 9 high-severity advisories in the existing dependency tree; this PR does not change dependencies.
- The last merged pull request was in September 2024, so I understand this may not be reviewed soon.
