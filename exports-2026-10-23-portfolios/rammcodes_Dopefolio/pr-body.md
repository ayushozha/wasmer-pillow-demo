Title: docs: add a Deploy to Wasmer option to the Deployment section

<a href="https://wasmer.io/apps/create?github=rammcodes%2FDopefolio"><img src="https://img.shields.io/badge/Deploy%20to-Wasmer-171717?style=for-the-badge&amp;logo=wasmer&amp;logoColor=white&amp;labelColor=171717" alt="Deploy to Wasmer" width="328" height="48"></a>

I work at Wasmer. Wasmer Edge is a cloud hosting platform powered by WebAssembly; it can host this repository’s static site. References: [Wasmer Edge docs](https://docs.wasmer.io/edge/), [Git deployments](https://docs.wasmer.io/edge/git/).

This change was prepared with AI assistance (Anthropic's Claude); the testing described below was run locally, and I did not deploy it to Wasmer.

## Summary

- Adds a short "Deploy to Wasmer" subsection, with a Deploy to Wasmer badge, to the README's existing **Deployment** section, right after the Netlify steps. The Netlify instructions are unchanged.
- Adds a one-line root `Staticfile` (`root: .`) so that Wasmer's builder serves the committed files (`index.html`, `project-*.html`, `css/style.css`, `index.js`, `assets/`) as they are, without running `npm install` or a build.
- The new text tells people to fork (or push their clone) first and import **their own** repository; the badge imports this original repository and does not create a copy in their account.
- The README note also says plainly that the contact form's `action="#"` is not configured, so submissions go nowhere until the user sets it up (for example with formspree.io, which the README already suggests), and that the Google Fonts stylesheet loads externally from fonts.googleapis.com.

No app code, styles, dependencies, licence or credits are changed.

## Why this repository

Dopefolio's README is about publishing your own copy of the template: "A Blazing Fast Multipage Portfolio Template for Developers", and its **Deployment** section says "Once you have done with your setup. You need to put your website online!", then walks through hosting "your Portfolio website ( Clone of Dopefolio )" with the publish directory set to `/`. This PR adds a second root-hosting option next to that guide.

Why the `Staticfile` is needed: without it, Wasmer's builder (Anybuild 0.33.1) treats the repo as a Node.js app because of `package.json`. It plans `npm install` → `npm run build` → start `node index.js`. On Node 24 (the builder default) `npm install` fails while building `node-sass` 6, and `index.js` is browser code (`node index.js` throws `ReferenceError: document is not defined`). With the `Staticfile`, the plan becomes the static site provider with root `.` and no install or build step. I checked that the committed `css/style.css` is complete: compiling `sass/main.scss` with the repo's node-sass (on Node 16) and compressing both files the same way gives the same 121 rule selectors. The only byte difference is `#fff` vs `white`.

## Testing

All at base `4734cb2c742ee9d849fdc5c1f05e1cbe13359a73` (BASE) and the patched commit (PATCHED):

- **Anybuild 0.33.1 `plan`**, on clean worktrees:
  - BASE: provider `node`, npm, install `npm install`, build `npm run build`, start `node index.js`.
  - PATCHED: provider `staticfile`, static_dir `.`, no install or build.
- **Replay of the planned steps** (Node 24.22.1, npm 11.19.1):
  - BASE: `npm install` fails (node-sass 6 / node-gyp).
  - PATCHED: no install or build; the copied root is served.
- **Upstream build, for reference:**
  - `npm ci` on Node 24.22.1 fails (node-sass 6).
  - On Node 16.20.2 / npm 8.19.4, `npm ci` and `npm run build` both succeed.
- **static-web-server 2.32.2 and 2.38.0** (native builds), serving the replay output:
  - `/`, `/index.html`, `/project-1.html`, `/project-2.html` and `/project-3.html` return 200 `text/html`.
  - `/css/style.css` returns 200 `text/css`, and `/index.js` returns 200 `text/javascript`.
  - The SVG, PNG and JPEG assets return 200 with `image/svg+xml`, `image/png` and `image/jpeg`.
  - A missing path returns 404.
- **Headless Chromium 141**, against native SWS 2.32.2:
  - `/` and `/project-1.html` to `/project-3.html` render with 0 failed local requests, 0 broken images, and 0 console or page errors.
  - `css/style.css` is applied, and the background SVG loads.
  - A relative-link scan found 84 references and 0 missing.
- **`npm audit --omit=dev`:** 0 vulnerabilities. The full audit's findings are all in the devDependency build tooling, which the `Staticfile` path does not install.

## Limitations

- I did not deploy this to Wasmer. The serving tests used native static-web-server builds, not Wasmer's WebAssembly build of static-web-server (2.32.2).
- The import page may show a different preset; in that case, choose the static site (staticfile) preset.
- Wasmer does not run `npm run build` (autoprefixer + minify). The committed, unminified `css/style.css` is served as is. Users who change the SASS need to run `npm run compile:scss` locally and commit `css/style.css`, as the README's styling steps already describe.
- The contact form is front-end only (`action="#"`). It sends nothing until the user connects a form service. Netlify Forms do not apply on other hosts.
- Google Fonts are loaded from fonts.googleapis.com / fonts.gstatic.com.
- The static root is the repository root, so repository files such as `README.md`, `package.json` and `sass/` are also served. They are already public in the repo.
- The stylesheet's `url(../../assets/...)` path assumes the site is served at the domain root, which is how it is served here and in the README's Netlify setup.
