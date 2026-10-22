#!/usr/bin/env python3
"""Run Wasmer's detector/builder (Anybuild) locally on patched trees and smoke the result.

For each ledger target (default: PUBLISHED and READY) this checks out the
patched commit from its local clone into a clean worktree, runs
`anybuild generate` + `anybuild build --builder=local`, then runs
smoke_static.py against the packaged `.anybuild/local/build/opt/static_app`
using the routes from the target's existing smoke log.

Writes logs/<owner>_<repo>.anybuild-build.log and .anybuild-smoke.json.
Local builder uses the host toolchain on PATH, not Wasmer's image; nothing
is deployed. Usage: python3 -I anybuild_e2e.py ANYBUILD_BIN [repo ...]
"""
import datetime
import json
import os
import subprocess
import sys

C = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CLONES = ["/tmp/claude-0/camp", "/tmp/claude-0/camp2"]
WORK = "/tmp/claude-0/e2e"


def run(cmd, log, cwd=None, timeout=1500):
    log.write(f"$ {' '.join(cmd)}\n")
    log.flush()
    try:
        r = subprocess.run(cmd, cwd=cwd, stdout=log, stderr=subprocess.STDOUT, timeout=timeout)
        code = r.returncode
    except subprocess.TimeoutExpired:
        code = "TIMEOUT"
    log.write(f"EXIT {code}\n")
    return code


def main():
    anybuild, only = sys.argv[1], set(sys.argv[2:])
    ledger = json.load(open(os.path.join(C, "ledger.json")))
    os.makedirs(WORK, exist_ok=True)
    summary = {}
    for t in ledger["targets"]:
        if only and t["repo"] not in only:
            continue
        if not only and t["status"] not in ("PUBLISHED", "READY"):
            continue
        key = t["repo"].replace("/", "_")
        clone = next((f"{d}/{key}" for d in CLONES if os.path.isdir(f"{d}/{key}")), None)
        if not clone:
            summary[t["repo"]] = "no clone"
            continue
        wt = f"{WORK}/{key}"
        subprocess.run(["git", "-C", clone, "worktree", "remove", "--force", wt], capture_output=True)
        subprocess.run(["git", "-C", clone, "worktree", "add", "-q", "--detach", wt, "HEAD"], check=True)
        head = subprocess.run(["git", "-C", wt, "rev-parse", "HEAD"], capture_output=True, text=True).stdout.strip()
        with open(os.path.join(C, "logs", f"{key}.anybuild-build.log"), "w") as log:
            now = datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
            node = subprocess.run(["node", "-v"], capture_output=True, text=True).stdout.strip()
            log.write(f"# {now} {t['repo']} patched commit {head} (base {t.get('base_sha')}) anybuild 0.33.0 local builder, host node {node}\n")
            code = run([anybuild, "generate", "."], log, cwd=wt)
            if code == 0:
                code = run([anybuild, "build", ".", "--builder=local"], log, cwd=wt)
        app = f"{wt}/.anybuild/local/build/opt/static_app"
        result = {"build_exit": code}
        if code == 0 and os.path.isdir(app):
            routes = []
            try:
                prior = json.load(open(os.path.join(C, "logs", f"{key}.smoke.json")))
                routes = [r for r in prior.get("routes", {}) if not r.startswith("http")]
            except (OSError, ValueError):
                pass
            cmd = ["python3", "-I", os.path.join(C, "tools", "smoke_static.py"), app]
            for r in routes or ["/"]:
                cmd += ["--route", r]
            s = subprocess.run(cmd, capture_output=True, text=True)
            with open(os.path.join(C, "logs", f"{key}.anybuild-smoke.json"), "w") as f:
                f.write(s.stdout)
            try:
                d = json.loads(s.stdout)
                result.update(smoke_ok=d["ok"], missing=d["missing_count"],
                              routes={k: v.get("status", v.get("error")) for k, v in d["routes"].items()})
            except ValueError:
                result["smoke"] = "unparseable"
        summary[t["repo"]] = result
        subprocess.run(["git", "-C", clone, "worktree", "remove", "--force", wt], capture_output=True)
        print(t["repo"], json.dumps(result), flush=True)
    json.dump(summary, open(f"{WORK}/summary.json", "w"), indent=2)


if __name__ == "__main__":
    main()
