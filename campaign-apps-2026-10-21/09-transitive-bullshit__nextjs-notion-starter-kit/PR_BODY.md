#### Description

Adds a "Deploy on Wasmer" subsection under "Setup" (after "Vercel Configuration") with a Deploy to Wasmer button, plus the matching table-of-contents entry. README-only; no code, dependency, lockfile or config changes.

The section says that Wasmer runs the project's `build` script (`pnpm run build`, which fetches the public Notion pages) and serves the production build with Node; that the button builds this public repo as-is without forking it, so to use your own `rootNotionPageId` in `site.config.ts` and redeploy on push you fork and connect the fork from the Wasmer dashboard; and that no environment variables are required, with `NEXT_PUBLIC_FATHOM_ID`, `NEXT_PUBLIC_POSTHOG_ID` and the Redis variables listed as optional.

Why this repo: the starter kit is used by people who want a site from a public Notion page with one config edit. Everything a basic deployment needs is in `site.config.ts`; the only environment variables the code reads (`lib/config.ts`, `lib/notion-api.ts`) are optional analytics, Redis cache and `NOTION_API_BASE_URL`. That makes a build-from-source button a reasonable second option beside the existing Vercel instructions, and the section spells out the one thing that is easy to miss: the button deploys the default demo page until you fork and change `rootNotionPageId`.

Testing, from a copy of `main` at `e787e7b594f1ca6fe7445e1866d4d4668c533737`, Node v22.22.0, pnpm 11.25.0 (via corepack, matching `packageManager`):

- `pnpm install --frozen-lockfile` - exit 0
- `pnpm exec oxfmt --check readme.md` - passes before and after the change (`pnpm fix:format` per AGENTS.md would make no change)
- `node -e "require('sharp')"` - loads (sharp 0.35.4 prebuilt binary, linux-x64)
- `pnpm build` - exit 1 in my environment, because outbound access to Notion is blocked there: `[POST] "https://app.notion.com/api/v3/loadPageChunk": <no response> fetch failed` while collecting page data for `/[pageId]`. TypeScript and compilation passed before that point. I could not run `pnpm start` without a completed build.

Limitations:

- The production build and `next start` still need to be confirmed on a network-enabled machine (and on Wasmer). No Wasmer deployment was submitted; Wasmer's Next.js detection and runtime and the shields.io badge were not verified from my environment.
- Preview images (`isPreviewImageSupportEnabled: true` by default) use `lqip-modern` and the native `sharp` module at build time; whether those native binaries work in Wasmer's build environment is unverified.

#### Notion Test Page ID

`7875426197cf461698809def95960ebf` (default `rootNotionPageId` in `site.config.ts`)
