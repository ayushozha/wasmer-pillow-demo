# 303 ubaimutl/react-portfolio: receipts (2026-10-23)

## Source
- Fresh `git clone --filter=blob:none`, `master` HEAD `ceb60ff0b3786a4be66841978906648d21808830` (2026-08-03). Same as the pin given for this run; no prior prep folder exists, so the change was written fresh.
- `upstream.patch` adds `Anybuild` (+34) and README (+6). sha256 `c4da6db8985215905eb6fea09afce84e646227f24799e71dad61a538834380a4`; `git diff --check` exit 0, `git apply --check` on clean HEAD exit 0, 0 trailing-whitespace lines (patch-check.txt).

## Policy (policy-files.txt)
- No CONTRIBUTING, AGENTS.md, CLAUDE.md, `.cursorrules`, `.github/` (no PR template, copilot instructions or CLA workflow), no AI/agent rule. README "Check the code: npm run lint" -> run, exit 0 (lint.txt).
- Last merged PR: #66 on 2024-09-24; owner commit 2026-08-03 (acceptance uncertainty, disclosed).

## Duplicates (duplicate-check.txt)
- 71 PR refs (all states). `--grep=wasmer`: none; `--author=wasmer/ayush`: none; README.md wasmer hits: 0 of 71.

## Plan
- Without Anybuild (plan-without-anybuild.*): static Node.js provider, Vite, npm 11, `npm install` / `npm run build`, output `dist`.
- With committed Anybuild (plan.*): "Using static Node.js provider declared in Anybuild", build `npm run build -- --base=/`, start adds `--config-file=/opt/static_config/sws.toml` (sws.toml.generated: 3 literal rewrites).

## Root-host override (the known caveat)
- `vite.config.js` hard-codes `base: "/react-portfolio/"`; no env-driven base. `package.json` has no `homepage`. Router: `BrowserRouter basename={import.meta.env.BASE_URL...}` (src/app/App.jsx), so it follows Vite's base.
- Smallest supported override: Vite CLI `--base=/` via Anybuild `node_build_command` (documented in shipit v0.33.0 docs/anybuild-files.md; used by node.bzl `node_build_step`). No source change; `npm run deploy` (gh-pages) still builds with `/react-portfolio/`.
- control-no-override.txt: default build references `/react-portfolio/assets/index-*.js`, 404 at root (blank page).

## EmailJS
- Reads no env vars. IDs are constants in `src/content_option.js` (`YOUR_SERVICE_ID/TEMPLATE_ID/USER_ID`, placeholders). Core site works with them unset; submit shows "Faild to send!,undefined" (browser.txt). Values in a static bundle are public: only the EmailJS public key belongs there.

## Replay (replay.log, smoke.txt)
- `scripts/replay_committed.sh` (replay.sh with `--anybuild-path` when an Anybuild exists) `<patched clone> v303 3981 / /about /portfolio /contact /does-not-exist /react-portfolio/`.
- Node v24.22.1, npm 11.21.1; `npm install` exit=0 (229 packages, "9 high severity vulnerabilities"); `npm run build -- --base=/` exit=0 (vite v8.2.0); 5 static files. smoke FAILs are the 2 intended 404 probes.

## HTTP (http-receipts.txt, external-refs.txt)
- 10 x 200, 10 x 404. 200: `/`, `/about`, `/portfolio`, `/contact`, `/index.html`, manifest.json, robots.txt, `/about` variant, JS (text/javascript), CSS (text/css). 404: `/about/`, `/does-not-exist`, `/react-portfolio/`, `/react-portfolio/about`, `/assets/nope.js`, `/package.json`, `/Anybuild`, plus 3 variant probes.
- External refs in HTML: fonts.googleapis.com, fonts.gstatic.com; no external scripts.

## Browser (browser.txt, scripts/pw303.js)
- Direct loads of 4 routes 200 with headings; menu clicks to 3 routes; reload `/contact` 200; `/does-not-exist` 404; page errors []. Blocked origins: fonts.googleapis.com, picsum.photos, images.unsplash.com, api.emailjs.com.

## Verdict: READY
- Open items are disclosures: EmailJS user-configured, runtime external fonts/images, trailing-slash routes 404, existing npm advisories, maintainer activity. Not deployed; import page and badge not opened.

## Claims table (PR_BODY.md -> receipt)
| Claim | Receipt |
|---|---|
| README section + Anybuild only; no source/config/lockfile change | upstream.patch |
| `base: "/react-portfolio/"`; router reads BASE_URL; default build 404s assets at root | config-excerpt.txt, control-no-override.txt |
| Plan with/without Anybuild: provider, commands, output | plan.txt/.json, plan-without-anybuild.txt/.json |
| Node 24.22.1, npm 11.21.1, install/build exit 0, 229 pkgs, Vite 8.2.0, 5 files | replay.log |
| 3 literal rewrites, no catch-all | sws.toml.generated, upstream.patch |
| curl 200/404 list and MIME types | http-receipts.txt |
| Browser routes, nav, reload, no page errors, blocked origins, EmailJS alert | browser.txt |
| `npm run lint` exit 0 | lint.txt |
| 9 high advisories reported by npm install | replay.log |
| Last merged PR September 2024 | policy-files.txt |
| Base SHA ceb60ff0 on master | policy-files.txt, patch-check.txt |
