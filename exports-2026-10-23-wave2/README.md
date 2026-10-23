# Wave 2 exports (2026-10-23)

These targets were prepared earlier. Each one has now had a fresh exact-source clone, a policy re-read, an all-state duplicate check over `refs/pull/*/head` (git only, no API) and a targeted compatibility review. All HTTP results were served with a local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here). Each folder's `RECEIPTS.md` is the entry point.

| Folder | HEAD | Verdict | upstream.patch sha256 |
|---|---|---|---|
| `export-51-estevanmaito__windmill-dashboard/` | `e05267588134ca2f4129087cc65a59c38a9c36b5` | READY. Low maintainer activity (last commit 2020-08-05) and Chart.js 2.9.3 (high advisory GHSA-h68q-55jf-x68w, no user input reaches chart options in the demo) are disclosed. | `7f54f49c4e5fc9066421392f06c06efae4b0aa772e9d4277987f5b40d60394cc` |
| `export-23-barryclark__jekyll-now/` | `12cb8a2e97c3b63c4bc92d2a1ab050b35bf946b7` | CONDITIONAL. With no Gemfile, Anybuild uses Jekyll 4.3, which ignores the old `gems:` key, so `/feed.xml` and `/sitemap.xml` 404 even though every page links the feed (disclosed). The README invites opening an issue first; that reads as a suggestion, so a reviewer decides. Inactive since 2018. | `072145ac72efb039b47e7db8b11c99c16069ddcf4a12c337b3067d099b24bacb` |
| `export-30-yaoyao-liu__minimal-light/` | `dd114c3fef2d97adc1c6b6d46901e0d96ab83a7c` | READY. No Gemfile.lock, so versions float at build time. The default `_config.yml` ships the template author's GA ID; both are disclosed. | `af6663e45fed5d9bb5980cf6e2dfabc8304fa49846a4a8e2e10240ba38bedf8f` |
| `export-09-markhorn-dev__astro-sphere/` | `f7e3a40f20e1267d7fbbb7b6dd868df1845e1d82` | READY. Badge sits next to the existing Vercel/Netlify buttons. `site` points at the Vercel demo (disclosed). | `287158c467fd5bd54966bda38b958a05c9ea7be0084baa6202d77770f894f9d6` |
| `export-11-mhyfritz__astro-landing-page/` | `987617a50863d31bb865ee531391a191d74a878a` | READY. Single page; `og:` URLs point at the Netlify demo (disclosed). | `fcac9d9243aa2f5591211a447d10994f2105371586869c9426c52e78d8cf9c28` |
| `export-70-treefarmstudio__odyssey-theme/` | `d191e5715a2519e25be4629b933189c421b30a1a` | READY. Contact and newsletter forms POST to paths a static host answers with 405, and the repo's Deno Deploy workflow may fail on fork PRs (both disclosed). | `fb7b517ce8c54229707a980d0fbef4625397e1e8fab3b5c5ed12c81d7a9a16c1` |
| `export-107-Yqnn__svg-path-editor/` | `937d75a83b6be2bdda11d02b9b3594841315223a` | READY. Built HTML keeps the maintainer's Google Analytics tag `G-1BBJSPSKQ9`, so self-hosted copies report to it (disclosed; whether to keep it is the maintainer's call). Icon font comes from fonts.gstatic.com. | `611f7f466dfc495655cfdad0ec43301e4a9ce53289bef2e18628a7852b0254c8` |
| `export-109-Bowen7__regex-vis/` | `a6d920601ca44ab2d4e9cd02306510ab6d5e4b38` | READY. `pnpm test` (CONTRIBUTING) exits 0, 53 tests. `/` and `/?r=…` work on direct load. `/samples` 404s on direct load or reload; it works only through in-app navigation, and is a secondary page linked from the header. Cloudflare beacon disclosed. | `5a4923f6aa8ac0c3b254d1734adec0603dee4f3b96a61ce109f17e361dac7133` |

`tools/` holds the duplicate-check and HTTP scripts used for 23 and 30.

README wording note for 09/11/70: these patches add only the badge line. The button explanation is in the PR body, not the README. If the standard README sentence is required in the README too, add it before publishing.

`tools-astro/` holds the scripts used for 09, 11 and 70.
