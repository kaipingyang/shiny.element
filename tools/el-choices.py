"""Enumerated string props in Element's docs, mapped to the R arguments.

    source ~/claude_code/bin/activate
    Rscript tools/api-coverage.R        # writes /tmp/elapi/ours.json
    python tools/el-choices.py > /tmp/elapi/choices.tsv

Every attribute whose documented type is a string and whose "Accepted Values"
column lists values ("primary / success / ...") is a candidate for
match.arg(). The output is for reading, row by row, against the upstream
docs and source before anything goes into R/el_choices.R -- see that file.
"""
import re, json, os, glob, sys
sys.argv = [sys.argv[0]]
DOCS = ".upstream/element/examples/docs/en-US"

def parse(path):
    lines = open(path, encoding="utf-8", errors="replace").read().split("\n")
    out, cur = [], None
    for ln in lines:
        h = re.match(r'^#{2,4}\s+(.+?)\s*$', ln)
        if h:
            t = h.group(1)
            cur = t if (t.endswith("Attributes") or t.endswith("Attribute") or t.strip() == "Options") else None
            continue
        if cur and ln.count("|") >= 2 and not re.match(r'^[\s:\-|]+$', ln):
            cells = [c.strip() for c in ln.strip().strip("|").split("|")]
            if len(cells) < 4: continue
            name = cells[0].strip("`*_ ").split("/")[0].strip().strip("`*_ ")
            if not re.match(r'^[a-z][\w-]*$', name): continue
            out.append(dict(section=cur, name=name, type=cells[2], accepted=cells[3],
                            default=cells[4] if len(cells) > 4 else ""))
    return out

ours = json.load(open("/tmp/elapi/ours.json"))
def snake(x): return x.replace("-", "_")

rows = []
for p in sorted(glob.glob(f"{DOCS}/*.md")):
    slug = os.path.basename(p)[:-3]
    for r in parse(p):
        if "string" not in r["type"].lower(): continue
        acc = r["accepted"]
        if acc in ("", "—", "-") or "/" not in acc: continue
        values = [v.strip().strip("'\"`") for v in re.split(r"\s*/\s*", acc) if v.strip()]
        base = re.sub(r'\s*(Attributes?|Options)\s*$', '', r["section"]).strip() or slug
        tag = "el-" + re.sub(r'(?<!^)(?=[A-Z])', '-', base).lower().replace(" ", "-") if base != slug else "el-" + slug
        fns = [fn for fn, v in ours.items()
               if snake(r["name"]) in (v.get("params") or "") and (tag in (v.get("tags") or "") or fn == "el_" + slug.replace("-", "_"))]
        rows.append([slug, r["section"], r["name"], " | ".join(values), r["default"], ",".join(fns)])
for row in rows:
    print("\t".join(row))
