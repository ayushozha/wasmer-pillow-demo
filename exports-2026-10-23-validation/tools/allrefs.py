# usage: allrefs.py BASE_URL STATIC_DIR  -> fetch every local href/src in every .html and every url() in every local .css
import os,re,sys,urllib.request,urllib.parse,urllib.error
B=sys.argv[1].rstrip('/'); A=os.path.abspath(sys.argv[2]); refs={}
attr=re.compile(r'''(?:href|src)\s*=\s*["']([^"'#?]+)''',re.I)
cssu=re.compile(r'''url\(\s*["']?([^"')#?]+)''',re.I)
def add(base_dir,u,origin):
    if re.match(r'^(?:[a-z]+:|//|data:|mailto:|javascript:|\{|\$)',u,re.I) or not u.strip(): return
    full=os.path.normpath(os.path.join(A,u.lstrip('/'))) if u.startswith('/') else os.path.normpath(os.path.join(base_dir,u))
    if not full.startswith(A): return
    refs.setdefault('/'+os.path.relpath(full,A).replace(os.sep,'/'),origin)
for root,dirs,files in os.walk(A):
    dirs[:]=[d for d in dirs if d!='node_modules']
    for f in files:
        p=os.path.join(root,f)
        if f.endswith('.html'):
            for u in attr.findall(open(p,encoding='utf-8',errors='replace').read()): add(root,u,os.path.relpath(p,A))
for r in list(refs):
    if r.endswith('.css') and os.path.isfile(A+r):
        for u in cssu.findall(open(A+r,encoding='utf-8',errors='replace').read()): add(os.path.dirname(A+r),u,r[1:])
fails=0
for r in sorted(refs):
    try:
        with urllib.request.urlopen(B+urllib.parse.quote(r)) as x: c=x.status; t=x.headers.get('content-type'); n=len(x.read())
    except urllib.error.HTTPError as e: c=e.code; t=e.headers.get('content-type'); n=0
    if c!=200: fails+=1
    print(f"{c}\t{t}\t{n}\t{r}\t(from {refs[r]})")
print(f"SUMMARY unique_local_refs={len(refs)} non200={fails}")
