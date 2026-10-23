<a href="https://wasmer.io/apps/create?github=barryclark%2Fjekyll-now"><img src="https://img.shields.io/badge/Deploy%20to-Wasmer-171717?style=for-the-badge&amp;logo=wasmer&amp;logoColor=white&amp;labelColor=171717" alt="Deploy to Wasmer" width="328" height="48"></a>

## Summary

This adds a short "Deploy on Wasmer" section to the README, after the local-development steps. It also adds an `Anybuild` file, Wasmer's build and serve configuration. No theme, layout or `_config.yml` changes.

The repository has no `Gemfile`, so Wasmer's builder installs only Jekyll. Jekyll 4 also ignores the legacy `gems:` key in `_config.yml`. Without this file, `jekyll-feed` and `jekyll-sitemap` would not run, and `/feed.xml` (linked from every page) and `/sitemap.xml` would return 404.

The `Anybuild` file keeps the detected install (Ruby 3.4.7, Jekyll 4.3.0) and the `_site` output. It changes only the build command to `bundle add jekyll-feed jekyll-sitemap --group jekyll_plugins && jekyll build`. Jekyll then loads the Gemfile's `jekyll_plugins` group itself, so the plugins listed in `_config.yml` run.

Disclosure: I work at Wasmer. I prepared this change with help from Claude, an AI assistant, and reviewed and tested it before opening this PR.

The button opens Wasmer's import page for this public repository, where you review the detected build settings and click Deploy; it does not create a copy of the repository in your GitHub account. To customize the site and redeploy on changes, fork the repository and import your fork instead.

## Why this repo

Jekyll Now is a fork-and-edit blog template, so a one-click way to see it running somewhere other than GitHub Pages fits how people already use it. The section is optional and sits next to the existing GitHub Pages instructions; it does not change them.

## Testing

I tested on commit `12cb8a2e97c3b63c4bc92d2a1ab050b35bf946b7` (master) with this change applied, replaying the steps Wasmer's builder (Anybuild v0.33.0) plans from the committed file. I used Ruby 3.4.7 with no locale variables set.

Build:
- Install: `bundle init && bundle add jekyll -v 4.3.0`, exit 0.
- Build: `bundle add jekyll-feed jekyll-sitemap --group jekyll_plugins && jekyll build`, exit 0. It installed jekyll-feed 0.18.0 and jekyll-sitemap 1.4.0, with only Ruby 3.4 and Sass deprecation warnings, and produced 16 files.

Serving, with a local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here):
- All 16 built files return 200.
- `/feed.xml` returns a well-formed Atom feed with the sample post.
- `/sitemap.xml` returns a well-formed urlset with `/`, `/about/` and `/Hello-World/`.
- The `/feed.xml` link in every page's `<head>` now resolves.
- `/`, `/about/` and `/Hello-World/` return 200, and `/about` redirects with 308 to `/about/`.
- Missing paths return 404 with the site's own `404.html`.

Using `bundle exec jekyll build` instead fails on Ruby 3.4. Jekyll 4.3.0 requires `csv`, which Ruby 3.4 no longer ships as a default gem, and it is not in the generated Gemfile. That is why the build runs plain `jekyll build`, as Wasmer does by default.

## Limitations

- No deployment was made, and the import page and badge were not opened from the test environment.
- The plugin versions are resolved at build time; there is no `Gemfile.lock`, as today.
- `url:` in `_config.yml` is empty by default, so the feed and sitemap contain site-relative URLs. Set `url:` to your domain for absolute links, as with any Jekyll site.
- Jekyll copies the `Anybuild` file into `_site`, so it is also served (as `application/octet-stream`). It contains only build settings.
- Google Analytics and Disqus are off by default (`google_analytics:` and `disqus:` are empty). If a user fills them in, those external services load from the visitor's browser; that was not tested.
- The last commit on `master` is from April 2018, so I understand this may not be reviewed soon.
