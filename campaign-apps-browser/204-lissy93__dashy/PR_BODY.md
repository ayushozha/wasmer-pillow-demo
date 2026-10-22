### Category
Docs

### Overview
Adds a short `### Wasmer` subsection under "Static Hosting Providers" in `docs/deployment/cloud.md`, after EdgeOne Pages, with a Deploy to Wasmer badge. It follows the format of the existing provider entries. The README list is unchanged.

The text says what Wasmer runs (`yarn install`, `yarn run build`, serving `dist` as static files), that the button opens Wasmer's import page for the public repo without copying it into the user's GitHub account, that people with their own `conf.yml` should fork and import the fork, and the same caveats you already list for static hosts: no Node server, so no status checks, CORS proxy or saving config through the UI. It also says to open Dashy from its root URL, because there are no rewrite rules, so reloading a sub-route such as `/workspace` returns a 404.

Why: Dashy is often run by people who want a start page without running a container. Wasmer gives them another static option built straight from the repo.

### Issue Number
N/A

### Additional Info
- Testing: I replayed what Wasmer's builder (Anybuild v0.33.0) generates for `a0005e8d6ea3dad611bc7c4daa1cd837dd338c79`. It detects a static Vite app (yarn). `yarn install` and `yarn run build` exited 0 on Node 24.22.1 / yarn 1.22.22. `dist` was served with a local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here). `/` and all 306 built files returned 200, including `conf.yml` and the lazy chunks. `/workspace`, `/minimal` and `/about` return 404 on reload, which the doc text mentions. `/opensearch.xml` returns 404 because the Node server generates it.
- No schema changes, no UI changes, no breaking changes.
- No deployment was made. The badge image and the Wasmer import page could not be checked from the test environment.
- AI disclaimer: this change and description were prepared with the help of an AI assistant and reviewed before submission.
