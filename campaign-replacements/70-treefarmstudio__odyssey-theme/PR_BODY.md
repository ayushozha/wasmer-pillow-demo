## Summary

Adds a "Deploy on Wasmer" subsection under the README's "Deploy" section, with a Deploy to Wasmer button and two sentences on what it does.

## Why this repo

Odyssey is a starting point for a startup or small-business marketing site: landing pages, a blog, and company pages. The people who pick it usually want the site live quickly, and the README already invites deploying to "your favorite static hosting service". The build is plain Astro static output, so Wasmer can build it from the repo and serve `dist/` with no extra configuration.

## Testing

Local replay of what Wasmer's builder (Anybuild v0.33.0) generates for `d191e5715a2519e25be4629b933189c421b30a1a` with this change:
- Detection: static Node.js provider, framework Astro, npm, output `dist`.
- `npm install` (Node 24.22.1, npm 11.21.1): exit 0.
- `npm run build`: exit 0.
- `dist/` served with a local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here): `/`, `/blog`, a blog post, `/company/about`, `/company/contact`, both landing pages, `/theme/style-guide`, `/404.html` and `/sitemap.xml` returned 200, and every local asset referenced from the HTML pages returned 200.

## Limitations

- No deployment was made. The badge image and the Wasmer import page could not be checked from the test environment.
- The contact and newsletter forms post to a static page; on a static host they need a form service such as Formspree or Formspark (the README sentence says so).
- The button opens Wasmer's import page for this public repository, where you review the configuration and click Deploy; it does not create a copy of the repository in your GitHub account. To build your own site, fork the repository and import your fork.
