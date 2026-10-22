## Summary

Adds a "Deploy the demo on Wasmer" button to the README (under "Developing AdminLTE itself") and a one-line `Staticfile` (`root: dist`) so Wasmer serves the committed `dist/` folder — the same files `netlify.toml` publishes for adminlte-v4.netlify.app — as a static site. No files under `dist/` or `src/` change.

Why the `Staticfile` is needed: without it, Wasmer's builder (Anybuild) detects a Node.js/Astro project and uses `npm run dev` (asset watchers plus the Astro dev server) as the start command. With the `Staticfile` it copies `dist/` as-is and serves it with static-web-server; no install or build runs.

The button imports this public repository as-is; it does not fork it. To deploy changes, users fork, rebuild `dist/` with `npm run build`, and import their fork. The README text points to the "Security & production deployment" section, since this publishes the demo pages.

## Why this repo

AdminLTE's live demo is the main way people evaluate it, and the repository already treats `dist/` as a deployable static demo (Netlify config publishing committed `dist/`). A one-click import gives people a private hosted copy of the demo to review or share without installing Node.

## Testing

Replayed what Anybuild v0.33.0 generates for this branch at `e13df78a4d0c`:
- `anybuild plan` → static provider, output `dist`, no install/build commands.
- Served `dist/` with static-web-server 2.38.0: `/`, `/index.html`, `/index2.html`, `/docs/`, `/layout/fixed-sidebar.html`, `/UI/general.html` all 200; 51 referenced same-origin assets all 200.
- Offline check of all 91 HTML files in `dist/`: 5,148 local links, one unresolved (`css/adminlte-colors.css` from `docs/faq.html`, an existing stale page).

Validation commands: `anybuild plan`, then `static-web-server --root=dist --port=<port>` and an HTTP smoke test.

## Limitations

- No deployment was made; the badge image and the wasmer.io import page could not be loaded from the test environment.
- This deploys the demo pages, which SECURITY.md says not to put in production for real applications; the README text says so.
