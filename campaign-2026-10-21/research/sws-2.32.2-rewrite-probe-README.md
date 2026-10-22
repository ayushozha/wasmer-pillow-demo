# SWS 2.32.2 rewrite probe: config to run against the wasm32-wasmer-wasi package

Files:
- `sws-2.32.2-spa-rewrite-probe-deep-only.toml`: rewrites only `/__wasmer_spa_probe__/deep` to `/index.html`, as root requested.
- `sws-2.32.2-spa-rewrite-probe.toml`: the worker's variant, which adds one separate exact nested route, `/__wasmer_spa_probe__/nested/route`.

Neither file has been run against any server yet; native results, if any, are added separately. Nothing here says anything about the Wasm build until root runs it.

Suggested Wasm run: the same mount as root's earlier probe, with the config file mounted next to the site. Root chooses the exact Wasmer invocation.
```
static-web-server --root /opt/static_app --config-file /opt/sws-probe.toml --host 127.0.0.1 --port 8080
```

Expected if rewrites are compiled into the package:

| Request | Expected result |
|---|---|
| `/__wasmer_spa_probe__/deep` | 200, body identical to `/index.html` |
| `/__wasmer_spa_probe__/other` | 404 |
| `/assets/nope.js` | 404 |
| an existing asset | 200 |
| `/` | 200 |

If `deep` still returns 404, or the config is rejected, rewrites are not usable on that package, and SPAs stay HELD_RUNTIME.
