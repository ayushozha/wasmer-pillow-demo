Title: docs: add Wasmer Edge deploy option

## Summary

Adds a short "🚀 Deploy" section before "📃 License" with a Deploy to Wasmer badge. The badge opens `https://wasmer.io/apps/create?github=TailGrids%2Fplay-tailwind`, the Wasmer Edge import page for this repository. It also adds a one-line `Staticfile` at the repository root:

```yaml
root: .
```

## Why this repository

Play is prebuilt HTML with the compiled Tailwind CSS committed in `src/css/tailwind.css`, so it can be served as-is from the repository root. The README has no hosting instructions yet.

**Why the `Staticfile` is needed:** `package.json` has `"main": "tailwind.config.js"` and no build or start script. Wasmer's project detector (Anybuild 0.33.0) turns `main` into a start command, so without the file it treats the repo as a Node app that runs `node tailwind.config.js`. That file isn't in the repository. A root `Staticfile` makes the detector use its static-site provider instead, serving the root with no build step. No existing files change.

## Testing

All at `05f872b`:
- I ran `anybuild plan` (Anybuild 0.33.0, built locally from wasmerio/shipit) on both trees:
  - without the `Staticfile`: provider `node`, start command `node tailwind.config.js`;
  - with it: provider `staticfile`, output directory `.`.
- I ran `anybuild build --builder=local` on the patched tree and served the resulting static bundle locally. `/`, `/about.html`, `/blog-grids.html`, `/404.html` and `/src/css/tailwind.css` all returned 200, and every root-relative reference in the 9 HTML pages resolved.
- A separate scan of relative `./` links checked 370 links and found 0 missing.

## Limitations

- I did not run a deployment from the import link.
- The sign-in, sign-up and contact forms are front-end only, with no backend; that is unchanged on any static host.
- The import page builds this repository and does not create a copy. To customize the site and redeploy on push, fork it and import your fork.
- The whole repository root is served, including `README.md` and `package.json`, as is usual for a root-served static template.
