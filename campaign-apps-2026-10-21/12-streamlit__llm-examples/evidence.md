# streamlit/llm-examples

- Upstream: https://github.com/streamlit/llm-examples, default `main`, pinned `7cf260745675e41f92e7436d3777aafdab9dad9f` (last commit 2025-12-08).
- Popularity (GitHub API, 2026-10-22): 936 stars, 1,711 forks, not archived. License: Apache-2.0 (`LICENSE`).
- Contribution policy: no CONTRIBUTING / PR template / AI policy; CI `.github/workflows/app-testing.yml` runs pytest on Python 3.11.
- Duplicates: GitHub PR search `wasmer` across batch-B targets → 0 (2026-10-22).

## Source facts (differ from the task notes)
- `OPENAI_API_KEY` is **not** read from env or `st.secrets` anywhere; every page uses a sidebar `st.text_input(type="password")`. Only `pages/5_Chat_with_user_feedback.py:53-56` reads `st.secrets` (`TRUBRICS_EMAIL`, `TRUBRICS_PASSWORD`, optional).
- `requirements.txt`: `langchain==0.0.350`, `langchain-community==0.0.3`, others unpinned.

## Wasmer detection (Anybuild v0.33.0 = wasmerio/shipit tag v0.33.0 @587be231, production-pinned version)
- Framework: Streamlit from deps (`crates/anybuild/src/providers/python.rs:785`).
- Main file: `detect_main_file` (`python.rs:655-680`) tries `main.py`, `app.py`, `streamlit_app.py`, `Home.py`, then `*_app.py` at depth 1-2. **`Chatbot.py` does not match** → `missing_main_file` → "cannot infer start" (`python.rs:521-541`).
- Override exists in the builder: env `ANYBUILD_PYTHON_MAIN_FILE` / legacy `SHIPIT_PYTHON_MAIN_FILE` (`python.rs:232`, `providers/base.rs:34-49`), or an explicit start command. Whether wasmer.io's create page exposes either is unverified.

## Build/runtime here
Python 3.13 and 3.11: install exit 0, `pytest app_test.py` 2 passed (mocked), streamlit health 200. See `build.log`.

## Verdict: CONDITIONAL (HOLD if the check fails)
Codex: open https://wasmer.io/apps/create?github=streamlit%2Fllm-examples. If the page lets you set the start command (or a build env var `ANYBUILD_PYTHON_MAIN_FILE=Chatbot.py`), the README text is accurate — adjust the wording to the actual field name, then open. If the create flow fails to infer a start command and offers no override, HOLD: the only fix would be a vendor-specific file or renaming `Chatbot.py`, which is out of scope.
