# Batch B ledger (apps/starters) — 2026-10-22

Stars/forks: GitHub API 2026-10-22. SHA = pinned upstream HEAD (full SHA in each `evidence.md`). Builder = Wasmer Anybuild v0.33.0 (`wasmerio/shipit` tag `v0.33.0` @587be231, the version production pins). No PRs opened, no deployments, no real keys. Wasmer hosts and img.shields.io are blocked from the cloud container, so **every** target still needs the create-URL check in a browser (detection + badge render).

| # | Repo | Stars / forks | SHA | Verdict | Local build / smoke | Blocker or remaining check |
| --- | --- | --- | --- | --- | --- | --- |
| 01 | ChatGPTNextWeb/NextChat | 88,881 / 58,757 | 1d3dc3315129 | HOLD | yarn build 0 (lockfile mirror hosts rewritten in build copy only); CODE gate 401/401/200; streaming via local mock | `app/config/server.ts:122-126` logs selected provider key, `auth.ts:35-38` logs access code; builder's Yarn path is Berry-only but repo is Yarn 1; history of rejected third-party button PRs |
| 02 | steven-tey/precedent | 5,114 / 493 | 3be40205d7cd | CONDITIONAL | pnpm build 0; `/` 500 without Clerk keys, 200 with placeholders | needs real Clerk dev keys checked on Wasmer; inactive since 2024-10, Next canary |
| 03 | Nutlope/turboseek | 1,658 / 261 | 9e16b401d559 | CONDITIONAL | build fails without keys; 0 with placeholder TOGETHER/EXA keys; `/` 200 | Wasmer must accept env vars before the first build; README describes old Bing search |
| 04 | Nutlope/llamatutor | 2,053 / 342 | 5b88de25bccd | READY | build 0 with no env; next-bundle build 0; `/` 200 | create-URL check only; no license file |
| 05 | Nutlope/blinkshot | 1,040 / 192 | e730e2a9dfd9 | READY | build 0 with no env; `/` 200; API 403/400 without keys | create-URL check only; no license file |
| 06 | Nutlope/roomGPT | 10,690 / 1,494 | 611398c78da6 | CONDITIONAL | npm ci + build 0; `/`, `/dream` 200 (Node 22) | builder default Node 24 + `npm install` untested with Next 13.4.4; 20 npm vulns (2 critical) |
| 07 | once-ui-system/magic-portfolio | 1,416 / 935 | 76ae5e33e975 | CONDITIONAL | npm build/start 200; protected route 401/200 | `/api/rss` 404 under next-bundle emulation; CC BY-NC 4.0 (wording added); base `preview`; password gate is client-side only |
| 08 | magicuidesign/portfolio | 1,516 / 432 | 5ef12e4c8bd0 | READY | pnpm build/start + next-bundle serve 200 | create-URL check only |
| 09 | transitive-bullshit/nextjs-notion-starter-kit | 7,033 / 5,641 | e787e7b594f1 | CONDITIONAL | install 0, build 1 (Notion unreachable here) | build on a network-enabled machine; sharp/lqip-modern on Wasmer |
| 10 | slimphp/Slim-Skeleton | 1,621 / 471 | 0ef01549870b | CONDITIONAL | composer --no-dev 0; `/` `/users` `/users/1` 200, 404/405 JSON | confirm PHP detection + `public/` docroot on live import; `logs/` writability on Wasmer not verified (README gives stdout alternative); base `main` |
| 11 | laravel/laravel | 85,232 / 27,626 | 9ffef3bc4241 | HOLD | composer 0; default `/` 500 (no SQLite file), 200 with cookie/array drivers | maintainers close vendor deploy PRs (#6179 etc.); stateful defaults; no patch staged |
| 12 | streamlit/llm-examples | 936 / 1,711 | 7cf260745675 | CONDITIONAL | pip 0 + `pytest app_test.py` 2 passed (mocked) on Py 3.13 and 3.11; health 200 | `Chatbot.py` not auto-detected (`python.rs:655-680`); needs start-command / `ANYBUILD_PYTHON_MAIN_FILE` override on create page, else HOLD |
| 13 | streamlit/streamlit-example | 440 / 24,528 | 8bd2197e4ba6 | READY | pip 0 Py 3.13; health 200; AppTest no exceptions | create-URL check; Streamlit-owned repo, acceptance risk |
| 14 | timlrx/tailwind-nextjs-starter-blog | 10,560 / 2,596 | b45bef66b40c | HOLD | yarn build + `yarn serve` 200, feed/sitemap OK | builder: `.yarnrc.yml` not in install inputs (PnP), `yarn dlx next-bundle` misdetects, `trailingSlash` 308 loop — report to wasmerio |
| 15 | ixartz/Next-JS-Landing-Page-Starter-Template | 2,140 / 716 | cd6694e6c69e | CONDITIONAL | npm build/start 200 | `next start`: unknown path 404; under Wasmer's next-bundle build/serve unknown paths 308-loop (`trailingSlash`), noted in Limitations; README's `out/` text is stale (no static export) |
| 16 | cruip/open-react-template | 4,712 / 2,088 | 9da36763df21 | HOLD | build log only | README: "please don't republish, redistribute, or resell the template" |
| 17 | arthelokyo/tailnext | 431 / 161 | bad459314c91 | CONDITIONAL | prettier/lint/typecheck/build/start OK; `/_next/image` 200 locally | sharp on Wasmer; next-bundle's image optimizer returned a 147 KB WebP vs 9.8 KB under `next start` and accepted q=80 |
| 18 | vercel/nextjs-portfolio-starter | 730 / 302 | 90cfee0f74c2 | HOLD | yarn frozen install + `yarn build` 0; `/`, post, `feed.xml` 200 | builder's generated `yarn dlx next-bundle` fails ("target project does not declare a next dependency", next-bundle `bin/build.mjs:54-57` uses `INIT_CWD`); Vercel-owned, inactive since 2023; patch staged anyway |
| 19 | codebucks27/Next.js-Developer-Portfolio-Starter-Code (replaces 11) | 1,351 / 664 | b6f8ee2d3a75 | HOLD | npm install/build/start + next-bundle 200 | repo is stock create-next-app page, not the portfolio; no LICENSE; no lockfile |

Excluded per brief: vercel/commerce, Chanzhaoyu/chatgpt-web, shadcn-ui/next-template, langchain-ai/streamlit-agent (archived), httpbin, symfony/demo. Other replacements (mldangelo/personal-site, m4tt72/terminal, TailAdmin/free-react-tailwind-admin-dashboard) are static-export targets left to the static session to avoid duplicates.

Duplicate check: GitHub PR search `wasmer` across all targets → 0 (2026-10-22).

## Wasmer builder issues found (worth reporting to wasmerio, not upstream)

- Yarn + Next.js: `yarn dlx next-bundle@1.0.0` resolves the project from `INIT_CWD`, which is the dlx temp folder → "target project does not declare a next dependency" (18, 14).
- Yarn Berry repos: `.yarnrc.yml` is not among install inputs (`node.rs:1782` overwrites them) → PnP install, build fails (14). Yarn 1 repos get Berry-only commands (01).
- `trailingSlash: true` → unknown paths 308-loop under `node .next-bundle/server.mjs` (14, 15).
- next-bundle image optimizer ignores `images.qualities` and returned much larger output than `next start` (17).
- Streamlit entry file only detected by fixed names (`python.rs:655-680`) (12).
- Builder ignores `engines`/`.nvmrc`; Node 24 default (06 old Next 13 untested on 24).

Local `anybuild` v0.33.0 CLI was built from source and `anybuild plan` was run on 15–18 (binary at scratchpad `w/anybuild-v0.33.0`, not committed).
