#!/usr/bin/env python3
"""Write each component page of the site after Element Plus's own.

    python tools/ep-pages.py [slug ...]

Reads Element Plus's page (.upstream/element-plus/docs/en-US/component/<slug>.md)
and the R demos (tools/demos/<slug>.R), and writes
vignettes/articles/components/<slug>.Rmd: the same title, sections, prose,
tips and demos in the same order -- each demo an R example that runs, live,
on the page -- then the API tables, Element Plus's with where each entry is
in R.

A demos file holds one block per upstream demo:

    ## basic
    el_button("b", "Default")

    ## use-vnode !skip
    Why there is no R form of it.

A block may start with lines of prose (`#' text`), shown above its code,
and chunk options (`#| shot_js = "..."`) for the screenshot. A block named
`in-shiny`, which upstream has not, is a section of its own, "In Shiny",
before the API: how the component is used in an app.
"""
import sys, re, os, glob

DOCS = ".upstream/element-plus/docs/en-US/component"
OUT = "vignettes/articles/components"
SITE = "https://element-plus.org/en-US"

def demos_of(slug):
    path = f"tools/demos/{slug}.R"
    if not os.path.exists(path): return {}
    blocks, cur = {}, None
    for line in open(path, encoding="utf-8").read().split("\n"):
        m = re.match(r"^## ([A-Za-z0-9-]+)( !skip)?\s*$", line)
        if m:
            cur = m.group(1)
            blocks[cur] = {"skip": bool(m.group(2)), "lines": []}
        elif cur:
            blocks[cur]["lines"].append(line)
    for b in blocks.values():
        lines = b["lines"]
        while lines and not lines[-1].strip(): lines.pop()
        while lines and not lines[0].strip(): lines.pop(0)
        b["note"] = "\n".join(l[3:] for l in lines if l.startswith("#' "))
        # chunk options: `#| shot_js = "..."`
        b["opts"] = [l[3:].strip() for l in lines if l.startswith("#| ")]
        b["code"] = "\n".join(l for l in lines if not l.startswith(("#' ", "#| ")))
    return blocks

def prose(text, slug):
    t = text
    # version marks and inline version tags
    # version marks: dropped from headings, kept as the bare number in text
    t = re.sub(r"^(#+ .*?)\s*\^\(([\w.]+)\)", lambda m: m.group(1) + (" (beta)" if m.group(2) == "beta" else ""), t, flags=re.M)
    t = re.sub(r"\^\(([\w.]+)\)", r"\1", t)
    t = re.sub(r"<el-tag[^>]*>([^<]*)</el-tag>", r"\1", t)
    t = re.sub(r"\^\[(\w+)\]`([^`]*)`", r"`\2`", t)
    t = re.sub(r"\^\[(\w+)\]", r"\1", t)
    # links: another component page here, anything else on element-plus.org
    t = re.sub(r"\]\(\./([a-z0-9-]+)\.md(#[^)]*)?\)", lambda m: f"]({m.group(1)}.html{m.group(2) or ''})", t)
    t = re.sub(r"\]\(\.\./guide/([a-z0-9-]+)\.md(#[^)]*)?\)", lambda m: f"]({SITE}/guide/{m.group(1)}.html{m.group(2) or ''})", t)
    t = re.sub(r"\]\(/en-US/([^)]*)\)", lambda m: f"]({SITE}/{m.group(1)})", t)
    # vitepress containers
    def box(m):
        kind, body = m.group(1), m.group(2).strip()
        label = {"tip": "Tip", "warning": "Warning", "danger": "Caution"}.get(kind, kind.title())
        return "\n> **" + label + "**\n>\n" + "\n".join("> " + l for l in body.split("\n")) + "\n"
    t = re.sub(r":::(tip|warning|danger)[^\n]*\n(.*?)\n:::", box, t, flags=re.S)
    # code blocks of Vue, TypeScript, shell: upstream's usage, not R's
    t = re.sub(r"```(vue|ts|typescript|js|javascript|html|shell|sh|bash|scss|css|json)[^\n]*\n.*?```", "", t, flags=re.S)
    t = re.sub(r"<(script|style)[^>]*>.*?</\1>", "", t, flags=re.S)
    t = re.sub(r"\n{3,}", "\n\n", t)
    return t.strip()

def build(slug):
    md = open(f"{DOCS}/{slug}.md", encoding="utf-8").read()
    title = re.search(r"^title:\s*(.+)$", md, re.M).group(1).strip()
    body = md.split("---", 2)[2]
    body = re.sub(r"^# .*\n", "", body.lstrip(), count=1)
    api_at = re.search(r"^## (.*\bAPI\b.*|API)\s*$", body, re.M)
    main = body[:api_at.start()] if api_at else body
    demos = demos_of(slug)
    used, missing = set(), []
    out = [f'---\ntitle: "{title}"\n---\n',
           '```{r setup, include = FALSE}\nsource(file.path("..", "..", "shots.R"))\n```\n']
    # :::demo text \n\n slug/name \n\n :::
    pos = 0
    pat = re.compile(r":::demo([^\n]*)\n(.*?)\n:::", re.S)
    for m in pat.finditer(main):
        out.append(prose(main[pos:m.start()], slug))
        desc = m.group(1).strip()
        inner = m.group(2)
        name_m = re.search(r"^\s*([a-z0-9-]+)/([A-Za-z0-9-]+)\s*$", inner, re.M)
        extra = inner[:name_m.start()] if name_m else inner
        desc = (desc + " " + extra.strip()).strip()
        if desc: out.append(prose(desc, slug))
        if name_m:
            name = name_m.group(2)
            used.add(name)
            b = demos.get(name)
            if b is None:
                missing.append(name)
                out.append(f"*No R example yet for `{slug}/{name}`.*")
            elif b["skip"]:
                out.append("> **In R**\n>\n" + "\n".join("> " + l for l in (b["note"] or b["code"]).split("\n")))
            else:
                if b["note"]: out.append(b["note"])
                chunk = re.sub(r"[^a-z0-9]+", "-", name.lower())
                extra = "".join(", " + o for o in b["opts"])
                out.append(f"```{{r {chunk}, eval = FALSE, shot = TRUE{extra}}}\n{b['code']}\n```")
        pos = m.end()
    out.append(prose(main[pos:], slug))
    b = demos.get("in-shiny")
    if b:
        used.add("in-shiny")
        out.append("## In Shiny")
        if b["note"]: out.append(b["note"])
        extra = "".join(", " + o for o in b["opts"])
        out.append(f"```{{r shiny-output, eval = FALSE, shot = TRUE{extra}}}\n{b['code']}\n```")
    out.append("## API\n\nElement Plus's tables, and beside each entry where it is in R.\n")
    out.append(f'```{{r api, echo = FALSE, results = "asis"}}\napi_tables("{slug}")\n```')
    text = "\n\n".join(x for x in out if x.strip()) + "\n"
    text = re.sub(r"\n{3,}", "\n\n", text)
    open(f"{OUT}/{slug}.Rmd", "w", encoding="utf-8").write(text)
    unused = sorted(set(demos) - used)
    return missing, unused

slugs = sys.argv[1:] or sorted(os.path.basename(p)[:-3] for p in glob.glob(f"{DOCS}/*.md"))
for s in slugs:
    if s in ("overview", "color", "icon"): continue  # written by hand
    miss, unused = build(s)
    print(f"{s}: " + ("ok" if not miss else "missing " + ", ".join(miss)) +
          (f"; unused {', '.join(unused)}" if unused else ""))
