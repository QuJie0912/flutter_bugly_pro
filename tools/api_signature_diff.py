#!/usr/bin/env python3
import re
import sys
import difflib
from pathlib import Path

OFFICIAL = Path("agent/packages/flutter_bugly-1.1.1/lib/src/flutter_bugly.dart")
OURS = Path("lib/src/flutter_bugly_pro.dart")


def class_body(path, class_name):
    text = Path(path).read_text(encoding="utf-8")
    m = re.search(rf"class\s+{class_name}\b", text)
    if not m:
        raise SystemExit(f"class {class_name} not found in {path}")
    body = text[m.start():]
    body = re.sub(r"//[^\n]*", "", body)
    body = re.sub(r"/\*.*?\*/", "", body, flags=re.S)
    return body


def public_static_signatures(body):
    sigs = []
    for m in re.finditer(r"\bstatic\s+(Future|void|bool)\b", body):
        start = m.start()
        i = start
        depth = 0
        quote = None
        while i < len(body):
            ch = body[i]
            if quote:
                if ch == "\\":
                    i += 2
                    continue
                if ch == quote:
                    quote = None
            elif ch in "\"'":
                quote = ch
            elif ch == "(":
                depth += 1
            elif ch == ")":
                depth -= 1
            elif ch == "{" and depth == 0:
                break
            i += 1
        sig = " ".join(body[start:i].split())
        sig = re.sub(r"\s+async\s*$", "", sig)
        name_m = re.match(
            r"static\s+(?:Future<[^>]+>|void|bool)\s+([A-Za-z_]\w*)", sig
        )
        if not name_m or name_m.group(1).startswith("_"):
            continue
        sigs.append(sig)
    return sigs


official = public_static_signatures(class_body(OFFICIAL, "FlutterBugly"))
ours = public_static_signatures(class_body(OURS, "FlutterBuglyPro"))

print(f"official public static members: {len(official)}")
print(f"ours     public static members: {len(ours)}")

diff = list(
    difflib.unified_diff(
        official, ours, fromfile="official/FlutterBugly", tofile="ours/FlutterBuglyPro", lineterm=""
    )
)
if diff:
    print("\n".join(diff))
    sys.exit(1)

print("OK: public static signatures are identical (class name excluded)")
