#!/usr/bin/env python3
"""Measure how much of upstream Element Plus's documented API this package exposes.

Needs the upstream sources, which are not in the repo (see .gitignore and
.upstream/README.md):

    git clone --depth 1 --branch 2.14.7 https://github.com/element-plus/element-plus .upstream/element-plus

In three steps, in this order (Python from the project venv): parse the
upstream docs, snapshot what we render -- which probes every slot the docs
list, so it needs the first step's output -- and compare:

    python tools/api-coverage.py --docs
    Rscript tools/api-coverage.R
    python tools/api-coverage.py [--missing el_table | --gaps]

The snapshot stops if the parsed docs are missing or older than the docs.

The baseline is the API tables in the upstream docs
(docs/en-US/component/*.md): what upstream actually promises.
"""
import sys, os

DOCS = ".upstream/element-plus/docs/en-US/component"
if not os.path.isdir(DOCS):
    sys.exit("upstream sources missing -- see the header of this file")
import re, json, glob

# Section titles that document a component's API, and what they hold.
# "Exposes" are the component's instance: its functions are what call_el()
# can call (Methods); the rest are refs and values.
KINDS = (("Attributes", "Attributes"), ("Attribute", "Attributes"), ("Options", "Attributes"),
         ("Events", "Events"), ("Event", "Events"), ("Exposes", "Methods"),
         ("Slots", "Slot"), ("Slot", "Slot"))
# Tables that are not one component's props: a prop's own fields, type
# declarations, ConfigProvider's per-component settings
SKIP_TITLE = re.compile(r"(Options attribute|Declarations|Types?$|Configurations|value-key|"
                        r"Tab-bar|Tab-nav)", re.I)
# ConfigProvider documents each component's settings under that component's
# name; only its own table is its API
CONFIG_OWN = re.compile(r"^(Config Provider )?(Attributes|Slots)$")

def clean(cell):
    cell = re.sub(r"\^\([^)]*\)", "", cell)            # ^(2.2.0) version marks
    cell = re.sub(r"\[([^\]]*)\]\([^)]*\)", r"\1", cell)   # [props](#props): a link to its own table
    return cell.strip()

def parse(path):
    lines = open(path, encoding="utf-8", errors="replace").read().split("\n")
    out, cur, comp, cols = {}, None, os.path.basename(path)[:-3], []
    for ln in lines:
        h = re.match(r'^#{2,4}\s+(.+?)\s*$', ln)
        if h:
            title = clean(h.group(1))
            kind = None
            for k, norm in KINDS:
                if title.lower() == k.lower() or title.lower().endswith(" " + k.lower()):
                    kind = norm
                    break
            if kind and SKIP_TITLE.search(title):
                kind = None
            if kind and comp == "config-provider" and not CONFIG_OWN.match(title):
                kind = None
            # Options belong to services only (message, notification, ...)
            if kind == "Attributes" and title.endswith("Options") and \
                    comp not in ("message", "notification", "message-box", "loading"):
                kind = None
            cur = (title, kind) if kind else None
            continue
        if cur and ln.count("|") >= 2 and not re.match(r'^[\s:\-|]+$', ln):
            cells = [c.strip() for c in re.split(r'(?<!\\)\|', ln.strip().strip("|"))]
            if not cells or not cells[0]: continue
            name = clean(cells[0]).strip("`*_ ")
            # "model-value / v-model" documents one prop under two spellings
            name = name.split("/")[0].strip().strip("`*_ ")
            if name.lower() in ("name", "attribute", "event", "method", "slot", "option", "property"):
                # a table listing methods by their parameters rather than a
                # type (tree's) is still methods
                cols = [clean(c).lower() for c in cells]
                continue
            if not re.match(r'^[a-zA-Z][\w:.-]*$', name): continue
            title, kind = cur
            typ = cells[2] if len(cells) > 2 else ""
            # An exposed value or ref is not something to call
            if kind == "Methods" and "Function" not in typ and "=>" not in typ \
                    and "parameters" not in cols:
                continue
            # v-model's plumbing, not an event of its own
            if kind == "Events" and name.startswith("update:"):
                continue
            out.setdefault(title, {"kind": kind, "items": []})
            out[title]["items"].append({
                "name": name,
                "desc": cells[1] if len(cells) > 1 else "",
                "type": typ,
                "accepted": "",
                "default": cells[3] if len(cells) > 3 and kind == "Attributes" else "",
            })
    return out

