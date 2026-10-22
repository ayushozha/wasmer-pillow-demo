Title: docs: add Wasmer Edge deploy option

## Type of change

- [ ] Bug fix (a non-breaking change that fixes an issue)
- [ ] New feature (a non-breaking change that adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [x] Other (please describe): README documentation only

## Checklist

- [x] I have read the [**CONTRIBUTING**](https://github.com/saicaca/fuwari/blob/main/CONTRIBUTING.md) document.
- [x] I have checked to ensure that this Pull Request is not for personal changes.
- [x] I have performed a self-review of my own code.
- [x] My changes generate no new warnings.

## Related Issue

None.

## Changes

**Summary:** Getting Started step 5 now has a sub-bullet for Wasmer Edge. It shows the import URL pattern for your own repository (`https://wasmer.io/apps/create?github=<owner>%2F<repo>`) and a Deploy to Wasmer badge for trying this template directly. One line, README only.

**Why this repository:** Fuwari is a template, and its deploy step points to generic host guides. The build produces a fully static `dist/` with Pagefind search, which a static host can serve without changes. Most readers deploy their own generated repository, so the sub-bullet leads with the `<owner>/<repo>` form.

## How To Test

At `6d39b0d`, `pnpm install --frozen-lockfile && pnpm run build` with the pinned `pnpm@9.14.4`:
- passed on Node 22.22.0;
- passed on Node 24.22.1;
- passed on a second Node 24.22.1 run.

I served `dist/` with a local static server. `/`, `/archive/`, `/about/`, `/posts/expressive-code/`, `/pagefind/pagefind.js` and `/rss.xml` all returned 200, and every root-relative `href`/`src` in the 8 HTML pages resolved to a file.

One earlier attempt failed once, with Tailwind reporting that the `link` class does not exist in `src/styles/markdown.css`. It was running alongside other builds and its install had hit a registry 503 retry. The failure did not reproduce in the three runs above.

## Screenshots (if applicable)

N/A

## Additional Notes

- Opening the import link shows the repository, the `main` branch and a static (`node-static`) build preset, with Deploy enabled. I did not run a deployment from it.
- The `site` setting in `astro.config.mjs` still has to be set before deploying, as the README already says.
- The import page builds the repository given in the URL and does not create a copy. Redeploy-on-push needs your own repository connected to your Wasmer app.
