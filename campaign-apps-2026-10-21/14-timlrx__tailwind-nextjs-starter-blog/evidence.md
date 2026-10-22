# Evidence: timlrx/tailwind-nextjs-starter-blog

| Item | Value |
| --- | --- |
| Branch / pinned SHA | `main` @ `b45bef66b40c63b6f57c15ee8cd090682238df4c` |
| Last commit | 2026-02-08T16:11:26+01:00, "Merge pull request #1217 from timlrx/update-dependencies" |
| Stars / forks | 10,560 / 2,596 (GitHub API, 2026-10-22) |
| License | MIT (`LICENSE`, "Copyright (c) 2021-2025 Timothy Lin") |
| Contribution / AI policy | No CONTRIBUTING, AGENTS or PR template; `.github/ISSUE_TEMPLATE/{bug_report,feature_request}.md` only. lint-staged runs `prettier --write` on `*.md` (README passes `prettier --check` before/after). |
| Duplicate check | GitHub search `wasmer` across all 18 batch targets returned 0 PRs (2026-10-22) |
| Prior third-party deploy-button PRs | None provided for this target |

## Source facts (at pinned SHA)

- `package.json`: `start` = `next dev` (NOT production), `build` = `cross-env INIT_CWD=$PWD next build && ... node ./scripts/postbuild.mjs` (RSS), `serve` = `next start`; `packageManager: yarn@3.6.1`; `.yarnrc.yml`: `nodeLinker: node-modules`, `yarnPath: .yarn/releases/yarn-3.6.1.cjs`.
- `next.config.js`: `trailingSlash: true`; `output: 'export'` only when `EXPORT` is set; `BASE_PATH`, `UNOPTIMIZED`, `ANALYZE` optional.
- Env (all optional): `NEXT_PUBLIC_GISCUS_*`, `NEXT_PUBLIC_UTTERANCES_REPO`, `NEXT_PUBLIC_DISQUS_SHORTNAME`, `NEXT_UMAMI_ID` (`data/siteMetadata.js`); newsletter provider keys (`BUTTONDOWN_API_KEY` for the default `buttondown`, others in `.env.example`) used by `app/api/newsletter/route.ts` via pliny.
- README already has `## Deploy` with GitHub Pages / Vercel / Netlify / static subsections. Patch adds `### Wasmer` between Vercel and Netlify and a badge beside the top Vercel button.
- Upstream content nit (not touched): `data/blog/guide-to-using-images-in-nextjs.mdx` links `/static/images/ocean.jpg`, but the file is `ocean.jpeg`.

## Local production proof (build.log)

`yarn install --immutable` 0, `yarn build` 0 (Contentlayer + `next build` + "RSS feed generated..."), `yarn serve` (`next start`): `/`, `/blog/`, post pages, `/tags/markdown/` 200; `/feed.xml` 200 XML with 10 items; `/sitemap.xml` 200; `/static/images/ocean.jpeg` and `/_next/image/?url=...ocean.jpeg` 200 image/jpeg; `/api/newsletter/` 500 without a key (optional).

## Wasmer builder behaviour (wasmerio/shipit @ 587be23132ea = tag `v0.33.0`, 2026-10-05; production reportedly pins Anybuild 0.33.0, but its config may differ)

Start command concern resolved: for Next.js the start command is `node .next-bundle/server.mjs` (`crates/anybuild/src/providers/node.rs:473-475`, applied at `node.rs:1764-1768` before the `start`-script fallback at `node.rs:1670-1682`). So `yarn start` (`next dev`) is **not** used. However, three blockers were found:

1. **Install step ignores `.yarnrc.yml`.** Package manager is yarn (from `packageManager`, `node.rs:1172-1183`); the yarn version is left floating (`node.rs:1116-1124, 1148-1151`; test comment at `node.rs:2237-2238` says the preset emits Berry-only commands). The install runs `yarn install` (`resources/starlib/tools/node.bzl:21-26`) with only `yarn.lock` copied and `package.json` bind-mounted (`node.bzl:115-116, 139`; Docker `--mount=type=bind` at `build/docker.rs:376-401`). `install_inputs` is always overwritten from the discovered context (`node.rs:1782`), so `ANYBUILD_NODE_INSTALL_INPUTS` cannot add `.yarnrc.yml` / `.yarn/releases`. Simulated here (build.log, "Anybuild install-step simulation"):
   - (a) Yarn 3.6.1 without `.yarnrc.yml`: install succeeds, but as **PnP** (`.pnp.cjs`, no `node_modules`). After the sources (with `.yarnrc.yml`, `nodeLinker: node-modules`) are copied in (`node.bzl:142-151`), `yarn run build` fails: `Usage Error: Couldn't find the node_modules state file - running an install might help`.
   - (b) Yarn 4.18.1 (latest Berry): `YN0028: The lockfile would have been modified by this install, which is explicitly forbidden.` (CI immutable).
2. **`yarn dlx next-bundle` finds the wrong project.** Even with a correct `node_modules`, `yarn dlx next-bundle@1.0.0 --build-command 'yarn run build'` (the command Anybuild generates, `node.rs:458-471`; asserted by the test at `node.rs:2172-2173`) failed: `Error: The target project does not declare a next dependency.` next-bundle resolves the project from `INIT_CWD || cwd` (`next-bundle@1.0.0 bin/build.mjs:55`), and under Yarn 3.6.1 `dlx` that points at the temporary dlx project.
3. **Trailing-slash redirect loop in the bundle server.** Diagnostic only: building the same bundle via `npx -y next-bundle@1.0.0 --build-command 'yarn run build'` succeeded. `node .next-bundle/server.mjs` then served `/` 200, `/feed.xml` 200 (10 items, but `application/octet-stream`), `/sitemap.xml` 200, the image and `_next/image` 200 (webp). Every other page loops: `/blog/` -> `308 Location: /blog/` (same for `/blog/code-sample/`, `/tags/markdown/`), and `curl -L` stops at max redirects. `trailingSlash: true` is the repo's default config.

Node: `24` default (`node.rs:561, 608`); no `engines` field. Static export is only used with `EXPORT=1` (not set by the button).

## Verdict: HOLD

Do not open the PR yet. With the Anybuild v0.33.0 source, a one-click deploy of this repo would fail at build (blockers 1 and 2). Even if it built, every page except `/` would hit a 308 loop (blocker 3). None of these is caused by the repo, and none can be fixed from the README. A config file would not help with 1 and 2 either, since the install and dlx commands are generated by the builder. The patch, PR title and body are staged in case Wasmer fixes this.

Remaining check for Codex: deploy `https://wasmer.io/apps/create?github=timlrx%2Ftailwind-nextjs-starter-blog` once. Upgrade to READY only if the build log shows the install producing `node_modules`, next-bundle finding the project, and `/blog/` returning 200 (not a 308 loop) on the deployed URL. Otherwise report the three issues to wasmerio (Anybuild yarn-berry install inputs, `yarn dlx` project root in next-bundle, trailingSlash loop in next-bundle `server.mjs`).
