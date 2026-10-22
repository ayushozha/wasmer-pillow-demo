## Summary

Adds a short "Deploy on Wasmer" section with a Deploy to Wasmer button after the existing "Deploy with Vercel" section of the README. README-only; no code, dependency, lockfile or config changes.

The section says that Wasmer runs the project's `build` script (`npm run build`) and serves the production build with Node; that the button builds this public repo as-is without forking it, so customizing `src/resources/content.tsx` / `src/resources/once-ui.config.ts` and redeploying on push needs a fork connected from the Wasmer dashboard; that no environment variables are required, with `PAGE_ACCESS_PASSWORD` only used by routes in `protectedRoutes` (users should set their own value, not the `.env.example` placeholder); and that the CC BY-NC 4.0 license still applies: a personal, non-commercial portfolio with attribution is within its terms, commercial use needs the extended license described in the README's License section.

## Why this repo

Magic Portfolio is a template people clone to publish their own portfolio. Content is MDX in the repo and configuration lives in `src/resources/`, with no database and no mandatory API key, so a build from source is the whole deployment. The one setting self-hosters can trip over is `PAGE_ACCESS_PASSWORD`: the default config protects `/work/automate-design-handovers-with-a-figma-to-code-pipeline`, and without the variable `/api/authenticate` returns 500, so the section names it and says where secrets go.

## Testing

From a copy of `main` at `76ae5e33e97599eaf209a4d9d844c4a77b3cc904` (`preview` is the same commit), Node v22.22.0, npm 10.9.4:

- `npm ci` - exit 0
- `npm run build` - exit 0 (Next.js 16.4.2 from the lockfile; blog and work MDX pages prerendered)
- `PORT=3202 npm start`, no env vars:
  - `/` 200 (contains the configured name), `/blog` 200, `/blog/quick-start` 200, `/work/simple-portfolio-builder` 200, `/api/rss` 200 `application/xml`
  - protected route 200 (client-side password prompt); `GET /api/check-auth` 401; `POST /api/authenticate` 500 with "PAGE_ACCESS_PASSWORD environment variable is not set" logged
- `PORT=3203 PAGE_ACCESS_PASSWORD=<throwaway test value> npm start`: wrong password 401; correct password 200 with an `authToken` HttpOnly cookie; `GET /api/check-auth` with that cookie 200
- Wasmer's build path, reproduced locally: `npx -y next-bundle@1.0.0 --build-command 'npm run build'` - exit 0, then `node .next-bundle/server.mjs` from a directory containing only `.next-bundle`: `/`, `/blog`, `/blog/quick-start`, `/work/simple-portfolio-builder` and the protected route 200, `/api/check-auth` 401, `/api/authenticate` 500 without the variable. `/api/rss` returned 404 there (see Limitations).

## Limitations

- No Wasmer deployment was submitted. Detection and runtime on wasmer.io, and shields.io badge rendering, were not verified from my environment.
- In the local reproduction of Wasmer's Next.js packaging (next-bundle 1.0.0), `/api/rss` (a `force-static` route handler) returned 404 even though the prerendered feed was in the bundle. `next start` serves it fine, so this looks like a packaging issue on the Wasmer side, not in this repo; it should be checked on a real deployment.
- `next/font/google` (Geist) is downloaded at build time, so the build needs outbound network access.
- This PR targets `preview`, per `PREVIEW.md`. Nothing visible in the app changes, so `no-demo` should apply.
