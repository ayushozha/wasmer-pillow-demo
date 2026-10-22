Title: docs: add Wasmer Edge to deployment options

## Summary

Adds Wasmer Edge to the README's Deployment list, in the same one-line format as the other hosts, with a Deploy to Wasmer badge as the link. The badge opens `https://wasmer.io/apps/create?github=RyanFitzgerald%2Fdevportfolio`, the Wasmer Edge import page for this repository. README only.

## Why this repository

The Deployment section is already a list of static hosts, and the template builds to a static `dist/` with no adapter or base path, so it can be served as-is. The line also tells readers to import their own copy to deploy their customized portfolio. The import page builds the repository you link to and does not create a copy for you.

## Testing

- At `852d650` on Node 24.22.1, `npm ci && npm run build` passed.
- I served `dist/` locally. `/` returned 200 with the expected page title, `/favicon.svg` returned 200, and every root-relative asset reference in the built HTML resolved.

## Limitations

- Opening the import link shows the repository, the `master` branch and a static (`node-static`) build preset, with Deploy enabled. I did not run a deployment from it.
- Redeploy-on-push works only for a repository you connect to your own Wasmer app.
