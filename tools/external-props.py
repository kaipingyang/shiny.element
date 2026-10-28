# Props of Element's that need something outside Element to work -- a router,
# a locale, a format library's tokens, a value R cannot send as it is -- and
# whether tools/external-props.csv lists each, with how the package provides
# it and the test that shows it working in a browser.
#
#   python tools/external-props.py          # unlisted ones, exit 1 if any
#   python tools/external-props.py --all    # every one found
#
# API coverage sees a prop bound, prop reach its value arrive; neither sees
# one that arrives and does nothing for want of what it needs (el_menu's
# `router`, with no router on the page). Run it with the other upstream
# tools when Element is updated.
import csv, os, re, sys

DOCS = ".upstream/element-plus/docs/en-US/component"
# what a prop needs, and where to look: its description ("d") or its type
# ("t") -- an `HTMLElement` type, not the word "element" in prose
NEEDS = [
    ("vue-router", "d", r"vue-router|RouteLocation|Vue Router"),
    ("vue-router", "t", r"RouteLocation"),
    ("dayjs", "d", r"day\.js|dayjs"),
    ("dayjs", "t", r"\bDayjs\b|day\.js"),
    ("popper", "d", r"popper\.js"),
    ("popper", "t", r"PopperOptions"),
    ("async-validator", "d", r"async-validator"),
    ("date", "t", r"\bDate\b"),
    ("element", "t", r"HTMLElement|\bElement\b"),
    ("locale", "t", r"\bLanguage\b"),
    ("locale", "d", r"Locale Object"),
]

def rows():
    for name in sorted(os.listdir(DOCS)):
        if not name.endswith(".md"):
            continue
        slug, section = name[:-3], ""
        for line in open(os.path.join(DOCS, name), encoding="utf-8"):
            if line.startswith("#"):
                section = line.strip("# \n")
                continue
            if not line.startswith("|") or "---" in line:
                continue
            cells = [c.strip() for c in line.strip().strip("|").split("|")]
            if len(cells) < 3 or cells[0] in ("Name", "Attribute", "Prop", "Event"):
                continue
            if not re.search(r"Attributes?|Props?|Configs?|Options?", section):
                continue
            prop = re.sub(r"\s*\^\(.*?\)", "", cells[0]).strip("` ")
            where = {"d": cells[1], "t": cells[2]}
            for need, col, pattern in NEEDS:
                if re.search(pattern, where[col]):
                    yield slug, section, prop, need

def listed():
    path = "tools/external-props.csv"
    if not os.path.exists(path):
        return set()
    with open(path, newline="") as f:
        return {(r["page"], r["prop"], r["needs"]) for r in csv.DictReader(f)}

if __name__ == "__main__":
    known = listed()
    found = sorted(set(rows()))
    show_all = "--all" in sys.argv
    missing = [r for r in found if (r[0], r[2], r[3]) not in known]
    for slug, section, prop, need in (found if show_all else missing):
        print(f"{slug:22} {prop:28} {need:16} {section}")
    if not show_all:
        print(f"{len(found)} found, {len(missing)} not in tools/external-props.csv")
    sys.exit(1 if missing and not show_all else 0)
