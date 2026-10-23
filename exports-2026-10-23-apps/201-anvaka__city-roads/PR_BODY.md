<a href="https://wasmer.io/apps/create?github=anvaka%2Fcity-roads"><img src="https://img.shields.io/badge/Deploy%20to-Wasmer-171717?style=for-the-badge&amp;logo=wasmer&amp;logoColor=white&amp;labelColor=171717" alt="Deploy to Wasmer" height="48"></a>

## Summary

Adds a short "Deploy on Wasmer" section before "License" in the README: a Deploy to Wasmer badge and a short paragraph on what Wasmer runs and what the button does. No source or build changes.

## Why this repo

city-roads is a fully client-side visualisation: it fetches roads from OpenStreetMap (Nominatim, Overpass and your CloudFront city cache) in the browser and renders them with WebGL, with no account or API key. Map-art makers, teachers using it for geography or urban-planning lessons, and people who build on the scripting API (city-script) sometimes want their own copy on their own URL, for example a fork with custom colours or presets for a workshop. The README currently documents local development and the GitHub Pages site; a one-click deploy from source gives those users a hosted instance without setting up Node.

## Testing

Replayed what Wasmer's builder (Anybuild v0.33.0) generates for commit `35d6497db70debf4508b4d75f17d80c4367d66a6` with this change:

- Detection: static Node.js provider, framework Vite, package manager npm, output directory `dist`.
- `npm install` (only `package.json` and `package-lock.json` staged, as the builder does) exited 0 on Node 24.22.1 / npm 11.21.1.
- `npm run build` (`vite build`, vite 2.9.18) exited 0 and produced `index.html`, `assets/index.46c74633.js` and `assets/index.d9d15598.css`.
- `dist` served with a local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here): `/` returned 200 ("Draw all roads in a city at once"), and the JS and CSS bundles referenced by the built `index.html` returned 200.
- `npm audit --omit=dev`: 0 vulnerabilities in runtime dependencies.

## Limitations

- No deployment was made. The badge image and the Wasmer import page could not be checked from the test environment.
- Checks were HTTP-level only; road loading and rendering were not exercised in a browser.
- A self-hosted copy behaves like the current site, including its third-party calls: city search goes to Nominatim and Overpass, cached cities come from your CloudFront host, `index.html` loads your Google Analytics tag (`G-TXT6313TGG`), and the "Onto a mug" option uploads the rendered image to your AWS endpoint and opens Zazzle with your referral link. This PR doesn't change any of that; anyone hosting a copy may want to remove or replace the analytics tag.
- There is no `favicon.ico`, so browsers get a 404 for it, as on the current site.
