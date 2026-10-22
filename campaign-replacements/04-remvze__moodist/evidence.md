# remvze/moodist: evidence

**Verdict: READY.** All 91 sound files in the repo, every other asset the app references and all 121 service-worker precache URLs returned 200 from the replayed build. The limitations below (third-party features, fonts not fetched in this sandbox, nothing tested in a browser) are disclosed in PR_BODY.md.

> Decision point for root (2026-10-22): a Wasmer deployment re-hosts all 91 sound files (~122 MB). Upstream already publishes them in the repo and on moodist.app and promotes self-hosting, but the README only says *some* sounds are Pixabay Content License or CC0 and leaves the rest unstated. The PR body discloses this; root decides whether that is acceptable before publishing.


## Repository
- Pinned SHA: `11c0be2200116a3635880d600fd6953899cc51a3` on branch `main`.
- Stars / forks: 3,901 / 335. The repo is not archived and was last pushed 2026-09-27 (GitHub API, 2026-10-22).
- `CONTRIBUTING.md` asks contributors to fork, branch and open a PR, and says: "Commit messages should follow Conventional Commits Specification." There is no PR template and no AI policy.
- Workflows: `build_docker.yml` only. No bad-PR bot.
- Recent merged PRs since 2025-10-01: 6.
- Duplicate `wasmer` PR check: 0. Prior deploy-button PRs: none.
- Existing deploy docs: the README has "## Self-Hosting" with "### 1. Run with Docker" and "### 2. Run with Docker Compose". The patch adds "### 3. Deploy on Wasmer" to that list. The build output is static files only (no server code of its own), so static hosting fits. Some optional features call third-party services from the browser; see "Network boundaries".

## Anybuild detection (v0.33.0)
- Provider: node-static, framework Astro, Strong detection (60; `mod.rs:421-426`). Static dir: `dist` (`providers/node.rs:330`).
- Package manager: pnpm 10 (`pnpm-lock.yaml`; there is no `packageManager` field). The replay installed pnpm 10.34.7. Install runs `pnpm install` with `package.json` and `pnpm-lock.yaml` staged.
- `pnpm-workspace.yaml` (holding `saveExact` and `allowBuilds` for esbuild and sharp) is not staged. It has no catalogs, and the install succeeded without it. pnpm reported "Ignored build scripts: esbuild@0.28.2"; the build still succeeded.

## Replay (2026-10-22, patched clone, Node 24.22.1, pnpm 10.34.7, static-web-server 2.38.0)
See `replay.log`.
- `pnpm install`: exit 0, 947 packages. `pnpm run build` (`astro build`): exit 0. `static_app` holds 122 files (148 MB, of which `sounds/` is 117 MB).
- Smoke run: 107 paths fetched. 105 returned 200. The 2 failures are probes: `/nope` (404, expected for a one-page app) and `/registerSW.js` (404, expected because the PWA uses `registerType: 'prompt'` and bundles registration into the page JS; nothing references that file).
- Supplementary run: every URL in `sw.js`'s precache list (121 entries, 153,804,719 bytes) returned 200. A `Range: bytes=0-99` request on an MP3 returned 206 with 100 bytes, so seeking and streaming requests work.

## Core ambient audio
How sounds are referenced (source):
- `src/data/sounds.ts` lists 8 categories, each in `src/data/sounds/<category>.tsx`: nature 12, rain 8, animals 16, urban 7, places 16, transport 6, things 16, noise 3. That is 84 sounds, matching the README's "84 curated ambient sounds". Each `src` is `getAssetPath('/sounds/<category>/<file>')`, which prefixes `import.meta.env.BASE_URL` (`/` here, so the paths work at the root of any origin).
- Timers (`pomodoro.tsx`, `countdown.tsx`, `flowmodoro.tsx`) use `/sounds/alarm.mp3`. `media-session-track.tsx` uses `/sounds/silence.wav` to keep the OS media controls alive.
- `src/data/sounds/binaural.tsx` lists 5 `/sounds/binaural/*.wav` files, but nothing imports it. The Binaural and Isochronic tools generate tones with the Web Audio API (`new window.AudioContext()`). The 5 WAVs are still shipped and precached by the service worker.
- The built JS references 86 distinct `/sounds/...` paths (84 + alarm + silence).

