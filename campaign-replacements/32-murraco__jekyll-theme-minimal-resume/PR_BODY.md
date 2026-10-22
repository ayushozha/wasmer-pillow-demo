## Summary

Adds a short "Deploy on Wasmer" section to the README, just before "Settings": a Deploy to Wasmer badge, one sentence on what Wasmer builds (Jekyll provider: `bundle install` from the committed `Gemfile.lock`, `jekyll build`, serve `_site`), a note that Gulp is not run there so the compiled `assets/` must be committed, and one sentence saying the button deploys this demo as-is (no fork), so people should fork, edit `_config.yml`/`_data/` and import their own fork. README only, no code or config changes.

## Why this repo

Minimal Resume is used by people who want a one-page resume site and often don't want to install Ruby and Node locally. The README already says "Deploys to GitHub Pages, Netlify, or any static host", and the live demo runs on Netlify. Because the compiled CSS/JS in `assets/` is committed and `Gemfile.lock` pins `github-pages`, the repo builds from source on Wasmer with no extra configuration. The button gives people another one-click way to preview the theme from source.

## Testing

Replayed the build that Wasmer's builder (Anybuild v0.33.0) generates for this repo, at commit `21f924a4671a24c8ea03b34ae0bcc35066d96a86` plus this README change:

- Detection: Jekyll provider (`_config.yml` + `Gemfile`), output `_site`. Anybuild picks Jekyll over the Node/Gulp setup, so `npm run build` is not run.
- Ruby 3.4.7 (Anybuild's default): `bundle install` (Gemfile.lock: github-pages, jekyll 3.10.0), then `jekyll build`. Both exit 0.
- Served `_site` with static-web-server 2.38.0: `/` 200 (title "Mauricio Urraco"), `/assets/css/main.css` 200, plus favicon, `particles.min.js`, `sweet-scroll.min.js` and `main.js` 200. Unknown paths return 404.

## Limitations

- I did not create a Wasmer deployment. I also could not load the badge image or the Wasmer import page from my test environment.
- Gulp is not run on Wasmer. A change to `src/` only shows up after `npm run build` and committing `assets/`. This is the same as GitHub Pages today.
- The repo has no `404.html`, so unknown paths get the server's default 404.
- With the current `exclude` list, Jekyll also copies root files such as `README.md`, `Dockerfile` and `Gemfile.lock` into `_site`. This happens on any host, not only Wasmer.
