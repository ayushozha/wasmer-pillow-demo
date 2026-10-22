# hakimel/reveal.js: evidence

**Verdict: HOLD (wrong output for a one-click app).** reveal.js is a library repository.

## What the builder does
- Plan: static Node.js provider, Vite, npm 11.
  - Install: `npm install`, with `package.json` and `package-lock.json` staged.
  - Build: `npm run build`, which runs `tsc`, then 8 `vite build` invocations, then `add-banner`.
  - Output directory: `dist`.
- Replay (Node 24.22.1, npm 11.21.1): install exited 0 and build exited 0. However, `dist/` holds only the library files (`reveal.js`, `reveal.mjs`, `reveal.css`, `theme/`, `plugin/`, typings) and has no `index.html`. So `/`, `/demo.html` and `/dist/reveal.js` all returned 404.
- The demo deck (`index.html` and `demo.html`) lives at the repo root and loads `dist/*`. The only config that would serve it is a Staticfile with `root: .`. Because this is a node-static project, the build would still run and then copy the whole working directory into the static artifact (`node_static.bzl`: `cp -R {static_dir}/. static_app`). That artifact would include `node_modules` and the full source tree. That is unacceptable, so there is no minimal supported config.

## Repository
- Pinned SHA: `e240e175232fa2de660a02bc0d7bf5f655b159bb` on `master`.
- Stars / forks: 72,450 / 17,025. Last push 2026-09-30 (GitHub API, 2026-10-22).
- License: MIT.
- `.github/CONTRIBUTING.md`: PRs "Should be submitted from a feature/topic branch (not your master)". Plugins must not be submitted as PRs. The issue tracker is for bug reports only.
- No deploy-button or duplicate-PR searches were run, because the target is held on the technical result.
