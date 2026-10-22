# streamlit/streamlit-example

- Upstream: https://github.com/streamlit/streamlit-example, default branch `master`, pinned `8bd2197e4ba68dd68127a264dc6708f0a96f23c8` (last commit 2023-11-02). Description: "Example Streamlit app that you can fork to test out share.streamlit.io".
- Popularity (GitHub API, 2026-10-22): 440 stars, 24,528 forks, 83 open issues, not archived.
- License: no LICENSE file in the repo. A README-only PR does not redistribute the code; the button builds the repo from source on GitHub.
- Contribution policy: none present (no CONTRIBUTING, no PR template, no AI policy).
- Duplicates: GitHub PR search `wasmer` across batch-B targets → 0 (2026-10-22).
- Acceptance risk: owned by Streamlit (Snowflake) and meant to funnel into Streamlit Community Cloud; inactive since 2023-11. A competing host's button may be ignored or closed. Technically fine.

## Wasmer detection (Anybuild v0.33.0 = wasmerio/shipit tag v0.33.0 @587be231, the version production pins)
- `crates/anybuild/src/providers/python.rs:785` framework = Streamlit when `streamlit` is in the dependency files.
- `python.rs:655-662` `detect_main_file` tries `main.py`, `app.py`, `streamlit_app.py`, `Home.py`, `*_app.py` → `streamlit_app.py` matches.
- `python.rs:602-607` start = `streamlit run streamlit_app.py --server.port $PORT --server.address 0.0.0.0 --server.headless true`.
- Default Python 3.13 (`python.rs:183,233,404`) — matches the version tested.
- Same stack in Wasmer's own fixture `examples/python-streamlit` (streamlit + langchain).

## Build/runtime here
pip install exit 0; streamlit health 200; AppTest run without exceptions. See `build.log`.

## Verdict: READY (technical) — moderate acceptance risk
Remaining check for Codex: open https://wasmer.io/apps/create?github=streamlit%2Fstreamlit-example and confirm the detected start command, and that the badge URL renders (img.shields.io is blocked from the cloud container).
