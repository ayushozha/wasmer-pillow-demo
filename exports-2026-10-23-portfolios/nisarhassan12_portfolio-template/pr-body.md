Title: add a Wasmer Edge deploy section to the README

<a href="https://wasmer.io/apps/create?github=nisarhassan12%2Fportfolio-template"><img src="https://img.shields.io/badge/Deploy%20to-Wasmer-171717?style=for-the-badge&amp;logo=wasmer&amp;logoColor=white&amp;labelColor=171717" alt="Deploy to Wasmer" width="328" height="48"></a>

I work at Wasmer. Wasmer Edge is a cloud hosting platform powered by WebAssembly; it can host this repository’s static site. References: [Wasmer Edge docs](https://docs.wasmer.io/edge/), [Git deployments](https://docs.wasmer.io/edge/git/).

This change was prepared with AI assistance (Anthropic's Claude); the testing described below was run locally, and I did not deploy it to Wasmer.

## Summary

- Adds a short **Deploy** section, with a Deploy to Wasmer badge, at the end of the README, after "Editing the Template".
- It tells people to fork the repository (or push their edited copy) to their own GitHub account and then import **their own** repository. The badge imports this original repository; it does not create a copy in their account.
- It reminds users that "Get in Touch" is a `mailto:` link (replace `you@example.com`), and that the footer's GitHub watch button loads from ghbtns.com (the README's Footer section already says to remove it).

README only. No HTML, CSS, JS, licence or credit changes, and no config files. The site is plain HTML, CSS and JavaScript, so nothing needs to be built.

## Why this repository

The README presents the project as "A beautiful minimal and accessible portfolio template for Developers". Its **Getting Started** and **Editing the Template** sections tell people to clone or download it and then "Go to `index.html` and fill your information." It does not cover where to host the edited site; the only hosting reference is the live demo link (portfolio-template.surge.sh). This section adds one documented way to put a personalised copy online. The README says "Contributions are warmly welcomed".

## Testing

All at base `f3ed88590be4f2b68ef952430d42cb3b0476b745` and the patched commit:

- **Anybuild 0.33.1 `plan`**, on clean worktrees: BASE and PATCHED both plan the static site provider (`staticfile`) at the repository root, with no install or build step. No `Staticfile` or other config is needed.
- **Replay of the planned steps:** the copied root is served; no build.
- **static-web-server 2.32.2 and 2.38.0** (native builds):
  - `/` and `/index.html` return 200 `text/html`.
  - `/index.css` returns 200 `text/css`, and `/index.js` returns 200 `text/javascript`.
  - The fonts return 200: `/fonts/HKGrotesk-Regular.woff` (`application/font-woff`) and `/fonts/Jost-Regular.ttf` (`font/ttf`).
  - The images return 200 (`image/jpeg`, `image/png`, `image/svg+xml`, `image/gif`).
  - A missing path returns 404.
- **Headless Chromium 141**, against native SWS 2.32.2:
  - The page renders with 0 failed local requests, 0 broken images (18 images), and 0 console or page errors.
  - Both local fonts (Hk Grotesk, Jost) load.
  - The only failed request was the external ghbtns.com iframe, which my test sandbox blocks.
  - A relative-link scan found 20 references and 0 missing.

## Limitations

- I did not deploy this to Wasmer. The serving tests used native static-web-server builds, not Wasmer's WebAssembly build of static-web-server (2.32.2).
- There is no contact form; "Get in Touch" opens the visitor's mail client via `mailto:`.
- The footer's GitHub watch button is an external iframe (ghbtns.com).
- The static root is the repository root, so `README.md`, `LICENSE.md` and `images/portfolio.gif` (about 6 MB) are also served. They are already public in the repo.
