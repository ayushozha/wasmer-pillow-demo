"""usage: python3 -I enum_refs.py STATIC_APP_DIR -> prints every HTML page path and every local href/src it references (resolved), one per line, prefixed page/ref."""
import os, re, sys, posixpath
root = sys.argv[1]
pages, refs = [], set()
for d, _, fs in os.walk(root):
    for f in fs:
        if f.endswith('.html'):
            p = '/' + os.path.relpath(os.path.join(d, f), root).replace(os.sep, '/')
            pages.append(p)
            t = open(os.path.join(d, f), encoding='utf-8', errors='replace').read()
            for m in re.finditer(r'(?:href|src)\s*=\s*["\']([^"\'#]+)["\']', t):
                r = m.group(1).strip().split('?')[0]
                if not r or r.startswith(('http:', 'https:', '//', 'mailto:', 'tel:', 'data:', 'javascript:')):
                    continue
                refs.add((r, posixpath.normpath(posixpath.join(posixpath.dirname(p), r)) if not r.startswith('/') else r))
for p in sorted(pages): print('page', p)
for r, u in sorted(refs, key=lambda x: x[1]): print('ref', u, r)
