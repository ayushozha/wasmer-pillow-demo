# Wasm static server: honest gap (2026-10-23)

Goal: capture the version and `--help` output of `wasmer/static-web-server@=1.1.0`, Wasmer's hosted static server, under Wasmer 7.5.0.

## What ran
- Downloaded `https://github.com/wasmerio/wasmer/releases/download/v7.5.0/wasmer-linux-amd64.tar.gz`: HTTP 200, 302,721,336 bytes.
  - Tarball sha256 `23f99818deaad93859f8bb8292af81f0c39f25aea19eaccfb72fc7c9e8a3fae9`.
  - Extracted `bin/wasmer`: sha256 `72c57ef6be45d500cb528c0a684b13159620ddfb4b50d3e429a3a352d0b3f116`.
  - `wasmer --version` printed `wasmer 7.5.0`.
- The official release-asset digest was NOT cross-checked. This session's GitHub API scope does not include wasmerio/wasmer.

## What could not run
- `wasmer run wasmer/static-web-server@=1.1.0 -- --version` exited 1, because registry.wasmer.io is unreachable from this container.
  - Raw output: `wasmer-run-static-web-server-1.1.0.txt`.
  - Reachability: `reachability.txt`. registry.wasmer.io, wasmer.io and cdn.wasmer.io return 000; GitHub release assets return 200.
- So no version or help output from the WASI package was captured here. No HTTP result in these receipts comes from the Wasm server.
- An earlier statement, from a separate environment, describes that package as SWS 2.32.2 for wasm32-wasmer-wasi with no page-fallback. It is NOT re-verified by these receipts.

## Consequence for every validation in this export
All HTTP checks were served by a local native static-web-server 2.38.0, the version Anybuild's plan pins. Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here.
