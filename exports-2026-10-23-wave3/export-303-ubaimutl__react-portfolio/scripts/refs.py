import os, re, sys, urllib.parse
app = sys.argv[1]; local = set(); ext = {}
for root, _, files in os.walk(app):
    for f in files:
        if not f.endswith('.html'): continue
        fp = os.path.join(root, f); rel = '/' + os.path.relpath(fp, app).replace(os.sep, '/')
        page = rel[:-len('index.html')] if rel.endswith('/index.html') else rel
        t = open(fp, encoding='utf-8', errors='replace').read()
        for m in re.finditer(r'(?:href|src|content|srcset|component-url|renderer-url|before-hydration-url)\s*=\s*["\']([^"\']+)["\']', t):
            for ref in [x.strip().split(' ')[0] for x in m.group(1).split(',')] if 'srcset' in m.group(0)[:7] else [m.group(1).strip()]:
                if not ref or ref.startswith(('#', 'mailto:', 'tel:', 'data:', 'javascript:')): continue
                if ref.startswith(('http:', 'https:', '//')):
                    h = urllib.parse.urlsplit(ref if not ref.startswith('//') else 'https:' + ref).netloc
                    tag = 'script' if re.search(r'<script[^>]*' + re.escape(m.group(0)), t) else 'other'
                    ext.setdefault((h, tag), set()).add(page); continue
                if m.group(0).startswith('content') and not ref.startswith('/'): continue
                u = urllib.parse.urljoin('http://x' + page, ref); p = urllib.parse.urlsplit(u)
                if p.netloc == 'x': local.add(urllib.parse.unquote(p.path))
for root, _, files in os.walk(app):
    for f in files:
        if not f.endswith('.css'): continue
        fp = os.path.join(root, f); rel = '/' + os.path.relpath(fp, app).replace(os.sep, '/')
        for m in re.finditer(r'url\(\s*["\']?([^"\')]+)["\']?\s*\)', open(fp, encoding='utf-8', errors='replace').read()):
            ref = m.group(1).strip()
            if ref.startswith(('data:', '#')): continue
            if ref.startswith(('http:', 'https:', '//')): ext.setdefault((urllib.parse.urlsplit(ref if not ref.startswith('//') else 'https:'+ref).netloc, 'css-url'), set()).add(rel); continue
            local.add(urllib.parse.unquote(urllib.parse.urlsplit(urllib.parse.urljoin('http://x' + rel, ref)).path))
for x in sorted(local): print(x)
sys.stderr.write('# external hosts referenced in built HTML (host, tag-kind: n pages)\n')
for (h, tag), pages in sorted(ext.items()): sys.stderr.write(f'{h}\t{tag}\t{len(pages)} pages\n')
sys.stderr.write('# <script src=...> to external hosts: ' + (', '.join(sorted({h for (h,t) in ext if t=='script'})) or 'none') + '\n')
