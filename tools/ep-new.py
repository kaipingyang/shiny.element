#!/usr/bin/env python3
"""Write a wrapper for an Element Plus component, from its API table.

    python tools/ep-new.py <doc page> <section prefix> <r name> [options]

    --value        the component has a v-model: `value` is its model-value,
                   reported as input$<id>
    --default V    R default for `value` (an R expression), default NULL
    --change EV    the event that carries the new value (default: change);
                   without it the model is watched
    --title T      the Rd title
    --desc D       one paragraph of description
    --example E    an R example (repeatable)
    --skip a,b     props not to take

Every documented prop becomes an argument (NULL: Element's default), every
event is forwarded as input$<id>_<event>, slots pass through `slots =`, and
an update_<r name>() sets value and disabled. Reads /tmp/elapi/docs.json.
"""
import sys, re, json
page, prefix, rname = sys.argv[1:4]
opts = sys.argv[4:]
def opt(name, default=None, many=False):
    vals = [opts[i + 1] for i, o in enumerate(opts) if o == name]
    return vals if many else (vals[0] if vals else default)
has_value = "--value" in opts
container = "--container" in opts
default = opt("--default", "NULL")
change = opt("--change", "change")
title = opt("--title", rname)
desc = opt("--desc", "")
examples = opt("--example", many=True)
skip = set((opt("--skip", "") or "").split(",")) - {""}

docs = json.load(open("/tmp/elapi/docs.json"))[page]
def sec(kind):
    for t, s in docs.items():
        base = re.sub(r"\s*(Attributes?|Events?|Exposes|Slots?)$", "", t).strip()
        if s["kind"] == kind and base == prefix:
            return s["items"]
    return []
# id is the host's; class and style are any element's, and reserved words in
# a template expression
attrs = [a for a in sec("Attributes") if a["name"] not in skip and a["name"] not in ("id", "class", "style")]
events = [e["name"] for e in sec("Events") if e["name"] not in skip]
slots = [s["name"] for s in sec("Slot") if s["name"] != "default"]
methods = [m["name"] for m in sec("Methods")]
tag = "el-" + re.sub(r"(?<=[a-z0-9])(?=[A-Z])", "-", prefix or page).lower().replace(" ", "-")
if not prefix: tag = "el-" + page

def clean(d):
    d = re.sub(r"\s+", " ", d).strip().rstrip(".")
    d = re.sub(r"\[([^\]]+)\]\([^)]*\)", r"\1", d)
    d = re.sub(r"\^\[(\w+)\]`([^`]*)`", lambda m: "`" + m.group(2).replace("\\|", "|") + "`", d)
    d = re.sub(r"\^\[(\w+)\]", r"\1", d)
    d = re.sub(r" ?\^\(([\d.]+)\)", "", d)
    return (d[:1].upper() + d[1:]) if d else "Element Plus's prop of that name"
def typ(t):
    raw = t.replace("\\|", "|")
    toks = re.findall(r"\^\[(\w+)\](`[^`]*`)?", raw)
    return " / ".join((b.strip("`") if b and len(b) < 70 else a) for a, b in toks)
def wrap(line):
    words, out, cur = line.split(" "), [], ""
    for w in words:
        if len(cur) + len(w) + 1 > 78 and cur:
            out.append(cur); cur = "#'   " + w
        else:
            cur = (cur + " " + w) if cur else w
    out.append(cur)
    return "\n".join(out)
RESERVED = {"width", "slots", "id", "session", "label", "error", "required", "value"}
def snake(p):
    s = p.replace("-", "_")
    return f"{rname.replace('el_', '')}_{s}" if s in RESERVED else s

model = [a for a in attrs if a["name"] == "model-value"]
props = [a for a in attrs if a["name"] != "model-value"]
lines = []
lines.append(f"#' {title}\n#'")
if desc: lines.append(wrap(f"#' {desc}") + "\n#'")
if container:
    lines.append("#' @param ... Its content: any Shiny UI. Components of this package are folded\n#'   into this one's Vue instance, as [el_button_group()] folds its buttons.")
lines.append("#' @param id Component ID. Auto-generated if `NULL`.")
if has_value:
    d = clean(model[0]["desc"]) if model else "The value"
    lines.append(wrap(f"#' @param value {d}: Element Plus's `model-value`, reported as `input$<id>`."))
for a in props:
    t = typ(a["type"])
    line = f"#' @param {snake(a['name'])} {clean(a['desc'])}. Element Plus's `{a['name']}`" + (f" ({t})" if t else "") + "."
    if "Function" in a["type"]: line += " Give it as [JS()]."
    if "Component" in a["type"]: line += " An icon's name, such as `\"Search\"`."
    lines.append(wrap(line))
if has_value:
    lines.append("#' @inheritParams el_widget")
lines.append("#' @param width Component width, as a CSS unit.")
lines.append(wrap("#' @param slots Named list of Element slot contents" + (": " + ", ".join(f"`{s}`" for s in slots) if slots else "") + ". A scoped slot is written with [template()]."))
lines.append("#'")
lines.append("#' @section Shiny inputs:")
if has_value: lines.append("#' - `input$<id>` -- the value, on load and on every change.")
for e in events:
    lines.append(f"#' - `input$<id>_{snake(e)}` -- Element Plus's `{e}` event.")