api = {}
for p in sorted(glob.glob(f"{DOCS}/*.md")):
    comp = os.path.basename(p)[:-3]
    sec = parse(p)
    if sec: api[comp] = sec

os.makedirs("/tmp/elapi", exist_ok=True)
json.dump(api, open("/tmp/elapi/docs.json","w"), indent=1)
if "--docs" in sys.argv:
    sys.exit(0)
if not os.path.exists("/tmp/elapi/ours.json") or \
        os.path.getmtime("/tmp/elapi/ours.json") < os.path.getmtime(DOCS):
    sys.exit("run Rscript tools/api-coverage.R first (after --docs)")

docs = api
ours = json.load(open("/tmp/elapi/ours.json"))

OWNER = {"el-button": "el_button", "el-option": "el_select", "el-icon": "el_icon"}

# Props a parent passes down to its children in Element itself
PROPAGATED = {
    "el-checkbox": {"disabled", "size"}, "el-checkbox-button": {"disabled", "size"},
    "el-radio": {"disabled", "size"}, "el-radio-button": {"disabled", "size"},
    "el-form-item": {"size", "labelWidth"},
}

# Props deliberately not exposed, with the reason. Counted as out of scope
# rather than missing, so the coverage figure means something.
EXCLUDED = {
    ("el-checkbox", "ariaControls"): "inside a group, each option's ARIA is the group's to set",
    ("el-checkbox", "ariaLabel"): "inside a group, each option's ARIA is the group's to set",
    ("el-checkbox", "controls"): "inside a group, each option's ARIA is the group's to set",
    ("el-checkbox", "tabindex"): "inside a group, each option's ARIA is the group's to set",
    ("el-checkbox", "validateEvent"): "inside a group, validation is the group's",
    ("el-tabs", "tabindex"): "the tabs are markup here; each tab's tabindex follows Element's roving focus",
    ("el-tree-select", "Attributes"): "a cross-reference row in upstream's table, not a prop",
    ("el-tree-select", "select"): "a cross-reference row: el_tree_select() takes the select's attributes, its `...` the rest",
    ("el-tree-select", "tree"): "a cross-reference row: el_tree_select() takes the tree's attributes, its `...` the rest",
    ("el-popover", "tooltip"): "a cross-reference row: the tooltip's other attributes go through el_popover(...)",
    ("el-popconfirm", "tooltip"): "a cross-reference row: the tooltip's other attributes go through el_popconfirm(...)",
    ("el-config-provider", "locale"): "the page's: el_page(locale =), as every component is an app of its own",
    ("el-config-provider", "zIndex"): "the page's: el_page(z_index =)",
    ("el-config-provider", "namespace"): "the stylesheet is Element Plus's own, built for the el- namespace",
    ("el-input", "modelModifiers"): "v-model's modifiers are a template's, not a prop to set",
    ("el-autocomplete", "popperAppendToBody"): "upstream marks popper-append-to-body deprecated; teleported is bound",
    ("el-space", "class"): "class, style and prefix-cls are any element's",
    ("el-table-v2", "class"): "any element's class; a reserved word in a template expression",
    ("el-space", "style"): "class, style and prefix-cls are any element's",
    ("el-space", "prefixCls"): "class, style and prefix-cls are any element's",
    ("el-checkbox", "modelValue"): "the group owns the value",
    ("el-checkbox", "trueValue"): "inside a group the group's value decides, not a box's own",
    ("el-checkbox", "falseValue"): "inside a group the group's value decides, not a box's own",
    ("el-checkbox-button", "trueValue"): "inside a group the group's value decides, not a box's own",
    ("el-checkbox-button", "falseValue"): "inside a group the group's value decides, not a box's own",
    ("el-checkbox-button", "value"): "the option's value, from `choices`",
    ("el-radio", "modelValue"): "the group owns the value",
    ("el-radio-button", "value"): "the option's value, from `choices`",
    ("el-select", "autoComplete"): "upstream marks auto-complete @DEPRECATED; autocomplete is bound",
    ("el-input", "autoComplete"): "upstream marks auto-complete @DEPRECATED; autocomplete is bound",
    ("el-checkbox", "value"): "the group owns the value through v-model; a child's own value is unused inside one",
    ("el-switch", "label"): "upstream marks label deprecated, an alias of aria-label, which is bound; `label` is the Shiny label",
    ("el-rate", "label"): "upstream marks label deprecated, an alias of aria-label, which is bound; `label` is the Shiny label",
    ("el-color-picker", "label"): "upstream marks label deprecated, an alias of aria-label, which is bound; `label` is the Shiny label",
    ("el-time-picker", "label"): "upstream marks label deprecated, an alias of aria-label, which is bound; `label` is the Shiny label",
    ("el-radio", "value"): "the group owns the value through v-model; a child's own value is unused inside one",
}
# An argument named as the prop but honoured otherwise than by binding it.
# Only these count as covered without a binding; any other argument that
# merely shares a prop's name is reported as missing.
ALIASES = {
    ("el-checkbox-group", "options"): "an alias of `choices`, rendered as el-checkbox children",
    ("el-radio-group", "options"): "an alias of `choices`, rendered as el-radio children",
    ("el-select", "options"): "an alias of `choices`, rendered as el-option children",
    ("el-select", "props"): "applied in R: the options are drawn as el-option children, their fields renamed",
}
# Events not forwarded, with the reason
EVENTS_EXCLUDED = {"el-tour-step": {"close"}}   # the tour's own close reports it, step and all

