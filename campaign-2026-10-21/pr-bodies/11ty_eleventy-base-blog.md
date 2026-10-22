Title: docs: add Wasmer Edge to "Deploy this to your own site"

## Summary

Adds one line to the "Deploy this to your own site" list: "Deploy this to **Wasmer Edge**" followed by a Deploy to Wasmer badge linking to `https://wasmer.io/apps/create?github=11ty%2Feleventy-base-blog`. It sits alongside the Netlify and Vercel entries. README only.

## Why this repository

eleventy-base-blog is the official Eleventy starter, and that README section exists to list one-click hosts. The build is plain static output in `_site/`, with no server runtime.

## Testing

- At `cf0cc1f` on Node 24.22.1, `npm ci && npm run build` passed (Eleventy v3.1.7, wrote 15 files).
- I served `_site/` locally. `/`, `/blog/`, `/blog/firstpost/`, `/about/`, `/tags/`, `/feed/feed.xml` and `/404.html` all returned 200, and every root-relative reference in the 13 HTML pages resolved.

## Limitations

- Opening the import link shows the repository, the `main` branch and a static (`node-static`) build preset, with Deploy enabled. The page does not show which output folder it will serve, so it has not been confirmed that `_site` is picked up. I did not run a deployment from it.
- The import page builds this repository and does not create a copy. To edit and redeploy, fork or use the template first, then import your own repository.
