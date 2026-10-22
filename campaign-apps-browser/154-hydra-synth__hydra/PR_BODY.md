## Summary

Adds a short "Deploy on Wasmer" section before "Connecting to server from dev/ local editor environment" in the README. It has a Deploy to Wasmer badge, one sentence on what gets built and served (including that gallery and stream sharing still need a hydra-server URL), and one sentence on what the button does. There are no code or config changes.

## Why this repo

Hydra is used for live-coded visuals: at algoraves and workshops, in classrooms and by VJs. Workshop hosts and venues often want their own copy of the editor on their own URL, for example a pinned version for a course or a workshop instance that does not depend on hydra.ojack.xyz. The README documents running locally with `npm install`. A one-click deploy from source gives those users a hosted copy without a local Node setup. The editor's core (writing and running sketches) runs in the browser. The README already explains that gallery and signalling need a separate hydra-server via `VITE_SERVER_URL`, and the added sentence points at that rather than inventing new configuration.

## Testing

I replayed what Wasmer's builder (Anybuild v0.33.0) generates for `523e0feaf3f49899b759ce0e7afabe0114ddfe2b` with this change:

- Detection: static Node.js provider, framework Vite, npm, output directory `dist`. Only `package.json` and `package-lock.json` were staged for install.
- `npm install` exited 0 on Node 24.22.1 with npm 11.21.1.
- `npm run build` (`vite build`) exited 0.
- `dist/` was served with a local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here). These returned 200:
  - `/` ("< hydra >").
  - The hashed `assets/index-*.js` and `bundle.js`.
  - All CSS files.
  - All 15 Font Awesome webfont files.
  - `p5.min.js` and `images/hydra-landing.png`.
- `VITE_SERVER_URL` was unset. The store falls back to `serverURL = null`.

## Limitations

- No deployment was made. The badge image and the Wasmer import page could not be checked from the test environment.
- The built `index.html` still loads `hydra-synth` from cdn.jsdelivr.net, p5 from cdnjs and the Chivo font from Google Fonts. Translations and extensions are fetched from raw.githubusercontent.com. A deployment therefore needs internet access for those, as hydra.ojack.xyz does today.
- Gallery and stream sharing need a hydra-server, which is not part of this deployment.
- Hydra is AGPL-3.0. Anyone hosting a modified version must offer its source to users.
- The button opens Wasmer's import page for this public repository, where the user reviews the configuration and clicks Deploy; it does not create a copy of the repository in their GitHub account.
