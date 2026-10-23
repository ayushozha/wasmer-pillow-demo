<a href="https://wasmer.io/apps/create?github=alexadam%2Fprintable-mockups"><img src="https://img.shields.io/badge/Deploy%20to-Wasmer-171717?style=for-the-badge&amp;logo=wasmer&amp;logoColor=white&amp;labelColor=171717" alt="Deploy to Wasmer" height="48"></a>

## Summary

Adds a short "Deploy on Wasmer" section before "Credits" in the README: a Deploy to Wasmer badge and a short paragraph on what the button does. No source or build changes.

## Why this repo

Printable Mockups runs entirely in the browser: you lay out UI and wireframe templates and export a PDF with jsPDF, with no account and no backend. UX designers, product teams running paper-prototyping sessions and teachers of UI/UX classes often want their own copy, for example an internal URL for a workshop or a fork with extra templates. The README covers running it locally; a one-click deploy from source lets them host an instance without setting up Node.

## Testing

Replayed what Wasmer's builder (Anybuild v0.33.0) generates for commit `4ac3ff3042cddb12c764c1706388df9ddd2532c9` with this change:

- Detection: static Node.js provider, framework Vite, package manager npm, output directory `dist`.
- `npm install` (only `package.json` and `package-lock.json` staged, as the builder does) exited 0 on Node 24.22.1 / npm 11.21.1.
- `npm run build` (vite 8.2.0) exited 0.
- `dist` served with a local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here): `/` returned 200, and all six built files returned 200, including the entry bundle, the stylesheet and jsPDF's lazily loaded chunks (html2canvas, DOMPurify).
- `npm audit --omit=dev`: one low-severity DOMPurify advisory (pulled in by jsPDF), no high or critical.

## Limitations

- No deployment was made. The badge image and the Wasmer import page could not be checked from the test environment.
- Checks were HTTP-level only; drawing and PDF export were not exercised in a browser.
- The app is a single page; unknown paths return 404, as on any static host.
