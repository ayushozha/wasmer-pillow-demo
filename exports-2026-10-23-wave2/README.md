# Wave 2 exports (2026-10-23)

These targets were prepared earlier. Each one has now had a fresh exact-source clone, a policy re-read, an all-state duplicate check over `refs/pull/*/head` (git only, no API) and a targeted compatibility review. All HTTP results were served with a local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here). Each folder's `RECEIPTS.md` is the entry point.

| Folder | HEAD | Verdict | upstream.patch sha256 |
|---|---|---|---|
| `export-51-estevanmaito__windmill-dashboard/` | `e05267588134ca2f4129087cc65a59c38a9c36b5` | READY. Low maintainer activity (last commit 2020-08-05) and Chart.js 2.9.3 (high advisory GHSA-h68q-55jf-x68w, no user input reaches chart options in the demo) are disclosed. | `7f54f49c4e5fc9066421392f06c06efae4b0aa772e9d4277987f5b40d60394cc` |
