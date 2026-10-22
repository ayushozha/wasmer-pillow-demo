# cworld1/astro-theme-pure: evidence

**Verdict: HOLD (unverifiable here, FAIL_ENV).** The exact replay cannot install or build in this container, so there is no proof of a working Wasmer build.

## Repository
- Pinned SHA: `4ecd4762e1e750daf7a51978092d7cea8e14c0d6` on branch `main`.
- Stars / forks: 1,110 / 278. The repo is not archived and was last pushed 2026-09-26 (GitHub API, 2026-10-22).
- License: Apache-2.0. Patches are acceptable under section 5 (contributions are submitted under the same license).
- Policy files: `CODE_OF_CONDUCT.md` and issue templates only. There is no CONTRIBUTING file, no PR template and no AI policy.
- Recent merged PRs since 2025-10-01: 22, so the repo is active.
- Duplicate `wasmer` check: 0. Prior deploy-button PRs: none.
- Existing deploy docs: the README "## Deployment" section has a Vercel and Netlify button table. The patch adds a Wasmer badge under that table.

## Anybuild detection (v0.33.0)
- Provider: node-static, framework Astro. Package manager: bun 1 (`bun.lock`). Install runs `bun install --no-save`; build runs `bun run build` (`astro-pure check && astro check && astro build`). Static dir: `dist`.

## Replay 1 (exact plan, patched clone): FAIL_ENV
- `bun install --no-save` failed with exit 1, with 686 lines of `ProxyConnectFailed (403) downloading tarball ...`.
- Cause: `bun.lock` pins all 800 tarball URLs to **`https://registry.npmmirror.com/`**, and this container's egress proxy denies that host.
- Then the build failed (`ERR_MODULE_NOT_FOUND`) and `dist` was MISSING.
- Whether the Wasmer builder can reach `registry.npmmirror.com` is unknown, so this is a real risk for production as well.

## Replay 2 (diagnostic, deviation clearly labelled; `replay-diagnostic-npmjs-lockfile.log`)
- I rewrote the lockfile URLs to `registry.npmjs.org` in a scratch copy only (not part of the patch).
- `bun install` succeeded.
- `bun run build` then failed with exit 1:
  - `astro build` could not fetch the remote avatar `https://gravatar.loli.net/avatar/...` (`[ERROR] Failed to parse image reference` on `/archives`).
  - `api.fontshare.com` was unreachable: `getaddrinfo ENOTFOUND`.
- Both failures are network/environment issues here. The build needs outbound access to `gravatar.loli.net` and `api.fontshare.com`.

## Remaining check for the reviewer
- Run a real Wasmer build of the public repo (or a replay from a network with access to `registry.npmmirror.com`, `gravatar.loli.net` and `api.fontshare.com`).
- If that builds and `/`, `/blog/`, `/docs/` and `/rss.xml` return 200, the prepared `upstream.patch` can go out as CONDITIONAL.
- No PR body was written until then.
