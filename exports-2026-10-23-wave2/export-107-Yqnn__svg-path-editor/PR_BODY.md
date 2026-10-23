<a href="https://wasmer.io/apps/create?github=Yqnn%2Fsvg-path-editor"><img src="https://img.shields.io/badge/Deploy%20to-Wasmer-171717?style=for-the-badge&amp;logo=wasmer&amp;logoColor=white&amp;labelColor=171717" alt="Deploy to Wasmer" width="328" height="48"></a>

## Summary

Adds a short "Deploy on Wasmer" section to the README, after "Running unit tests", with a Deploy to Wasmer badge and one sentence on what the deployment does. No application code, build configuration or dependency changes.

Disclosure: I work at Wasmer. I prepared this change with help from Claude, an AI assistant, and reviewed and tested it before opening this PR.

The button opens Wasmer's import page for this public repository, where you review the detected build settings and click Deploy; it does not create a copy of the repository in your GitHub account. To customize the site and redeploy on changes, fork the repository and import your fork instead.

## Why this repo

SVG Path Editor is a single-page Angular app that builds to plain static files (`dist/svg-path-editor`) and has no router, so it can be served by a plain static file server. Shared links put the path in the URL fragment (`/#P=...`), which never reaches the server, so they need no rewrite configuration. The README already documents `npm install` and `npm run build`; the new section reuses those same commands.

## Testing

Local replay of what Wasmer's builder (Anybuild v0.33.0) generates for `937d75a83b6be2bdda11d02b9b3594841315223a` (current `master`) with this change applied:

- Detection: static Node.js provider, framework Angular, package manager npm, output directory `dist/svg-path-editor`.
- `npm install` (Node 24.22.1, npm 11.21.1) exited 0.
- `npm run build` exited 0 and produced 29 files.
- The output was served with a local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here).
- `/` and `/index.html` returned 200 with the title "SvgPathEditor". All 29 built files returned 200 with the expected content types (JS, CSS, PNG/SVG icons, `manifest.webmanifest`, `ngsw.json` and the service worker scripts). `/nope` returned 404.
- In headless Chromium (Playwright 1.56.1), with every request outside the local server blocked: `/` rendered the editor canvas with the default path (23 command rows); replacing the path text with `M 0 0 L 10 10 L 20 0 Z` updated the canvas and the command list (4 rows); a fresh load of `/#P=M_0_0_L_10_10_L_20_0_Z` imported that path. No page errors other than the blocked third-party requests.

## Limitations

- No deployment was made. The import page and the badge image were not opened from the test environment.
- Analytics: `src/index.html` contains the Google Analytics tag `G-1BBJSPSKQ9` (`gtag('config', 'G-1BBJSPSKQ9')`), and the built `index.html` keeps it. A copy deployed with this button would therefore report page views to the same Google Analytics property as the upstream site unless the deployer removes or replaces the tag. This PR does not change it; you may prefer to keep it, make it configurable, or not merge the button while it is there.
- External services: the page loads Roboto and Material Icons from fonts.gstatic.com and the gtag script from www.googletagmanager.com. In the browser test these were blocked: the editor still rendered and edited paths, but the Material Icons buttons showed their ligature names as text instead of icons, so icon rendering depends on fonts.gstatic.com being reachable (as on the upstream site). Angular inlines the Google Fonts CSS at build time, so the build itself fetches fonts.googleapis.com.
- The service worker (PWA) was disabled in the browser test and was not exercised.
- Dependency advisories (exact `package-lock.json`, `npm audit`): 5 critical and 73 high packages overall. None of the criticals ships to the browser; they are dev and build tooling, absent from the production bundle. The production bundle does include @angular/common, @angular/core and @angular/service-worker 17.3.12, which carry 12 high advisories (XSRF, date formatting, i18n, hydration, SSR transfer cache and SVG attribute handling). I checked each against the app's inputs (typed or pasted path, the `#P=` share link, a local image file) and found none reachable by another party. One SVG URL binding (`<svg:image [attr.xlink:href]>` for a user-uploaded image) is not sanitized, but only the user's own local file reaches it. Upgrading Angular would clear these; this PR does not change dependencies.
