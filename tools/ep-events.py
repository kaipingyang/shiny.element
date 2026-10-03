#!/usr/bin/env python3
"""Forward more Element Plus events from a component, as input$<id>_<event>.

    python tools/ep-events.py R/el_select.R end-reached popup-scroll

Adds the names to the first .el_event_bindings(ns_id, ...) call in the file:
a single name becomes a c(...), a c(...) gets them appended.
"""
import sys, re
path, names = sys.argv[1], sys.argv[2:]
s = open(path).read()
m = re.search(r"\.el_event_bindings\(ns_id,\s*", s)
if not m:
    sys.exit(f"{path}: no .el_event_bindings(ns_id, ...) call -- add the events by hand")
at = m.end()
new = ", ".join(f'"{n}"' for n in names)
if s[at] == '"':                          # one name: "error" -> c("error", ...)
    end = s.index('"', at + 1) + 1
    s = s[:at] + "c(" + s[at:end] + ", " + new + ")" + s[end:]
elif s.startswith("c(", at):
    depth, i = 0, at + 1
    while True:
        if s[i] == "(": depth += 1
        elif s[i] == ")":
            depth -= 1
            if depth == 0: break
        i += 1
    inner = s[at + 2:i].rstrip()
    sep = ",\n    " if "\n" in inner else ", "
    s = s[:at + 2] + inner + sep + new + s[i:]
else:
    sys.exit(f"{path}: events given as a variable -- add them by hand")
open(path, "w").write(s)
print(f"{path}: + {', '.join(names)}")
