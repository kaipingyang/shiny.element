#!/usr/bin/env python3
"""Measure how much of upstream Element UI's documented API this package exposes.

Needs the upstream sources, which are not in the repo (see .gitignore):

    mkdir -p .upstream && cd .upstream
    curl -sL https://github.com/ElemeFE/element/archive/refs/tags/v2.13.2.tar.gz | tar xz
    mv element-2.13.2 element

and a snapshot of what we render, written by tools/api-coverage.R:

    Rscript tools/api-coverage.R

Then:

    python3 tools/api-coverage.py [--missing el_table]

The baseline is the API tables in the upstream docs, not the props found in
the minified bundle: the bundle hides props behind mixins, and the docs are
what upstream actually promises.
"""
import sys, os

if not os.path.isdir(".upstream/element/examples/docs/en-US"):
    sys.exit("upstream sources missing -- see the header of this file")
if not os.path.exists("/tmp/elapi/ours.json"):
    sys.exit("run Rscript tools/api-coverage.R first")

import re, json, os, glob

DOCS = ".upstream/element/examples/docs/en-US"

def parse(path):
    lines = open(path, encoding="utf-8", errors="replace").read().split("\n")
    out, cur = {}, None
    for i, ln in enumerate(lines):
        h = re.match(r'^#{2,4}\s+(.+?)\s*$', ln)
        if h:
            title = h.group(1)
            kind = None
            for k, norm in (("Attributes","Attributes"), ("Attribute","Attributes"),
                            ("Events","Events"), ("Event","Events"),
                            ("Methods","Methods"), ("Method","Methods"),
                            ("Scoped Slot","Slot"), ("Slots","Slot"), ("Slot","Slot")):
                if title.endswith(k) or f" {k} " in f" {title} ":
                    kind = norm
                    break
            cur = (title, kind) if kind else None
            continue
        # Some tables are written without leading/trailing pipes
        if cur and ln.count("|") >= 2 and not re.match(r'^[\s:\-|]+$', ln):
            cells = [c.strip() for c in ln.strip().strip("|").split("|")]
            if not cells or not cells[0]: continue
            # Header row, whatever the first column happens to be called
            if len(cells) > 1 and cells[1].strip().lower() in ("description", "desc"): continue
            name = cells[0].strip("`*_ ")
            # "value / v-model" documents one prop under two spellings
            name = name.split("/")[0].strip().strip("`*_ ")
            if re.match(r'^(attribute|event|method|slot|parameter|param)s?(\s+name)?$', name, re.I): continue
            if not re.match(r'^[a-zA-Z][\w:.-]*$', name): continue
            title, kind = cur
            out.setdefault(title, {"kind": kind, "items": []})
            out[title]["items"].append({
                "name": name,
                "desc": cells[1] if len(cells) > 1 else "",
                "type": cells[2] if len(cells) > 2 else "",
                "default": cells[4] if len(cells) > 4 else "",
            })
    return out

api = {}
for p in sorted(glob.glob(f"{DOCS}/*.md")):
    comp = os.path.basename(p)[:-3]
    sec = parse(p)
    if sec: api[comp] = sec

os.makedirs("/tmp/elapi", exist_ok=True)
json.dump(api, open("/tmp/elapi/docs.json","w"), indent=1)

docs = api
ours = json.load(open("/tmp/elapi/ours.json"))

OWNER = {"el-button": "el_button", "el-option": "el_select"}

# Props deliberately not exposed, with the reason. Counted as out of scope
# rather than missing, so the coverage figure means something.
EXCLUDED = {
    ("el-select", "autoComplete"): "upstream marks auto-complete @DEPRECATED; autocomplete is bound",
    ("el-input", "autoComplete"): "upstream marks auto-complete @DEPRECATED; autocomplete is bound",
    ("el-checkbox", "value"): "the group owns the value through v-model; a child's own value is unused inside one",
    ("el-radio", "value"): "the group owns the value through v-model; a child's own value is unused inside one",
}
SPECIAL = {"submenu": "el-submenu", "menu-group": "el-menu-item-group"}

def section_tag(fileslug, title):
    """'Table-column Attributes' -> el-table-column ; 'Attributes' -> el-<file>"""
    base = re.sub(r'\s*(Attributes?|Events?|Methods?|Scoped Slot|Slots?)\s*$', '', title).strip()
    if not base:
        base = fileslug
    slug = re.sub(r'(?<!^)(?=[A-Z])', '-', base).lower()
    slug = re.sub(r'[\s_]+', '-', slug).strip('-')
    slug = re.sub(r'-+', '-', slug)
    return SPECIAL.get(slug, "el-" + slug)

# 上游：tag -> {kind -> [names]}
up = {}
for f, secs in docs.items():
    for title, s in secs.items():
        tag = section_tag(f, title)
        up.setdefault(tag, {}).setdefault(s["kind"], [])
        for it in s["items"]:
            up[tag][s["kind"]].append(it["name"])

def snake_camel(p):        # disable_transitions -> disableTransitions
    bits = p.split("_")
    return bits[0] + "".join(b.capitalize() for b in bits[1:])

def camel(a):
    a = a.lstrip(":@").split(".")[0]
    p = a.split("-")
    return p[0] + "".join(x.capitalize() for x in p[1:])

