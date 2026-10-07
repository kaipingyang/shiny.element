# Build the cases of tools/prop-reach.R -- (fn, arg, tag, prop, value): every
# upstream prop of a component's own tag that its R function takes.
#
#   python tools/api-coverage.py --docs && Rscript tools/api-coverage.R
#   python tools/prop-reach.py && Rscript tools/prop-reach.R
#
# Each case is a component given one upstream prop's non-default value; the
# browser then reads the prop off Element's component instance.
import json, re
docs = json.load(open("/tmp/elapi/docs.json"))
ours = json.load(open("/tmp/elapi/ours.json"))
SPECIAL = {"submenu": "el-sub-menu", "own": None, "transfer-panel": "el-transfer-panel",
           "config-provider": "el-config-provider", "countdown": "el-countdown"}
def section_tag(fileslug, title):
    base = re.sub(r'\s*(Attributes?|Events?|Exposes|Slots?|Options)\s*$', '', title, flags=re.I).strip()
    if not base or base.lower() == "own": base = fileslug
    slug = re.sub(r'(?<=[a-z0-9])(?=[A-Z])', '-', base).lower()
    slug = re.sub(r'(?<=[a-z])(?=v2$)', '-', slug)
    slug = re.sub(r'[\s_]+', '-', slug).strip('-'); slug = re.sub(r'-+', '-', slug)
    if slug in SPECIAL and SPECIAL[slug]: return SPECIAL[slug]
    return "el-" + slug
up = {}
for f, secs in docs.items():
    for title, s in secs.items():
        if s["kind"] != "Attributes": continue
        tag = section_tag(f, title)
        for it in s["items"]:
            up.setdefault(tag, {})[it["name"]] = it
if "el-datetime-picker" in up:
    for k, v in up.pop("el-datetime-picker").items(): up.setdefault("el-date-picker", {}).setdefault(k, v)
def camel(a):
    a = a.split("/")[0].strip()
    bits = re.split(r"[-_]", a)
    return bits[0] + "".join(b[:1].upper() + b[1:] for b in bits[1:])
def snake(a): return re.sub(r"-", "_", a.split("/")[0].strip())
SKIP_ARGS = {"value", "model_value", "id", "label", "slots", "width", "session", "choices", "options", "data", "items"}
cases = []
for fn, info in sorted(ours.items()):
    if fn.startswith(".") or not info.get("ok"): continue
    tag = "el-" + fn[3:].replace("_", "-")
    if tag not in up: continue
    params = info.get("params") or []
    if isinstance(params, str): params = [params]
    for name, it in up[tag].items():
        arg = snake(name)
        if arg not in params or arg in SKIP_ARGS: continue
        t = it["type"]; dflt = (it.get("default") or "").strip().strip("`").strip("'").strip('"')
        val = None
        if t.startswith("^[boolean]") and "/" not in t:
            val = dflt != "true"
        elif t.startswith("^[enum]"):
            opts = re.findall(r"'([^']*)'", t)
            opts = [o for o in opts if o and o != dflt and "deprecated" not in t.split("'" + o + "'")[1][:14]]
            if opts: val = opts[-1]
        elif t.startswith("^[number]") and "/" not in t:
            try: val = float(dflt) + 1
            except: val = 3
            if val == int(val): val = int(val)
        elif t.startswith("^[string]") and "/" not in t and not re.search(r"icon|format|class|style|placement|content|src|href|target|url|method|accept|name|key|tooltip|text$", name):
            val = "probe-" + arg
        if val is None: continue
        cases.append({"fn": fn, "arg": arg, "tag": tag, "prop": camel(name), "value": val, "type": t[:40]})
json.dump(cases, open("/tmp/elapi/reach-cases.json", "w"), indent=0)
print(len(cases), "cases over", len({c["fn"] for c in cases}), "functions")
