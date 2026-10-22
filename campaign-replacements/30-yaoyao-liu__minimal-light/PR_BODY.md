## Summary

Adds a short "Deploying on Wasmer" subsection under "Getting Started", between "Using Locally with Jekyll" and "Using the HTML version". It contains a Deploy to Wasmer badge, one sentence on what Wasmer runs (Jekyll: `bundle install`, `jekyll build`, serve `_site`), and one sentence explaining that the button opens Wasmer's import page for this template's example page (the user reviews the configuration and clicks Deploy; no GitHub copy is created). To get their own homepage, people fork or use the template, edit `_config.yml` and `index.md`, and import their own repository. README only.

## Why this repo

Minimal Light is used by researchers who want a one-page academic homepage. The README already lists two ways to publish it (GitHub Pages, or building locally with Jekyll and uploading `_site`), and the second needs a local Ruby setup. Wasmer builds the Jekyll source directly from a repository, so someone who has customised their copy can host it without installing Ruby. The repo builds there unchanged, using its own `Gemfile` (jekyll ~> 3.8.5, webrick).

## Testing

Replayed the build that Wasmer's builder (Anybuild v0.33.0) generates, at commit `dd114c3fef2d97adc1c6b6d46901e0d96ab83a7c` plus this README change:

- Detection: Jekyll provider (`_config.yml` + `Gemfile`), output `_site`.
- Ruby 3.4.7: `bundle install` (resolved jekyll 3.8.7, 27 gems), then `jekyll build`. Both exit 0.
- Served with a local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here): `/` 200 (title "Your Name | Your Affiliation"). All 11 referenced assets return 200, including the CSS, JS, images and `/assets/files/curriculum_vitae.pdf`.

## Limitations

- I did not create a Wasmer deployment. I also could not load the badge image or the Wasmer import page from my test environment.
- The deployed page is the template's placeholder content, not anyone's site. Users need to import their own edited repository.
- `remote_theme:` in `_config.yml` has no effect in this build because `jekyll-remote-theme` is not in the Gemfile. The local layouts are used, which is how a forked copy behaves anyway.
- There is no `404.html`, so unknown paths get the server's default 404.
