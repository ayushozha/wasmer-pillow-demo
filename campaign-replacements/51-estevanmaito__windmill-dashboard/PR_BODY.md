## Summary

Adds a "Deploy on Wasmer" subsection under Usage with a button, plus a one-line `Staticfile` (`root: public`). No HTML, CSS or JS changes.

## Why this repo

The README already says "everything you need is inside the `public` folder" — the dashboard is plain HTML with a committed, prebuilt `tailwind.output.css`, so it can be hosted as-is with no build. A one-click import lets people try the accessible, light/dark dashboard on their own URL before adopting it.

Why the `Staticfile` is needed: without it Wasmer's builder (Anybuild) sees `package.json` and treats the repo as a Node.js server with no start command (the `build` script only regenerates the CSS). The `Staticfile` tells it to serve `public/` as a static site, with no install or build step.

The button opens Wasmer's import page for this public repository, where the user reviews the configuration and clicks Deploy. It does not create a copy of the repository in their GitHub account; to customize, they use their own copy and import that.

## Testing

Replayed Anybuild v0.33.0 (the version Wasmer pins) locally on this branch at base `e05267588134ca2f4129087cc65a59c38a9c36b5`:
- `anybuild plan`: "Detected static site provider", output directory `public`.
- Copied `public/` as generated and served it with static-web-server 2.38.0 (the version it pins).
- `/`, `/index.html`, `/forms.html`, `/cards.html`, `/charts.html`, `/buttons.html`, `/modals.html`, `/tables.html`, `/pages/login.html`, `/pages/create-account.html`, `/pages/forgot-password.html`, `/pages/blank.html`, `/pages/404.html` → 200; local assets (`tailwind.output.css`, `init-alpine.js`, chart scripts) → 200. `/does-not-exist` → 404.

No Wasmer deployment was made.

## Limitations

- Not deployed; the import page and badge image weren't checked from the test environment.
- Alpine.js, Chart.js, Google Fonts and demo images load from external CDNs, as in the existing demo.
- The committed `tailwind.output.css` is served as-is; changing Tailwind sources still needs `npm run build` before pushing.