HTTP results (all from `replay.log`):
- All 91 files under `public/sounds/` returned 200: 82 `audio/mpeg`, 9 `audio/wav`, 122,375,998 bytes in total. The smallest is `things/clock.mp3` (90,674 B) and the largest is `animals/chickens.mp3` (5,017,248 B). There were no 404s, and every sound file the source references exists in `public/sounds/`.
- `/images/hero-background.webp`: 200, `image/webp`.
- PWA: `/manifest.webmanifest` 200 (`application/manifest+json`), `/sw.js` 200 (`text/javascript`), and all 7 manifest icons `/assets/pwa/{72,128,144,152,192,256,512}.png` 200 (`image/png`). `/favicon.svg`, `/og.png`, `/robots.txt` and the logos also returned 200.
- Fonts: **none in this build.** `astro.config.mjs` uses Astro's font API with `fontProviders.google()` for Inter, Inter Tight and Fraunces. Astro downloads the font files from Google at **build time** and serves them from the site's own origin. The sandbox cannot reach `fonts.google.com` (the build logged `ENOTFOUND`, and the proxy returns 403). Astro printed "No data found for font family ..." and "Copying fonts (0 files)", but the build still exited 0. Our output therefore has no `@font-face` rules, and pages render in fallback fonts. On a builder with internet access the fonts should be downloaded and self-hosted. This is unverified here. If Google is unreachable at build time, the deploy still succeeds, with fallback fonts.

## Network boundaries
Every external host in `src/`, `astro.config.mjs` and the built `dist/`. Icon-library and licence URLs in bundle comments are not requested at runtime.

| Host | Used by | Core? | Contacted at runtime? | Self-hosted copy |
|---|---|---|---|---|
| `fonts.google.com` / Google font files | Astro font API (`astro.config.mjs`) | Cosmetic | No. Build time only; files are copied into `dist` | The builder needs internet access for the real fonts. Otherwise the deploy uses fallback fonts (see above). |
| `all.api.radio-browser.info` | Radio modal (`radio.tsx`): `fetch` on station search | Optional | Yes, but only when the user opens the Radio modal (`if (!show ...) return`) | Calls the public Radio Browser API from the user's browser. |
| Arbitrary radio stream hosts | Radio modal plays `url_resolved` from the API (HTTPS-only filter) | Optional | Yes, while a station plays | The user's browser connects to the third-party stream host. |
| `www.youtube.com` (`/iframe_api`, embeds) | Lofi modal (`react-youtube`, 5 hard-coded video IDs) | Optional | Yes, but only after the user clicks "Continue" on an explicit YouTube consent notice | Third-party embeds. YouTube may collect data, as the app's notice says. |
| `moodist.app` | `layout.astro`: `og:url` = `https://moodist.app`, `og:image` = `https://moodist.app/og.png`. `share-link.tsx`: `https://moodist.app/?share=` fallback | Metadata | No fetch | Link previews of a self-hosted copy point at moodist.app and show its image. **Share links use the deploy's own origin** (`window.location.protocol//host`) after mount; the moodist.app URL is only the pre-hydration fallback (it is in the JS bundle, not in the built `index.html`). |
| `github.com/remvze/moodist`, `buymeacoffee.com/remvze`, `twitter.com/remvze`, `www.radio-browser.info` | Footer, menu, about and credit links | No | Only if the user clicks | Links to the upstream author, which is appropriate attribution. |

There is no analytics or tracking script in the source or in `index.html`. The core features (84 ambient sounds, mixer, presets, share links, timers, binaural/isochronic generators, breathing, todo, notepad) use only same-origin files. They need nothing beyond the deploy's own origin. By design, they should also work offline once the service worker has cached them (not tested). The Radio and Lofi features need third-party services and do not work offline. "Backend-free" is accurate only in the sense that there is no server of its own.

