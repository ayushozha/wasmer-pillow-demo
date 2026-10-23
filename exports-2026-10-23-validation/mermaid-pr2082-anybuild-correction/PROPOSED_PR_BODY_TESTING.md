## Testing

Tested locally at 7e34d9be plus the `Anybuild` correction, with Anybuild v0.33.0 reading the committed `Anybuild` file:

- `pnpm install --frozen-lockfile` (pnpm 10.34.7, Node 24) and `pnpm run build` both exit 0, writing to `docs/`.
- The output was served with a local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here), using the generated `sws.toml`:
  - `/`, `/edit`, `/view`, `/embed`, their trailing-slash forms and query-string forms return 200.
  - All 57 referenced assets return 200 with correct content types.
  - Unknown paths such as `/definitely-missing`, `/edit/extra`, `/editor`, `/_app/immutable/missing.js` and `/missing.css` return 404.
- In Chromium, `/edit`, `/view#pako:…` and `/embed#pako:…` each render the diagram with no console errors.

## Limitations

- No deployment was made, and the Deploy button and import page were not opened from the test environment.
- The rewrites are literal entry routes only; there is no catch-all, so unknown paths stay 404.
- Renderer, Kroki and analytics endpoints keep the build-time defaults described in the README.
