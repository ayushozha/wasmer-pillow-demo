# dalibo/pev2: evidence

> **HOLD (security, root review 2026-10-22; confirmed by local DOM probe) — DO NOT PUBLISH a deployment PR** until a proper remediation/disclosure process has run. No public security comment, issue or app change has been made. The Staticfile/README patch below is technically proven but is not recommended for submission.

## HTML reinterpretation check (local, DOM-only)
- Source at pinned SHA `e41d4e8`: `src/components/Plan.vue:426` `v-if="!store.plan"` (invalid-plan branch) renders `src/components/Plan.vue:439` `<code v-html="planSource"></code>`. `planSource` is the raw prop (`Plan.vue:52`), with no escaping. The example app passes it unchanged: `example/src/views/HomeView.vue:89-104` `submitPlan()` → `setPlanData(name, planInput.value, ...)`. Other entry points with third-party content reach the same prop: dropped plan files (`HomeView.vue:69`, `196-203` FileReader) and imported saved-plan JSON (`HomeView.vue:242-258` → `idb.importPlans` → `loadPlan` → `setPlanData`, `HomeView.vue:129-149`).
- History (blobless clone of upstream, `git log -S'v-html="planSource"' -- src/components/Plan.vue`): introduced in `e4fbe012537eac8d0f9edc1a50ab1e0aa74b3be4` (Pierre Giraud, 2024-08-21, "Improve parsing error message"), and still present at `e41d4e8` (v1.25.0, 2026-10-20). I could not read issue #847 or its comments: the GitHub API is not enabled for dalibo/pev2 in this session (403). So I can't verify the maintainer's "last unsafe use was fixed" statement, or its date. A related issue, #892 "unsafe usage of innerHTML for `Output` node" (opened 2026-05-19, closed 2026-06-08), concerned `PlanNodeDetail.vue`/`filters.ts`, not this branch.
- Probe (`receipt-vhtml-probe.cjs`, output `receipt-vhtml-probe.json`): headless Chromium 1194 (Playwright) against the replayed `dist-app/index.html`, served by a local native static-web-server 2.38.0 on 127.0.0.1:4154. Every non-localhost request was aborted; the only attempted one was `api.github.com/.../releases/latest`, the version check. The payload `not a plan <b data-wasmer-marker="probe">marker</b>` (no script, handlers or URLs) was typed into `#planInput` and submitted with the form's submit button.
- Result: the "Couldn't parse plan" card was shown, and `[data-wasmer-marker]` count = 1 (a `B` element, text "marker"). `pre code` innerHTML is the payload verbatim, and textContent is "not a plan marker". **The plan text is reinterpreted as HTML.** Not tested, deliberately: any script-bearing or event-handler payload, and the file-drop/import paths.
- Correction: the earlier statement that the app is a good fit because it "runs entirely in the browser" stays true, but the deployment claim is withdrawn. Pasted or imported plan text (which may come from a third party, such as a shared plan file) is rendered as HTML in this branch.

**Verdict: HOLD (security).** Technical status: the Staticfile fix is proven (re-evaluated 2026-10-22). The lane A HOLD (output-dir mismatch, kept below as history) is resolved by a one-line root `Staticfile` with `root: dist-app`. This is the supported Anybuild mechanism: in a node-static project the Staticfile `root:` becomes `static_dir`, and install and build still run (`crates/anybuild/src/providers/node_static.rs:202-205`, `260-276`). The patched plan still says "Detected static Node.js provider" (`plan.txt`), not the copy-only StaticFile provider.

Remaining reviewer note: the patch is README plus a one-line `Staticfile`, so it is not documentation-only. The PR body says so up front.

