#!/usr/bin/env python3
"""Smoke-test a built static site directory.

Serves DIR on 127.0.0.1 with the stdlib HTTP server, requests each given
route (default "/"), then checks that every root-relative href/src/srcset
found in the built HTML resolves to a file in DIR. Prints a JSON summary and
exits non-zero on any failed route or missing local reference.

Usage: python3 -I smoke_static.py DIR [--base /] [--route /] [--route /about/]
"""
import argparse
import functools
import http.server
import json
import os
import re
import sys
import threading
import urllib.parse
import urllib.request

ATTR = re.compile(r'''(?:href|src)\s*=\s*["']([^"'#?]+)''', re.I)
SRCSET = re.compile(r'''srcset\s*=\s*["']([^"']+)''', re.I)


def local_refs(html):
    refs = ATTR.findall(html)
    for value in SRCSET.findall(html):
        refs += [part.strip().split(" ")[0] for part in value.split(",") if part.strip()]
    return [r for r in refs if r.startswith("/") and not r.startswith("//")]


def resolves(root, base, ref):
    if base != "/" and ref.startswith(base):
        ref = "/" + ref[len(base):]
    path = os.path.join(root, urllib.parse.unquote(ref).lstrip("/"))
    return any(os.path.isfile(p) for p in (path, os.path.join(path, "index.html"), path + ".html"))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("dir")
    ap.add_argument("--base", default="/")
    ap.add_argument("--route", action="append")
    args = ap.parse_args()
    root = os.path.abspath(args.dir)

    class Quiet(http.server.SimpleHTTPRequestHandler):
        def log_message(self, *a):
            pass

    handler = functools.partial(Quiet, directory=root)
    server = http.server.ThreadingHTTPServer(("127.0.0.1", 0), handler)
    threading.Thread(target=server.serve_forever, daemon=True).start()
    origin = f"http://127.0.0.1:{server.server_address[1]}"

    routes = {}
    for route in args.route or ["/"]:
        try:
            with urllib.request.urlopen(origin + route, timeout=10) as r:
                body = r.read().decode("utf-8", "replace")
                title = re.search(r"<title[^>]*>(.*?)</title>", body, re.I | re.S)
                routes[route] = {"status": r.status, "bytes": len(body),
                                 "title": title.group(1).strip()[:80] if title else None}
        except Exception as e:  # report, don't hide
            routes[route] = {"error": str(e)}
    server.shutdown()

    html_files, refs, missing = 0, set(), set()
    for dirpath, _, files in os.walk(root):
        for name in files:
            if name.endswith(".html"):
                html_files += 1
                with open(os.path.join(dirpath, name), encoding="utf-8", errors="replace") as f:
                    for ref in local_refs(f.read()):
                        refs.add(ref)
                        if not resolves(root, args.base, ref):
                            missing.add(ref)

    ok = all(v.get("status") == 200 for v in routes.values()) and not missing and html_files > 0
    print(json.dumps({"dir": args.dir, "base": args.base, "html_files": html_files,
                      "local_refs_checked": len(refs), "missing_local_refs": sorted(missing)[:50],
                      "missing_count": len(missing), "routes": routes, "ok": ok}, indent=2))
    sys.exit(0 if ok else 1)


if __name__ == "__main__":
    main()
