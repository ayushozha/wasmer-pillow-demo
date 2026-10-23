<a href="https://wasmer.io/apps/create?github=barryclark%2Fjekyll-now"><img src="https://img.shields.io/badge/Deploy%20to-Wasmer-171717?style=for-the-badge&amp;logo=wasmer&amp;logoColor=white&amp;labelColor=171717" alt="Deploy to Wasmer" height="48"></a>

## Summary

This adds a short "Deploy on Wasmer" section to the README, after the local-development steps, with a Deploy to Wasmer badge. It changes only `README.md` (6 added lines) and no site code or configuration.

The button opens Wasmer's import page for this public repository, where you review the detected build settings and click Deploy; it does not create a copy of the repository in your GitHub account. To customize the site and redeploy on changes, fork the repository and import your fork instead.

Disclosure: I work at Wasmer. I prepared this change with help from Claude, an AI assistant, and reviewed and tested it before opening this PR.

## Why this repo

Jekyll Now is a fork-and-edit blog template, so a one-click way to see it running somewhere other than GitHub Pages fits how people already use it. The section is optional and sits next to the existing GitHub Pages instructions; it does not change them.

## Testing

Tested on commit `12cb8a2e97c3b63c4bc92d2a1ab050b35bf946b7` (master) with the README change applied:

- Wasmer's build planner (Anybuild v0.33.0) detects a Jekyll site. Because the repository has no `Gemfile`, the plan is `bundle init && bundle add jekyll -v 4.3.0`, then `jekyll build`, serving `_site`.
- Replayed those exact commands with Ruby 3.4.7 and no locale variables set: install exit 0, `jekyll build` exit 0 (only warnings: Ruby 3.4 "Logger not initialized properly" and four Sass `@import` deprecation notices), 12 output files.
- The output was served with a local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here). `/`, `/about/`, `/Hello-World/`, `/404.html` and `/style.css` return 200. Every same-origin link and image in the built HTML returns 200 (`/about` redirects with 308 to `/about/`). Missing paths return 404 with the site's own `404.html` page.

## Limitations

- No deployment was made, and the import page and badge were not opened from the test environment.
- Only Jekyll is installed on Wasmer (there is no `Gemfile`), and Jekyll 4 reads plugins from `plugins:`, not the legacy `gems:` key in `_config.yml`. So `jekyll-feed` and `jekyll-sitemap` do not run, and `/feed.xml` and `/sitemap.xml` return 404, although every page links `/feed.xml` in its `<head>`. The README section says this. On GitHub Pages they still work.
- Google Analytics and Disqus are off by default (`google_analytics:` and `disqus:` are empty); if a user fills them in, those external services load from the visitor's browser and were not tested. The `html5shiv` script tag only applies to IE 8 and older.
- The last commit on `master` is from April 2018, so I understand this may not be reviewed. The README also asks contributors to start with an issue and to keep the project minimal; I am happy to open an issue first or close this if it does not fit.
