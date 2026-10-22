## Summary

Adds a short "Deploy on Wasmer" subsection under "Offline Use" in the README: a Deploy to Wasmer badge and two sentences. No code, dependency or build changes.

## Why this repo

Hat.sh is a client-side file encryption tool, and the README already encourages self-hosting it. People who rely on it, such as journalists, small teams sharing sensitive files and IT admins who want an internal encryption page, often prefer an instance on a URL they control over a public one, so they know exactly which build is served. The app is a Next.js static export with no server component and no environment variables, so a one-click build from source gives them that instance without setting up Node locally.

## Testing

I replayed what Wasmer's builder (Anybuild v0.33.0) generates for `540d3ccfd2a12b4ed96b78a776c764f899678b6c` with this change:

- Detection: static Node.js provider, framework Next.js, output directory `out`.
- `npm install` exited 0 on Node 24.22.1 / npm 11.21.1, with only `package.json` and `package-lock.json` staged.
- `npm run build` (browserify service worker, `next build`, `next export`, postbuild) exited 0.
- `out` was served with a local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here):
  - `/`, `/about/`, `/generate-keys/` and `/service-worker.js` returned 200.
  - All 23 referenced `_next/static` scripts and styles, the favicon and images returned 200.

## Limitations

- No deployment was made. The badge image and the Wasmer import page could not be checked from the test environment.
- Checks were HTTP-level only; encrypting and decrypting a file in a browser (service-worker streaming, which needs HTTPS) was not exercised.
- Unknown paths return a plain 404.
- The button opens Wasmer's import page for this public repository, where the user reviews the configuration and clicks Deploy; it does not create a copy of the repository in their GitHub account.
