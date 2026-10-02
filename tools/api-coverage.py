#!/usr/bin/env python3
"""Measure how much of upstream Element UI's documented API this package exposes.

Needs the upstream sources, which are not in the repo (see .gitignore):

    mkdir -p .upstream && cd .upstream
    curl -sL https://github.com/ElemeFE/element/archive/refs/tags/v2.15.14.tar.gz | tar xz
    mv element-2.15.14 element

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
            # Services document their arguments as "Options" (Message,
            # Notification, MessageBox, Loading); they are attributes here.
            for k, norm in (("Options","Attributes"), ("Attributes","Attributes"), ("Attribute","Attributes"),
                            ("Events","Events"), ("Event","Events"),
                            ("Methods","Methods"), ("Method","Methods"),
                            ("Scoped Slot","Slot"), ("Slots","Slot"), ("Slot","Slot")):
                if title.endswith(k) or f" {k} " in f" {title} ":
                    kind = norm
                    break
            # "Picker Options", "Time Select Options": the fields of one
            # argument (picker_options = list(...)), not props of a component
            if kind and title.endswith("Options") and title.strip() != "Options":
                kind = None
            cur = (title, kind) if kind else None
            continue
        # Some tables are written without leading/trailing pipes
        if cur and ln.count("|") >= 2 and not re.match(r'^[\s:\-|]+$', ln):
            cells = [c.strip() for c in ln.strip().strip("|").split("|")]
            if not cells or not cells[0]: continue
            # Header row: a header word in the first column and "Description"
            # in the second. Checking the second alone dropped el-empty's
            # `description` prop, whose own description is "description".
            if (len(cells) > 1 and cells[1].strip().lower() in ("description", "desc")
                    and re.match(r'^(attribute|attributes|name|event|method|slot|param|parameter|option)s?(\s+name)?$',
                                 cells[0].strip("`*_ ").lower())):
                continue
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

# Props a parent passes down to its children in Element itself
PROPAGATED = {
    "el-checkbox": {"disabled", "size"}, "el-checkbox-button": {"disabled", "size"},
    "el-radio": {"disabled", "size"}, "el-radio-button": {"disabled", "size"},
    "el-form-item": {"size", "labelWidth"},
}

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
    base = re.sub(r'\s*(Attributes?|Events?|Methods?|Scoped Slot|Slots?|Options)\s*$', '', title).strip()
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

# Upstream documents some components under names that are not the tag, or as
# a mode of another component; fold them into what actually renders.
def _merge(into, frm):
    if frm not in up: return
    for k, v in up.pop(frm).items():
        have = up.setdefault(into, {}).setdefault(k, [])
        have.extend(x for x in v if x not in have)
_merge("el-submenu", "el-sub-menu")
_merge("el-dropdown-item", "el-dropdown-menu-item")
_merge("el-date-picker", "el-datetime-picker")      # type = "datetime"
_merge("el-statistic", "el-statistic.-countdown")   # time-indices
up.pop("el-date-cell-scoped-slot-parameters", None) # a doc table, not a tag

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
    if fn.startswith(".") or not info.get("ok"): continue
    acc = set()
    for tag, attrs in (info.get("tags") or {}).items():
        if isinstance(attrs, str): attrs = [attrs]
        acc |= {camel(a) for a in attrs if not a.startswith("@")}
        if any(a == "v-model" for a in attrs): acc |= {"value"}
    bound_by_fn[fn] = acc - VUE

report, seen = [], set()
for fn, info in sorted(ours.items()):
    if fn.startswith(".") or not info.get("ok"): continue
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
        filled = info.get("slots") or []
        if isinstance(filled, str): filled = [filled]
        filled = set(filled)
        # "default" is the unnamed slot: markup passed straight in
        if any(not a.startswith(("@", ":", "v-")) for a in
               sum(([x] if isinstance(x, str) else x
                    for x in (info.get("tags") or {}).values()), [])):
            pass
        mine_a = {camel(a) for a in attrs if not a.startswith("@")} - VUE
        raw_params = info.get("params") or []
        if isinstance(raw_params, str): raw_params = [raw_params]
        params = {snake_camel(p) for p in raw_params}
        # A function's arguments describe its own component. A child tag only
        # borrows one where the parent really hands it down -- a checkbox
        # group's `disabled` reaches every checkbox, but a select's `disabled`
        # turns off the whole select, not one option.
        if tag != "el-" + fn[3:].replace("_", "-"):
            params = params & PROPAGATED.get(tag, set())
        mine_e = {a[1:] for a in attrs if a.startswith("@")}
        # v-model 覆盖 value
        if any(a == "v-model" for a in attrs): mine_a |= {"value", "modelValue"}
        # Settable but not bound: the UI accepts it, update_el_*() cannot touch it
        conditional = sorted((upa & params) - mine_a - (bound_by_fn.get(fn, set()) & (params | PROPAGATED.get(tag, set()))))
        report.append({
            "fn": fn, "tag": tag, "conditional": conditional,
            "attr": [len(upa & (mine_a | params)), len(upa)],
            "bound": [len(upa & mine_a), len(upa)],
            "attr_missing": sorted(upa - mine_a - params),
            "evt": [len(upe & mine_e), len(upe)], "evt_missing": sorted(upe - mine_e),
            # el_call() can invoke any of them on a component with a Vue instance
            "method": [len(upm) if info.get("invokable") else 0, len(upm)],
            "method_missing": [] if info.get("invokable") else sorted(upm),
            "slot": [len(ups & filled), len(ups)],
            "slot_missing": sorted(ups - filled),
        })

json.dump({"report": report, "upstream_tags": sorted(up)}, open("/tmp/elapi/final.json","w"), indent=1)

# Components reimplemented as markup plus a Shiny input binding render
# Element's classes rather than its tags, so rendering them tells nothing.
# Their props are checked against the R arguments and the fields read off
# each item; their events against the input names their binding sets.
import os
def _js(name):
    path = os.path.join("inst", "js", name)
    return open(path).read() if os.path.exists(path) else ""

def _snake(c):
    # dangerouslyUseHTMLString -> dangerously_use_html_string, not ..._h_t_m_l_...
    c = re.sub(r'([A-Z]+)([A-Z][a-z])', r'\1_\2', c)
    return re.sub(r'([a-z0-9])([A-Z])', r'\1_\2', c).lower()

MARKUP = {
    "el-tabs": ("el_tabs", "el-tabs-binding.js"),
    "el-tab-pane": ("el_tabs", "el-tabs-binding.js"),
    "el-collapse": ("el_collapse", "el-collapse-binding.js"),
    "el-collapse-item": ("el_collapse", "el-collapse-binding.js"),
    "el-dialog": ("el_dialog", "el-overlay-binding.js"),
    "el-drawer": ("el_drawer", "el-overlay-binding.js"),
    "el-row": ("el_row", None), "el-col": ("el_col", None),
    "el-container": ("el_container", None), "el-header": ("el_header", None),
    "el-aside": ("el_aside", None), "el-footer": ("el_footer", None),
    "el-card": ("el_card", None), "el-badge": ("el_badge", None),
    "el-divider": ("el_divider", None), "el-link": ("el_link", None),
    "el-infinite-scroll": ("el_infinite_scroll", None),
}
# An upstream name that is deliberately different here: (tag, prop) -> arg
RENAMED = {
    ("el-tabs", "value"): "selected", ("el-collapse", "value"): "value",
    ("el-infinite-scroll", "infinite-scroll-disabled"): "disabled",
    ("el-infinite-scroll", "infinite-scroll-delay"): "delay",
    ("el-infinite-scroll", "infinite-scroll-distance"): "distance",
    ("el-infinite-scroll", "infinite-scroll-immediate"): "immediate",
}
# An event reported as the component's own input value rather than a new one
VALUE_EVENTS = {("el-collapse", "change")}
for tag, (fn, js) in MARKUP.items():
    if tag not in up or fn not in ours: continue
    info = ours[fn]
    params = info.get("params") or []
    if isinstance(params, str): params = [params]
    fields = info.get("item_fields") or []
    if isinstance(fields, str): fields = [fields]
    have = set(params) | set(fields) | {_snake(f) for f in fields}
    src = _js(js) if js else ""
    upa = [a for a in up[tag].get("Attributes", []) if (tag, camel(a)) not in EXCLUDED]
    def has_attr(a):
        if (tag, a) in RENAMED: return RENAMED[(tag, a)] in have
        return _snake(camel(a)) in have or camel(a) in have
    ev = up[tag].get("Events", [])
    def has_evt(e):
        # Only a quoted input suffix counts: "_open" also matches the
        # el-drawer__open class name
        return (tag, e) in VALUE_EVENTS or re.search(
            r"['\"]_" + e.replace("-", "_") + r"['\"]", src) is not None
    me = up[tag].get("Methods", [])
    sl = up[tag].get("Slot", [])
    report.append({
        "fn": fn, "tag": tag + " (markup)", "conditional": [],
        "attr": [sum(map(has_attr, upa)), len(upa)], "bound": [sum(map(has_attr, upa)), len(upa)],
        "attr_missing": [a for a in upa if not has_attr(a)],
        "evt": [sum(map(has_evt, ev)), len(ev)], "evt_missing": [e for e in ev if not has_evt(e)],
        "method": [sum(1 for m in me if m in src), len(me)],
        "method_missing": [m for m in me if m not in src],
        "slot": [sum(1 for x in sl if x in have), len(sl)],
        "slot_missing": [x for x in sl if x not in have],
    })

# Services called from the server: their options are the function's
# arguments, and `close` is a function of its own.
SERVICES = {
    "el-message":      ("el_message", "el_message_close"),
    "el-notification": ("el_notification", "el_notification_close"),
    "el-message-box":  ("el_message_box", None),
    "el-loading":      ("el_loading", "el_loading_close"),
}
# Callbacks become Shiny inputs rather than arguments: option -> the input
CALLBACK_INPUTS = {
    ("el-message", "onClose"): "input$<id>_close",
    ("el-notification", "onClose"): "input$<id>_close",
    ("el-notification", "onClick"): "input$<id>_click",
    ("el-message-box", "callback"): "input$<id>",
}
svc = ours.get(".services", {}) if isinstance(ours.get(".services"), dict) else {}
for tag, (fn, closer) in SERVICES.items():
    if tag not in up: continue
    args = svc.get(fn) or []
    if isinstance(args, str): args = [args]
    js_all = "".join(_js(f) for f in os.listdir(os.path.join("inst", "js")))
    def has_opt(o):
        if (tag, o) in CALLBACK_INPUTS:
            suffix = CALLBACK_INPUTS[(tag, o)].split("$<id>")[1]
            return "id" in args and (suffix == "" or
                                     re.search(r"['\"]" + suffix + r"['\"]", js_all) is not None)
        return _snake(o) in args or o in args
    opts = up[tag].get("Attributes", [])
    me = up[tag].get("Methods", [])
    has_m = lambda m: m == "close" and closer is not None and bool(svc.get(closer))
    report.append({"fn": fn if args else "-", "tag": tag + " (service)", "conditional": [],
        "attr": [sum(map(has_opt, opts)), len(opts)], "bound": [sum(map(has_opt, opts)), len(opts)],
        "attr_missing": [o for o in opts if not has_opt(o)],
        "evt": [0, 0], "evt_missing": [],
        "method": [sum(map(has_m, me)), len(me)], "method_missing": [m for m in me if not has_m(m)],
        "slot": [0, 0], "slot_missing": []})

# Upstream components this package has no wrapper for at all
_seen_tags = {r["tag"].split(" ")[0] for r in report}
for tag in sorted(up):
    if tag in _seen_tags: continue
    d = up[tag]
    report.append({"fn": "-", "tag": tag + " (unwrapped)", "conditional": [],
        "attr": [0, len(d.get("Attributes", []))], "bound": [0, len(d.get("Attributes", []))],
        "attr_missing": d.get("Attributes", []),
        "evt": [0, len(d.get("Events", []))], "evt_missing": d.get("Events", []),
        "method": [0, len(d.get("Methods", []))], "method_missing": d.get("Methods", []),
        "slot": [0, len(d.get("Slot", []))], "slot_missing": d.get("Slot", [])})

if "--gaps" in sys.argv:
    for r in sorted(report, key=lambda r: r["tag"]):
        parts = [(k, r[k + "_missing"]) for k in ("attr", "evt", "method", "slot")]
        parts = [f"{k}: {', '.join(v)}" for k, v in parts if v]
        if parts:
            print(f"  {r['fn']:22s} {r['tag']:34s} {' | '.join(parts)}")
    sys.exit(0)

if "--missing" in sys.argv:
    want = sys.argv[sys.argv.index("--missing")+1]
    for r in report:
        if want not in (r["fn"], r["tag"], r["tag"].split(" ")[0]): continue
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
tm = [sum(r["method"][i] for r in report) for i in (0, 1)]
ts = [sum(r["slot"][i] for r in report) for i in (0, 1)]
print("-"*74)
if any(True for _ in EXCLUDED):
    print(f"  ({len(EXCLUDED)} 个上游 prop 按设计排除，见 tools/api-coverage.py 的 EXCLUDED)")
print(f"  合计  可设 {ta[0]}/{ta[1]} ({100*ta[0]//ta[1]}%)  其中已绑定 {tb}, 仅条件绑定 {tc}   事件 {te[0]}/{te[1]} ({100*te[0]//max(te[1],1)}%)   方法 {tm[0]}/{tm[1]}   插槽 {ts[0]}/{ts[1]}")

# ── methods: reachable, and verified ──────────────────────────────────────────
# Every method of a component with a Vue instance can be called by name; what
# a browser test has run end to end is a smaller set. Called directly with
# el_call() in the tests, or by an update_el_*()/helper that runs it.
import glob as _glob
VIA_UPDATE = {"setActiveItem": "update_el_carousel(active =)",
              "setCheckedKeys": "update_el_tree(checked =)",
              "validate": "el_form_validate()", "resetFields": "el_form_reset()",
              "clearValidate": "el_form_clear_validate()", "clearFiles": "el_upload_clear()",
              "abort": "test-browser.R abort()"}
tested = set()
for f in _glob.glob("tests/testthat/*.R") + _glob.glob("tests/testthat/apps/*.R"):
    src = open(f, encoding="utf-8").read()
    tested |= set(re.findall(r'el_call\([^)]*?"[^"]+",\s*"([A-Za-z]+)"', src))
upstream_methods = set()
for r in report:
    upstream_methods |= set(up.get(r["tag"].split(" ")[0], {}).get("Methods", []))
verified = sorted((tested | set(VIA_UPDATE)) & upstream_methods)
print(f"  方法：{tm[0]}/{tm[1]} 可按名调用，其中 {len(verified)} 个有浏览器端到端测试")

if "--write-docs" in sys.argv:
    # The numbers in .claude/docs/api-coverage.md come from here, not by hand
    path = ".claude/docs/api-coverage.md"
    doc = open(path, encoding="utf-8").read()
    block = "\n".join([
        "<!-- coverage:start -- written by `python tools/api-coverage.py --write-docs` -->",
        f"{len(report)} wrapper/tag pairs measured:",
        "",
        "| | covered | total |",
        "|---|---|---|",
        f"| Settable attributes | {ta[0]} | {ta[1]} |",
        f"| Events | {te[0]} | {te[1]} |",
        f"| Methods callable by name | {tm[0]} | {tm[1]} |",
        f"| Methods run end to end in a browser test | {len(verified)} | {tm[1]} |",
        f"| Slots | {ts[0]} | {ts[1]} |",
        "",
        "Methods with an end-to-end test: " + ", ".join(f"`{m}`" for m in verified) + ".",
        "<!-- coverage:end -->"])
    doc = re.sub(r"<!-- coverage:start.*?<!-- coverage:end -->", block, doc, flags=re.S)
    open(path, "w", encoding="utf-8").write(doc)
    print("wrote", path)
