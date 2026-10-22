Title: docs: add Wasmer Edge deploy option

## Type of change

- [ ] Bug fix (a non-breaking change that fixes an issue)
- [ ] New feature (a non-breaking change that adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [x] Other (please describe): README documentation only

## Checklist

- [x] I have read the [**CONTRIBUTING**](https://github.com/CuteLeaf/Firefly/blob/master/CONTRIBUTING.md) document.
- [x] I have checked to ensure that this Pull Request is not for personal changes.
- [x] I have performed a self-review of my own code.
- [x] My changes generate no new warnings.

## Related Issue

None.

## Changes

Adds a **Deploy to Wasmer** badge next to the existing Vercel and Netlify buttons in the "平台托管部署" / "Platform Hosting Deployment" section of `README.md` and `README.en.md`. The badge links to `https://wasmer.io/apps/create?github=CuteLeaf%2FFirefly`, the Wasmer Edge import page for this repository. Under the buttons there is one line, in each README's language, saying that the button imports this repository for building and that people should import their own fork if they want to customize it and get redeploys on push. Only README files change. No code or config files are touched.

**Why this repository:** Firefly's default build is a fully static Astro site. `astro.config.mjs` only turns on the Cloudflare adapter when `CF_WORKERS` is set, and the build log reports `output: "static"`. The README already lists one-click deploy buttons and the settings to use (`pnpm run build`, output `dist`), so a Wasmer button fits there next to Vercel and Netlify.

## How To Test

At base `91cbbef` (master), Node v24.22.1, pnpm 11.22.0 (matches `packageManager`):

- `pnpm install --frozen-lockfile`: exit 0
- `pnpm run build` (the full upstream script: github-card data, LQIPs, VNDB covers, `astro build`, font subsetting, inline-script minify, Pagefind): exit 0. Astro built 40 pages, and Pagefind indexed 18 pages.
- I served `dist/` with a local static server and got 200 for `/`, `/about/`, `/archive/`, `/posts/code-examples/`, `/404.html`, `/rss.xml`, `/pagefind/pagefind.js` and `/sitemap-index.xml`. I checked 116 root-relative refs across 40 HTML files. The only unresolved one is `/404/`. It is the `Astro.redirect("/404/")` target that pages for disabled features (bangumi, vndb, etc.) point to, and it behaves the same on every static host.
- `git apply --check` of the patch against `91cbbef`: clean.

I did not run a Wasmer deployment from the link.

## Additional Notes

Limitations:
- I have not deployed this to Wasmer. The import page builds whatever repository it is given. It does not create a copy in the visitor's GitHub account, and redeploy on push only works for a repository the visitor connects themselves.
- The build fetches data over the network: the Fontsource API (`api.fontsource.org`, Astro Fonts) and the GitHub API (github-card refresh). My sandbox blocked both. The build still exited 0, but the fonts were not embedded and the github card data came from the committed cache, so a host with normal network access will produce the full output.
- Host-specific files such as `vercel.json` (security and cache headers) and `wrangler.jsonc` are not applied on Wasmer.
- The engines field needs Node >= 22.23.0, and the build uses pnpm 11.
