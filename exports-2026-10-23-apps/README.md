# Deploy to Wasmer — prepared app integrations (export 2026-10-23)

Public, allowlisted export of three prepared upstream PRs. Each folder holds the exact Claude-authored `upstream.patch` (apply with `git apply` on the pinned commit), `PR_TITLE.txt`, `PR_BODY.md` (starts with the black Deploy to Wasmer button), `RECEIPTS.md` (pin, licence, contribution policy, hooks, build/runtime results) and the raw build/smoke receipts. `SHA256SUMS` covers every file.

| Folder | Repo | Status |
|---|---|---|
| 201-anvaka__city-roads | anvaka/city-roads | CLEARED (README only) |
| 202-alexadam__printable-mockups | alexadam/printable-mockups | CONDITIONAL (no outside PR ever merged) |
| 255-FreezingMoon__AncientBeast | FreezingMoon/AncientBeast | CLEARED (README + `Staticfile`) |

Proof method: exact local replay of what Wasmer's builder (Anybuild v0.33.0) generates — plan, staged install, build — then serving the output with a local native static-web-server 2.38.0. Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested; badge rendering and the import page are checked separately by the publisher. No deployments were made.
