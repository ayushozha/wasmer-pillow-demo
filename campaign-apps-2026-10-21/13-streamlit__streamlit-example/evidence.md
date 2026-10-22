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

## Verdict: HOLD (root review, 2026-10-22)
- Live import page (checked by the root reviewer in a browser) selects a **generic Python** app, not the Streamlit framework that Anybuild v0.33.0's source predicts (`python.rs:785`). The start command it would use is therefore not the `streamlit run streamlit_app.py ...` line this README promises.
- Local health check and AppTest ran on host CPython 3.13; they do not prove numpy/pandas/pyarrow run on Wasmer's runtime.
- Unhold only with an officially supported Streamlit runtime proof on Wasmer (e.g. a test deploy that renders the chart) and the README wording matched to what the import page actually configures.
