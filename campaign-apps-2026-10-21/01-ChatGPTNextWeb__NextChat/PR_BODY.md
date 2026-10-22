#### 💻 变更类型 | Change Type

- [ ] feat
- [ ] fix
- [ ] refactor
- [ ] perf
- [ ] style
- [ ] test
- [x] docs
- [ ] ci
- [ ] chore
- [ ] build

#### 🔀 变更说明 | Description of Change

**Summary**

- Adds a "Deploy to Wasmer" button to the existing row of deploy buttons at the top of `README.md`, in the same HTML `<img height="30">` style.
- Adds a short `### Wasmer` subsection under Deployment. It explains that the button builds this public repo as-is, without forking it; how to fork and connect the fork for redeploys and updates; and the four variables most self-hosters need: a provider key, `CODE`, `BASE_URL` and `DEFAULT_MODEL`. It links to Environment Variables for the rest.
- README only. No code, dependency or lockfile changes.

**Why this repo**

NextChat is one of the most self-hosted chat front ends. It needs no database, and `BASE_URL` lets it front any OpenAI-compatible endpoint, including local models. A self-hoster's main risk is exposing their provider key on a public URL. With `CODE` unset, anyone with the URL can chat on the owner's key. So the new section says `CODE` is required whenever a provider key is set, and it warns that the server currently prints the selected key to its logs.

#### 📝 补充信息 | Additional Information

**Testing** (SHA `1d3dc331512929a4b1d3e82354e72acce33b5c7a`, Node v22.22.0, Yarn 1.22.22, mock keys only)

- `yarn install --frozen-lockfile`: exit 0. In this sandbox, the lockfile's `registry.npmmirror.com` / `mirrors.huaweicloud.com` hosts were rewritten to `registry.npmjs.org` in a scratch copy, with integrity hashes unchanged.
- `yarn build`: exit 0. `yarn start` (`next start`): `/` returned 200 with `<title>NextChat</title>`.
- Against a local OpenAI-compatible SSE mock via `BASE_URL`, with `CODE=mockcode`, `/api/openai/v1/chat/completions` returned:
  - 401 with no code;
  - 401 with a wrong code;
  - 200 `text/event-stream` with the correct code, streaming the mock's chunks.
- With `CODE` unset, the same request without any Authorization header was served with the server key.

**Limitations**

- No Wasmer deployment was submitted from the test environment.
- Wasmer's detection and runtime were not verified there, and neither was badge rendering.
