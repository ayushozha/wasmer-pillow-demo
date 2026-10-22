Title: docs: add Wasmer Edge deploy option

I work at Wasmer. Wasmer Edge is a cloud hosting platform powered by WebAssembly; it can host this repository’s generated static site. References: [Wasmer Edge docs](https://docs.wasmer.io/edge/), [Git deployments](https://docs.wasmer.io/edge/git/).

## Summary

This PR adds a short **Deploy** section to the README, between Installation and Components. The section has a "Deploy to Wasmer" badge that links to `https://wasmer.io/apps/create?github=TailAdmin%2Ffree-react-tailwind-admin-dashboard`. It tells people to fork the repository first, because the import builds the repository you pick and does not copy it into your GitHub account.

It also adds a root `Anybuild` file. Wasmer reads this file to build and serve the app.

## Why this repository

The dashboard is a Vite build of a React app that uses `BrowserRouter`. Its pages live at real paths such as `/profile`, `/calendar` and `/basic-tables` (`src/App.tsx`). Like any history-router SPA on a plain static server, those URLs return 404 when someone opens them directly or refreshes the page, because no `profile` file exists in `dist/`.

The `Anybuild` file fixes this for exactly the routes the app defines. Wasmer then serves `index.html` for those routes, so links to dashboard pages work. You don't need to change the app's code or switch to hash routing.

## What the `Anybuild` file does

The file is what Anybuild 0.33.0 generates with `anybuild generate .` (npm, Vite, `dist`, `schema = 1`, `sws_version = "2.38.0"`). One argument is added to `nodestatic_config(...)`: `static_redirects_config`, which holds a static-web-server TOML config.

The config is 15 `[[advanced.rewrites]]` rules, one for each route in `src/App.tsx` apart from `/`. Each rule has the shape `source = "{/profile,/profile/}"`, `destination = "/index.html"`, so the route works with or without a trailing slash. None of the rules has a `redirect` key.

Public sources:

- **Anybuild** ([wasmerio/shipit](https://github.com/wasmerio/shipit) at `587be23132ea9302775d1cd4c075c1b75e2670a2`):
  - In `crates/anybuild/resources/starlib/tools/staticfile.bzl` (lines 21-30), a non-empty `static_redirects_config` creates a `static_config` mount. That code then writes the text verbatim to `sws.toml`.
  - Lines 69-73 of the same file then start static-web-server with `--config-file=<static_config>/sws.toml`.
  - `node_static.bzl` (lines 27-56) uses the same two helpers for Vite and other Node static builds.
- **static-web-server** [URL Rewrites](https://static-web-server.net/features/url-rewrites/):
  - `source` is a glob.
  - Without a `redirect` key, the server does an internal rewrite. It serves the `destination` file with its normal 200 response, and no redirect is sent to the browser.
  - A source with no wildcards matches only that exact path.
- **globset** [syntax](https://docs.rs/globset/0.4.14/globset/#syntax) (the glob crate static-web-server uses): `{a,b}` matches `a` or `b`. static-web-server compiles each source to an anchored regex, so `{/profile,/profile/}` becomes `^(/profile/|/profile)$`.
- **static-web-server** [Configuration File](https://static-web-server.net/configuration/config-file/) documents the `[advanced]` and `[[advanced.rewrites]]` syntax.

Because every rule lists exact paths, behaviour for anything else stays the same:

- unknown URLs such as `/nope` and nested paths such as `/profile/extra` still return 404;
- missing assets such as `/assets/nope.js` still return 404;
- real files under `/assets/` and `/images/` are served as before.

## Testing

Everything below ran on Linux at base commit `e888dd1716b9803b535c7c2fa4f2c6b7d39b3da9` with Node v24.22.1, npm 11.19.1 and Anybuild 0.33.0.

**Plan**
- `anybuild plan .` printed "Using static Node.js provider declared in Anybuild" (Vite, npm, `dist`).
- The plan's `static_redirects_config` is byte-identical to the TOML above.
- The plan's start command includes `--config-file=.../static_config/sws.toml`.

**Build**
- `anybuild build . --builder=local` ran `npm ci` and `npm run build` and exited 0.
- The written `sws.toml` matches the TOML in the `Anybuild` file byte for byte (sha256 `a58d026a0a8b8ec7e2e30bdff89e81e8758a7b458cd6a1c24ddac206a806d06f`).

**Rendered Wasmer files**
- `anybuild build . --runner=wasmer` rendered `wasmer.toml`. Nothing was deployed.
- `wasmer.toml` mounts `/opt/static_app` and `/opt/static_config` and runs `wasmer/static-web-server` with these args: `--root=/opt/static_app --log-level=info --config-file=/opt/static_config/sws.toml --port=8080`.

**HTTP checks**

I served the build with `anybuild run . --start`, on native static-web-server 2.32.2 and on 2.38.0. Both gave the same results (86 requests, all as expected):

| Request | Result |
|---|---|
| `/` and all 15 routes, each as `/route`, `/route/`, `/route?x=1` and `/route/?x=1` | 200 `text/html`, body identical to `index.html` |
| `/images` and `/images/` (a route that is also a folder in `public/`) | 200 |
| `HEAD /profile`, `HEAD /profile/` | 200 |
| `/nope`, `/nope/`, `/profile/extra`, `/profile/extra/`, `/profile//`, `/profiles`, `/signin/x`, `/assets/`, `/assets/nope.js`, `/images/nope.png` | 404 |
| hashed JS | 200 `text/javascript` |
| hashed CSS | 200 `text/css` |
| `/favicon.png` | 200 `image/png` |

**Browser checks**

In headless Chromium I tested:
- a direct load and a refresh of every route, plus `/profile?x=1` and `/calendar#today`;
- a direct load and a refresh of `/profile/`, `/calendar/`, `/signin/`, `/basic-tables/?x=1` and `/images/`. React Router renders the same page as without the slash;
- sidebar navigation from `/` to `/profile` and `/calendar`, each followed by a refresh.

Each page rendered its expected title. There were no failed same-origin requests and no JS errors, with two exceptions:
- on `/profile/`, the profile card's avatar returns 404. `src/components/UserProfile/UserMetaCard.tsx` line 24 uses the relative path `./images/user/owner.png`, which resolves to `/profile/images/user/owner.png` under a trailing slash. This happens on any host that serves `/profile/`, and the rest of the page renders;
- the YouTube embeds on `/videos` could not load in my offline sandbox.

**Control**

The same build without the `Anybuild` argument returns 404 for every route, and `/images` returns a 308 redirect to `/images/`.

**Format**

`prettier --check` already reports issues on the base README. The new section has no changes under the repo's Prettier config.

## Limitations

- **Known routes only.** The list mirrors `src/App.tsx`. When you add a route there, add the same path to `static_redirects_config` in `Anybuild`, or that page will return 404 when someone opens it directly. The README section says so.
- **Unknown URLs return a server 404 on direct load.** The app's own "404" page (`path="*"`) only appears after in-app navigation.
- **Trailing slashes.** `/route/` is served like `/route`. On `/profile/`, one avatar uses a relative image path and shows as broken (see Testing). Deeper paths such as `/profile/extra` return 404.
- **Anybuild and Wasmer only.** Other hosts ignore the `Anybuild` file.
- **Regeneration drops the rules.** `anybuild generate` does not keep `static_redirects_config`, so re-add it if you regenerate the file.
- **Build environment variables override the rules.** If `ANYBUILD_STATIC_REDIRECTS_CONFIG` or `SHIPIT_STATIC_REDIRECTS_CONFIG` is set in the build environment, it replaces the rules.
- **No live deployment.** I have not deployed this to Wasmer, and I ran the HTTP checks with native static-web-server binaries, not on Wasmer's runtime. The badge imports this public repository for a build. Redeploy-on-push needs your own fork connected.
- **External dependency.** The badge image is served by shields.io.
