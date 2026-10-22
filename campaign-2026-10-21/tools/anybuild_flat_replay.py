#!/usr/bin/env python3
"""Replay Anybuild's planned build steps in a non-nested temp dir, then smoke the output.

Why: `anybuild build --builder=local` puts its working dir at
<project>/.anybuild/local/build/opt/temp, nested inside the project. Tools
that search parent directories (pnpm finds the project's pnpm-workspace.yaml
and installs into the outer root; Astro/tsconfck picks up outer tsconfig
state) then behave differently from a builder whose /opt/temp is not inside
the source tree. This script follows the same order the local builder logs:
copy package.json + lockfile -> run the planned install command -> copy the
rest of the source (excluding node_modules, .git, lockfile) -> run the
planned build command -> copy the planned static_dir -> smoke it.

It is evidence about the planned commands, NOT a run of Wasmer's builder.
Usage: python3 -I anybuild_flat_replay.py ANYBUILD_BIN CLONE_DIR [route ...]
Writes logs/<clone basename>.flat-replay.log and .flat-replay-smoke.json.
"""
import datetime
import json
import os
import shutil
import subprocess
import sys

C = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LOCKS = ["package-lock.json", "pnpm-lock.yaml", "yarn.lock", "bun.lock", "bun.lockb"]


def main():
    anybuild, clone, routes = sys.argv[1], sys.argv[2], sys.argv[3:] or ["/"]
    key = os.path.basename(clone.rstrip("/"))
    base = f"/tmp/claude-0/flat-replay/{key}"
    shutil.rmtree(base, ignore_errors=True)
    src, temp = f"{base}/src", f"{base}/opt/temp"
    os.makedirs(temp)
    subprocess.run(["git", "-C", clone, "worktree", "remove", "--force", src], capture_output=True)
    subprocess.run(["git", "-C", clone, "worktree", "add", "-q", "--detach", src, "HEAD"], check=True)
    log = open(os.path.join(C, "logs", f"{key}.flat-replay.log"), "w")

    env = dict(os.environ)

    def sh(cmd, cwd):
        log.write(f"$ (cd {cwd} && {cmd})\n")
        log.flush()
        code = subprocess.run(cmd, shell=True, cwd=cwd, env=env, stdout=log, stderr=subprocess.STDOUT).returncode
        log.write(f"EXIT {code}\n")
        return code

    head = subprocess.run(["git", "-C", src, "rev-parse", "HEAD"], capture_output=True, text=True).stdout.strip()
    tools = "; ".join(subprocess.run(f"{t} --version 2>/dev/null | head -1", shell=True, capture_output=True,
                                     text=True).stdout.strip() or f"{t}: n/a" for t in ("node", "npm", "pnpm", "bun"))
    now = datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
    log.write(f"# {now} flat replay of anybuild 0.33.0 planned steps for {key} @ {head} ({tools})\n")
    plan_path = f"{base}/plan.json"
    sh(f"{anybuild} plan {src} --out {plan_path}", base)
    cfg = json.load(open(plan_path))["config"]
    install, build = cfg["commands"].get("install"), cfg["commands"].get("build")
    pnpm_version = cfg.get("pnpm_version")
    if cfg.get("node_package_manager") == "pnpm" and pnpm_version:
        # Match the pnpm version Anybuild pins (declared packageManager, else its default).
        prefix = f"/tmp/claude-0/tools/pnpm-{pnpm_version}"
        if not os.path.exists(f"{prefix}/bin/pnpm"):
            subprocess.run(["npm", "i", "-g", "--prefix", prefix, f"pnpm@{pnpm_version}"], check=True, capture_output=True)
        env["PATH"] = f"{prefix}/bin:" + env["PATH"]
        env["COREPACK_ENABLE_STRICT"] = env.get("COREPACK_ENABLE_STRICT", "0")
    pin = subprocess.run("pnpm --version", shell=True, env=env, capture_output=True, text=True).stdout.strip()
    log.write(f"# pinned per plan: node_version={cfg.get('node_version') or '24 (default)'} pnpm_version={pnpm_version} -> pnpm on PATH {pin}; npm_version={cfg.get('npm_version')} bun_version={cfg.get('bun_version')}\n")
    static_dir = cfg.get("static_dir") or "."
    log.write(f"# plan: provider={json.load(open(plan_path))['provider']} install={install!r} build={build!r} static_dir={static_dir!r}\n")

    for name in ["package.json"] + LOCKS:
        if os.path.exists(f"{src}/{name}"):
            shutil.copy2(f"{src}/{name}", temp)
    code = sh(install, temp) if install else 0
    if code == 0:
        sh(f"tar --exclude=./node_modules --exclude=./.git {' '.join('--exclude=./' + l for l in LOCKS)} -cf - . | tar -xf - -C {temp}", src)
        code = sh(build, temp) if build else 0
    result = {"install": install, "build": build, "static_dir": static_dir, "exit": code}
    out = os.path.join(temp, static_dir)
    if code == 0 and os.path.isdir(out):
        cmd = ["python3", "-I", os.path.join(C, "tools", "smoke_static.py"), out]
        for r in routes:
            cmd += ["--route", r]
        s = subprocess.run(cmd, capture_output=True, text=True)
        open(os.path.join(C, "logs", f"{key}.flat-replay-smoke.json"), "w").write(s.stdout)
        d = json.loads(s.stdout)
        result.update(smoke_ok=d["ok"], missing=d["missing_count"],
                      routes={k: v.get("status", v.get("error")) for k, v in d["routes"].items()})
    log.write(f"# result {json.dumps(result)}\n")
    log.close()
    subprocess.run(["git", "-C", clone, "worktree", "remove", "--force", src], capture_output=True)
    print(key, json.dumps(result))


if __name__ == "__main__":
    main()
