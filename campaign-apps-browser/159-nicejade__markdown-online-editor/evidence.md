# nicejade/markdown-online-editor: evidence

**Verdict: HOLD (FAIL_ENV, unverifiable here).** All 1,709 `resolved` URLs in `yarn.lock` point to `https://registry.npmmirror.com`. This container's proxy blocks that host (`CONNECT tunnel failed, response 403`). Two replays failed during `yarn install` with `ECONNRESET` (exit 1), and the build never ran.

Remaining check: someone with access to npmmirror must run `yarn install && yarn run build` on Node 24 and check `dist/`. The reliability of a China mirror from Wasmer's builders is also unknown. If the build passes, the app is a Vue 2 / Vue CLI editor using a history router:
- `/` is the editor.
- `/about-arya` would 404 on reload. That must be disclosed, or the target held.

## Repository
- Pinned SHA: `adb413875bde1da1325474f82d1b8282a8638ef8` on `master`.
- Stars / forks: 3,984 / 600. Last push 2026-10-21.
- License: MIT.
- Plan: static Node.js provider, Vue, yarn 1, `yarn install`, then `yarn run build`, output `dist` (matches `vue.config.js`, `outputDir: 'dist'`).
- Policy and PR checks were not run, because the target was held on the environment failure.
