## Summary

Adds a third option, "Deploy on Wasmer", to the README's Self-Hosting section, after Docker and Docker Compose. It has a Deploy to Wasmer badge and two sentences: one on how the site is built, and one on what the button does. There are no code or config changes.

## Why this repo

Moodist is promoted as open-source and self-hostable, and the README's self-hosting options are currently Docker based. The Astro build produces only static files and has no server of its own, so people who want their own instance without running a container can deploy it from source in one click. Wasmer detects Astro, runs `pnpm install` and `pnpm run build`, and serves `dist/`.

## Testing

I ran a local replay of what Wasmer's builder (Anybuild v0.33.0) generates for `11c0be2200116a3635880d600fd6953899cc51a3` with this change.

Detection:
- Provider: static Node.js.
- Framework: Astro.
- Package manager: pnpm 10.
- Output directory: `dist`.

Commands and results:
- `pnpm install` (pnpm 10.34.7, Node 24.22.1) exited 0. Only `package.json` and `pnpm-lock.yaml` were staged, as the builder does.
- `pnpm run build` exited 0 and produced 122 files.
- `dist/` was served with static-web-server 2.38.0.

HTTP checks (no browser):
- `/` returned 200 ("Moodist: Ambient Sounds for Focus and Calm").
- All 91 sound files under `public/sounds/` returned 200, about 122 MB in total (82 `audio/mpeg`, 9 `audio/wav`). This covers the 84 sounds listed in `src/data/sounds/*`, plus `alarm.mp3`, `silence.wav` and the 5 binaural WAVs. Every sound path in the source exists.
- A range request on an MP3 returned 206.
- `/manifest.webmanifest`, `/sw.js`, all 7 PWA icons, the hero image, the favicon and `og.png` returned 200.
- All 121 URLs in the service worker's precache list returned 200.

## Limitations

- **Not tested in a browser:**
  - Audio playback and mixing.
  - The timers' alarm.
  - The binaural/isochronic generators (Web Audio).
  - Service-worker registration, offline mode and PWA install.
  - Share-link import.
- **Optional features use third parties** and were not exercised:
  - Radio calls `all.api.radio-browser.info` and the stations' stream hosts when the Radio modal is opened.
  - Lofi embeds YouTube after the in-app consent notice.
  - A self-hosted copy still uses these services, and they do not work offline.
- **Points at moodist.app:** the page's `og:url` and `og:image` are hard-coded to `https://moodist.app`, so link previews of a self-hosted copy point there. Share links use the deploy's own origin.
- **Fonts:** Inter, Inter Tight and Fraunces are downloaded from Google Fonts at build time by Astro's font API. My sandbox could not reach Google, so the build succeeded with 0 font files and fallback fonts. With network access on the builder they should be self-hosted in `dist`, but I could not verify this.
- **Large precache:** the service worker precaches every file (about 154 MB, including the sounds), so an installed PWA downloads all of it. This is upstream behaviour and is unchanged here.
- **Sound licences:** the README says some sounds are under the Pixabay Content License and some under CC0, without a per-file list. This PR does not change the sounds or that section.
- **Not checked from the test environment:**
  - No deployment was made.
  - The badge image and the Wasmer import page could not be checked.
- **What the button does:** it opens Wasmer's import page for this public repository, where the user reviews the configuration and clicks Deploy. It does not create a copy of the repository in their GitHub account. To customize and redeploy on push, they import their own copy of the repo.
