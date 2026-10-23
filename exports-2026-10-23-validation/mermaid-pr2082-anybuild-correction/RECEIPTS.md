# mermaid-js/mermaid-live-editor PR #2082: Anybuild correction (local, native only)

These receipts are local and read-only. No upstream write and no deployment was made. The correction is meant to be committed by the account owner onto the existing PR branch, with no new PR.

## Exact head context (`exact-head-context.txt`)
- Head `7e34d9be5a614babac246434773411d341018abb`. `git ls-remote refs/pull/2082/head` gives the same SHA. Base `develop`, merge-base `eb4141dd51247259e95ecd890c1bf3dabf314913`.
- Blobs at the head:
  - `Anybuild` 8be261e62776b44bf40dbc59221745b389adaf09
  - `README.md` 260b74842b1d650c883f2eb86a52ff18c13e37a7
  - `pnpm-lock.yaml` 45e5cb743e4292fb6e639937a8b7452d94f8eec3
  - `package.json` e0eba3e2d54c1bf880bc8063d5f6120d8c7e63a7
  - `.husky/` tree 96f3185fb179c34279a1bb908f5ec03bc356041e
- `mermaid-pr2082-anybuild-correction.patch`:
  - sha256 `9badc5e53fc5995f96e8bc23eda1f7b5610ec34f3b9893d310c79fc6b2cddffc`
  - It touches only `Anybuild` (+11/-7). The corrected blob is `28b94e456dd867ffb7d0a215a12c347e69fbfded`.
  - Run on the clean head, `git apply --check` exits 0 and `git diff --cached --check` exits 0.
  - Prettier `--check --ignore-unknown Anybuild` exits 0.
  - The `.husky` pre-commit hook runs lint-staged, whose globs do not match `Anybuild`. README, lockfile, hooks and source are unchanged.

## What changes
The old rules were `/_app/**`→`$0`, `/edit`→`/edit.html`, `/view`→`/view.html`, `/**/*.*`→`$0`, and a catch-all `/**`→`/404.html`. The catch-all answered every unknown extensionless path with 200.

The new rules are six literal entries and nothing else:

| Source | Destination | Why |
|---|---|---|
| `/edit` | `/edit.html` | prerendered page |
| `/view` | `/view.html` | prerendered page |
| `/embed` | `/embed.html` | prerendered page (the old file had no `/embed` rule) |
| `/edit/`, `/view/`, `/embed/` | `/404.html` | see below |

The trailing-slash variants go to the SvelteKit fallback page, `404.html` (adapter-static `fallback: '404.html'`). Pointing them at the prerendered page fails: the prerendered pages use relative `./_app/…` asset URLs, which resolve under `/edit/_app/…` and 404. That was observed in a first attempt and is not kept as evidence. `404.html` uses root-absolute `/_app/…` imports and boots the router, and `src/routes/+layout.ts` sets `trailingSlash = 'ignore'`.

## Replay (Anybuild v0.33.0 reading the committed file; `replay.log`, `plan.txt`, `plan.json`)
- Plan: node-static, pnpm 10.34.7, `pnpm install --frozen-lockfile`, `pnpm run build`, `docs/`. `sws.toml.generated` is the SWS config the plan emits.
- `node -v`, `pnpm --version`, install and build all exit 0. The output has 278 files (`static_app-files.txt`).
- The harness smoke run (`smoke.txt`) lists `/definitely-missing-x9` as "FAIL 404". That is the desired result; the smoke tool expects 200 for every path.

## HTTP (`http-receipts.txt`, script `scripts/http_check.py`): 81 PASS / 0 FAIL
- `/`, `/edit`, `/view`, `/embed`, plus `?query` variants, return 200 and serve the intended file (checked by body hash). `/edit/`, `/view/`, `/embed/` return 200 and serve `404.html`. HEAD returns 200.
- Negatives all return 404:
  - `/definitely-missing-x9`
  - `/definitely/missing/deep`
  - `/edit/extra`, `/view/x/y`
  - `/embedx`, `/editor`
  - `/_app/immutable/missing.js`
  - `/missing.css`, `/missing.wasm`
  - `/_app/nothing`
  - HEAD on a missing path
- All 57 assets referenced by the served HTML of every entry return 200 with the correct MIME type.

## Browser (`browser.json`, `scripts/browser.cjs`, screenshots)
- `/edit`, `/view#pako…` and `/embed#pako…` (using a state the app generated), `/`, `/edit/#…`, `/view/#…`, `/embed/#…` and `/edit?x=1#…` each render a `flowchart-v2` SVG with 0 console errors and 0 same-origin HTTP errors.
- An unknown path returns HTTP 404. The 404 body is the SvelteKit fallback, which then routes client-side to the editor; that is the app's own behaviour.
- The only blocked external origin is `https://mermaid.js.org` (docs links). The build still points at mermaid.ink, kroki.io and Mermaid Chart; these are optional externals, so this is not a fully self-hosted stack.

## Limits
- Native only: served with a local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here). This correction uses only literal `[[advanced.rewrites]]` sources. Root reports that the WASI package `wasmer/static-web-server@=1.1.0` honours TOML rewrites via `--config-file`; that was not re-tested here, because registry.wasmer.io is unreachable from this container.
- The PR body could not be read (proxy 403), so `PROPOSED_PR_BODY_TESTING.md` gives replacement Testing/Limitations text only.
