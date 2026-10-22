Title: docs: add Wasmer Edge deploy option

## Summary

Adds a short "Deploy" section after Quick Start with a link that imports this repository on Wasmer Edge (`https://wasmer.io/apps/create?github=alxshelepenok%2Flumen`). It also adds a one-line `Staticfile` at the repository root:

```
root: target
```

No other files change.

## Why this repository

Lumen is built with `output: "static"` and every page is rendered to HTML at build time, with no adapter. The site can be served by any static host. The `.grove` notes (D-46) say a deploy tool once auto-detected `dist` while the real output is `target`. That is the same issue the `Staticfile` addresses here.

## Why the Staticfile is needed

`astro.config.ts` sets `outDir: "target"`. Wasmer's build detection (Anybuild, `wasmerio/shipit` at `587be23`, `crates/anybuild/src/providers/node_static.rs`) works like this:

- `get_static_dir` uses the framework default output folder, which is `dist` for Astro. It does not read `outDir` from `astro.config`.
- `load_static_parts` reads a repo-root `Staticfile` and, when it has a `root:` key, uses that value as the static directory.
- In `providers/mod.rs`, Strong `node_static` evidence (score 60) ranks above Staticfile evidence (score 50). Astro stays the selected provider and `bun run build` still runs. The `Staticfile` only changes which folder is served.

Without it, the build would succeed but Wasmer would look for a `dist/` folder that never exists. The value is the literal `outDir` in `astro.config.ts` and is not computed from env. Astro does not read the `Staticfile`, and it is not under `public/`, so it does not change the build or the Cloudflare setup.

## Testing

- At `4d965a9`, on bun 1.4.2 (`bun install --frozen-lockfile`, then `bun run build`, as in `.github/workflows/analyze.yml`), the build passed: 31 pages written to `target/`, with sitemap, Atom feed and `llms.txt`. Node v24.22.1 was on PATH. Sentry was off because no credential was set.
- I served `target/` locally and requested `/`, `/posts/a-brief-history-of-typography/`, `/posts/a-brief-history-of-typography.md`, `/404.html`, `/atom.xml`, `/llms.txt`, `/tags/` and `/sitemap-index.xml`. All returned 200, and all 148 root-relative references across the 31 HTML pages resolved.
- The project has no Markdown formatter configured, so no format check was run.

## Limitations

- I did not run a deployment. That Wasmer picks up `target/` comes from reading the Anybuild source, not from a deploy run.
- The import link builds this public repository. It does not copy it into your GitHub account. To customize the blog or redeploy on push, import your own fork or copy.
- The build needs network access for `bun install`. Sentry stays off unless `SENTRY_AUTH_TOKEN` or `PUBLIC_SENTRY_DSN` is set.
- Cloudflare dashboard settings, such as the 404 handling for `wrangler deploy`, do not carry over to Wasmer.