if not has_value and not events: lines.append("#' None: it reports nothing.")
if methods:
    lines.append("#'\n#' @section Element methods:\n#' Callable with [call_el()]: " + ", ".join(f"`{m}()`" for m in methods) + ".")
lines.append("#'\n#' @return A Shiny UI element.")
if examples:
    lines.append("#' @examples")
    for e in examples: lines.append("#' " + e.replace("\n", "\n#' "))
lines.append("#' @export")

sig = (["..."] if container else []) + ["id = NULL"]
if has_value: sig.append(f"value = {default}")
sig += [f"{snake(a['name'])} = NULL" for a in props]
if has_value:
    sig += ["label = NULL", 'label_position = c("top", "left", "right")', "label_width = NULL",
            "label_suffix = NULL", "required = FALSE", "error = NULL", "show_message = TRUE",
            "inline_message = FALSE"]
sig += ["width = NULL", "slots = NULL"]
ind = " " * (len(rname) + len(" <- function("))
body = []
body.append(f"  .el_check_choices(\"{rname}\", environment())")
body.append(f"  if (is.null(id)) id <- paste0(\"{rname}_\", uuid::UUIDgenerate())")
body.append("  ns_id <- .el_ui_id(id, NULL)")
evs = [e for e in events if not (has_value and e == change)]
body.append(f"  events <- .el_event_bindings(ns_id, c({', '.join(json.dumps(e) for e in evs)}))" if evs
            else "  events <- .el_event_bindings(ns_id, character())")
markup_attrs = ['"v-model" = "value"'] if has_value else []
if has_value and change in events:
    markup_attrs.append(f'"@{change}" = "handleChange"')
if not container:
    body.append(f"  attrs <- c(list({', '.join(markup_attrs)}), events$attrs)")
def val(a):
    s = snake(a["name"])
    return f".el_icon_name({s})" if "Component" in a["type"] else s
plist = ",\n      ".join(f"{snake(a['name'])} = {val(a)}" for a in props)
renamed = {snake(a["name"]): a["name"] for a in props if snake(a["name"]) != a["name"].replace("-", "_")}
if renamed:
    plist += "),\n      rename = c(" + ", ".join(f'{k} = "{v}"' for k, v in renamed.items()) + ")"
    plist = plist[:-1] if plist.endswith(")") else plist
if container:
    pl = (f"props = .el_props(list(\n      {plist})),\n    ") if props else ""
    body.append(f"  .el_wrap_widget(\"{tag}\", ns_id, list(...),\n    {pl}events = events, width = width, slots = slots)")
    code = "\n".join(lines) + "\n" + rname + " <- function(" + (",\n" + ind).join(sig) + ") {\n" + "\n".join(body) + "\n}\n"
    open(f"R/{rname}.R", "w").write(code)
    print(f"wrote R/{rname}.R: container, {len(props)} props, {len(events)} events")
    sys.exit(0)
body.append("  el_widget(")
if has_value:
    body.append("    label = label, label_position = label_position,\n"
                "    label_width = label_width, label_suffix = label_suffix, required = required,\n"
                "    error = error, show_message = show_message, inline_message = inline_message,")
body.append("    id      = ns_id,")
body.append(f"    markup  = htmltools::tag(\"{tag}\", attrs),")
if props: body.append(f"    props   = .el_props(list(\n      {plist})),")
if has_value:
    body.append("    data    = list(value = .el_restore(ns_id, if (is.null(value)) NA else value)),")
    m = (f"    methods = c(events$methods, list(handleChange = JS(sprintf(\n"
         f"      \"function(v) {{ window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s', v); }}\", ns_id)))),")
    if change in events:
        body.append(m)
    else:
        body.append("    methods = events$methods,")
        body.append("    watch   = list(value = JS(sprintf(\n"
                    "      \"function(v) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s', v); }\", ns_id))),")
    body.append("    mounted = .el_mounted_init(stats::setNames(\"value\", ns_id)),")
else:
    body.append("    data    = list(),")
    body.append("    methods = events$methods,")
body.append("    width   = width,")
body.append("    slots   = slots")
body.append("  )")
code = "\n".join(lines) + "\n" + rname + " <- function(" + (",\n" + ind).join(sig) + ") {\n" + "\n".join(body) + "\n}\n"
if has_value:
    upd = "update_" + rname
    code += f'''

#' Update {title}
#'
#' Server-side update for [{rname}()].
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id Component ID (un-namespaced).
#' @param value,disabled New values; `NULL` leaves one unchanged.
#' @param label New label, as for [shiny::updateTextInput()]: text, or
#'   tags or `HTML()` drawn as markup. Only a component built with a `label`
#'   has one to change.
#' @param error An error message to show on the component; `""` clears it.
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {{
#'   # inside a server function
#'   observeEvent(input$reset, {upd}(session, "x", value = NULL))
#' }}
#' @export
{upd} <- function(session = shiny::getDefaultReactiveDomain(), id, value = NULL,
{" " * len(upd)}           disabled = NULL, label = NULL, error = NULL) {{
  .el_check_session(session)
  msg <- list(id = session$ns(id))
  if (!is.null(value))    msg$value    <- value
  if (!is.null(disabled)) msg$disabled <- disabled
  msg <- .el_form_item_update(msg, label, error)
  .el_send_update(session, msg)
  invisible(NULL)
}}
'''
open(f"R/{rname}.R", "w").write(code)
print(f"wrote R/{rname}.R: {len(props)} props, {len(events)} events, {len(slots)} slots, value={has_value}")
