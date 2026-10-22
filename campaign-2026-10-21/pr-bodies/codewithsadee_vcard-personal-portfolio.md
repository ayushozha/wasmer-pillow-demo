Title: docs: add Wasmer Edge deploy option

## Summary

Adds a short "Deploy" section to the README, between "Installing vCard" and "Contact". It has one sentence telling readers to fork the repository and import their fork, followed by a "Deploy to Wasmer" badge linking to `https://wasmer.io/apps/create?github=codewithsadee%2Fvcard-personal-portfolio`. README only, no config files.

## Why this repository

vCard is a single-page portfolio made of `index.html` plus `assets/` (CSS, JS, images), with no `package.json` and no build step, so it can be served as-is from the repository root. The README currently stops at `git clone`, and people who use this template usually want to put their portfolio online next.

## Testing

- Base commit `927f09a6ef894a24cc8aef7a2e51f8e93ac306f7`. There is no build step.
- I served the repository root with Python's stdlib HTTP server. `/`, `/index.html`, `/assets/css/style.css`, `/assets/js/script.js` and `/assets/images/my-avatar.png` all returned 200.
- A scan of the 35 relative `href`/`src` references in `index.html` found every file. The one apparent miss, `./assets/images/icon-design.svg`, has a trailing newline inside the attribute, and the file exists.
- Running Wasmer's open-source build detector (anybuild 0.33.0) on a clean checkout picks the static-site provider and serves the repository root, with no config needed.

## Limitations

- I have not run a deployment. Wasmer's import page has not yet been checked in a browser for this repository.
- The import link builds this repository and does not copy it into the visitor's GitHub account. To customize the site and redeploy on push, fork it first and import your own repository.
- The contact form is UI only (`action="#"`; `script.js` only enables the submit button when the fields are valid). Nothing is sent anywhere, on Wasmer or any other static host.
- Ionicons and Google Fonts are loaded by the visitor's browser from their CDNs at runtime.