# Section names that are not the tag's
SPECIAL = {"submenu": "el-sub-menu", "own": None, "transfer-panel": "el-transfer-panel",
           "config-provider": "el-config-provider", "countdown": "el-countdown"}

def section_tag(fileslug, title):
    """'ButtonGroup Attributes' -> el-button-group ; 'Attributes' -> el-<file>"""
    base = re.sub(r'\s*(Attributes?|Events?|Exposes|Slots?|Options)\s*$', '', title, flags=re.I).strip()
    if not base or base.lower() == "own":
        base = fileslug
    slug = re.sub(r'(?<=[a-z0-9])(?=[A-Z])', '-', base).lower()   # ButtonGroup -> button-group
    slug = re.sub(r'(?<=[a-z])(?=v2$)', '-', slug)                 # TableV2 -> table-v2
    slug = re.sub(r'[\s_]+', '-', slug).strip('-')
    slug = re.sub(r'-+', '-', slug)
    if slug in SPECIAL and SPECIAL[slug]: return SPECIAL[slug]
    return "el-" + slug

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
_merge("el-date-picker", "el-datetime-picker")      # type = "datetime"

def camel(a):
    # v-model:current-page binds current-page
    if a.startswith("v-model:"): a = a[len("v-model:"):]
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
        # `id` is the host's: every component has one, the Shiny input's
        upa -= {"id"}
        upe = set(up[tag].get("Events", [])) - EVENTS_EXCLUDED.get(tag, set())
        upm = set(up[tag].get("Methods", []))
        ups = set(up[tag].get("Slot", []))
        filled = info.get("slots") or []
        if isinstance(filled, str): filled = [filled]
        filled = set(filled) | {"default"}
        # A table column's cell template is its default slot, which an
        # expand column shows as the expanded row
        if tag == "el-table-column": filled |= {"expand"}
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
        # An argument that only shares the prop's name -- el_tooltip's old
        # `trigger`, which was the reference -- is not the prop
        aliased = {p for p in conditional if (tag, p) in ALIASES}
        covered = upa & (mine_a | (params - set(conditional)) | aliased)
        report.append({
            "fn": fn, "tag": tag, "conditional": sorted(aliased),
            "attr": [len(covered), len(upa)],
            "bound": [len(upa & mine_a), len(upa)],
            "attr_missing": sorted(upa - covered),
            "evt": [len(upe & mine_e), len(upe)], "evt_missing": sorted(upe - mine_e),
            # call_el() can invoke any of them on a component with a Vue instance
            "method": [len(upm) if info.get("invokable") else 0, len(upm)],
            "method_missing": [] if info.get("invokable") else sorted(upm),
            "slot": [len(ups & filled), len(ups)],
            "slot_missing": sorted(ups - filled),
            # bound here but not an Element Plus prop: renamed or removed upstream
            "extra": sorted(mine_a - upa - {"modelValue", "value"} - {camel(x) for x in up[tag].get("Attributes", [])}),
            "extra_evt": sorted(mine_e - upe - {"update:modelValue"}),
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
    "el-main": ("el_main", None), "el-icon": ("el_icon", None),
}
# An upstream name that is deliberately different here: (tag, prop) -> arg
RENAMED = {
    ("el-dialog", "model-value"): "visible", ("el-drawer", "model-value"): "visible",
    ("el-collapse", "model-value"): "value", ("el-tabs", "model-value"): "selected",
    ("el-tabs", "default-value"): "selected",
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
    # A slot is filled by content, by the argument of its name, or -- the
    # header -- by the title, which takes markup
    def slot_ok(x):
        return (x == "default" or x in have or _snake(camel(x)) in have or
                (x == "header" and "title" in have) or (x == "content" and "value" in have))
    report.append({
        "fn": fn, "tag": tag + " (markup)", "conditional": [],
        "attr": [sum(map(has_attr, upa)), len(upa)], "bound": [sum(map(has_attr, upa)), len(upa)],
        "attr_missing": [a for a in upa if not has_attr(a)],
        "evt": [sum(map(has_evt, ev)), len(ev)], "evt_missing": [e for e in ev if not has_evt(e)],
        "method": [sum(1 for m in me if m in src), len(me)],
        "method_missing": [m for m in me if m not in src],
        "slot": [sum(1 for x in sl if slot_ok(x)), len(sl)],
        "slot_missing": [x for x in sl if not slot_ok(x)],
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
    ("el-loading", "closed"): "input$<id>_closed",
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

# Tags whose props are fields of a data argument rather than markup: a
# virtualized table's columns are objects it is handed, not child tags
FIELD_TAGS = {"el-column": "el_table_v2"}
for tag, fn in FIELD_TAGS.items():
    if tag not in up: continue
    a = up[tag].get("Attributes", [])
    report.append({"fn": fn, "tag": tag + " (fields)", "conditional": [],
        "attr": [len(a), len(a)], "bound": [len(a), len(a)], "attr_missing": [],
        "evt": [0, 0], "evt_missing": [], "method": [0, 0], "method_missing": [],
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

if "--extra" in sys.argv:
    for r in sorted(report, key=lambda r: r["tag"]):
        ex, ev = r.get("extra") or [], r.get("extra_evt") or []
        if ex or ev:
            print(f"  {r['fn']:22s} {r['tag']:24s} attr: {', '.join(ex)}" + (f" | evt: {', '.join(ev)}" if ev else ""))
    sys.exit(0)

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
            print(f"  别名，未绑定同名 prop ({len(r['conditional'])}): {', '.join(r['conditional'])}")
        for key, label in (("attr_missing","属性缺失"), ("evt_missing","事件"),
                           ("method_missing","方法"), ("slot_missing","插槽")):
            if r[key]:
                print(f"  {label} ({len(r[key])}): {', '.join(r[key])}")
    sys.exit(0)

report.sort(key=lambda r: (r["attr"][0]/max(r["attr"][1],1), -r["attr"][1]))
print(f"{'函数':22s} {'标签':20s} {'可设':>8s} {'别名':>5s} {'事件':>6s} {'方法':>6s} {'插槽':>6s}")
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
    print(f"  ({len(EXCLUDED)} 个上游 prop 按设计排除，不计入分母，见 tools/api-coverage.py 的 EXCLUDED)")
print(f"  合计  可设 {ta[0]}/{ta[1]} ({100*ta[0]//ta[1]}%)  其中绑定到同名 prop {tb}, 由父标签下传 {ta[0]-tb-tc}, 声明的别名 {tc}   事件 {te[0]}/{te[1]} ({100*te[0]//max(te[1],1)}%)   方法 {tm[0]}/{tm[1]}   插槽 {ts[0]}/{ts[1]}")

# ── methods: reachable, and verified ──────────────────────────────────────────
# Every method of a component with a Vue instance can be called by name.
# Verified means run on a live component in a browser test, counted per
# component and method -- focus() on an input and on a select are two.
# tests/testthat/apps/methods.R lists one case per pair, run one by one by
# test-browser-methods.R; a case names its component's id, and the id is
# found in the call that builds it.
METHOD_EXCLUDED = {
    ("el_calendar", "pickDay"): "takes a day.js date, which R cannot send; update_el_calendar(value =)",
    ("el_calendar", "calculateValidatedDateRange"): "takes two day.js dates, which R cannot send",
    ("el_upload", "handleStart"): "takes a file the user picked, which only the browser holds",
}
fixture = open("tests/testthat/apps/methods.R", encoding="utf-8").read()
id_fn = {}
for m in re.finditer(r'\b(el_[a-z0-9_]+)\(', fixture):
    near = re.search(r'"(m_[a-z0-9]+)"', fixture[m.end():m.end() + 160])
    if near and near.group(1) not in id_fn and \
            not fixture[m.end():m.end() + near.start()].count("("):
        id_fn[near.group(1)] = m.group(1)
ran = set()
for c in re.finditer(r'list\(\s*id = "(m_[a-z0-9]+)",\s*(?:component = "([A-Za-z]+)",\s*)?method = "([A-Za-z]+)"', fixture):
    fn = id_fn.get(c.group(1))
    tag = re.sub(r'(?<!^)(?=[A-Z])', '-', c.group(2)).lower() if c.group(2) else None
    ran.add((fn, tag, c.group(3)))
expected, verified, unrun = [], [], []
for r in report:
    if not r["method"][1]: continue
    tag = r["tag"].split(" ")[0]
    for m in up.get(tag, {}).get("Methods", []):
        if (r["fn"], m) in METHOD_EXCLUDED: continue
        expected.append((r["fn"], tag, m))
        own = tag == "el-" + r["fn"][3:].replace("_", "-")
        if (r["fn"], tag, m) in ran or (own and (r["fn"], None, m) in ran):
            verified.append((r["fn"], tag, m))
        else:
            unrun.append(f"{r['fn']}:{tag}.{m}")
tested_pairs = len(set(verified))
print(f"  方法：{tm[0]}/{tm[1]} 可按名调用；{len(METHOD_EXCLUDED)} 个的参数只有浏览器能造（METHOD_EXCLUDED）；"
      f"其余 {len(set(expected))} 个（组件, 方法）中 {tested_pairs} 个在浏览器里实跑过")
if unrun:
    print("  未实跑：" + ", ".join(sorted(set(unrun))))

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
        f"| Methods run on a live component in a browser test | {tested_pairs} | {len(set(expected))} |",
        f"| Slots | {ts[0]} | {ts[1]} |",
        "",
        f"Every method is run by `test-browser-methods.R`, from `apps/methods.R`, except {len(METHOD_EXCLUDED)} whose "
        "argument only the browser can make: " + ", ".join(f"`{f}()`'s `{m}`" for (f, m) in METHOD_EXCLUDED) + ".",
        "<!-- coverage:end -->"])
    doc = re.sub(r"<!-- coverage:start.*?<!-- coverage:end -->", block, doc, flags=re.S)
    open(path, "w", encoding="utf-8").write(doc)
    print("wrote", path)

# ── API tables for the component pages ───────────────────────────────────────
# Each page under vignettes/articles/components ends with Element's own API
# tables, and beside each entry where it is in R. Written to a JSON file the
# pages read, so the site builds without the upstream sources.
PAGE_FNS = {
    "layout": ["el_row", "el_col"], "container": ["el_container", "el_header", "el_aside", "el_main", "el_footer"],
    "icon": ["el_icon"], "button": ["el_button", "el_button_group"], "link": ["el_link"],
    "radio": ["el_radio_group"], "checkbox": ["el_checkbox", "el_checkbox_group"],
    "input": ["el_input", "el_autocomplete"], "input-number": ["el_input_number"],
    "select": ["el_select"], "cascader": ["el_cascader", "el_cascader_panel"],
    "switch": ["el_switch"], "slider": ["el_slider"],
    "time-picker": ["el_time_picker", "el_time_select"], "date-picker": ["el_date_picker"],
    "datetime-picker": ["el_date_picker"], "upload": ["el_upload"], "rate": ["el_rate"],
    "color-picker": ["el_color_picker"], "transfer": ["el_transfer"],
    "form": ["el_form", "el_form_field", "el_rule"], "table": ["el_table"], "tag": ["el_tag"],
    "progress": ["el_progress"], "tree": ["el_tree"], "pagination": ["el_pagination"],
    "badge": ["el_badge"], "skeleton": ["el_skeleton"], "empty": ["el_empty"],
    "descriptions": ["el_descriptions"], "result": ["el_result"], "statistic": ["el_statistic"],
    "alert": ["el_alert"], "loading": ["el_loading"], "message": ["el_message"],
    "message-box": ["el_message_box"], "notification": ["el_notification"],
    "menu": ["el_menu"], "tabs": ["el_tabs"], "breadcrumb": ["el_breadcrumb"],
    "page-header": ["el_page_header"], "dropdown": ["el_dropdown"], "steps": ["el_steps"],
    "dialog": ["el_dialog"], "tooltip": ["el_tooltip"], "popover": ["el_popover"],
    "popconfirm": ["el_popconfirm"], "card": ["el_card"], "carousel": ["el_carousel"],
    "collapse": ["el_collapse"], "timeline": ["el_timeline"], "divider": ["el_divider"],
    "calendar": ["el_calendar"], "image": ["el_image"], "backtop": ["el_backtop"],
    "infinite-scroll": ["el_infinite_scroll"], "avatar": ["el_avatar", "el_avatar_group"],
    "drawer": ["el_drawer"], "affix": ["el_affix"], "anchor": ["el_anchor"],
    "autocomplete": ["el_autocomplete"], "color-picker-panel": ["el_color_picker_panel"],
    "config-provider": ["el_config_provider"], "date-picker-panel": ["el_date_picker_panel"],
    "input-otp": ["el_input_otp"], "input-tag": ["el_input_tag"], "mention": ["el_mention"],
    "scrollbar": ["el_scrollbar"], "segmented": ["el_segmented"], "select-v2": ["el_select_v2"],
    "space": ["el_space"], "splitter": ["el_splitter", "el_splitter_panel"],
    "table-v2": ["el_table_v2"], "text": ["el_text"], "time-select": ["el_time_select"],
    "tour": ["el_tour"], "tree-select": ["el_tree_select"], "tree-v2": ["el_tree_v2"],
    "watermark": ["el_watermark"],
}
PAGE_FNS["tag"] = ["el_tag", "el_check_tag"]
PAGE_FNS["image"] = ["el_image", "el_image_viewer"]
PAGE_FNS["statistic"] = ["el_statistic", "el_countdown"]
PAGE_FNS["time-picker"] = ["el_time_picker"]
PAGE_FNS["radio"] = ["el_radio_group"]
NAMED = {("el-menu", "default-active"): "active", ("el-tree", "default-expanded-keys"): "expanded",
         ("el-tree", "default-checked-keys"): "checked", ("el-upload", "data"): "extra_data",
         ("el-popover", "width"): "popover_width", ("el-tabs", "value"): "selected",
         ("el-select", "value"): "selected (or value)", ("el-radio-group", "value"): "selected (or value)",
         ("el-checkbox-group", "value"): "selected (or value)", ("el-upload", "http-request"): "(the Shiny upload)",
         ("el-upload", "on-success"): "input$<id>", ("el-upload", "on-error"): "input$<id>_error"}

def _params(fn):
    p = (ours.get(fn) or {}).get("params") or (ours.get(".services") or {}).get(fn) or []
    return [p] if isinstance(p, str) else p

# A child tag's props are fields of each item in an argument of the parent
CONTAINER = {"el-column": "columns", "el-anchor-link": "links", "el-tour-step": "steps",
             "el-splitter-panel": "el_splitter_panel()","el-sub-menu": "items", "el-table-column": "columns", "el-step": "steps", "el-timeline-item": "items",
             "el-submenu": "items", "el-menu-item": "items", "el-menu-item-group": "items",
             "el-breadcrumb-item": "items", "el-descriptions-item": "items",
             "el-radio": "choices", "el-radio-button": "choices", "el-checkbox": "choices",
             "el-checkbox-button": "choices", "el-option": "choices", "el-option-group": "choices",
             "el-tab-pane": "tabs", "el-collapse-item": "items", "el-carousel-item": "items",
             "el-dropdown-item": "items", "el-skeleton-item": "template()",
             "el-form-item": "el_form_field()"}
NAMED.update({("el-tooltip", "value"): "update_el_tooltip(value =)",
              ("el-popover", "value"): "update_el_popover(value =)",
              ("el-form", "model"): "each field's `value`; update_el_form(model =)",
              ("el-tree", "props"): "label_field, children_field, disabled_field, is_leaf_field",
              ("el-input", "auto-complete"): "(deprecated upstream; `autocomplete`)",
              ("el-select", "auto-complete"): "(deprecated upstream; `autocomplete`)",
              ("el-infinite-scroll", "infinite-scroll-disabled"): "disabled",
              ("el-infinite-scroll", "infinite-scroll-delay"): "delay",
              ("el-infinite-scroll", "infinite-scroll-distance"): "distance",
              ("el-infinite-scroll", "infinite-scroll-immediate"): "immediate"})
NAMED.update({("el-tabs", "default-value"): "selected",
              ("el-config-provider", "locale"): "el_page(locale =)",
              ("el-config-provider", "zIndex"): "el_page(z_index =)",
              ("el-config-provider", "namespace"): "(fixed: `el`)",
              ("el-input", "model-modifiers"): "(Vue only: `v-model.trim`; trim in R)",
              ("el-autocomplete", "popper-append-to-body"): "(deprecated upstream; `teleported`)",
              ("el-space", "prefix-cls"): "(internal upstream)",
              ("el-tabs", "tabindex"): "(set by the tabs)",
              ("el-loading", "closed"): "`el_loading_close()`",
              ("el-message-box", "callback"): "`input$<id>`, the answer",
              ("el-message", "onClose"): "(JS only; Shiny hears through the id)",
              ("el-notification", "onClose"): "`input$<id>_close`",
              ("el-notification", "onClick"): "`input$<id>_click`"})
def _fields(fn):
    f = (ours.get(fn) or {}).get("item_fields") or []
    return [f] if isinstance(f, str) else f

# A child tag written with its own constructor (R/el_items.R): its props are
# that function's arguments. Arguments from /tmp/elapi/formals.json, written
# as tools/ep-choices.py's header says.
ITEM_FN = {"el-tab-pane": "el_tab_pane", "el-collapse-item": "el_collapse_item",
           "el-timeline-item": "el_timeline_item", "el-descriptions-item": "el_descriptions_item",
           "el-carousel-item": "el_carousel_item", "el-step": "el_step",
           "el-breadcrumb-item": "el_breadcrumb_item", "el-dropdown-item": "el_dropdown_item",
           "el-tour-step": "el_tour_step", "el-anchor-link": "el_anchor_link",
           "el-menu-item": "el_menu_item", "el-sub-menu": "el_sub_menu",
           "el-menu-item-group": "el_menu_item_group", "el-option": "el_option",
           "el-option-group": "el_option_group", "el-table-column": "el_table_column",
           "el-column": "el_table_v2_column", "el-skeleton-item": "el_skeleton_item"}
try:
    FORMALS = json.load(open("/tmp/elapi/formals.json"))
except FileNotFoundError:
    FORMALS = {}

def r_name(slug, tag, kind, name):
    fns = PAGE_FNS.get(slug, [])
    snake = _snake(camel(name)) if kind == "Attributes" else _snake(name.replace("-", "_"))
    if kind == "Attributes":
        if (tag, name) in NAMED: return "`" + NAMED[(tag, name)] + "`"
        item_fn = ITEM_FN.get(tag)
        if item_fn and snake in FORMALS.get(item_fn, []):
            return f"`{item_fn}({snake} =)`"
        # v-model's prop: the R argument that starts it, the input that reports it
        if name in ("model-value", "checked"):
            arg = {"el-dialog": "visible", "el-drawer": "visible", "el-tabs": "selected",
                   "el-tour": "open"}.get(tag, "value")
            return f"`{arg}`; `input$<id>`"
        if name == "id": return "`id`, the Shiny input's"
        if name in ("class", "style"): return "an HTML attribute of the tag; `tagAppendAttributes()`"
        for fn in fns:
            if snake in _params(fn): return f"`{snake}`" if len(fns) == 1 else f"`{fn}({snake} =)`"
        for fn in fns:
            if snake in _fields(fn) or camel(name) in _fields(fn): return f"item field `{snake}`"
        if tag in CONTAINER:
            c = CONTAINER[tag]
            if c.endswith(")"): return f"`{c[:-1]}{snake} =)`"
            return f"field `{snake}` of each of `{c}`"
        return ""
    if kind == "Events":
        fw = set()
        for fn in fns:
            x = (ours.get(fn) or {}).get("forwarded") or []
            fw |= set([x] if isinstance(x, str) else x)
        if name in fw: return f"`input$<id>_{snake}`"
        # A container's binding reports its events itself
        tags_js = {"el-tabs": "el-tabs-binding.js", "el-collapse": "el-collapse-binding.js",
                   "el-dialog": "el-overlay-binding.js", "el-drawer": "el-overlay-binding.js"}
        if tag in tags_js and re.search(r"['\"]_" + snake + r"['\"]", _js(tags_js[tag])):
            return f"`input$<id>_{snake}`"
        if name in ("change", "input"): return "`input$<id>`, the value"
        return "one of the component's inputs -- see its reference page"
    if kind == "Methods":
        return f'`call_el(session, id, "{name}")`'
    if kind == "Slot":
        return "default content" if name == "default" else f"`slots = list({name} = )`"
    return ""

if "--write-api" in sys.argv:
    pages = {}
    for slug, secs in docs.items():
        if slug not in PAGE_FNS: continue
        out = []
        for title, sec in secs.items():
            tag = section_tag(slug, title)
            rows = []
            for it in sec["items"]:
                # tree-select's table only points to tree's and select's
                if it["name"] == "Attributes":
                    rows.append({"name": "tree, select", "desc": "The props of el-tree and el-select.",
                                 "type": "", "accepted": "", "default": "",
                                 "r": "any argument of `el_tree()` or `el_select()`, through `...`"})
                    continue
                rows.append({"name": it["name"], "desc": it["desc"], "type": it["type"],
                             "accepted": it.get("accepted", ""),
                             "default": it["default"], "r": r_name(slug, tag, sec["kind"], it["name"])})
            out.append({"title": title, "kind": sec["kind"], "rows": rows})
        pages[slug] = out
    path = "vignettes/articles/components/api.json"
    os.makedirs(os.path.dirname(path), exist_ok=True)
    json.dump(pages, open(path, "w", encoding="utf-8"), indent=0, ensure_ascii=False)
    print("wrote", path, len(pages), "pages")