The PWA service worker precaches `**/*` with no size limit (`maximumFileSizeToCacheInBytes: Number.MAX_SAFE_INTEGER`): 121 files, about 154 MB, including the 5 unused binaural WAVs. Once the service worker is installed, a visitor downloads all of it. This is upstream behaviour, unchanged by the patch, and also applies to the Docker image and moodist.app.

## Licences
- Code: MIT, "Copyright (c) 2023 MAZE" (`LICENSE`).
- Sounds: the repo has no per-file credits or sources file (`find` for credit/attribution/licence files finds only `LICENSE`). The only statement is the README's "### Third-Party Assets":
  > Some sounds used in this project are sourced from third-party providers and **are subject to different licenses**:
  > - Sounds licensed under the **Pixabay Content License**
  > - Sounds licensed under **CC0**
- Unclear:
  - The README does not say which of the 91 files fall under Pixabay and which under CC0.
  - It says "some", leaving the origin and licence of the remaining files (including the 5 binaural WAVs, `alarm.mp3` and `silence.wav`) unstated.
  - The README says nothing about redistribution. CC0 allows redistribution. The Pixabay Content License has its own conditions, which I could not fetch from the sandbox. A Wasmer deploy redistributes the files exactly as the upstream Docker image and moodist.app already do. The patch does not touch the sounds or this section.

## Security (npm advisory bulk endpoint, versions from the replay's installed tree)
- Libraries shipped to the browser: howler 2.2.4, react/react-dom 19.2.7, zustand 4.4.3, cmdk 1.1.1, radix-ui 1.5.0, motion 12.23.24 (framer-motion and motion-dom 12.42.2), react-youtube 10.1.0 (youtube-player 5.5.2, load-script 1.0.0, sister 3.0.2, debug 2.6.9, ms 2.0.0), uuid 14.0.0, deepmerge 4.3.1, focus-trap-react 10.2.3 (focus-trap 7.8.0, tabbable 6.5.0), react-hotkeys-hook 3.2.1, react-icons 4.11.0, react-wrap-balancer 1.1.0, js-confetti 0.12.0, workbox-window/core/precaching/routing 7.4.1, and the astro 7.3.1 client runtime. **0 advisories** for all of them.
- Full tree (846 packages, 941 versions): high/critical advisories exist only in **build-time or dev tooling**:
  - Critical: handlebars 4.7.9 (via conventional-changelog, used by `standard-version` for releases, not by the build).
  - High: brace-expansion, braces, browserslist, devalue 5.9.2 (astro and @astrojs/react, server-side prop serialisation during the static render), fast-uri, http-cache-semantics, js-yaml, lodash and tmp (commitizen), sharp 0.35.4, source-map-js, vite 8.2.2 (mostly dev-server issues).
  - None of these package names appear in the built `_astro/*.js`. The output contains no server code.
- Net: no known high/critical advisory reaches the browser or the served site. The build-time issues would matter only if the build processed untrusted input.

## Not tested (no browser in this environment)
- Actual audio decoding and playback, mixing, volume and fade, the sleep timer, and the timer alarm sound.
- The Web Audio binaural/isochronic generators.
- The Radio feature (the Radio Browser API and stream hosts are third-party and were not called).
- The Lofi/YouTube feature.
- Service-worker registration, precaching, offline behaviour, the PWA install prompt and the 154 MB precache download.
- The media-session controls.
- Share-link round trip (`?share=` import).
- Fonts with internet access at build time.
- The badge image (`img.shields.io`) and the Wasmer import page (`wasmer.io`), which are blocked here.
- No Wasmer deployment was made.

## Remaining check for the reviewer
- Verify the badge and import page in a browser.
- Use a Conventional Commits message (`docs: ...`).
- The README patch is unchanged: its claims (Astro detected, `pnpm install`, `pnpm run build`, `dist` served as static files; the button behaviour) still match what was verified. `upstream.patch` equals `git diff` of the clone, and `git apply --check -R upstream.patch` passes.
