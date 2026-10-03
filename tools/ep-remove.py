#!/usr/bin/env python3
"""Remove an argument Element Plus no longer has from a component file.

    python tools/ep-remove.py R/el_rate.R icon_classes void_icon_class

Drops its @param entry, its line in the signature, its binding and its data
field (both the `camel = .el_or_na(x)` and `vue_data$camel <-` spellings).
Lines it cannot place are reported, not guessed at.
"""
import sys, re
path, names = sys.argv[1], sys.argv[2:]
s = open(path).read()
def camel(x):
    p = x.split("_"); return p[0] + "".join(w.capitalize() for w in p[1:])
for n in names:
    c, k = camel(n), n.replace("_", "-")
    before = s
    # @param block: the line and its continuation lines
    s = re.sub(r"#' @param " + re.escape(n) + r"\b[^\n]*\n(#'  +[^\n]*\n)*", "", s)
    # signature line(s)
    s = re.sub(r"\n[ \t]+" + re.escape(n) + r"\s*=\s*[^\n]*?,[ \t]*(?=\n)", "", s)
    # bindings
    s = re.sub(r"\n[^\n]*\[\[\":" + re.escape(k) + r"\"\]\][^\n]*", "", s)
    s = re.sub(r"\n[ \t]*\":" + re.escape(k) + r"\"\s*=[^\n]*", "", s)
    # data
    s = re.sub(r"\n[ \t]*vue_data\$" + re.escape(c) + r"\s*<-[^\n]*", "", s)
    s = re.sub(r"\n[ \t]*" + re.escape(c) + r"\s*=\s*\.el_or_na\(" + re.escape(n) + r"\),?", "", s)
    s = re.sub(r"\n[ \t]*" + re.escape(n) + r"\s*=\s*" + re.escape(n) + r",?", "", s)
    left = [l for l in s.split("\n") if re.search(r"\b(" + re.escape(n) + "|" + re.escape(c) + r")\b", l)]
    print(f"{n}: {'removed' if s != before else 'NOT FOUND'}" + (f"; still mentioned: {left}" if left else ""))
open(path, "w").write(s)
