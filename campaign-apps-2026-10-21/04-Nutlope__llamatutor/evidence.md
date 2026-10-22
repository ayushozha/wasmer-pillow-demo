# Evidence: Nutlope/llamatutor

## Verdict: HOLD

Do not open this PR yet. The replay of the Wasmer build path fails at runtime for the app's main feature.

The flat Anybuild v0.33.0 replay builds the bundle. `pnpm install`, then `pnpm dlx next-bundle@1.0.0 --build-command 'pnpm run build'`, then `pnpm prune --prod`, all exit 0. When the exported bundle is served with `node .next-bundle/server.mjs` on Node 24.22.1:
- `/` returns 200.
- `/api/getSources` fails safely without a key.
- **`POST /api/getChat` returns 500 `Internal Server Error` every time, with or without keys.** The error is `ReferenceError: self is not defined` at `.next-bundle/functions/api/getChat.func/index.js:24`.

The cause is in the tooling, not in the README. `app/api/getChat/route.ts:54` sets `export const runtime = "edge"`, so @vercel/next emits that route as an edge function (`.vc-config.json`: `runtime: "edge"`, `entrypoint: "index.js"`, no `handler`). next-bundle@1.0.0's `templates/server.mjs` handles the edge runtime only for middleware (`server.mjs:745-793`, check at `:762`). For every other function, `getFunctionHandler` does `require(path.join(functionDir, vcConfig.handler || "index.js"))` (`server.mjs:894-912`). That loads the edge bundle as a Node module, and the module crashes.

A Deploy button would therefore produce an app whose chat endpoint is broken. The PR can be unblocked in either of two ways:
- next-bundle serves edge functions;
- upstream drops `runtime = "edge"`. That would need a separate code PR, which is out of scope for a README-only campaign.

The Wasmer runtime itself (Edge.js, `edgejs_enable`/`edgejs_precompile: true` in the plan) was not replayed. The result there could differ, but nothing here shows that it does.

## Fix for reviewer finding 1 (HELICONE_API_KEY)
The code paths, exactly:
- `utils/TogetherAIStream.ts:32` hardcodes `fetch("https://together.helicone.ai/v1/chat/completions", …)`. No env var or base-URL setting can bypass Helicone.
- `utils/TogetherAIStream.ts:35` always sends `"Helicone-Auth": \`Bearer ${process.env.HELICONE_API_KEY}\``. With no `??` fallback, the header value is the literal string `Bearer undefined` when the variable is unset. By contrast, `:37` sends `Authorization: Bearer ${TOGETHER_API_KEY ?? ""}`.
- `utils/TogetherAIStream.ts:54-65`: on a non-200 upstream response it only `console.log`s and closes the stream. `app/api/getChat/route.ts:36-51` then returns **HTTP 200 with an empty body**, so the failure is silent in the UI. Only a thrown fetch error reaches the `catch` and returns 202 "Error. Answer stream failed."

The local test used a **mock**, not real Helicone. It ran `next start` from the same replay build dir, in a loopback-only netns, with outbound HTTPS forced through a TLS-terminating local logging mock (build.log §1c):
- With a fake Together key and no Helicone key, the server sent `POST together.helicone.ai/v1/chat/completions` with `helicone-auth: Bearer undefined`. The mock answered 401 (simulated), and the app returned 200 with 0 bytes.
- With both keys fake, the request carried a real-length `Helicone-Auth`. The mock answered with SSE, and the app streamed `data: {"text":"MOCK_CHAT_TOKEN"}`.
- With no keys and no route, the result was 202 "Error. Answer stream failed."

Because the URL is hardcoded, optionality cannot be proven locally. The only way to learn how the real gateway treats `Bearer undefined` would be a real outbound call, which was not made. The variable is therefore now documented as **Required**, and the row reads: "Chat always goes through Helicone's Together gateway (`together.helicone.ai`, hardcoded in `utils/TogetherAIStream.ts`); without it the `Helicone-Auth` header is sent as `Bearer undefined`".

