#!/usr/bin/env python3
"""Write R/el_choices.R's table from Element Plus's API tables.

Every argument of a component function that is an enumerated prop upstream
-- ^[enum]`'a' | 'b'` with no free-form alternative -- is checked against
upstream's values. Needs /tmp/elapi/docs.json (tools/api-coverage.py --docs)
and /tmp/elapi/formals.json, the functions' arguments:

    Rscript -e 'pkgload::load_all(); ns <- asNamespace("shiny.element");
      f <- grep("^el_", getNamespaceExports(ns), value = TRUE);
      f <- Filter(function(x) is.function(ns[[x]]), f);
      jsonlite::write_json(lapply(setNames(f, f), function(x) names(formals(ns[[x]]))),
                           "/tmp/elapi/formals.json")'
"""
import json, re
docs = json.load(open("/tmp/elapi/docs.json"))
formals = json.load(open("/tmp/elapi/formals.json"))

def tag_of(f, title):
    base = re.sub(r'\s*(Attributes?|Events?|Exposes|Slots?|Options)\s*$', '', title).strip() or f
    if base.lower() == "own": base = f
    slug = re.sub(r'(?<=[a-z0-9])(?=[A-Z])', '-', base).lower()
    return "el-" + re.sub(r'[\s_]+', '-', slug).strip('-')
enums = {}
for f, secs in docs.items():
    for t, sec in secs.items():
        if sec["kind"] != "Attributes": continue
        tag = tag_of(f, t)
        if f in ("message", "notification", "message-box", "loading"): tag = "el-" + f
        for it in sec["items"]:
            typ = it["type"].replace("\\|", "|")
            # a deprecated value is still accepted: drop the note, keep the value
            typ = re.sub(r"\s*\(deprecated\)", "", typ)
            typ = re.sub(r"\s*\([\d.]+\)", "", typ)
            alts = re.findall(r"\^\[(\w+)\](`[^`]*`)?", typ)
            kinds = {a for a, _ in alts}
            if "enum" not in kinds: continue
            if kinds - {"enum", "number"}: continue      # a free-form alternative
            vals, free = [], False
            for a, b in alts:
                if a == "enum" and b:
                    for v in b.strip("`").split("|"):
                        v = v.strip()
                        if re.match(r"^'[\w-]*'$", v): vals.append(v.strip("'"))
                        elif v: free = True              # boolean, number, a type name
            if free: continue
            vals = [v for v in vals if re.match(r"^[\w-]*$", v)]
            if vals:
                enums.setdefault(tag, {})[it["name"].replace("-", "_")] = vals
# the component each function draws, and the children whose props it takes
# (a radio group's size is a free string upstream, but every radio it holds
# takes only large, default or small; a tree select is a select)
EXTRA = {"el_checkbox_group": ["el-checkbox-group"], "el_radio_group": ["el-radio-group", "el-radio"],
         "el_tree_select": ["el-tree-select", "el-select"],
         "el_message": ["el-message"], "el_notification": ["el-notification"],
         "el_message_box": ["el-message-box"], "el_time_select": ["el-time-select"],
         "el_countdown": ["el-countdown"]}
# Upstream's table lists fewer values than the component takes: a tooltip's
# `effect` names any theme of your own (`is-<effect>`), and a tag's type is
# el-tag's, which has `primary`.
LOOSE = {("el-tooltip", "effect"), ("el-popover", "effect"), ("el-popconfirm", "effect")}
MORE = {("el-input-tag", "tag_type"): ["primary"], ("el-select", "tag_type"): ["primary"],
        ("el-select-v2", "tag_type"): ["primary"], ("el-cascader", "tag_type"): ["primary"],
        ("el-tree-select", "tag_type"): ["primary"]}
for (tag, arg) in LOOSE: enums.get(tag, {}).pop(arg, None)
for (tag, arg), extra in MORE.items():
    if arg in enums.get(tag, {}):
        enums[tag][arg] = enums[tag][arg] + [v for v in extra if v not in enums[tag][arg]]
out = {}
for fn, args in sorted(formals.items()):
    tags = EXTRA.get(fn, ["el-" + fn[3:].replace("_", "-")])
    for tag in tags:
        for arg, vals in enums.get(tag, {}).items():
            if arg in args and arg not in ("value", "model_value"):
                out.setdefault(fn, {})[arg] = vals
lines = []
for fn, d in out.items():
    items = ", ".join(f"{a} = c({', '.join(json.dumps(v) for v in vs)})" for a, vs in d.items())
    lines.append(f"    {fn} = list({items})")
body = ",\n".join(lines)
src = open("R/el_choices.R").read()
start = src.index(".el_choices <- local({")
end = src.index("\n})\n", start) + 4
new = ".el_choices <- local({\n  list(\n" + body + "\n  )\n})\n"
open("R/el_choices.R", "w").write(src[:start] + new + src[end:])
print(len(out), "functions,", sum(len(d) for d in out.values()), "arguments")