## Repository and policy
- Pinned SHA: `e41d4e8b3006c479f9364d68a5d538d81cb7d110` (tag v1.25.0) on `master`, committed 2026-10-20. `master` is the default branch and the branch CI runs PRs against (`.github/workflows/build.yml`: `pull_request: branches: ["master"]`).
- Stars / forks: 3,606 / 200; not archived (GitHub API, 2026-10-22). Merged PRs since 2025-10-01: 110, including external contributors (for example #966 and #967 by dajiaohuang).
- License: PostgreSQL License (`LICENSE`; `package.json` `"license": "PostgreSQL license"`). Permissive.
- `CONTRIBUTING.md` covers only dev setup (npm ci, dev, build, lint, tests). It has no approval-first rule, AI or agent policy, or CLA. There is no PR template and no AGENTS.md. `.github/ISSUE_TEMPLATE` holds only issue templates. The workflows (build, release, visual_tests) have no auto-close bot.
- CI runs `npm run format` (`prettier --check .`). The patched README passes `prettier --check README.md` (run in the replay work dir, exit 0). `Staticfile` has no extension, so Prettier ignores it.
- Duplicate check: `wasmer repo:dalibo/pev2` returned 0 PRs. Prior "deploy" PRs: only #258 "Don't deploy automatically to gh-pages" (maintainer pgiraud, merged 2020). There were no third-party deploy-button PRs to learn from. Not in `static_excl.txt`.

## Anybuild detection (v0.33.0)
- Unpatched (`plan-unpatched.txt`, lane A): static Node.js, Vite, npm, output `dist`. `vite.config.ts:27` sets `outDir: "dist-app"` for the non-LIB build, so `dist` would be missing.
- Patched (`plan.txt`): static Node.js provider, Vite, npm, output directory `dist-app`.
  - install `npm install`; build `npm run build`; start `static-web-server --root=/opt/static_app --log-level=info --port=8080`.
  - Staged install inputs: `package.json` and `package-lock.json`; env `CI=true NPM_CONFIG_FUND=false`.

## Replay (patched clone): `replay.log`
- Node 24.22.1, npm 11.21.1.
- `npm install`: exit 0, 370 packages. Husky printed ".git can't be found" (non-fatal; no hooks disabled).
- `npm run build`: exit 0. vite 8.1.5 and vite-plugin-singlefile produced `dist-app/index.html` (1,308,080 bytes). `static_app` contains 1 file.
- Smoke on a local native static-web-server 2.38.0 (Wasmer's hosted WASI SWS 2.32.2 package not tested):
  - `/` returned 200 with title "Postgres EXPLAIN Visualizer 2 (pev2)".
  - `/nope` returned 404, as expected.
  - `/pev2.html` returned 404. That name is only the release asset; the build emits `index.html`, and the README patch doesn't mention it.
- Asset and route receipt (`asset-check-receipt.txt`, same build): the only `src`/`href` in index.html is a data-URI favicon, so there are no other local assets. `/` and `/index.html` returned 200; `/nope` and `/plan/node/1` returned 404. Absolute URLs in the bundle are links and SVG namespaces, plus `api.github.com` for the version check.
- Routes: no router. `Plan.vue:270,296` uses `window.location.hash` (`#plan/node/<id>`), which is client-only. This is single-URL and needs no fallback, so it works on any static host, including the hosted 2.32.2.
- Env and keys: no `import.meta.env` or `process.env` reads in `example/` or `src/` (besides the build-time `LIB` switch in vite.config). No keys. Data stays in IndexedDB (`example/src/idb.ts`) and localStorage.

## Security (`audit-receipt.txt`)
- `npm audit --omit=dev`: 0 vulnerabilities, so nothing known is shipped to the browser.
- Full audit: 8 (2 moderate, 6 high), all dev/build tooling (vite 8.0.0-8.1.5 dev-server advisories, braces, @vitest/mocker). None of it is shipped.
- (Audit run with host npm 10.9.4 against the replay's lockfile/node_modules.)

## Remaining checks for the reviewer
1. Verify the badge and import page in a browser; img.shields.io and wasmer.io are blocked here.
2. Optionally, after deploying, paste a sample plan and check the visualization renders.

---
## History: lane A triage (original text, superseded)
### dalibo/pev2: evidence (triage; no patch prepared)

**Verdict: HOLD (output-dir mismatch).** Anybuild v0.33.0 detects static Node.js/Vite and serves `dist` (plan.txt). This repo's app build writes elsewhere: `vite.config.ts` sets `outDir: "dist-app"` for the non-library build. `npm run build` (`vue-tsc --noEmit && vite build`) would therefore produce `dist-app/`, `dist` would be missing, and the deployment would serve nothing. I did not replay it, because the config is unambiguous; this is the same Anybuild limitation seen with mermaid-live-editor (111) and erd-editor (115): it does not read the framework's configured output directory. Fixing it needs a builder or config change, not a README PR.

## Facts
- Pinned SHA: `e41d4e8b3006c479f9364d68a5d538d81cb7d110` on `master` (2026-10-20). Stars / forks: 3,606 / 200 (GitHub API, 2026-10-22). License: PostgreSQL License.
- The app build is a single-file bundle (`vite-plugin-singlefile`, `inlineDynamicImports: true`) and is otherwise ideal for static hosting.
