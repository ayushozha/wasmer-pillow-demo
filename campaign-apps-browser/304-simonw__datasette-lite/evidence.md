# 304 simonw/datasette-lite — SKIP (no build step; below star floor)

- Pinned: main @ 779b2d4da76a5dc2f1d9aea0d7c8d854f6e1497b, last commit 2026-08-09.
- GitHub API, 2026-10-22: 410 stars, 43 forks, Apache-2.0, not archived. That is below the lane's 500-star floor.
- Duplicate check: `wasmer` PR search returned 0 (2026-10-22).
- Build step: none. The repo is index.html, app.css and webworker.js plus a test workflow. Anybuild v0.33.0 plan: static site provider, no install/build (plan.txt). Pure root HTML belongs to the other session.
- Local vs third-party at runtime (source lines saved in triage-receipt.txt):
  - Local: index.html, app.css and webworker.js only.
  - webworker.js:1 `importScripts("https://cdn.jsdelivr.net/pyodide/v0.27.2/full/pyodide.js")` and :72 `indexURL` on cdn.jsdelivr.net. The whole Pyodide runtime and its Python packages come from jsDelivr, and webworker.js:108-120 runs `micropip.install` for h11, httpx, python-multipart, typing-extensions and datasette at runtime (from PyPI).
  - webworker.js:68-69: when no `?url=`/`?csv=` is given, the default databases come from https://latest.datasette.io/fixtures.db and https://datasette.io/content.db.
  - index.html:33 always loads `https://plausible.io/js/script.manual.js`. Pageview events fire only when hostname is `lite.datasette.io` (index.html:177), but the script request itself goes to plausible.io from any host.
  - index.html:102/106 rewrite GitHub and Gist URLs to raw.githubusercontent.com / gist.githubusercontent.com for user-supplied data.
- Verdict: SKIP. It has no build step and is below the star floor. A self-hosted copy would still depend on jsDelivr, PyPI, datasette.io and plausible.io, so "self-hosted" would be misleading without that disclosure. No browser proof was run.
