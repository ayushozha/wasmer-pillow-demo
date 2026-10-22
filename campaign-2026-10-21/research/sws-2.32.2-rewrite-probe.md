# SWS 2.32.2 `[[advanced.rewrites]]` SPA probe (native only)

Status: **native x86_64 evidence only. Every history-router SPA stays HELD_RUNTIME until root reports the result against the actual WASI package.**

> **Scope statement.** Everything below was measured with a *native* `static-web-server 2.32.2` built from crates.io for `x86_64-unknown-linux-gnu`. It says **NOTHING** about the `wasmer/static-web-server@=1.1.0` package (SWS 2.32.2 built for `wasm32-wasmer-wasi`). Whether that build compiles in rewrites, resolves the config path inside the WASI sandbox, or behaves the same is **untested**.

Files:
- Config: `campaign-2026-10-21/research/sws-2.32.2-spa-rewrite-probe.toml` (sha256 `a10e5a030598d08c1bc98a3e6375d7cd449aaf2a74b5428d2f52f32a9bdddf63`)
- Log: `campaign-2026-10-21/logs/sws-2.32.2-rewrite-probe.log`

## 1. Primary sources (tag `v2.32.2`, commit `e61c97e76fcd2ae3b4c9e4133ff145a16bc6eb04`)

Cloned with `git clone --depth 1 --branch v2.32.2 https://github.com/static-web-server/static-web-server.git`.

| What | Where | Finding |
|---|---|---|
| Structure | `docs/content/features/url-rewrites.md` L9-15 | Rules are a TOML array of tables; keys `source` (glob), `destination`, optional `redirect`. |
| Glob engine | same, L22-27 | `source` is a globset (Unix-style) pattern matched against the request URI path. |
| Destination | same, L31, L45-47 | A relative URL (e.g. `/some/directory/file.html`) or absolute URL. **Without `redirect`, SWS does an internal rewrite**: it serves the file at the destination URL path (resolved under `--root`); no 3xx is sent. L14 calls it a "file path", but L31 and the code treat it as a URL path. |
| Redirect codes | same, L75-81 | `redirect` only takes `301` or `302`. Leaving it out means internal rewrite (200). |
| Config file syntax | `docs/content/configuration/config-file.md` L5, L101, L136-146 | Turned on with `-w, --config-file` or `SERVER_CONFIG_FILE`. `[advanced]` plus `[[advanced.rewrites]]` examples. |
| Precedence | same, L176-178 | Options in the file take precedence over CLI/ENV. The probe has no `[general]` section, so `--root/--host/--port` come from the CLI. |
| Missing file | same, L7-9; `src/settings/mod.rs` L669-681; `src/server.rs` L149-155 | If the config path is not a regular file, it is **silently ignored**: there is only a DEBUG line, `config file path not found or not a regular file`. When the file loads, an INFO line appears: `config file used: <path>`. |
| TOML struct | `src/settings/file.rs` L141-151 (`Rewrites {source, destination, redirect: Option<RedirectsKind>}`), L163-175 (`Advanced {headers, rewrites, redirects, virtual_hosts}`), L117-125 (`RedirectsKind` 301/302) | These are the keys that exist in 2.32.2. |
| Compilation | `src/settings/mod.rs` L441-487 | Each `source` goes through `Glob::new(..).compile_matcher()`, then to a regex (`(?-u)` stripped), and is logged at DEBUG as `url rewrites regex equivalent`. A literal glob becomes `^...$`, an exact match. |
| Request order | `src/handler.rs` L228-236 | `redirects::pre_process` runs first, then `rewrites::pre_process`, then virtual hosts, then static files. |
| Rewrite logic | `src/rewrites.rs` L20-78, L104-118 | The first matching rule wins. With no `redirect`, `req.uri` is replaced by the destination, the original query string is kept (L80-100), and the request continues to static file serving. The response is the destination file's normal 200 response. |

## 2. Exact config

```toml
# SWS 2.32.2 SPA rewrite probe (exact-path, NOT a catch-all).
# Source: static-web-server tag v2.32.2 (commit e61c97e7)
#   docs/content/features/url-rewrites.md L9-15  : [[advanced.rewrites]] array of tables, keys source/destination/redirect
#   docs/content/features/url-rewrites.md L47    : no `redirect` key => internal rewrite (file served, no 3xx)
#   docs/content/configuration/config-file.md L101,L138-146 : [advanced] / [[advanced.rewrites]] syntax
#   src/settings/file.rs L141-151 (Rewrites struct), L163-175 (Advanced struct)
#   src/settings/mod.rs L441-487 : each `source` compiled with globset Glob::new -> anchored regex
# No [general] section on purpose: --root/--host/--port stay on the command line
# (config-file.md L178: file options would otherwise take precedence).

[advanced]

# Literal glob (no wildcards) => matches only this exact URI path.
[[advanced.rewrites]]
source = "/__wasmer_spa_probe__/deep"
destination = "/index.html"

# Second, separate exact nested route.
[[advanced.rewrites]]
source = "/__wasmer_spa_probe__/nested/route"
destination = "/index.html"
```

