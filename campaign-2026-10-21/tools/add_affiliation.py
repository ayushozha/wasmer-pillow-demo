#!/usr/bin/env python3
"""Insert the Wasmer affiliation/context paragraph at the top of PR bodies.

The paragraph goes right after the `Title:` line, before the repo's own
template sections. Its wording is fixed by the campaign owner. It uses
"static site" for repos served as-is (staticfile provider, no build) and
"generated static site" otherwise. Bodies that already contain it are left
unchanged. Usage: python3 -I add_affiliation.py pr-bodies/OWNER_REPO.md [...]
"""
import json
import os
import sys

C = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MARK = "I work at Wasmer."


def paragraph(no_build):
    site = "static site" if no_build else "generated static site"
    return (f"I work at Wasmer. Wasmer Edge is a cloud hosting platform powered by WebAssembly; "
            f"it can host this repository’s {site}. References: "
            f"[Wasmer Edge docs](https://docs.wasmer.io/edge/), "
            f"[Git deployments](https://docs.wasmer.io/edge/git/).\n")


def no_build(key):
    frag = os.path.join(C, "ledger.d", f"{key}.json")
    text = json.dumps(json.load(open(frag))) if os.path.exists(frag) else ""
    return "staticfile" in text and "node-static" not in text


def main():
    for path in sys.argv[1:]:
        body = open(path, encoding="utf-8").read()
        if MARK in body:
            print(path, "already has affiliation")
            continue
        key = os.path.basename(path)[:-3]
        lines = body.split("\n")
        at = 1 if lines and lines[0].startswith("Title:") else 0
        while at < len(lines) and lines[at] == "":
            at += 1
        # Keep exactly one blank line after the title, then the paragraph, then a blank line.
        lines[at:at] = ([""] if at == 1 else []) + [paragraph(no_build(key)).rstrip("\n"), ""]
        open(path, "w", encoding="utf-8").write("\n".join(lines))
        print(path, "added", "(static site)" if no_build(key) else "(generated static site)")


if __name__ == "__main__":
    main()
