## Summary

Adds a "Deploy on Wasmer" section after "Local Development". It contains a Deploy to Wasmer badge, one sentence on what Wasmer runs, and one sentence on what the button does. Wasmer has no Gemfile to work from here, so it runs `bundle init && bundle add jekyll -v 4.3.0` and `jekyll build`, then serves `_site`. The button deploys this repo as-is (no fork), so people should fork, edit `_config.yml` and import their fork. The section also notes that `jekyll-sitemap`/`jekyll-feed` are not run there. README only.

## Why this repo

Jekyll Now's whole pitch is "build a Jekyll blog without touching the command line": fork, rename, edit in the browser. Its only documented hosting path is GitHub Pages under `username.github.io`. Wasmer builds the same repository from source with no local Ruby, which fits that no-command-line workflow for people who want hosting other than GitHub Pages.

## Testing

Replayed the build that Wasmer's builder (Anybuild v0.33.0) generates, at commit `12cb8a2e97c3b63c4bc92d2a1ab050b35bf946b7` plus this README change:

- Detection: Jekyll provider (`_config.yml`, no Gemfile), output `_site`.
- Ruby 3.4.7: `bundle init && bundle add jekyll -v 4.3.0`, then `jekyll build`. Both exit 0.
- Served with static-web-server 2.38.0: `/`, `/about`, `/Hello-World/` and `/404.html` all return 200. `/style.css` and the images return 200.

## Limitations

- I did not create a Wasmer deployment. I also could not load the badge image or the Wasmer import page from my test environment.
- Only Jekyll is installed, so the `gems:` entries in `_config.yml` (`jekyll-sitemap`, `jekyll-feed`) are not loaded and `/feed.xml` and `/sitemap.xml` are not generated. The default config does not link to the feed (`rss:` is empty).
- The build uses Jekyll 4.3.0 rather than the GitHub Pages gem set. With the default content the output looked the same, apart from Sass `@import` deprecation warnings.
