# Browser-app lanes ledger — 2026-10-22

Prepare-only. Proof = exact Anybuild v0.33.0 flat replay + saved receipts, served by a *local native* static-web-server 2.38.0; Wasmer's hosted static server (wasmer/static-web-server 1.1.0 = SWS 2.32.2 WASI) was not tested. Browser behaviour is not proven unless a folder says so. Every target still needs root's live import-page/badge check.

## Qualified
| Folder | Repo | Stars | Verdict | Note |
|---|---|---|---|---|
| 201 | anvaka/city-roads | 9.8k | READY | client-side OSM roads → WebGL; runtime calls Nominatim/Overpass/author cache (disclosed); repo has never merged a PR |
| 203 | SeanWong17/Future-Style-Periodic-Table | 515 | READY | bundled data, no runtime calls; maintainer merged an outside deployment-docs PR; Chinese README text should get a native-speaker check |
| 107 | Yqnn/svg-path-editor | 5.3k | CONDITIONAL | ships upstream Google Analytics tag; Angular 17 (EOL) advisories reviewed |
| 109 | Bowen7/regex-vis | 4.4k | CONDITIONAL | `/samples` 404 on reload; Cloudflare analytics beacon |
| 202 | alexadam/printable-mockups | 537 | CONDITIONAL | 0 merged PRs ever; 1 low DOMPurify advisory shipped |
| 204 | lissy93/dashy | 26.8k | CONDITIONAL (leaning HOLD) | 3 third-party deploy-button PRs closed unmerged Aug–Oct 2026 (comments unreadable here — root to read); `/workspace`, `/minimal`, `/about` 404 on reload |
| 151 | viliusle/miniPaint | 3.5k | CONDITIONAL (policy) | owner closed deploy PRs #365/#434 — root to read comments |
| 154 | hydra-synth/hydra | 2.7k | CONDITIONAL | low activity; CDN-loaded libs; AGPL |
| 155 | aykutkardas/regexlearn.com | 4.1k | CONDITIONAL | hardcoded GTM; README sells logo placement (advert-objection risk) |

## Security / policy holds
152 piskel — **security HOLD**: local DOM probe confirmed `Template.sanitize` passes `"` so imported `.piskel` names / layer names add attributes (receipt-attr-probe.*). No disclosure made.
101 drawdb (owner declined buttons, PR #57) · 104 CyberChef (CLA + AGENTS.md) · 105 jsoncrack (issue-first; next 16.3.5 advisories) · 153 svgedit (issue/discussion first) · 208 tints-and-shades (issue first) · 102 chartdb (CLA unresolved + history routes).
116 pev2 — pending root-requested `v-html="planSource"` DOM probe before any verdict.

## Builder holds (see each evidence.md)
103 it-tools, 113 omni-tools (history routes) · 106 squoosh, 112 excalidraw, 114 svgomg (Node provider/dev-server start) · 110 cssgridgenerator, 111 mermaid-live-editor, 115 erd-editor (output-dir/Node fixes being tested) · 108 oklch-picker (fit/analytics) · 156 learnGitBranching (`generate` beats `build`) · 157 VERT (required PUB_* env) · 158 mini-qr, 205 rawgraphs, 206 maputnik (`.npmrc` not staged) · 207 llm-viz (Yarn 4 not pinned, `.yarnrc.yml` not staged) · 159 markdown-online-editor, 209 maptoposter-online (FAIL_ENV: blocked mirrors/CDN) · 160 bentopdf (detected as VitePress docs; CLA) · 161 reveal.js, 162 doocs/md, 163 BassoonTracker (library/monorepo/no index).

## Anybuild v0.33.0 issues found by these lanes (for wasmerio)
- `.npmrc`, `.yarnrc.yml`, `pnpm-workspace.yaml` never staged before install (install_context.rs:124, node.bzl:95-140) → ERESOLVE / catalog / PnP failures.
- Yarn version floats (`packageManager: yarn@4` ignored); pnpm `packageManager` pin can disable the allow-all-builds env.
- `generate` script preferred over `build` (node_static.rs:902-907).
- Output dir hard-coded (Vite `dist`, SvelteKit `build`); Vite `outDir`, adapter-static `pages`, monorepo app paths ignored (Staticfile `root:` works as an output-dir override on node-static repos).
- No heap setting (chartdb OOM at default heap); lifecycle scripts can't see repo files during staged install.
- Builds without a recognised framework fall to the Node provider with no static output.
- next-bundle@1.0.0: drops pnpm symlinks, can't resolve Turbopack hashed externals, `require()`s edge bundles (ES-module error) — see campaign-apps-2026-10-21/08-*/security-remediation.
