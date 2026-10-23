Title: docs: add Wasmer Edge deploy option

<a href="https://wasmer.io/apps/create?github=rohitg00%2Fk8sgames"><img src="https://img.shields.io/badge/Deploy%20to-Wasmer-171717?style=for-the-badge&amp;logo=wasmer&amp;logoColor=white&amp;labelColor=171717" alt="Deploy to Wasmer" height="48"></a>

I work at Wasmer. Wasmer Edge is a cloud hosting platform powered by WebAssembly; it can host this repository’s static site. References: [Wasmer Edge docs](https://docs.wasmer.io/edge/), [Git deployments](https://docs.wasmer.io/edge/git/).

This change was prepared with AI assistance (Anthropic's Claude); the testing described below was run locally, and I did not deploy it to Wasmer.

## Summary

This adds a short "Host your own copy" subsection under Get Started, right after the local `python3 -m http.server` instructions. It has a "Deploy to Wasmer" badge linking to `https://wasmer.io/apps/create?github=rohitg00%2Fk8sgames`, and a few lines that say:

- fork first, then import your fork (swap the `rohitg00%2Fk8sgames` in the link for your fork);
- importing does not copy this repository into anyone's account, and only a repository you own and connect redeploys on push;
- there is still no build step, because the repository root is served as static files;
- `vercel.json` is read only by Vercel, so its cache headers and its user-agent redirect of AI and SEO crawlers to `robots.txt` don't apply on other hosts. `robots.txt` itself is still served.

The change touches README.md only. No code or config files change.

## Why this repository

K8s Games is a teaching tool, and the README already tells people to clone the folder and serve it themselves, with no install and no build. Teams, classes and workshops that want their own copy can host a fork, for example one with their own campaign levels in `js/data/CampaignLevels.js` or a translation. #42 was a community fork doing exactly that for Korean readers on GitHub Pages. K8s Draw share links are built from `window.location.origin`, so on a self-hosted copy they point at that copy.

## Testing

- Base commit: `af5dbc19b3a41dcb42822572dd766bdf225a1860`.
- There is no build or package manager, so there was nothing to install or build.
- Detection: I ran Anybuild 0.33.1's `anybuild plan` on clean checkouts of the base commit and of this branch. Both gave provider `staticfile`, serving the repository root, with no install or build step. No config file is added.
- Replay: I replayed the planned steps in a clean directory. `/`, `/index.html`, `/draw.html`, `/style.css`, two JS modules, `/og-image.png` and `/robots.txt` were present.
- Static server: I served the result with a native static-web-server 2.38.0 using Anybuild's flags.
  - `/`, `/index.html`, `/draw.html`, `/draw`, `/draw/`, `/style.css`, three JS modules, `/og-image.png` and `/robots.txt` returned 200.
  - An unknown path returned 404.
  - Native SWS 2.32.2 gave the same result for `/`, `/draw`, `/draw/`, `/draw.html` and `/style.css`. Wasmer runs the SWS 2.32.2 WebAssembly build, which I did not test.
- `/draw` without `vercel.json`: I served a directory holding only `index.html` and `draw.html`, with no page fallback. Both SWS versions returned `draw.html` for `/draw` and `/draw/`, and 404 for an unknown path. The default server maps an extensionless path to the matching `.html` file, so the in-game "K8s Draw" link and share links keep working without the Vercel rewrite.
- Browser: I loaded `/` and `/draw` in headless Chromium against that server.
  - Both pages loaded with HTTP 200 and created the WebGL canvas.
  - There were no page errors and no failed or 4xx requests for local files.
  - The sandbox blocks unpkg and the Tailwind CDN. Three.js 0.152.0 was served from the npm package of the same version, and Tailwind was stubbed, so styling was not exercised.

## Limitations

- I did not deploy to Wasmer. Only the local static serving above was tested.
- `vercel.json` is Vercel-specific. On Wasmer or any other generic static host:
  - its cache headers are not applied;
  - its user-agent redirect that sends AI and SEO crawlers to `robots.txt` is not applied. `robots.txt` is still served, so crawlers that honour it still see its rules, but other crawlers are not redirected.
- Redeploy-on-push needs your own fork connected.
- The whole repository root is served, so `README.md`, `LICENSE` and `vercel.json` are publicly reachable, as they are on Vercel today.
- The `og:url` and `og:image` meta tags still name k8sgames.com. Fork owners may want to change them.
- The game still loads Three.js (unpkg), Tailwind (Play CDN) and Google Fonts at runtime, and the menu fetches the star count from the GitHub API. The badge image is served by shields.io.
