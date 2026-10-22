Title: docs: add Wasmer Edge deploy option

## Summary

Adds a short "Deploy" section to the README, between "Templates" and "Contributing". It has one sentence telling readers to fork the repository and import their fork, followed by a "Deploy to Wasmer" badge linking to `https://wasmer.io/apps/create?github=BulmaTemplates%2Fbulma-templates`. README only, no config files.

## Why this repository

The gallery (`index.html`, `index.css`) and the 35 templates in `templates/` are plain HTML/CSS/JS with no `package.json` and no build step. The demo site on GitHub Pages serves the repository root as-is, so any static host can serve it the same way. People who fork the collection to adapt a template can use the section to publish their copy.

## Testing

- Base commit `188672e66bccc5e2e946440ebc6214d600860969`. There is no build step.
- I served the repository root with Python's stdlib HTTP server. `/`, `/templates/landing.html`, `/templates/admin.html`, `/templates/login.html`, `/css/admin.css` and `/index.css` all returned 200.
- I also served the same files with static-web-server 2.38.0, the server that Wasmer's builder plans. All of those routes returned 200, and an unknown path returned 404.
- Link checks. I checked 3 root-relative references (2 misses) and 221 relative `href`/`src` references (22 flagged). None of the misses is caused by the host, and they are the same on GitHub Pages:
  - The 2 root-relative misses are placeholder links in the demo templates: `/documentation/overview/start/` in `tabs.html` and `band.html`, and `/register` in `loginPage.html`.
  - Of the 22 relative flags, most come from `templates/personal.html`, which links to `templates/*.html` from inside `templates/`. The rest are missing favicons and images in a few templates, plus two JS template strings (`card.avatar`, `card.image`).
- I ran Wasmer's open-source build detector (anybuild 0.33.0) on a clean checkout of the patched commit. It picks the static-site provider (`staticfile`) and serves the repository root, with no install or build step.

## Limitations

- I have not run a deployment. Wasmer's import page has not yet been checked in a browser for this repository.
- The import link builds this repository and does not copy it into the visitor's GitHub account. To customize the site and redeploy on push, fork it first and import your own repository.
- The login, register, contact, inbox and search templates are UI only. Nothing is submitted anywhere, and there is no auth. `templates/loginPage.html` posts to `/login`, which does not exist on any static host.
- Bulma, Font Awesome, Google Fonts and the demo images (unpkg, cdnjs, pexels, picsum and others) are loaded by the visitor's browser from their CDNs at runtime.
