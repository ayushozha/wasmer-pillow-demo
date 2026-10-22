Title: docs: add Wasmer Edge deploy option

## Summary

This adds a visible **Deploy to Wasmer** badge in the Quick Start section of `README.md` and `README.zh-CN.md`, right after the existing Vercel and Netlify buttons. The badge links to `https://wasmer.io/apps/create?github=moeyua%2Fastro-theme-typography`, the Wasmer Edge import page for this repository. Under the buttons there is one line, in each README's language, saying that the button imports this repository and that people should import their own fork to publish their own blog and get redeploys on push. Only README files change.

## Why this repository

Typography is a static Astro blog theme. `astro.config.ts` sets `base: '/'` and no adapter, and `astro build` writes plain HTML to `dist/`. The Quick Start already walks readers through forking the repository and importing it with a hosting button, so a Wasmer button fits in that same list.

## Testing

At base `162ca9c` (main), Node v24.22.1, pnpm 10.13.1 (matches `packageManager`):

- `pnpm install --frozen-lockfile`: exit 0
- `pnpm run build` (`astro check && astro build`): exit 0. `astro check` reported 0 errors and 0 warnings across 41 files, and Astro built 9 pages.
- I served `dist/` with a local static server and got 200 for `/`, `/about/`, `/archive/`, `/posts/hometown/`, `/categories/Articles/`, `/atom.xml` and `/sitemap-index.xml`. All 17 root-relative refs resolve.
- `eslint README.md README.zh-CN.md` (the repo's `@antfu/eslint-config` with `formatters: true`): exit 0.
- I made the commit with the repo's `simple-git-hooks` pre-commit hook installed. `pnpm lint-staged` (`eslint --fix`) ran and changed nothing.
- `git apply --check` of the patch against `162ca9c`: clean.

I did not run a Wasmer deployment from the link.

## Limitations

- I have not deployed this to Wasmer. The import page builds the repository it is given. It does not copy the repository into the visitor's GitHub account, and redeploy on push only works for a repository the visitor connects themselves.
- The build produces no custom `404.html`.
