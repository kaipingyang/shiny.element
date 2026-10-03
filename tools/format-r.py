#!/usr/bin/env python3
"""Format the R code that is not in an .R file of its own, with air
(https://posit-dev.github.io/air/), as `air format R tests tools` formats
the rest:
    python tools/format-r.py
- each demo block of tools/demos/*.R (prose and `!skip` blocks untouched),
- each R chunk of the hand-written articles under vignettes/ (the component
  pages are generated from the demos: run tools/ep-pages.py after this),
- each roxygen @examples block under R/ (run devtools::document() after).
Code air cannot parse -- a \\dontrun{}, a fragment -- is left as it is."""
import glob, os, re, subprocess, tempfile

AIR = os.path.expanduser("~/.local/bin/air")
if not os.path.exists(AIR): AIR = "air"

left = []

def air(code, where=""):
    # \dontrun{} and the like are Rd, not R: format their body as an
    # if (.dontrun) block, then put the macro back.
    code = re.sub(r"\\(dontrun|donttest|dontshow)\{", r"if (.\1) {", code)
    with tempfile.NamedTemporaryFile("w", suffix=".R", delete=False) as f:
        f.write(code.rstrip("\n") + "\n")
    try:
        r = subprocess.run([AIR, "format", f.name], capture_output=True, text=True)
        if r.returncode != 0:
            left.append(where); return None
        out = open(f.name).read().rstrip("\n")
        out = re.sub(r"if \(\.(dontrun|donttest|dontshow)\) \{", r"\\\1{", out)
        return out
    finally:
        os.unlink(f.name)

changed = 0

# demos: "## name" blocks; "#'" prose and "#|" options lead the code
for path in sorted(glob.glob("tools/demos/*.R")):
    text = open(path).read()
    parts = re.split(r"(?m)^(## [A-Za-z0-9-]+(?: !skip)?\s*\n)", text)
    out = [parts[0]]
    for head, body in zip(parts[1::2], parts[2::2]):
        out.append(head)
        if "!skip" in head:
            out.append(body); continue
        lines = body.rstrip("\n").split("\n")
        lead = []
        while lines and (lines[0].startswith("#'") or lines[0].startswith("#|")):
            lead.append(lines.pop(0))
        new = air("\n".join(lines), path + ": " + head.strip()) if lines else None
        out.append("\n".join(lead + ([new] if new is not None else lines)) + "\n\n")
    new_text = re.sub(r"\n{3,}", "\n\n", "".join(out)).rstrip("\n") + "\n"
    if new_text != text:
        open(path, "w").write(new_text); changed += 1

# hand-written articles' chunks
generated = {os.path.basename(p) for p in glob.glob("tools/demos/*.R")}
rmds = glob.glob("vignettes/*.Rmd") + glob.glob("vignettes/articles/*.Rmd") + \
    [p for p in glob.glob("vignettes/articles/components/*.Rmd")
     if os.path.basename(p)[:-4] + ".R" not in generated]
chunk = re.compile(r"(?ms)^(```\{r[^}]*\}\n)(.*?)(^```\s*$)")
for path in sorted(rmds):
    text = open(path).read()
    def fix(m):
        if "include = FALSE" in m.group(1) or not m.group(2).strip(): return m.group(0)
        new = air(m.group(2), path + ": " + m.group(1).strip())
        return m.group(0) if new is None else m.group(1) + new + "\n" + m.group(3)
    new_text = chunk.sub(fix, text)
    if new_text != text:
        open(path, "w").write(new_text); changed += 1

# roxygen @examples
for path in sorted(glob.glob("R/*.R")):
    lines = open(path).read().split("\n")
    out, i = [], 0
    while i < len(lines):
        out.append(lines[i])
        if re.match(r"^#' @examples\s*$", lines[i]):
            j = i + 1
            while j < len(lines) and lines[j].startswith("#'") and not re.match(r"^#' @", lines[j]):
                j += 1
            block = [l[3:] if l.startswith("#' ") else l[2:] for l in lines[i + 1:j]]
            new = air("\n".join(block), path + ": @examples line %d" % (i + 1)) if any(b.strip() for b in block) else None
            if new is not None:
                out.extend(("#' " + l).rstrip() for l in new.split("\n"))
            else:
                out.extend(lines[i + 1:j])
            i = j
            continue
        i += 1
    new_text = "\n".join(out)
    if new_text != "\n".join(lines):
        open(path, "w").write(new_text); changed += 1

print(changed, "files formatted")
for w in left: print("  not R, left as is:", w)
