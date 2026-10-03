#!/usr/bin/env python3
"""Write the components overview, as element-plus.org's: the component groups
of its sidebar, each component a card with upstream's illustration.
    python tools/ep-overview.py
Reads .upstream/element-plus (see .upstream/README.md); writes
vignettes/articles/components.Rmd and pkgdown/assets/el-vars.css, Element
Plus's CSS variables, which the illustrations and the site's styles use."""
import json, os, re

UP = ".upstream/element-plus/docs"
ICONS = f"{UP}/.vitepress/vitepress/components/overview-icons"
groups = json.load(open(f"{UP}/.vitepress/crowdin/en-US/pages/component.json", encoding="utf-8"))

def svg(slug):
    path = f"{ICONS}/ov-{slug}.vue"
    if not os.path.exists(path): return ""
    s = open(path, encoding="utf-8").read()
    s = re.search(r"<svg.*</svg>", s, re.S).group(0)
    # Each illustration's ids are its own; keep them so across one page
    s = re.sub(r'\bid="([^"]+)"', lambda m: f'id="{slug}-{m.group(1)}"', s)
    s = re.sub(r'url\(#([^)]+)\)', lambda m: f'url(#{slug}-{m.group(1)})', s)
    s = re.sub(r'href="#([^"]+)"', lambda m: f'href="#{slug}-{m.group(1)}"', s)
    s = re.sub(r">\s+<", "><", s)
    return re.sub(r"\s+", " ", s)

out = ['---\ntitle: "Overview"\n---\n',
       "Overview of all components: Element Plus's, in the groups of its own "
       "documentation, each with its demos in R and its API tables beside the "
       "R names.\n",
       '```{=html}\n<div class="ov-search"><input type="search" id="ov-q" '
       'placeholder="Search Components" aria-label="Search Components"></div>\n```\n']
total = 0
for key, g in groups.items():
    if key == "overview": continue
    kids = g.get("children", [])
    total += len(kids)
    cards = []
    for c in kids:
        slug = c["link"].strip("/")
        cards.append(f'<a class="ov-card" href="components/{slug}.html" data-name="{c["text"].lower()}">'
                     f'<div class="ov-card-head">{c["text"]}</div>'
                     f'<div class="ov-card-body">{svg(slug)}</div></a>')
    out.append(f'```{{=html}}\n<div class="ov-group"><p class="ov-title">{g["text"]} '
               f'<span class="ov-count">{len(kids)}</span></p>'
               f'<div class="ov-cards">{"".join(cards)}</div></div>\n```\n')
out.append('```{=html}\n<p class="ov-credit">Illustrations from Element Plus\'s documentation, '
           'designed by <a href="https://github.com/daodaozz08">daodaozz08</a>.</p>\n'
           '<script>\n(function () {\n  var q = document.getElementById("ov-q");\n'
           '  q.addEventListener("input", function () {\n    var t = q.value.trim().toLowerCase();\n'
           '    document.querySelectorAll(".ov-group").forEach(function (g) {\n      var n = 0;\n'
           '      g.querySelectorAll(".ov-card").forEach(function (c) {\n'
           '        var hit = !t || c.dataset.name.indexOf(t) >= 0;\n'
           '        c.style.display = hit ? "" : "none"; if (hit) n++;\n      });\n'
           '      g.style.display = n ? "" : "none";\n    });\n  });\n})();\n</script>\n```\n')
open("vignettes/articles/components.Rmd", "w", encoding="utf-8").write("\n".join(out))

css = open("inst/element-plus/theme-chalk/index.css", encoding="utf-8").read()
root = re.findall(r":root\{[^}]*\}", css)
dark = open("inst/element-plus/theme-chalk/dark/css-vars.css", encoding="utf-8").read()
os.makedirs("pkgdown/assets", exist_ok=True)
open("pkgdown/assets/el-vars.css", "w", encoding="utf-8").write(
    "/* Element Plus's CSS variables, from its theme-chalk; written by tools/ep-overview.py */\n"
    + "\n".join(root) + "\n" + dark + "\n")
print(f"{total} components; components.Rmd {os.path.getsize('vignettes/articles/components.Rmd')//1024} KB")
