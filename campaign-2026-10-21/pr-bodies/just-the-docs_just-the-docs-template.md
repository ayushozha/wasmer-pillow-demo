Title: docs: add Wasmer Edge deploy option

I work at Wasmer. Wasmer Edge is a cloud hosting platform powered by WebAssembly; it can host this repository’s generated static site. References: [Wasmer Edge docs](https://docs.wasmer.io/edge/), [Git deployments](https://docs.wasmer.io/edge/git/).

## Summary

This adds a visible **Deploy to Wasmer** badge to the existing "Publishing your built site on a different platform" section of the README. The badge links to `https://wasmer.io/apps/create?github=just-the-docs%2Fjust-the-docs-template`. Next to it are two sentences of guidance:

- The button imports this public template repository. It does not create a copy in the visitor's GitHub account. To customize the site and redeploy on push, create your own repository from the template first and import that one.
- Set `url` in `_config.yml` to your own site's address. It currently points at `https://just-the-docs.github.io`.

Only `README.md` changes (+6 lines). No config files are added.

## Why this repository

- This is the official "use this template" starter for Just the Docs. The repository root is a complete Jekyll site: a `Gemfile` with a committed `Gemfile.lock` (Jekyll 4.4.1, `just-the-docs` 0.12.0), `_config.yml` and `index.md`.
- The README already says the site "can be built and previewed locally, and published on other platforms". It also has a section about publishing `_site` somewhere other than GitHub Pages, and that section only says to upload the files. The badge gives template users one concrete hosted option with a Git-based build, placed in that section.
- The site works when served from the root. `baseurl` is unset, so asset links are root-relative (`/assets/...`). The only absolute URLs come from `url`, which feeds the canonical, Open Graph and JSON-LD tags. That is why the new text names that setting.

## Testing

All runs used the base commit `d9e885a8bf281872759fbe061633e040772e76a1`, or the patched commit on top of it.

- **Normal build:** Ruby 3.3.6 and Bundler 4.0.18, with `BUNDLE_PATH=vendor/bundle` and `JEKYLL_ENV=production`. `bundle install` exited 0 and left `Gemfile.lock` unchanged. `bundle exec jekyll build` exited 0 and wrote `_site`. The only warnings were Dart Sass deprecation notices.
- **Static smoke check on `_site`:** `/`, `/assets/js/search-data.json`, `/assets/css/just-the-docs-default.css` and `/assets/js/just-the-docs.js` all returned 200. There were 0 missing root-relative refs and 0 missing relative refs.
- **Anybuild 0.33.0 `plan`:** ran on clean worktrees of both the base and the patched commit. Both gave the same result: provider `jekyll`, install `bundle install`, build `jekyll build`, static_dir `_site` (the default), with Ruby 3.4.7 and Jekyll 4.3.0 as the planned defaults.
- **Replay of the planned steps:** two replays ran on the patched commit. Both used Ruby 3.3.6, because Ruby 3.4.7 was not available here.
  - The first copied the whole source tree.
  - The second matched the builder's install step: only `Gemfile` and `Gemfile.lock` were present during `bundle install`, then the source was copied without `.git`, then `jekyll build` ran without `bundle exec`.

  In both replays, install and build exited 0.
- **static-web-server 2.38.0 with Anybuild's planned flags:** served the replay output. These all returned 200:
  - `/`, `/index.html`
  - `/assets/js/search-data.json` (the lunr search index)
  - `/assets/css/just-the-docs-default.css`, `/assets/css/just-the-docs-dark.css`
  - `/assets/js/just-the-docs.js`, `/assets/js/vendor/lunr.min.js`

  A missing path returned 404.

## Limitations

- No deployment was performed. The results above come from Anybuild's `plan` and local replays of its planned commands, not from Wasmer's hosted builder.
- Ruby version: Anybuild plans Ruby 3.4.7, but these builds ran on Ruby 3.3.6. Some gems that Jekyll 4.4 needs stop being default gems in Ruby 3.4, and `Gemfile.lock` already includes them (`csv`, `base64`, `bigdecimal`). Ruby 3.3.6 printed no warnings about them. A build on 3.4.7 itself was not run.
- The import link builds this public template repository. It does not create a copy in the visitor's account. To customize the site, or to redeploy on push, create your own repository from the template and import it.
- The build needs network access to rubygems.org. Nothing is fetched at runtime.
- The template has no `404.html`, so missing paths get the server's default 404 page. Jekyll also copies `README.md` and `LICENSE` into `_site`, because the config has no `exclude` list. This is the same as on GitHub Pages.
- `bundle-audit` reports advisories in build-time gems: `addressable` 2.8.7 (high), `concurrent-ruby` 1.3.5 (high and medium), `json` 2.9.1 (low) and `rexml` 3.4.0. These gems run only during `jekyll build` and are not part of the served static files.
