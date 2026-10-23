# Inventory of exports on this branch (2026-10-23)

This lists only the public-safe exports on this branch. Patch hashes are in each folder's `RECEIPTS.md` and in the wave `README.md` tables.

All HTTP results were served with a local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here). Publication is paused by root (GitHub fork rate limit), and nothing here was published by Claude.

## READY (new PR candidates)
| Target | Folder |
|---|---|
| themeselection/sneat-bootstrap-html-admin-template-free | `exports-2026-10-23-validation/export-69-…` (root publishes first) |
| yaoyao-liu/minimal-light | `exports-2026-10-23-wave2/export-30-…` |
| estevanmaito/windmill-dashboard | `exports-2026-10-23-wave2/export-51-…` |
| Bowen7/regex-vis (with `/samples` routing fix) | `exports-2026-10-23-wave2/export-109-…` |
| barryclark/jekyll-now (with feed/sitemap plugin fix) | `exports-2026-10-23-wave2/export-23-…` |
| markhorn-dev/astro-sphere | `exports-2026-10-23-wave2/export-09-…` (critical applicability: not HOLD) |
| mhyfritz/astro-landing-page | `exports-2026-10-23-wave2/export-11-…` (critical applicability: not HOLD) |
| treefarmstudio/odyssey-theme | `exports-2026-10-23-wave2/export-70-…` (critical applicability: not HOLD) |
| Fechin/reference | `exports-2026-10-23-wave3/export-301-…` |
| ubaimutl/react-portfolio | `exports-2026-10-23-wave3/export-303-…` |

## READY (follow-ups to existing PRs; root commits to the same PR branch)
| PR | Folder |
|---|---|
| mermaid-js/mermaid-live-editor PR 2082: `Anybuild` correction (no catch-all) | `exports-2026-10-23-validation/mermaid-pr2082-anybuild-correction/` |
| FreezingMoon/AncientBeast: trailing-space follow-up | `exports-2026-10-23-validation/255-ancientbeast-trailing-space-fix/` |

## CONDITIONAL (root decision needed)
| Target | Open item |
|---|---|
| Yqnn/svg-path-editor | No critical ships. 12 high advisories in shipped Angular 17.3.12 are not reachable by another party's input and are disclosed. Root must accept that. |
| coreui/coreui-free-react-admin-template | The repo's `.cursorrules` forbids AI-created files outside `src/`, and the patch must add a root `Staticfile`. `npm run lint` exits 0 but does not cover the changed files. |

## HELD
| Target | Reason |
|---|---|
| sadanandpai/frontend-mini-challenges | The PR template requires an issue number. A tested draft is kept. |
| epicmaxco/vuestic-admin | The repo's `_redirects` `/* /index.html 200` is rejected by Anybuild 0.33.0, and the history router has 13+ routes. |
| themesberg/flowbite-admin-dashboard | Upstream `build:webpack` fails (postcss-calc versus Tailwind 4), and Hugo `publishDir` is not read. A candidate diff is kept. |
| PgTune | Held by root after an indeterminate result on the exact WASI package. That result is not claimed here as a hosted failure. |

## Validations of existing PRs (receipts only)
- astrowind PR 744: the head was verified here, but this container could not build it (remote hosts blocked; a dev-server UI check only). Root built it successfully on Windows.
- excalidraw PR 12417: the head builds from its committed `Anybuild`, and 380/380 HTTP checks pass.
- Wasm runtime gap: `wasmer/static-web-server@=1.1.0` cannot be fetched from this container.