The config has no wildcards and no `redirect` key, so it is not a catch-all.

## 3. Native run

- Binary: `cargo install static-web-server --version 2.32.2 --locked --root /tmp/claude-0/tools/sws-2.32.2`. `--version` prints `Version: 2.32.2`, `Build target: x86_64-unknown-linux-gnu`, `Rust version: rustc 1.97.0`. The cargo target dir was deleted afterwards.
- Site: a copy of `codewithsadee/vcard-personal-portfolio` (local clone at `/tmp/claude-0/camp2/codewithsadee_vcard-personal-portfolio`, HEAD `e52e85c7`), copied to `/tmp/claude-0/sws-probe-site` without `.git`. `index.html` sha256 is `ae156e35…c6c9fc`, 33576 bytes.
- Probe command: `static-web-server --root /tmp/claude-0/sws-probe-site --config-file <probe.toml> --host 127.0.0.1 --port 18787 --log-level debug`
- Control command: the same without `--config-file`, on port 18788. The cwd has no `./config.toml`, and the log confirms `config file path not found or not a regular file: ./config.toml`.

### Results

| Request | With probe config | Control (no config) | Expected |
|---|---|---|---|
| `/` | 200 text/html 33576, body = index.html | 200, body = index.html | 200 |
| `/index.html` | 200 text/html 33576, body = index.html | 200, body = index.html | 200 |
| `/__wasmer_spa_probe__/deep` | **200 text/html 33576, sha256 = index.html** | **404** | 200 / control 404 |
| `/__wasmer_spa_probe__/nested/route` | **200 text/html 33576, sha256 = index.html** | **404** | 200 / control 404 |
| `/__wasmer_spa_probe__/deep?q=1` | 200, body = index.html | 404 | query kept, still matches |
| `/__wasmer_spa_probe__/other` (not in rules) | 404 (106 B) | 404 | 404 |
| `/__wasmer_spa_probe__/deep/extra` | 404 | 404 | 404 (exact match only) |
| `/x/__wasmer_spa_probe__/deep` | 404 | 404 | 404 (anchored) |
| `/assets/nope.js` (missing asset) | 404 | 404 | 404 |
| `/assets/js/script.js` | 200 text/javascript 4524 | 200 text/javascript 4524 | 200 |
| `/assets/css/style.css` | 200 text/css 30738 | 200 text/css 30738 | 200 |

Startup log with the config loaded (log-level debug):

```
DEBUG static_web_server::settings: config file read successfully
DEBUG static_web_server::settings: config file path resolved: …/sws-2.32.2-spa-rewrite-probe.toml
 WARN static_web_server::warn: config file empty or no `general` settings found, using default values
DEBUG static_web_server::settings: url rewrites glob pattern: /__wasmer_spa_probe__/deep
DEBUG static_web_server::settings: url rewrites regex equivalent: ^/__wasmer_spa_probe__/deep$
DEBUG static_web_server::settings: url rewrites regex equivalent: ^/__wasmer_spa_probe__/nested/route$
 INFO static_web_server::info: config file used: …/sws-2.32.2-spa-rewrite-probe.toml
```

The `general` WARN is expected because the file has no `[general]` section on purpose. The full log has a per-request DEBUG trace: `url redirects/rewrites glob pattern destination replaced: "/index.html"`.

Native verdict: PASS. Exact-path internal rewrite gives 200 with a body byte-identical to index.html. Non-matching routes and missing assets still return 404.

## 4. Command for root to run against the Wasm package (NOT run here)

Mount the site and the config exactly as in root's earlier Wasm test, with the site at `/opt/static_app`. Put the probe TOML at a guest path that is a real file inside the sandbox. The Anybuild layout would use `/opt/static_config/sws.toml`. Then pass the same SWS flags:

```
<root's existing wasmer run invocation of wasmer/static-web-server@=1.1.0, with the site at /opt/static_app
 and the probe toml at /opt/static_config/sws.toml> -- \
  --root /opt/static_app --config-file /opt/static_config/sws.toml \
  --host 127.0.0.1 --port <p> --log-level debug
```

Run the same requests from section 3, plus a control run without `--config-file`.

