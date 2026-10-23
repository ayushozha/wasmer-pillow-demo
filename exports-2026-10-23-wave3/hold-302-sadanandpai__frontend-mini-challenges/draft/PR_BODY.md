<a href="https://wasmer.io/apps/create?github=sadanandpai%2Ffrontend-mini-challenges"><img src="https://img.shields.io/badge/Deploy%20to-Wasmer-171717?style=for-the-badge&amp;logo=wasmer&amp;logoColor=white&amp;labelColor=171717" alt="Deploy to Wasmer" width="328" height="48"></a>

# Title and Issue number

Title : docs: add Deploy to Wasmer button and Anybuild config

Issue No. : ISSUE_NUMBER_REQUIRED

Code Stack : README.md, Anybuild (build configuration only; no application code)

Close #ISSUE_NUMBER_REQUIRED

Disclosure: I work at Wasmer. I prepared this change with help from Claude, an AI assistant, and reviewed and tested it before opening this PR.

This adds a "Deploy on Wasmer" section to the README and an `Anybuild` file in the project root.

The button opens Wasmer's import page for this public repository, where you review the detected build settings and click Deploy; it does not create a copy of the repository in your GitHub account. To customize the site and redeploy on changes, fork the repository and import your fork instead.

Why the `Anybuild` file is needed: without it, Wasmer's builder (Anybuild v0.33.0) detects this npm workspace as a Node.js server app with no start command, because the root `package.json` has no `vite` or other static-framework dependency. The file declares a static site instead and runs the same commands as the GitHub Pages workflow: `npm install`, `npm run build` and `npm run copy-to-dist`. Every app is built with the `/frontend-mini-challenges/` base path and the apps link to each other under that path, so the assembled `dist` folder is served under `/frontend-mini-challenges/`, and a single redirect sends `/` there. There is no catch-all or SPA fallback: all five apps use hash routing, and the CSS and JavaScript challenges are real HTML files.

# Testing

Local replay of what Anybuild v0.33.0 generates for `48b7dae8bae41e4c69b904c7793bb8a4f892f337` (current `main`) with this change applied:

- Plan: static Node.js provider declared in `Anybuild`, npm 11, output directory `wasmer-site`, one redirect (`/` to `/frontend-mini-challenges/`, 302).
- `npm install` (Node 24.22.1, npm 11.21.1) exited 0. `package-lock.json` was not changed.
- `npm run build && npm run copy-to-dist && ...` exited 0 (Nx built 6 projects) and produced 308 files.
- Served with a local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here).
- HTTP: `/` returned 302 to `/frontend-mini-challenges/`, and the portal returned 200. Each app's index (`react/`, `vue/`, `angular/`) returned 200, as did three CSS challenges and three JavaScript challenges. All 29 assets referenced by those pages returned 200 as JS or CSS, and all 308 built files returned 200 with the expected content types. `/nope` and `/frontend-mini-challenges/nope` returned 404.
- Browser (headless Chromium via Playwright 1.56.1, with all requests outside the local server blocked): the portal, its JavaScript list and the leaderboard rendered. The CSS accordion, the JavaScript 25-5 Clock and ATM Simulator, the React counter and anagram checker, the Vue counter and accordion, and the Angular counter and todo list all rendered after a direct load and again after a reload, with no same-origin errors.
- `npm run lint` and `npm run unit:test` exited 0.

# Limitations

- No deployment was made. The import page and the badge image were not opened from the test environment.
- The site lives under `/frontend-mini-challenges/` on a Wasmer deployment too, just as on GitHub Pages.
- Analytics: `apps/host/index.html` loads GoatCounter with `data-goatcounter="https://sadanandpai.goatcounter.com/count"`, and that tag is in the build. A copy deployed with this button would report page views to this project's GoatCounter account unless the deployer removes it. This PR does not change it.
- External services: the portal loads contributor data from api.github.com and avatars from avatars.githubusercontent.com, and pages load fonts from Google Fonts. Some challenges call third-party APIs. These were blocked in the browser test. The pages still rendered, but the contributors section logged a network error.
- `npm audit --omit=dev` on the committed lockfile reports 4 high-severity advisories. The ones that reach the browser are axios 1.18.1 and @angular/router 22.1.4. axios is used by the portal and by two React challenges, and it only requests fixed third-party URLs. The @angular/router advisories cover server-side rendering, which this project does not use. The other two, follow-redirects and source-map-js, are not used in the browser. This PR does not change dependencies.

# Checklist:

- [] I have mentioned the issue number in my Pull Request.
- [X] I have commented my code, particularly in hard-to-understand areas
- [X] I have created a helpful and easy to understand `README.md`
- [] I have updated the Index.html file for my contribution
