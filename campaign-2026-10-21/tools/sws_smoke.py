#!/usr/bin/env python3
"""Serve a built site with static-web-server (the server Anybuild deploys) and probe routes.

Runs SWS with Anybuild's planned flags (`--root=<dir> --log-level=info --port=<p>`)
plus `--host=127.0.0.1` (this sandbox has no IPv6; SWS binds [::] by default).
Requests each route without following redirects, records status, Location and
size, then requests a known-missing path to show 404 handling. Writes
logs/<key>.sws-smoke.json. Exit 1 if any listed route is not 200/3xx->200.

Usage: python3 -I sws_smoke.py SWS_BIN KEY DIR route [route ...]
"""
import http.client
import json
import os
import socket
import subprocess
import sys
import time

C = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def get(port, path, follow=3):
    hops = []
    for _ in range(follow + 1):
        conn = http.client.HTTPConnection("127.0.0.1", port, timeout=10)
        conn.request("GET", path)
        r = conn.getresponse()
        body = r.read()
        hops.append({"path": path, "status": r.status, "location": r.getheader("Location"), "bytes": len(body)})
        conn.close()
        loc = r.getheader("Location")
        if r.status in (301, 302, 307, 308) and loc:
            path = loc.split("127.0.0.1:%d" % port, 1)[-1] if "://" in loc else loc
            continue
        break
    return hops


def main():
    sws, key, root, routes = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4:] or ["/"]
    s = socket.socket()
    s.bind(("127.0.0.1", 0))
    port = s.getsockname()[1]
    s.close()
    version = subprocess.run([sws, "--version"], capture_output=True, text=True).stdout.split("\n")[0]
    proc = subprocess.Popen([sws, f"--root={root}", "--log-level=info", f"--port={port}", "--host=127.0.0.1"],
                            stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    try:
        for _ in range(50):
            try:
                socket.create_connection(("127.0.0.1", port), timeout=0.2).close()
                break
            except OSError:
                time.sleep(0.1)
        results = {r: get(port, r) for r in routes}
        missing = get(port, "/__wasmer_campaign_missing__/", follow=0)
    finally:
        proc.terminate()
        proc.wait()
    ok = all(h[-1]["status"] == 200 for h in results.values())
    out = {"tool": f"static-web-server {version.strip()} with anybuild 0.33.0 planned flags + --host=127.0.0.1",
           "root": root, "routes": results, "missing_probe": missing, "ok": ok}
    with open(os.path.join(C, "logs", f"{key}.sws-smoke.json"), "w") as f:
        json.dump(out, f, indent=2)
    summary = {r: "->".join(str(h["status"]) for h in hops) for r, hops in results.items()}
    print(key, "ok" if ok else "FAIL", json.dumps(summary), "missing:", missing[-1]["status"])
    sys.exit(0 if ok else 1)


if __name__ == "__main__":
    main()
