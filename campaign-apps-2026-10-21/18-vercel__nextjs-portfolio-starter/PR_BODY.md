## Summary

Adds a "Deploy to Wasmer" button under "Deploy your own", after the existing Vercel button, with two sentences on what it does. README-only; the Vercel button and all other text are unchanged.

## Why this repo

The starter is a Markdown portfolio with no backend, no database and no environment variables; its build script also generates the RSS feed (`node ./scripts/gen-rss.js && next build`). That makes it a good fit for a build-from-source deploy: the section says the button runs `yarn build` (so `public/feed.xml`, which is gitignored, is generated during the deploy) and points to the three places the README's Configuration list already tells people to edit (`theme.config.js`, `scripts/gen-rss.js`, `pages/posts/*.md`) for anyone who forks to redeploy on push.

## Testing

At `90cfee0f74c25bb3688369a0587e435f8b8f114d` (main), Linux x64, Node 22.22.0, Yarn 1.22.22:

- `yarn install --frozen-lockfile` - exit 0 (only warning: "Workspaces can only be enabled in private projects")
- `yarn build` - exit 0 (`gen-rss.js` then Next.js 13.5.6; 8 static pages)
- `yarn start -p 3311` - `/` 200 (`<title>About</title>`), `/posts/markdown` 200 with `<h1>Markdown Examples`, `/feed.xml` 200 `application/xml` with 2 items, `/tags/web%20development` 200

## Limitations

- No Wasmer deployment was submitted from this environment; the badge image and the wasmer.io create page could not be loaded from it.
- Wasmer builds Next.js apps through its own bundler and serves them with its own Node server rather than `next start`, on Node 24 by default. The build itself was checked locally on Node 24.22.1.