## Flat replay facts (build.log §1)
- The source is the patched clone exported without `.git` to `$SCRATCH/replay/04-Nutlope__llamatutor/src`. No ancestor directory has a `package.json`.
- The replayed README still had the old "Recommended" row. The README-only fix does not affect the build.
- `anybuild-v0.33.0 plan --temp-anybuild --wasmer` detected Node.js, Next.js, server `node`, `pnpm_version: "10"` and Node 24. Install is `pnpm install`, build is `pnpm dlx next-bundle@1.0.0 --build-command 'pnpm run build'`, and start is `node .next-bundle/server.mjs`.
- The steps follow `crates/anybuild/resources/starlib/tools/node.bzl` (tag v0.33.0, `:95-150`). Only `pnpm-lock.yaml` and `package.json` were staged, and the install ran with `CI=true pnpm_config_minimum_release_age=0 pnpm_config_dangerously_allow_all_builds=true pnpm_config_strict_dep_builds=false`. The install was followed by the source copy, the build, `pnpm prune --prod` and `cp -R .next-bundle <app>`. Toolchain: Node 24.22.1, pnpm 10.28.0.
- Not replayed: `optimize-node-modules.sh` and the Edge.js runtime.
- **INIT_CWD:** pnpm is not affected. `INIT_CWD` was unset before the call, and next-bundle (`bin/build.mjs:55`, `process.env.INIT_CWD || process.cwd()`) printed `Building …/replay/04-Nutlope__llamatutor/build`, which is the correct project root.
- A secondary bundle issue was found but has no observed effect here. next-bundle@1.0.0 drops pnpm symlinks under scoped or `.pnpm/node_modules` dirs: 20 traced symlinks are missing from this bundle, including `next/node_modules/@swc/helpers`. The cause is that `bin/build.mjs:234-250` copies only regular files, and `:275-328` relinks only inside covered dirs. `/api/getSources` (Next 16.0.10) still loaded. The same bug breaks blinkshot's API route.

## Runtime smoke (`node .next-bundle/server.mjs`, loopback-only `unshare -n`, build.log §1b)
- An external connectivity probe failed (no route).
- `/` returned **200** and contained "Llama Tutor" and "Your Personal". `/favicon.ico` returned 200.
- `POST /api/getSources` with no env returned **500**, and the server log shows `Error: EXA_API_KEY is required`. With a fake `EXA_API_KEY` and outbound traffic sent to the mock, the server attempted only `api.exa.ai:443 POST /search`. The mock returned 401, so the app returned 500.
- `POST /api/getChat` returned **500** in all four configurations (no env, mock proxy, fake Together key, fake Together+Helicone+Exa keys), each time with `ReferenceError: self is not defined`. The mock recorded **no** chat request, so the route fails before any outbound call.
- `X-Vercel-IP-Country: IN` returned 200. `proxy.ts` is a Node-runtime middleware, and next-bundle's server runs only edge middleware (`server.mjs:762`), so the country rule does not run there. It is Vercel-specific anyway.

## Other notes vs current source
- **Upstash is optional:** `app/api/getChat/route.ts:12-20` creates the limiter only `if (process.env.UPSTASH_REDIS_REST_URL)`.
- **Exa is required:** `app/api/getSources/route.ts:11-14` throws.
- The package manager is pnpm (`pnpm-lock.yaml` v9). The README's `npm install` is unchanged.
- Chat or answer quality was **never** exercised against real Together, Helicone or Exa. Every upstream response came from the local mock.

## Repo facts
- Pinned SHA: `5b88de25bccd33524342f5ee34ca49ca38aca7f3` (main), last commit 2026-07-12.
- Stars / forks: 2,053 / 342.
- License: none found. There is no `.github` folder, CONTRIBUTING or AI policy.
- Duplicate check: 0 `wasmer` PRs.
- Existing deploy buttons: none.

## Patch
`upstream.patch` is the `git diff` of README.md only (+13 lines), and `git apply --check -R` passes against the clone. The only change from the previous version is the `HELICONE_API_KEY` row, which goes from Recommended to Yes.

## Limitations
- No Wasmer deployment was made.
- wasmer.io and img.shields.io are blocked from this environment.
- No real keys or paid calls were used.
- The server ran on stock Node 24.22.1, not on Wasmer's Edge.js.
