<a href="https://wasmer.io/apps/create?github=Fechin%2Freference"><img src="https://img.shields.io/badge/Deploy%20to-Wasmer-171717?style=for-the-badge&amp;logo=wasmer&amp;logoColor=white&amp;labelColor=171717" alt="Deploy to Wasmer" width="328" height="48"></a>

## Summary

This PR adds a short "Deploy your own copy" subsection to the README, under "Live Demonstration". It has a Deploy to Wasmer badge and one paragraph explaining what the deployment does. It also adds a 5-line `_redirects` file at the repository root. The file repeats the two rename rewrites from `nginx.conf` (`/golang` to `/go` and `/css` to `/css3`) for static hosts that read `_redirects`. Nothing else changes: no cheat sheets, theme, build scripts, dependencies, lockfile, hooks, `Dockerfile` or `nginx.conf`.

Disclosure: I work at Wasmer. I prepared this change with help from Claude, an AI assistant, and reviewed and tested it before opening this PR.

The button opens Wasmer's import page for this public repository, where you review the detected build settings and click Deploy; it does not create a copy of the repository in your GitHub account. To customize the site and redeploy on changes, fork the repository and import your fork instead.

## Why this repo

Reference is a Hexo site. `public/` is gitignored, so the site has to be built first. The `Dockerfile` does this with `pnpm install` and `pnpm run build` and then serves `public/` with `nginx.conf`. Wasmer detects the same thing and runs the same two commands. The `_redirects` file is the only part of `nginx.conf` that needs an equivalent: without it, `/golang` returns 404 and `/css` resolves to the `public/css/` stylesheet directory and then 404s.

## Testing

All tests are a local replay of what Wasmer's builder (Anybuild v0.33.0) generates for `6fe843f01a81a2f87279eb629a806f318e6a4d72` (current `main`) with this change applied:

- Detection: static Node.js provider, framework Hexo, pnpm 10, output directory `public`. The `_redirects` file becomes 4 static-web-server redirect rules (kind 301), and the start command gets `--config-file`.
- `pnpm install` (Node 24.22.1, pnpm 10.34.7, 1259 packages) exited 0. `pnpm run build` exited 0, and Hexo reported "650 files generated".
- The output was served with a local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here).
- All 650 built files returned 200 with the expected content types: HTML, `text/css`, `text/javascript` (`main.js`, `fuse_7.1.0.js`, `sw.js`), PNG/SVG icons, `search.json`, `sitemap.xml`, `manifest.json` and `robots.txt`. `/nope` and `/assets/nope.js` returned 404.
- Built pages link to 237 unique same-origin paths. 236 of them returned 200. The exception is `/atom.xml`, which also returns 404 under the repository's own `nginx.conf`.
- URL behaviour compared with your nginx setup: I served the same build with nginx 1.24.0 using this repository's `nginx.conf` (only the paths, port and worker user were changed) and sent the same 71 requests to both servers.
  - Cheat sheets: for 12 sheets (including `go`, `css3`, `bash`, `python`, `docker`, `git` and `regex`), both the extensionless and `.html` forms returned 200 with the same response size on both servers.
  - `/`, `/index` and `/index.html` returned 200 on both.
  - Renamed sheets: `/golang` returns 301 to `/go`, `/golang.html` 301 to `/golang`, `/css` 301 to `/css3` and `/css.html` 301 to `/css`, matching nginx's status and Location.
  - Negatives: `/nope`, `/golang/../x`, `/css.html.bak`, `/go.html.bak`, `/GO`, `/js/nope.js` and `/assets/nope.js` return 404 on both.
  - 20 of the 71 requests differ. They are listed under Limitations.
- In headless Chromium (Playwright 1.56.1), with every request outside the local server blocked:
  - `/` loaded with 229 cheat sheet links.
  - The search box opened with 216 entries. Typing "python" gave 12 results with `/python.html` first, and that result opened with 200.
  - `/golang` redirected (301) to `/go`, which rendered the Go sheet (18 sections, 87 code blocks). `/css` and `/css.html` both ended on the CSS 3 sheet.
  - No 4xx/5xx responses came from the local server.
- Checks: `prettier --check README.md` passed (prettier 3.5.3 with the repo's config) and `pnpm run lint:check` passed. The PR title passes `commitlint`. `pnpm run format:check` fails on 27 existing files at `main` both with and without this change, and neither changed file is among them.

## Limitations

- No deployment was made. The import page and the badge image were not opened from the test environment.
- Differences from `nginx.conf` that remain (no catch-all rule was added):
  - nginx's generic `@html` rule (redirect `/x.html` to `/x` when `x.html` does not exist) is not reproduced. For example, `/about.html` and `/nope.html` return 404 here instead of nginx's 301. Every existing `.html` page and its extensionless form still return 200, as with nginx.
  - Directory pages redirect with 308 instead of 301 (`/about` to `/about/`).
  - Sheet URLs with a trailing slash (for example `/go/`) return 200 here, where nginx returns 404.
  - Path-traversal requests return 404 instead of 400.
  - 404 responses use static-web-server's default page instead of `/assets/page/oops.htm`.
- External services and site URL:
  - `_config.yml` sets `url: https://cheatsheets.zip`, so a deployed copy keeps canonical links, Open Graph tags and prefetch/prerender hints pointing at cheatsheets.zip unless the deployer changes `url` in a fork.
  - The star count is fetched from api.github.com.
  - 23 pages load LiveCodes or KaTeX from cdn.jsdelivr.net.
  - In the browser test these requests were blocked, and the pages and search still worked.
  - The built pages also contain SVG `path` attributes that Chromium reports as malformed (already present at `main`).
  - The service worker was blocked in the browser test and was not exercised.
- pnpm 10 skips the build scripts of `hexo-util` and `javascript-obfuscator` by default. The build still succeeded.
- The project is GPL-3.0: anyone who hosts a modified version should make sure they meet the license's obligation to offer the corresponding source, for example by keeping their fork public.
