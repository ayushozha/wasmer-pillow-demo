## Summary

Adds a short "Deploy on Wasmer" section with a button to the README. README-only; `streamlit_app.py` and `requirements.txt` are unchanged.

## Why this repo

This repo exists to be forked and deployed (24.5k forks against 440 stars), and its app needs nothing but `requirements.txt` and `streamlit_app.py`: no database, no secrets. Wasmer's builder detects Streamlit from `requirements.txt` and `streamlit_app.py` is one of the entry files it looks for by name, so the example deploys without any extra configuration. The section also covers the step people get wrong with this repo: the button deploys `streamlit/streamlit-example` itself, so to deploy their own edits they need to connect their fork (or change the link in their fork's README).

## Testing

Pinned at `8bd2197e4ba68dd68127a264dc6708f0a96f23c8` (master), Python 3.13.16 (the default Python version in Wasmer's builder):

- `pip install -r requirements.txt` in a fresh venv — exit 0 (streamlit 1.66.1, altair 6.3.0, pandas 3.0.6, numpy 2.5.4, pyarrow 26.0.0)
- `streamlit run streamlit_app.py --server.address=127.0.0.1 --server.port=3431 --server.headless=true` — `/_stcore/health` → 200 `ok`, `/` → 200
- Ran the script headlessly with `streamlit.testing.v1.AppTest`: no exceptions on first run or after moving the first slider to 5000

No Wasmer deployment was made as part of this PR.

## Limitations

- Not deployed to Wasmer from this change. numpy/pandas/pyarrow are native packages; Wasmer's own Streamlit example uses the same stack, but the exact versions resolved on Wasmer may differ from the ones tested here.
- The button always points at this repository, so a fork's README still links here until the link is edited.