**Interpretation guard:** a config path the guest cannot see is silently ignored (section 1, "Missing file"). The Wasm result counts only if the log contains `INFO … config file used: /opt/static_config/sws.toml`, and at DEBUG `url rewrites regex equivalent: ^/__wasmer_spa_probe__/deep$`. If those lines are missing, the result is "config not loaded", not "rewrites unsupported". If they are present but the probe routes still return 404, rewrites do not work in that build.

## 5. Anybuild wiring proposal: CONDITIONAL on root's actual-WASI probe succeeding, untested on Wasmer, NOT applied anywhere

Source: pinned Anybuild 0.33.0, `/tmp/claude-0/camp/wasmerio_shipit` @ `587be23132ea9302775d1cd4c075c1b75e2670a2`, under `crates/anybuild/`.

How it works today:
- `resources/starlib/tools/staticfile.bzl` L21-30: `SWS_CONFIG_FILE = "sws.toml"`. `sws_config_mount(config)` returns `mount("static_config")` **only if `config.static_redirects_config` is truthy**. `sws_config_step` writes that string verbatim to `<static_config.path>/sws.toml`.
- Same file, L69-73: when that mount exists, serve starts `static-web-server --root=<static_app.serve_path> --log-level=info --config-file=<static_config.serve_path>/sws.toml --port=<port>`. `src/plan/layout.rs` L60-72 sets the serve path to `/opt/<name>`, so the result is `--root=/opt/static_app --config-file=/opt/static_config/sws.toml`.
- `resources/starlib/tools/node_static.bzl` L24-56: `nodestatic_config` and `nodestatic_build` use the same `sws_config_mount` and `sws_config_step`, so the wiring is identical.
- `src/providers/staticfile.rs` L293-334 `compute_redirects_config` renders only `[[advanced.redirects]]` (`source`/`destination`/`kind`) from `_redirects`. Auto-load **overwrites** the field: `load_config` L134-135 for staticfile, `node_static.rs` L245-246.
- `src/starlark/config.rs` L73-113: `config(provider, schema, **kwargs)` first runs `load_explicit_provider` (the auto-computed value). It then `validate_patch`es and `merge_json`s the Anybuild-file kwargs **on top** (L100-101), and nothing after that recomputes the redirects (`node_static.rs` L747-754 `resolve` only infers the build command). `static_redirects_config` is a real serialized field (`staticfile.rs` L40-43, `node_static.rs` L43-44), so `validate_patch` accepts it.
- `src/providers/mod.rs` L35-45: `static_redirects_config` is in `SNAPSHOT_EXCLUDED_FIELDS`, so `anybuild generate` never writes it. A hand-edited kwarg is lost on regeneration.
- `src/run/wasmer.rs` L272-283: `static-web-server` maps to `wasmer/static-web-server@=1.1.0` for `latest`, `2.38.0` and `0.1`, entrypoint `webserver`. This is the same package root is probing.

**Smallest supported path:** no Anybuild code change. In the checked-in Anybuild file, pass the TOML text as the `static_redirects_config` kwarg:

```python
config = nodestatic_config(            # or staticfile_config(...)
    schema = 1,
    # ...existing generated kwargs unchanged...
    static_redirects_config = """[[advanced.rewrites]]
source = "/some/known/route"
destination = "/index.html"
""",
)
```

Effects: a non-empty value makes `sws_config_mount` create `static_config`, and `sws_config_step` writes it to `sws.toml`. Serve then appends `--config-file=/opt/static_config/sws.toml`, with no further wiring needed. Caveats:
1. The kwarg **replaces** any `_redirects`-derived text. If the project also has `_redirects`, include its `[[advanced.redirects]]` blocks in the same string.
2. `anybuild generate` drops it because the field is snapshot-excluded. Re-add it after regenerating, or keep it in a hand-maintained file.
3. A real SPA needs a broader `source` glob than this exact-path probe, and anything broader than exact paths risks turning missing assets into 200. Using extension-less globs per known route prefix is a separate decision.
4. Environment: `apply_environment` (`config.rs` L102; `src/providers/environment.rs` L8-40) runs *after* the kwarg merge and maps every field to `ANYBUILD_<FIELD>` / `SHIPIT_<FIELD>`. So a set `ANYBUILD_STATIC_REDIRECTS_CONFIG` or `SHIPIT_STATIC_REDIRECTS_CONFIG` would also land in the field, and would **override** the kwarg. Make sure neither variable is set in the build env. The kwarg is the reviewable option to check in. (Read from code, not exercised.)

This proposal is valid only if root's Wasm probe shows `config file used`, the parsed rewrite regex, and 200 with a body identical to index.html on the probe routes while other paths still return 404. Until then, every SPA stays HELD.