VUE = {"vIf","vFor","vModel","vShow","key","ref","slot","slotScope","class","style","id",
       "vPre","vHtml","vText","vCloak","vOnce","vBind","vOn"}

# A prop bound on a parent tag reaches the children: el-checkbox-group carries
# `disabled` for every el-checkbox under it. Collect per function first so a
# prop is not reported as unbound just because it sits on a sibling tag.
bound_by_fn = {}
for fn, info in ours.items():
    if not info.get("ok"): continue
    acc = set()
    for tag, attrs in (info.get("tags") or {}).items():
        if isinstance(attrs, str): attrs = [attrs]
        acc |= {camel(a) for a in attrs if not a.startswith("@")}
        if any(a == "v-model" for a in attrs): acc |= {"value"}
    bound_by_fn[fn] = acc - VUE

report, seen = [], set()
for fn, info in sorted(ours.items()):
    if not info.get("ok"): continue
    for tag, attrs in (info.get("tags") or {}).items():
        # jsonlite's auto_unbox writes a one-element vector as a bare string
        if isinstance(attrs, str): attrs = [attrs]
        if tag not in up: continue
        # A tag rendered inside another component (el-button in a form's
        # submit row) is that component's own concern, not this one's.
        if tag in OWNER and OWNER[tag] != fn: continue
        seen.add(tag)
        upa = {camel(x) for x in up[tag].get("Attributes", [])}
        upa -= {p for (t, p) in EXCLUDED if t == tag}
        upe = set(up[tag].get("Events", []))
        upm = set(up[tag].get("Methods", []))
        ups = set(up[tag].get("Slot", []))
        mine_a = {camel(a) for a in attrs if not a.startswith("@")} - VUE
        raw_params = info.get("params") or []
        if isinstance(raw_params, str): raw_params = [raw_params]
        params = {snake_camel(p) for p in raw_params}
        mine_e = {a[1:] for a in attrs if a.startswith("@")}
        # v-model 覆盖 value
        if any(a == "v-model" for a in attrs): mine_a |= {"value", "modelValue"}
        # Settable but not bound: the UI accepts it, update_el_*() cannot touch it
        conditional = sorted((upa & params) - mine_a - bound_by_fn.get(fn, set()))
        report.append({
            "fn": fn, "tag": tag, "conditional": conditional,
            "attr": [len(upa & (mine_a | params)), len(upa)],
            "bound": [len(upa & mine_a), len(upa)],
            "attr_missing": sorted(upa - mine_a - params),
            "evt": [len(upe & mine_e), len(upe)], "evt_missing": sorted(upe - mine_e),
            "method": [0, len(upm)], "method_missing": sorted(upm),
            "slot": [0, len(ups)], "slot_missing": sorted(ups),
        })

json.dump({"report": report, "upstream_tags": sorted(up)}, open("/tmp/elapi/final.json","w"), indent=1)

if "--missing" in sys.argv:
    want = sys.argv[sys.argv.index("--missing")+1]
    for r in report:
        if want not in (r["fn"], r["tag"]): continue
        print(f"\n== {r['fn']}  <{r['tag']}> ==")
        if r["conditional"]:
            print(f"  条件绑定/update不可达 ({len(r['conditional'])}): {', '.join(r['conditional'])}")
        for key, label in (("attr_missing","属性缺失"), ("evt_missing","事件"),
                           ("method_missing","方法"), ("slot_missing","插槽")):
            if r[key]:
                print(f"  {label} ({len(r[key])}): {', '.join(r[key])}")
    sys.exit(0)

report.sort(key=lambda r: (r["attr"][0]/max(r["attr"][1],1), -r["attr"][1]))
print(f"{'函数':22s} {'标签':20s} {'可设':>8s} {'仅条件':>5s} {'事件':>6s} {'方法':>6s} {'插槽':>6s}")
print("-"*74)
for r in report:
    print(f"  {r['fn']:20s} {r['tag']:20s} "
          f"{r['attr'][0]:3d}/{r['attr'][1]:<4d} {len(r['conditional']):>3d}  {r['evt'][0]:2d}/{r['evt'][1]:<4d} "
          f"{r['method'][0]:2d}/{r['method'][1]:<3d} {r['slot'][0]:2d}/{r['slot'][1]:<3d}")
tc = sum(len(r["conditional"]) for r in report)
tb = sum(r["bound"][0] for r in report)
ta = [sum(r["attr"][i] for r in report) for i in (0,1)]
te = [sum(r["evt"][i] for r in report) for i in (0,1)]
tm = sum(r["method"][1] for r in report); ts = sum(r["slot"][1] for r in report)
print("-"*74)
if any(True for _ in EXCLUDED):
    print(f"  ({len(EXCLUDED)} 个上游 prop 按设计排除，见 tools/api-coverage.py 的 EXCLUDED)")
print(f"  合计  可设 {ta[0]}/{ta[1]} ({100*ta[0]//ta[1]}%)  其中已绑定 {tb}, 仅条件绑定 {tc}   事件 {te[0]}/{te[1]} ({100*te[0]//max(te[1],1)}%)   方法 0/{tm}   插槽 0/{ts}")
