# Pillow image processor on Wasmer

[![Deploy to Wasmer](https://frontend-edge-git-ayush-deploy-button-journey-wasmer.vercel.app/deploy/button.svg)](https://frontend-edge-git-ayush-deploy-button-journey-wasmer.vercel.app/deploy?repository-url=https%3A%2F%2Fgithub.com%2Fayushozha%2Fwasmer-pillow-demo&branch=demo&project-name=pillow-demo&repository-name=wasmer-pillow-demo-copy&env=DEFAULT_IMAGE_URL&envDefaults=%7B%22DEFAULT_IMAGE_URL%22%3A%22https%3A%2F%2Fpicsum.photos%2F400%2F300%22%7D&envDescription=Image+URL+prefilled+in+the+crop+and+rotate+form.&redirect-url=https%3A%2F%2Fgithub.com%2Fayushozha%2Fwasmer-pillow-demo)

A small FastAPI + [Pillow](https://python-pillow.org/) app that downloads an image, rotates and crops it, and returns a PNG.
Source snapshot: [`wasmerio/examples` → `python-pillow`](https://github.com/wasmerio/examples/tree/dd8532fcc1aebf8554f5b904332c3778f5246ffb/python-pillow) at `dd8532fc`.

This is a disposable test repository for the Deploy to Wasmer button. The badge above targets the
`ayush/deploy-button-journey` preview (dev environment, `registry.wasmer.wtf`) until the feature is released to wasmer.io.

## Configuration

| Variable | Required | Effect |
| --- | --- | --- |
| `DEFAULT_IMAGE_URL` | Yes (button) | Image URL prefilled in the form. Falls back to `https://picsum.photos/200/300` locally. |

## Run locally

```bash
python -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt
uvicorn main:app --host 0.0.0.0 --port 8000
```

Open `http://127.0.0.1:8000/`, submit the form, and you get the rotated, cropped PNG from `/process`.

Note: `/process` fetches any URL you give it. Keep this as a demo; do not expose it as a general image proxy.
