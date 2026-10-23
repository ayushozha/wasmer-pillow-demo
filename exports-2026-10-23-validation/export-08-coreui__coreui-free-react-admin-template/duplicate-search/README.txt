Duplicate check, 2026-10-23.
1) Unauthenticated curl to https://api.github.com/search/issues (as instructed) returned HTTP 403 from this session's proxy
   ("This GitHub API path is not available: sessions are bound to their configured repositories").
   Raw responses: *.wasmer.json, *.deploy.json, *.wasmer-all.json.
2) Repo-scoped /repos/OWNER/REPO/pulls?state=all also returned 403 (repo not attached): *.pulls.p1.json.
3) Fallback: GitHub MCP search_pull_requests (GitHub search API, is:pr scoped). Raw results in mcp-*.json.
