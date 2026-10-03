#!/usr/bin/env python3
"""Add Element Plus props to a component function, from the upstream API table.

    python tools/ep-align.py el_autocomplete append-to aria-label ...
    python tools/ep-align.py el_autocomplete --missing [--skip a,b]

Each prop becomes an argument (snake_case, NULL by default: Element's own
default), documented with upstream's description, and passed to
el_widget(props = .el_props(...)). Reads /tmp/elapi/{docs,final}.json, written
by tools/api-coverage.py.
"""
import sys, re, json, glob

fn = sys.argv[1]
args = sys.argv[2:]
docs = json.load(open("/tmp/elapi/docs.json"))
final = json.load(open("/tmp/elapi/final.json"))

def camel(a):
    p = a.split("-"); return p[0] + "".join(x.capitalize() for x in p[1:])
def kebab(c):
    return re.sub(r'(?<=[a-z0-9])(?=[A-Z])', '-', c).lower()

skip = set()
if "--skip" in args:
    skip = set(args[args.index("--skip") + 1].split(","))
    args = [a for a in args if a != "--skip" and a not in (",".join(skip),)]
tag = None
if "--tag" in args:
    tag = args[args.index("--tag") + 1]
    args = [a for a in args if a not in ("--tag", tag)]
if "--missing" in args:
    want = []
    for r in final["report"]:
        if r["fn"] == fn and (tag is None or r["tag"].split(" ")[0] == tag):
            want += r["attr_missing"]
    args = [kebab(a) if "-" not in a else a for a in want]
props = [a for a in args if a not in skip and kebab(a) not in skip]
if not props:
    sys.exit("nothing to add")

# upstream description and type, by prop name: the component's own tables
# first (its file, or the section naming its tag), then anyone's
def tag_of(f, title):
    base = re.sub(r'\s*(Attributes?|Events?|Exposes|Slots?|Options)\s*$', '', title).strip() or f
    slug = re.sub(r'(?<=[a-z0-9])(?=[A-Z])', '-', base).lower()
    return "el-" + re.sub(r'[\s_]+', '-', slug).strip('-')
mytags = {r["tag"].split(" ")[0] for r in final["report"] if r["fn"] == fn}
if tag: mytags = {tag}
info, fallback = {}, {}
for f, secs in docs.items():
    for t, sec in secs.items():
        if sec["kind"] != "Attributes": continue
        for it in sec["items"]:
            if tag_of(f, t) in mytags or ("el-" + f in mytags and t == "Attributes"):
                info.setdefault(it["name"], it)
            fallback.setdefault(it["name"], it)
for k, v in fallback.items():
    info.setdefault(k, v)

src_file = None
for p in glob.glob("R/*.R"):
    if re.search(r"^" + re.escape(fn) + r" <- function", open(p).read(), re.M):
        src_file = p
s = open(src_file).read()
start = re.search(r"^" + re.escape(fn) + r" <- function\(", s, re.M).start()
# end of the signature: the ") {" that closes it
sig_end = s.index(") {", start)
sig = s[start:sig_end]
have = set(re.findall(r"([A-Za-z_][A-Za-z0-9_.]*)\s*=", sig))

def snake(p): return p.replace("-", "_")
new = [p for p in props if snake(p) not in have]
if not new:
    sys.exit("all present")

# 1. signature: before label/width/slots/session, whichever comes first
indent = re.search(r"\n(\s+)\w", sig).group(1)
m = None
for anchor in ("width", "slots", "session"):
    m = re.search(r"\n\s+" + anchor + r"\s*=", sig)
    if m: break
ins = "".join(f"\n{indent}{snake(p)} = NULL," for p in new)
if m:
    sig = sig[:m.start()] + ins + sig[m.start():]
else:
    sig = sig.rstrip() + "," + ins.rstrip(",")
s = s[:start] + sig + s[sig_end:]

# 2. docs: before @param session / @param width / @return in the block above
block_end = start
block_start = s.rfind("\n\n", 0, start) + 2
block = s[block_start:block_end]
def doc(p):
    it = info.get(p, {})
    d = re.sub(r"\s+", " ", it.get("desc", "")).strip().rstrip(".")
    d = re.sub(r"\[([^\]]+)\]\([^)]*\)", r"\1", d)            # links -> text
    d = re.sub(r"\^\[(\w+)\]`([^`]*)`", lambda m: "`" + m.group(2).replace("\\|", "|") + "`", d)
    d = re.sub(r"\^\[(\w+)\]", r"\1", d)
    d = re.sub(r" ?\^\(([\d.]+)\)", "", d)
    d = d[:1].upper() + d[1:] if d else "Element Plus's prop of that name"
    raw = it.get("type", "").replace("\\|", "|")
    toks = re.findall(r"\^\[(\w+)\](`[^`]*`)?", raw)
    typ = " / ".join((b.strip("`") if b and len(b) < 70 else a) for a, b in toks)
    line = f"#' @param {snake(p)} {d}. Element Plus's `{p}`"
    if typ: line += f" ({typ})"
    line += "."
    if "Function" in typ: line += " Give it as [JS()]."
    if "Component" in typ: line += " An icon's name, such as `\"Search\"`."
    # wrap at 80
    words, out, cur = line.split(" "), [], ""
    for w in words:
        if len(cur) + len(w) + 1 > 78 and cur:
            out.append(cur); cur = "#'  " + " " + w
        else:
            cur = (cur + " " + w) if cur else w
    out.append(cur)
    return "\n".join(out) + "\n"
docs_txt = "".join(doc(p) for p in new)
for anchor in ("#' @param session", "#' @param width", "#' @param slots", "#' @return"):
    i = block.find(anchor)
    if i != -1:
        block = block[:i] + docs_txt + block[i:]
        break
s = s[:block_start] + block + s[block_end:]

# 3. the el_widget() call: props = .el_props(list(...))
start = re.search(r"^" + re.escape(fn) + r" <- function\(", s, re.M).start()
wm = re.compile(r"\n\s+el_widget\(").search(s, start)
w = wm.start() + wm.group(0).index("el_widget(") if wm else -1
nxt = re.search(r"\n\S[^\n]* <- function\(", s[start + 10:])
if w == -1 or (nxt and w > start + 10 + nxt.start()):
    sys.exit(f"{fn}: no el_widget() call -- add the props by hand")
def val(p):
    it = info.get(p, {})
    return f".el_icon_name({snake(p)})" if "Component" in it.get("type", "") else snake(p)
pm = re.search(r"props\s*=\s*\.el_props\(list\(", s[w:w + 4000])
if pm:
    at = w + pm.end()
    s = s[:at] + ", ".join(f"{snake(p)} = {val(p)}" for p in new) + ", " + s[at:]
else:
    at = w + len("el_widget(")
    items = ",\n      ".join(f"{snake(p)} = {val(p)}" for p in new)
    s = s[:at] + f"\n    props = .el_props(list(\n      {items})),\n" + s[at:].lstrip("\n")
open(src_file, "w").write(s)
print(f"{fn}: added {', '.join(new)} in {src_file}")
