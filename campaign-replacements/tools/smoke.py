"""Smoke-test a static site served by static-web-server.

usage: smoke.py BASE_URL STATIC_APP_DIR [extra paths...]
Fetches /, any extra paths, and up to 60 same-origin href/src references found in
those pages (resolved like a browser). Prints one line per URL and a summary.
Exit 0 only when every page and referenced asset returns 2xx.
"""
import re
import sys
import urllib.error
import urllib.parse
import urllib.request

base, app = sys.argv[1].rstrip("/"), sys.argv[2]
pages = ["/"] + sys.argv[3:]
seen, results = set(), []


def fetch(url):
    try:
        with urllib.request.urlopen(url, timeout=15) as r:
            return r.status, r.headers.get("content-type", ""), r.read()
    except urllib.error.HTTPError as e:
        return e.code, e.headers.get("content-type", ""), b""
    except Exception as e:  # noqa: BLE001
        return 0, str(e), b""


refs = []
for p in pages:
    url = base + p
    status, ctype, body = fetch(url)
    seen.add(url)
    results.append((status, "page", p, ctype.split(";")[0], len(body)))
    if "html" in ctype:
        text = body.decode("utf-8", "replace")
        title = re.search(r"<title[^>]*>(.*?)</title>", text, re.S | re.I)
        results.append(("--", "title", p, (title.group(1).strip()[:80] if title else "(none)"), ""))
        for m in re.finditer(r'(?:href|src)\s*=\s*["\']([^"\'#]+)["\']', text):
            ref = m.group(1).strip()
            if ref.startswith(("http:", "https:", "//", "mailto:", "tel:", "data:", "javascript:")):
                continue
            refs.append(urllib.parse.urljoin(url, ref))

for url in refs[:60]:
    if url in seen:
        continue
    seen.add(url)
    status, ctype, body = fetch(url)
    results.append((status, "ref", url[len(base):], ctype.split(";")[0], len(body)))

bad = [r for r in results if r[1] in ("page", "ref") and not (200 <= int(r[0] or 0) < 300)]
for r in results:
    print(*r, sep="\t")
print(f"SUMMARY pages={len(pages)} refs_checked={sum(1 for r in results if r[1]=='ref')} failures={len(bad)}")
for r in bad:
    print("FAIL", *r, sep="\t")
sys.exit(1 if bad else 0)
