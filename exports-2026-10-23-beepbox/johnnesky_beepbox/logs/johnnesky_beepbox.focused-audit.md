# johnnesky/beepbox focused audit (coordinator, 2026-10-23), exact lock

Raw input: `johnnesky_beepbox.npm-audit-exact-lock.critical-high.json`, which is the `npm audit --package-lock-only --json` output for the exact lock, filtered to critical and high entries. Dependency paths come from `package-lock.json`. Command execution comes from `package.json` scripts and `scripts/*.sh`. Bundle contents come from the production sourcemaps of `npm ci && npm run build` on the exact lock.

- Commit 39893e3 (base 355e510 plus README/Anybuild); package-lock.json sha256 3bb9866c05537544546a18f2914c6a402717cc5553a546ad8159319b3937570a.
- `npm audit --package-lock-only` (npm 11.19.1): 26 findings: 2 critical, 13 high, 7 moderate, 4 low. The package has no `dependencies`; all are devDependencies.

## Criticals: dependency path, execution, applicability

| Package@locked | Advisory | Path | Executed by | Executed in Wasmer build (`npm install`, then `npm run build`)? | Shipped? |
|---|---|---|---|---|---|
| proxy-addr@2.0.7 | [GHSA-jqcg-44mw-7w3h](https://github.com/advisories/GHSA-jqcg-44mw-7w3h) (IP spoofing, trust subnet) | five-server > express6 > proxy-addr | `npx five-server` in scripts/live_editor.sh and live_editor_fast_typeless.sh (`npm run live-editor*`): a local dev server | No. The build scripts (clean/compile_synth/compile_player/compile_editor) run only tsc, rollup and terser. Installed only, with no install script. | No |
| shell-quote@1.8.1 | [GHSA-w7jw-789q-3m8p](https://github.com/advisories/GHSA-w7jw-789q-3m8p) (quote() newline), [GHSA-395f-4hp3-45gv](https://github.com/advisories/GHSA-395f-4hp3-45gv) (parse() quadratic DoS) | concurrently > shell-quote | `npx concurrently` in the same live_editor scripts | No. Installed only, with no install script. | No |

## Highs that do run in the production build

| Package@locked | Advisory | Use in the build | Untrusted input? | Effect on output |
|---|---|---|---|---|
| rollup@2.79.1 (direct) | [GHSA-gcx4-mw62-g8wm](https://github.com/advisories/GHSA-gcx4-mw62-g8wm) (DOM clobbering gadget in bundled output) | Bundles to iife | n/a | The gadget relies on `document.currentScript` / `import.meta` resolution. The built editor, synth and player min.js contain 0 `currentScript` and 0 `import.meta`. |
| rollup@2.79.1 (direct) | [GHSA-mw96-cpmx-2vgc](https://github.com/advisories/GHSA-mw96-cpmx-2vgc) (path traversal, arbitrary file write) | Fixed --file outputs from scripts/*.sh | Input is the repository's own source; there are no untrusted chunk names | None. Build-time only. |
| picomatch@2.3.1 | [GHSA-3v7f-55p6-f55p](https://github.com/advisories/GHSA-3v7f-55p6-f55p), [GHSA-c2c7-rcm5-vvqj](https://github.com/advisories/GHSA-c2c7-rcm5-vvqj) | Via @rollup/pluginutils (rollup plugins) | Fixed patterns from the plugins | Build-time only |

All other highs (braces, chokidar, five-server, glob, cross-spawn, minimatch, brace-expansion, node-forge, path-to-regexp, ws, lodash) are reachable only through five-server (the dev server) or concurrently (the dev task runner). Neither runs in `npm run build`.

## What ships (production bundles, `npm ci` + `npm run build` on the exact lock)

- beepbox_editor.min.js.map: 51 sources; the only npm package is imperative-html (no advisory).
- beepbox_synth.min.js.map: 5 sources; no npm packages.
- player/beepbox_player.min.js.map: 9 sources; the only npm package is imperative-html.
- Packages with install scripts in the lock: esbuild, fsevents only. None of the flagged packages runs code at install.

## Conclusion

Neither critical is executed by the Wasmer build path or shipped to visitors. Both are reachable only through `npm run live-editor*` on a developer machine. The production-build highs are rollup and picomatch: rollup's DOM-clobbering gadget is absent from the output, and the remaining issues need untrusted build inputs, which the builder does not take (it builds the repository's own source).

## All critical and high entries: path and execution (exact lock)

| Package@locked | Severity | Advisories | Dependency path(s) (lockfile) | Top-level dev tool / where it runs | Runs in `npm run build`? |
|---|---|---|---|---|---|
| proxy-addr@2.0.7 | critical | [GHSA-jqcg-44mw-7w3h](https://github.com/advisories/GHSA-jqcg-44mw-7w3h) | five-server > express6 > proxy-addr | `npx five-server` in scripts/live_editor.sh, live_editor_fast_typeless.sh (`npm run live-editor*`) | No |
| shell-quote@1.8.1 | critical | [GHSA-w7jw-789q-3m8p](https://github.com/advisories/GHSA-w7jw-789q-3m8p), [GHSA-395f-4hp3-45gv](https://github.com/advisories/GHSA-395f-4hp3-45gv) | concurrently > shell-quote | `npx concurrently` in the same live_editor scripts | No |
| brace-expansion@2.0.1 | high | [GHSA-v6h2-p8h4-qcjw](https://github.com/advisories/GHSA-v6h2-p8h4-qcjw), [GHSA-f886-m6hf-6m8v](https://github.com/advisories/GHSA-f886-m6hf-6m8v), [GHSA-3jxr-9vmj-r5cp](https://github.com/advisories/GHSA-3jxr-9vmj-r5cp), [GHSA-mh99-v99m-4gvg](https://github.com/advisories/GHSA-mh99-v99m-4gvg), [GHSA-rgw5-rvv9-x895](https://github.com/advisories/GHSA-rgw5-rvv9-x895), [GHSA-q2hr-2g5m-vwhr](https://github.com/advisories/GHSA-q2hr-2g5m-vwhr), [GHSA-qhr7-859c-m2p7](https://github.com/advisories/GHSA-qhr7-859c-m2p7), [GHSA-6j4f-fj2g-mc7p](https://github.com/advisories/GHSA-6j4f-fj2g-mc7p) | five-server > html-validate > glob > minimatch > brace-expansion | `npx five-server` in scripts/live_editor.sh, live_editor_fast_typeless.sh (`npm run live-editor*`) | No |
| braces@3.0.3 | high | [GHSA-vfj7-8cjw-p6xm](https://github.com/advisories/GHSA-vfj7-8cjw-p6xm) | five-server > chokidar > braces | `npx five-server` in scripts/live_editor.sh, live_editor_fast_typeless.sh (`npm run live-editor*`) | No |
| chokidar@3.6.0 | high | via braces | five-server > chokidar | `npx five-server` in scripts/live_editor.sh, live_editor_fast_typeless.sh (`npm run live-editor*`) | No |
| cross-spawn@7.0.3 | high | [GHSA-3xgq-45jj-v275](https://github.com/advisories/GHSA-3xgq-45jj-v275) | five-server > html-validate > glob > foreground-child > cross-spawn | `npx five-server` in scripts/live_editor.sh, live_editor_fast_typeless.sh (`npm run live-editor*`) | No |
| five-server@0.3.3 | high | via chokidar, express6 | five-server | `npx five-server` in scripts/live_editor.sh, live_editor_fast_typeless.sh (`npm run live-editor*`) | No |
| glob@10.4.5 | high | [GHSA-5j98-mcp5-4vw2](https://github.com/advisories/GHSA-5j98-mcp5-4vw2) | five-server > html-validate > glob | `npx five-server` in scripts/live_editor.sh, live_editor_fast_typeless.sh (`npm run live-editor*`) | No |
| lodash@4.17.21 | high | [GHSA-r5fr-rjxr-66jc](https://github.com/advisories/GHSA-r5fr-rjxr-66jc), [GHSA-f23m-r3pf-42rh](https://github.com/advisories/GHSA-f23m-r3pf-42rh), [GHSA-xxjr-mmjv-4gpg](https://github.com/advisories/GHSA-xxjr-mmjv-4gpg) | concurrently > lodash | `npx concurrently` in the same live_editor scripts | No |
| minimatch@9.0.5 | high | [GHSA-3ppc-4f35-3m26](https://github.com/advisories/GHSA-3ppc-4f35-3m26), [GHSA-7r86-cg39-jmmj](https://github.com/advisories/GHSA-7r86-cg39-jmmj), [GHSA-23c5-xmqv-rm74](https://github.com/advisories/GHSA-23c5-xmqv-rm74) | five-server > html-validate > glob > minimatch | `npx five-server` in scripts/live_editor.sh, live_editor_fast_typeless.sh (`npm run live-editor*`) | No |
| node-forge@1.3.1 | high | [GHSA-554w-wpv2-vw27](https://github.com/advisories/GHSA-554w-wpv2-vw27), [GHSA-5gfm-wpxj-wjgq](https://github.com/advisories/GHSA-5gfm-wpxj-wjgq), [GHSA-65ch-62r8-g69g](https://github.com/advisories/GHSA-65ch-62r8-g69g), [GHSA-2328-f5f3-gj25](https://github.com/advisories/GHSA-2328-f5f3-gj25), [GHSA-q67f-28xg-22rw](https://github.com/advisories/GHSA-q67f-28xg-22rw), [GHSA-5m6q-g25r-mvwx](https://github.com/advisories/GHSA-5m6q-g25r-mvwx), [GHSA-ppp5-5v6c-4jwp](https://github.com/advisories/GHSA-ppp5-5v6c-4jwp), [GHSA-86w9-cpqp-85rv](https://github.com/advisories/GHSA-86w9-cpqp-85rv) | five-server > selfsigned > node-forge | `npx five-server` in scripts/live_editor.sh, live_editor_fast_typeless.sh (`npm run live-editor*`) | No |
| path-to-regexp@0.1.8 | high | [GHSA-9wv6-86v2-598j](https://github.com/advisories/GHSA-9wv6-86v2-598j), [GHSA-rhx6-c78j-4q9w](https://github.com/advisories/GHSA-rhx6-c78j-4q9w), [GHSA-37ch-88jc-xwx2](https://github.com/advisories/GHSA-37ch-88jc-xwx2) | five-server > express6 > path-to-regexp | `npx five-server` in scripts/live_editor.sh, live_editor_fast_typeless.sh (`npm run live-editor*`) | No |
| picomatch@2.3.1 | high | [GHSA-3v7f-55p6-f55p](https://github.com/advisories/GHSA-3v7f-55p6-f55p), [GHSA-c2c7-rcm5-vvqj](https://github.com/advisories/GHSA-c2c7-rcm5-vvqj) | @rollup/plugin-node-resolve > @rollup/pluginutils > picomatch<br>rollup-plugin-sourcemaps > @rollup/pluginutils > picomatch<br>five-server > chokidar > anymatch > picomatch | rollup plugin in `npm run build`; `npx five-server` in scripts/live_editor.sh, live_editor_fast_typeless.sh (`npm run live-editor*`); rollup plugin in `npm run build` | Yes |
| rollup@2.79.1 | high | [GHSA-gcx4-mw62-g8wm](https://github.com/advisories/GHSA-gcx4-mw62-g8wm), [GHSA-mw96-cpmx-2vgc](https://github.com/advisories/GHSA-mw96-cpmx-2vgc) | rollup | `npx rollup` in scripts/compile_*.sh (`npm run build`) | Yes |
| ws@8.18.0 | high | [GHSA-58qx-3vcg-4xpx](https://github.com/advisories/GHSA-58qx-3vcg-4xpx), [GHSA-96hv-2xvq-fx4p](https://github.com/advisories/GHSA-96hv-2xvq-fx4p) | five-server > ws | `npx five-server` in scripts/live_editor.sh, live_editor_fast_typeless.sh (`npm run live-editor*`) | No |

Untrusted-input conditions for the build-time entries:
- rollup GHSA-gcx4-mw62-g8wm needs the bundle to resolve `import.meta.url` / `document.currentScript` in an attacker-influenced DOM; the built bundles contain neither.
- rollup GHSA-mw96-cpmx-2vgc needs attacker-controlled chunk or file names. The build uses fixed `--file` outputs over the repository's own source.
- picomatch needs attacker-controlled glob patterns; the plugins use fixed patterns.
- None of these packages is in the production bundles (see the sourcemap check above).
