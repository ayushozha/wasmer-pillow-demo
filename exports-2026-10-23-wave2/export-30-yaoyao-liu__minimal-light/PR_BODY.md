<a href="https://wasmer.io/apps/create?github=yaoyao-liu%2Fminimal-light"><img src="https://img.shields.io/badge/Deploy%20to-Wasmer-171717?style=for-the-badge&amp;logo=wasmer&amp;logoColor=white&amp;labelColor=171717" alt="Deploy to Wasmer" width="328" height="48"></a>

## Summary

This adds a "Deploying on Wasmer" subsection to the English README, between "Using Locally with Jekyll" and "Using the HTML version", with a Deploy to Wasmer badge. It changes only `README.md` (6 added lines) and no theme code or configuration.

The button opens Wasmer's import page for this public repository, where you review the detected build settings and click Deploy; it does not create a copy of the repository in your GitHub account. To customize the site and redeploy on changes, fork the repository and import your fork instead.

Disclosure: I work at Wasmer. I prepared this change with help from Claude, an AI assistant, and reviewed and tested it before opening this PR.

## Why this repo

Minimal Light is a personal-homepage template that people fork and edit, and the README already covers GitHub Pages and building `_site` locally. This adds one more hosting option next to those, without changing them.

## Testing

Tested on commit `dd114c3fef2d97adc1c6b6d46901e0d96ab83a7c` (main) with the README change applied:

- Wasmer's build planner (Anybuild v0.33.0) detects a Jekyll site from `_config.yml` and the `Gemfile`; the plan is `bundle install`, then `jekyll build`, serving `_site`.
- Replayed those exact commands with Ruby 3.4.7 and no locale variables set: `bundle install` exit 0 (27 gems; the Gemfile resolves to jekyll 3.8.7 and webrick 1.9.2), `jekyll build` exit 0 (one Ruby 3.4 warning: "Logger not initialized properly"), 16 output files.
- The output was served with a local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here). `/` returns 200, and all 11 same-origin assets in the built page (CSS, JS, images, the CV PDF) return 200 with the expected content types. Missing paths return 404.

## Limitations

- No deployment was made, and the import page and badge were not opened from the test environment.
- The repository has no `Gemfile.lock`, so gem versions are resolved at build time (jekyll stays on 3.8.x because of `~> 3.8.5`).
- The default `_config.yml` sets `google_analytics: UA-111540567-4`, so a deployment of the unmodified example loads Google Analytics with that ID until a user removes it (the config comment already says to). Font Awesome loads from cdnjs. These external services were not tested.
- Routes: the site is a single page at `/` plus its assets; there are no other pages or client-side routes. The site has no `404.html`, so missing paths (including `/feed.xml` and `/sitemap.xml`, which this theme does not generate) get the server's generic 404 page.
- `remote_theme:` only applies on GitHub Pages; plain `jekyll build` ignores it and uses the local `_layouts`, which is what was tested.
- I could not find merged pull requests in the history (the maintainer commits directly), so I understand this may not be merged; happy to close it if it does not fit.
