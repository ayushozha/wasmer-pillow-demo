# Evidence: ChatGPTNextWeb/NextChat

## Verdict: HOLD

Do not open the PR yet. There are two reasons, and both come from current source:

1. **The server logs the provider key in plaintext.** `app/config/server.ts:116-130` (`getApiKey`) runs `console.log(\`[Server Config] using ${randomIndex + 1} of ${apiKeys.length} api key - ${apiKey}\`)` (lines 122-126) every time `getServerSideConfig()` builds the config. In the local run that was several times per request (see build.log, "server output", which shows the mock key `sk-mock-****`, redacted). `app/api/auth.ts:35-38` also logs the allowed hashed codes and the **plaintext access code** sent by the client (`[Auth] got access code: mockcode`). On any hosted deploy, Wasmer included, the app's runtime logs would hold the owner's provider key and users' access codes. A README-only patch cannot fix this. The patch can only warn ("keep the app's logs private"), and a one-click button that leads people straight into this is a poor fit. The coordinator's rule applies: HOLD.
2. **The Wasmer builder's Yarn path does not fit this repo's Yarn 1 lockfile.** `wasmerio/shipit@587be231` (Anybuild) selects Yarn from `packageManager: "yarn@1.22.19"` (`crates/anybuild/src/providers/node.rs:1172-1183`) but deliberately leaves the Yarn version floating (`node.rs:1150-1153`, "Yarn keeps floating"; `default_manager_version` returns `None` for Yarn, `node.rs:1116-1124`). Its Yarn commands are Berry-only. The build is wrapped as `yarn dlx next-bundle@1.0.0 --build-command 'yarn run build'` (`node.rs:458-471`, `resources/starlib/tools/node.bzl:35-40`), and the prune step is `yarn workspaces focus --all --production` (`node.bzl:28-33`). Yarn 1.22 has neither `dlx` nor `workspaces focus`. Under Yarn Berry, a v1 `yarn.lock` with no `.yarnrc.yml` would be migrated, and Berry defaults to PnP. So the build fails under Yarn 1, and under Berry it is unverified at best. I could not run the real builder or a Wasmer deploy from here.

What would re-open it: (a) upstream removes or redacts the key and access-code logging, and (b) a real deploy through `https://wasmer.io/apps/create?github=ChatGPTNextWeb%2FNextChat` builds and serves (`node .next-bundle/server.mjs`) with a mock or low-limit key and `CODE` set. Without (b) the button would point a large audience at a build that may fail.

## Repo facts
- Pinned SHA: `1d3dc331512929a4b1d3e82354e72acce33b5c7a` (branch `main`), last commit 2026-10-20T18:19:31+08:00 ("Merge pull request #6921 from ChatGPTNextWeb/security/mcp-action-auth").
- Stars / forks: 88,881 / 58,757 (GitHub API, 2026-10-22).
- License: MIT (`LICENSE`; `package.json` `"license": "mit"`).
- Contribution / AI policy: no CONTRIBUTING, AGENTS.md or AI policy file found. There is a PR template at `.github/PULL_REQUEST_TEMPLATE.md` with bilingual headings (变更类型 | Change Type checklist, 变更说明 | Description of Change, 补充信息 | Additional Information), and PR_BODY.md follows it.
- Duplicate check: a GitHub search for `wasmer` across all 18 batch targets returned 0 PRs (2026-10-22).
- Prior third-party deploy-button PRs, all closed unmerged: #6184, #4752 (RepoCloud), #5229, #3632 / #3766 (Sealos). The README still carries Zeabur, Vercel, Gitpod and opendeploy buttons (`README.md:32`), so the maintainers accept some buttons, but acceptance risk is high.

## Build and runtime facts (local, Node v22.22.0, Yarn 1.22.22)
- Scripts: `build` = `yarn mask && cross-env BUILD_MODE=standalone next build`, `start` = `next start`. `next.config.mjs` defaults `BUILD_MODE` to `standalone`, so `output: "standalone"`. `next start` still serves but warns: `"next start" does not work with "output: standalone" configuration` (build.log).
- `yarn mask` runs `npx tsx app/masks/build.ts`. tsx is a devDependency, so this needs devDependencies installed.
- Install: `yarn.lock` resolves 390 entries from `registry.npmmirror.com` and 4 from `mirrors.huaweicloud.com`. This container's proxy denies both (403 on CONNECT), so the first two frozen installs failed with ECONNRESET. **Fallback (build copy only):** I rewrote those two hosts to `registry.npmjs.org`. Tarball paths and sha512 integrity are unchanged. After that, `yarn install --frozen-lockfile` passed (exit 0) and `yarn build` passed (exit 0). The upstream lockfile was not touched. On Wasmer the mirrors are presumably reachable; this is not verified.
- The build output includes a "Module not found: Can't resolve 'utf-8-validate'" warning from `rt-client` and an ESLint rule crash. Both are non-fatal.
- Smoke on port 3101, with mock key `sk-mock-****`, `CODE=mockcode`, and `BASE_URL=http://127.0.0.1:3191` (a local Python SSE mock written in scratch):
  - `/` returned 200 with `<title>NextChat</title>`. `POST /api/config` returned 200 with `needCode:true`.
  - `POST /api/openai/v1/chat/completions` with no code returned **401** `{"error":true,"msg":"empty access code"}`.
  - The same request with `Bearer nk-wrongcode` returned **401** `wrong access code`.
  - With `Bearer nk-mockcode` it returned **200** `text/event-stream`, and 3 `data:` chunks plus `[DONE]` streamed from the mock. The mock received `Authorization: Bearer sk-mock****`, which shows the server key is injected.
  - With `CODE` unset, a request with **no Authorization header** returned 200 and streamed with the server key. This is why the README now says `CODE` is required whenever a provider key is set.
- The env vars in the patch were checked against `app/config/server.ts`: `CODE` (line 104), `BASE_URL` (184), `OPENAI_API_KEY` (185), `DEFAULT_MODEL` (141), plus the other providers. A user-supplied API key (Bearer without the `nk-` prefix) bypasses the code check (`app/api/auth.ts:42`), so the README says "required unless every user enters their own key".

## Wasmer builder (Anybuild) facts
Source: `wasmerio/shipit@587be23132ea` (2026-10-05). Production wasmer.io may run a different builder version.
- Next.js is detected from the `next` dependency (`node.rs:1318`).
- Build is `yarn dlx next-bundle@1.0.0 --build-command 'yarn run build'` (`node.rs:23, 458-471, 1646-1667`). Start is `node .next-bundle/server.mjs` (`node.rs:473-475, 1765-1769`), not `next start`.
- Node 24 by default (`node.rs:561, 608`; override with `ANYBUILD_NODE_VERSION`, see `providers/base.rs:34-43`). Local tests used Node 22.
- Install is plain `yarn install` (`node.bzl:21-26`), with only `package.json` and the lockfile present (`node.bzl:110-117`), so the `prepare: husky install` script runs without `.git`.

## Deviations of the task notes from current source
- The notes said "production start = `next start`". `yarn start` is `next start`, but the Wasmer builder does not use it (see above).
- The badge row line was correct (`README.md:32`). The patch adds the button there in the same HTML `<img height="30">` style, plus a short `### Wasmer` subsection under Deployment.

## Limitations
No Wasmer deployment was submitted. wasmer.io and img.shields.io are blocked here, so detection, build, runtime and badge rendering are not verified. No real API keys were used; the only upstream was the local mock.
