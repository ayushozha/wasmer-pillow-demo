## Summary

Adds a "Deploy on Wasmer" section with a button to the README, just before "Run it locally". README-only; no code or dependency changes.

## Why this repo

These are Streamlit's official LLM starter examples (936 stars, 1.7k forks), and the usual next step after reading them is running your own copy. They need no database and no deploy-time secrets: every page asks for the OpenAI or Anthropic key in the sidebar, so a public deploy cannot spend the deployer's key. That makes a one-click build from source a good fit.

The section names the one thing that is not automatic: the entry file is `Chatbot.py`, which Wasmer's builder does not detect by name (it looks for `main.py`, `app.py`, `streamlit_app.py`, `Home.py` or `*_app.py`), so the start command has to be set when creating the app. It also corrects an assumption the current README invites: the code never reads `OPENAI_API_KEY` from secrets, only from the sidebar (`TRUBRICS_EMAIL`/`TRUBRICS_PASSWORD` in `st.secrets` are optional, for the feedback page).

## Testing

Pinned at `7cf260745675e41f92e7436d3777aafdab9dad9f` (main). Run in fresh venvs on Python 3.13.16 (Wasmer's builder default) and Python 3.11 (this repo's CI version):

- `pip install -r requirements.txt` — exit 0 on both (langchain 0.0.350, langchain-community 0.0.3, langchain-core 0.1.23, openai 3.36.1, anthropic 2.1.0, streamlit 1.66.1)
- `python -m pytest -q app_test.py` — 2 passed on both (the repo's tests mock the OpenAI and LangChain calls, so no API requests were made)
- `streamlit run Chatbot.py --server.headless=true` — `/_stcore/health` → 200 `ok`, `/` → 200

No Wasmer deployment was made as part of this PR, and no API keys were used.

## Limitations

- Not deployed to Wasmer from this change; whether the create flow offers a start-command field is to be confirmed.
- `langchain==0.0.350` is old; it installs and passes the repo's tests today on 3.11 and 3.13, but the pages using it were not run against a live model.
