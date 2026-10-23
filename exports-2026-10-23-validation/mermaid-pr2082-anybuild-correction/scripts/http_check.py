"""HTTP receipts for the corrected mermaid Anybuild: entry routes, query/HEAD, negatives, all assets from served HTML."""
import hashlib, re, sys, urllib.request, urllib.error
base, root = sys.argv[1], sys.argv[2]
def req(path, method="GET"):
    r = urllib.request.Request(base + path, method=method)
    try:
        with urllib.request.urlopen(r) as resp: return resp.status, resp.headers.get("content-type"), resp.read()
    except urllib.error.HTTPError as e: return e.code, e.headers.get("content-type"), e.read()
def h(b): return hashlib.sha256(b).hexdigest()[:16]
files = {n: h(open(f"{root}/{n}", "rb").read()) for n in ("index.html", "edit.html", "view.html", "embed.html", "404.html")}
who = {v: k for k, v in files.items()}
print("# file body hashes:", files)
fails = 0
def check(path, want_status, want_file=None, method="GET"):
    global fails
    st, ct, body = req(path, method)
    served = who.get(h(body), "-") if body else "(empty)"
    ok = st == want_status and (want_file is None or served == want_file)
    fails += not ok
    print(f"{'PASS' if ok else 'FAIL'}\t{method}\t{st}\t{ct}\t{len(body)}\tserved={served}\t{path}\twant={want_status}{' '+want_file if want_file else ''}")
    return body
print("## entry routes")
pages = {}
for p, f in [("/", "index.html"), ("/edit", "edit.html"), ("/edit/", "404.html"), ("/view", "view.html"), ("/view/", "404.html"), ("/embed", "embed.html"), ("/embed/", "404.html"),
             ("/edit?x=1", "edit.html"), ("/view/?a=b", "404.html"), ("/embed?x=1", "embed.html")]:
    pages[p] = check(p, 200, f)
for p in ("/edit", "/view/", "/embed"):
    check(p, 200, None, "HEAD")
print("## negatives (must be 404)")
for p in ("/definitely-missing-x9", "/definitely/missing/deep", "/edit/extra", "/view/x/y", "/embedx", "/editor", "/_app/immutable/missing.js", "/missing.css", "/missing.wasm", "/_app/nothing"):
    check(p, 404)
check("/definitely-missing-x9", 404, None, "HEAD")
print("## assets referenced by the served HTML of every entry route")
refs = set()
for body in pages.values():
    for m in re.findall(rb'(?:href|src)="([^"#]+)"', body) + re.findall(rb'import\("([^"]+)"\)', body):
        u = m.decode()
        if u.startswith(("http:", "https:", "//", "data:", "mailto:")): continue
        u = "/" + u.lstrip("./") if not u.startswith("/") else u
        refs.add(u.split("?")[0])
mime = {".js": "text/javascript", ".css": "text/css", ".svg": "image/svg+xml", ".png": "image/png", ".ico": "image/x-icon", ".json": "application/json", ".html": "text/html", ".woff2": "font/woff2"}
for u in sorted(refs):
    st, ct, body = req(u)
    ext = "." + u.rsplit(".", 1)[-1] if "." in u.rsplit("/", 1)[-1] else ""
    ok = st == 200 and (ext not in mime or (ct or "").startswith(mime[ext]))
    fails += not ok
    print(f"{'PASS' if ok else 'FAIL'}\tGET\t{st}\t{ct}\t{len(body)}\t{u}")
print(f"SUMMARY refs={len(refs)} failures={fails}")
