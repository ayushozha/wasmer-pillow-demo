# Wave 2 exports (2026-10-23)

These targets were prepared earlier. Each one has now had a fresh exact-source clone, a policy re-read, an all-state duplicate check over `refs/pull/*/head` (git only, no API) and a targeted compatibility review. All HTTP results were served with a local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here). Each folder's `RECEIPTS.md` is the entry point.

| Folder | HEAD | Verdict | upstream.patch sha256 |
|---|---|---|---|
| `export-51-estevanmaito__windmill-dashboard/` | `e05267588134ca2f4129087cc65a59c38a9c36b5` | READY. Low maintainer activity (last commit 2020-08-05) and Chart.js 2.9.3 (high advisory GHSA-h68q-55jf-x68w, no user input reaches chart options in the demo) are disclosed. | `7f54f49c4e5fc9066421392f06c06efae4b0aa772e9d4277987f5b40d60394cc` |
| `export-23-barryclark__jekyll-now/` | `12cb8a2e97c3b63c4bc92d2a1ab050b35bf946b7` | CONDITIONAL. With no Gemfile, Anybuild uses Jekyll 4.3, which ignores the old `gems:` key, so `/feed.xml` and `/sitemap.xml` 404 even though every page links the feed (disclosed). The README invites opening an issue first; that reads as a suggestion, so a reviewer decides. Inactive since 2018. | `072145ac72efb039b47e7db8b11c99c16069ddcf4a12c337b3067d099b24bacb` |
| `export-30-yaoyao-liu__minimal-light/` | `dd114c3fef2d97adc1c6b6d46901e0d96ab83a7c` | READY. No Gemfile.lock, so versions float at build time. The default `_config.yml` ships the template author's GA ID; both are disclosed. | `af6663e45fed5d9bb5980cf6e2dfabc8304fa49846a4a8e2e10240ba38bedf8f` |

`tools/` holds the duplicate-check and HTTP scripts used for 23 and 30.
