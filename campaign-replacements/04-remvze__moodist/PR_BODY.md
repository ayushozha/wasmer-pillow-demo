## Summary

Adds a third option, "Deploy on Wasmer", to the README's Self-Hosting section, after Docker and Docker Compose. It has a Deploy to Wasmer badge and two sentences: one on how the site is built, and one on what the button does. There are no code or config changes.

## Why this repo

Moodist is promoted as open-source and self-hostable, and the README's self-hosting options are currently Docker based. Because the app is a fully static Astro build with no backend, people who want their own instance without running a container can deploy it from source in one click. Wasmer detects Astro, runs `pnpm install` and `pnpm run build`, and serves `dist/`.

## Testing

I ran a local replay of what Wasmer's builder (Anybuild v0.33.0) generates for `11c0be2200116a3635880d600fd6953899cc51a3` with this change.

Detection:
- Provider: static Node.js.
- Framework: Astro.
- Package manager: pnpm 10.
- Output directory: `dist`.

Commands and results:
- `pnpm install` on Node 24.22.1 exited 0. Only `package.json` and `pnpm-lock.yaml` were staged, as the builder does.
- `pnpm run build` exited 0 and produced 122 files.
- `dist/` was served with static-web-server 2.38.0.

Smoke test:
- `/` returned 200 ("Moodist: Ambient Sounds for Focus and Calm").
- `/manifest.webmanifest` returned 200.
- All referenced assets returned 200.

## Limitations

- No deployment was made. The badge image and the Wasmer import page could not be checked from the test environment.
- Audio playback and the PWA were not tested in a browser; the check was HTTP-level only.
- The button opens Wasmer's import page for this public repository, where the user reviews the configuration and clicks Deploy; it does not create a copy of the repository in their GitHub account. To customize and redeploy on push, they import their own copy of the repo.
