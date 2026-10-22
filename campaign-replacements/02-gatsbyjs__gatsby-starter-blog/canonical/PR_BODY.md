## Description

Adds a "Quick start (Wasmer)" section to `starters/blog/README.md`, right after the existing "Quick start (Netlify)" section: a Deploy to Wasmer button plus one sentence on what Wasmer runs and one on what the button does. README only; no starter code, config or dependency changes.

This file is the source for the read-only `gatsbyjs/gatsby-starter-blog` mirror (the mirror's README blob `f272fcd` is identical to this file at `516700a`), so the change reaches the mirror through the normal starter sync.

What the section says, and why it's accurate:
- Wasmer's builder detects the starter as a static Gatsby site, runs `npm install` and `npm run build`, and serves the generated `public/` folder as static files.
- The button opens Wasmer's import page for the public `gatsbyjs/gatsby-starter-blog` repository, where the user reviews the configuration and clicks Deploy; it does not create a copy of the repository in their GitHub account. To customize, users fork the starter and import their own repository.

### Documentation

README-only change to the starter's own documentation.

### Tests

Replayed Wasmer's builder (Anybuild v0.33.0, the version Wasmer pins) locally on the starter's exact tree (`gatsbyjs/gatsby-starter-blog` @ `d75052245100…`, whose files match `starters/blog` here): `anybuild plan` → static Node.js provider, Gatsby, `npm install` / `npm run build`, output `public`; staged install with only `package.json` + `package-lock.json` as the builder does; Node 24.22.1; build exit 0; served with static-web-server 2.38.0: `/`, all three sample posts, and `/rss.xml` return 200, with every same-origin asset 200. No deployment was made.

## Related Issues

None.
