Title: docs: add Wasmer Edge deploy option

## Description

Adds a short "🚀 Deploy" section to the README with a Deploy to Wasmer badge. The badge opens
`https://wasmer.io/apps/create?github=satnaing%2Fastro-paper`, the Wasmer Edge import page for this repository. README only; no code or config changes.

**Why this repository:** AstroPaper is a template that builds to a static `dist/` with no adapter, and the README has no deployment section yet. The badge lets someone try the theme on Wasmer in one click. The text also tells readers to import their own copy of the repository if they want to publish a customized blog, because the import page builds the repository you point it at and does not create a copy for you.

## Types of changes

- [ ] Bug Fix (non-breaking change which fixes an issue)
- [ ] New Feature (non-breaking change which adds functionality)
- [x] Documentation Update (if none of the other choices apply)
- [ ] Others (any other types not listed above)

## Checklist

- [x] I have read the [Contributing Guide](https://github.com/satnaing/astro-paper/blob/main/.github/CONTRIBUTING.md)
- [x] I have added the necessary documentation (if appropriate)
- [ ] Breaking Change (fix or feature that would cause existing functionality to not work as expected)

## Further comments

**Testing**
- At `35cfa7f`: `pnpm install --frozen-lockfile && pnpm run build` (pnpm 10.30.1, Node 24.16.0) exited 0. `astro check` reported 0 errors, 0 warnings and 0 hints across 55 files. Astro built 45 pages plus the OG images, and Pagefind indexed 17 pages.
- `prettier --check README.md` passes.
- Opening the import link shows the repository, the `main` branch and a static (`node-static`) build preset. I did not run a full deployment from it.

**Limitations**
- The build fetches Google Fonts at build time (Astro Fonts), so the Wasmer build needs network access to `fonts.google.com`.
- The build needs pnpm 10 or newer, because `pnpm-workspace.yaml` uses `allowBuilds`.
- Redeploy-on-push works only for a repository you connect to your own Wasmer app.

## Related Issue

None.
