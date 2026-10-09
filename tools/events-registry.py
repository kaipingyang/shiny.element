"""Write R/el_events_registry.R: every Shiny input each component reports.

For each component function: the inputs it always reports (its value and
the requests the server answers), and the Element Plus events it can
forward -- those on by default, and the rest a user asks for with
`events =`. The events' descriptions and arguments are Element's own, read
from vignettes/articles/components/api.json (python tools/api-coverage.py
--write-api); which are on by default, and what an input carries when it is
shaped here, is written below.

    python tools/events-registry.py
"""
import json
import re

API = json.load(open("vignettes/articles/components/api.json"))

# function: (docs page, table title prefix, always-reported inputs,
#            forwarded events, on by default, value of shaped events)
SPEC = {
    "el_affix": ("affix", "", {}, ["change", "scroll"], ["change"], {
        "scroll": "`list(scrollTop, fixed)`, at most every 200 ms"}),
    "el_alert": ("alert", "", {"close": "fires when the user closes the alert"}, [], [], {}),
    "el_anchor": ("anchor", "Anchor", {"": "the `href` of the current link, as the page scrolls"},
                  ["click"], [], {"click": "the `href` of the link clicked"}),
    "el_autocomplete": ("autocomplete", "", {
        "": "the current text",
        "query": "with `remote = TRUE`, the text to suggest for; answer with `update_el_autocomplete()`"},
        ["select", "change", "blur", "clear", "focus", "input"], ["select"], {}),
    "el_avatar": ("avatar", "Avatar", {}, ["error"], ["error"], {}),
    "el_backtop": ("backtop", "", {}, ["click"], ["click"], {}),
    "el_breadcrumb": ("breadcrumb", "", {"": "the `label` of the step last clicked"}, [], [], {}),
    "el_button": ("button", "", {"": "the number of clicks, as `actionButton()` reports it"}, [], [], {}),
    "el_calendar": ("calendar", "", {
        "": "the day picked, `\"YYYY-MM-DD\"`",
        "dates": "the month shown: `list(current, start, end)`, Dates",
        "click": "an event clicked",
        "add": "a new event the user saved (`editable`); answer with `update_el_calendar(insert =)`",
        "update": "an edit or a move: `list(event, changes)`; answer with `update_el_calendar(replace =)`",
        "delete": "an event the user deleted; answer with `update_el_calendar(delete =)`"}, [], [], {}),
    "el_carousel": ("carousel", "Carousel", {
        "": "the index of the slide showing, from 0",
        "name": "its `name`, if it has one"}, [], [], {}),
    "el_cascader": ("cascader", "Cascader", {
        "": "the selected path",
        "lazy_load": "with `props = list(lazy = TRUE)`, a column to load; answer with `el_load_children()`"},
        ["expand-change", "blur", "focus", "visible-change", "remove-tag", "clear"], [], {}),
    "el_cascader_panel": ("cascader", "CascaderPanel", {
        "": "the selected path",
        "lazy_load": "with `props = list(lazy = TRUE)`, a column to load; answer with `el_load_children()`"},
        ["expand-change", "close"], [], {}),
    "el_check_tag": ("tag", "CheckTag", {"": "`TRUE` while checked"}, [], [], {}),
    "el_checkbox": ("checkbox", "Checkbox", {"": "`TRUE` or `FALSE`, or `true_value` and `false_value`"}, [], [], {}),
    "el_checkbox_group": ("checkbox", "CheckboxGroup", {"": "the values checked"}, [], [], {}),
    "el_collapse": ("collapse", "Collapse", {"": "the names of the open panels"}, [], [], {}),
    "el_color_picker": ("color-picker", "", {"": "the colour"},
                        ["active-change", "blur", "clear", "focus"], [], {
                            "active-change": "the colour being picked, at most every 200 ms"}),
    "el_color_picker_panel": ("color-picker-panel", "", {"": "the colour"}, [], [], {}),
    "el_date_picker": ("date-picker", "", {"": "the date, two for a range"},
                       ["blur", "focus", "calendar-change", "clear", "panel-change", "visible-change"], [], {}),
    "el_date_picker_panel": ("date-picker-panel", "", {"": "the date, two for a range"},
                             ["calendar-change", "panel-change", "clear"], [], {}),
    "el_dialog": ("dialog", "", {"": "`TRUE` while it is open"},
                  ["open", "opened", "close", "closed", "open-auto-focus", "close-auto-focus"],
                  ["closed"], {}),
    "el_drawer": ("drawer", "", {"": "`TRUE` while it is open"},
                  ["open", "opened", "close", "closed", "open-auto-focus", "close-auto-focus",
                   "resize-start", "resize", "resize-end"], ["closed"], {
                      "resize-start": "the size, in pixels", "resize": "the size, in pixels",
                      "resize-end": "the size, in pixels"}),
    "el_dropdown": ("dropdown", "Dropdown", {
        "": "the `command` of the item clicked, as an event",
        "count": "the number of items clicked"}, ["click", "visible-change"], ["click"], {}),
    "el_form": ("form", "Form", {
        "": "the whole model, on load and on every submit",
        "valid": "`TRUE` when the last submit passed validation",
        "submit": "a submit counter"}, ["validate"], [], {}),
    "el_image": ("image", "Image", {}, ["load", "error", "close", "show", "switch"], ["error"], {}),
    "el_image_viewer": ("image", "Image Viewer", {"close": "fires as it closes"},
                        ["error", "switch", "rotate"], ["error"], {}),
    "el_infinite_scroll": ("infinite-scroll", "", {"load": "rises by one each time more content is wanted"}, [], [], {}),
    "el_input": ("input", "", {"": "the text, as it is typed (debounced by 250 ms)"},
                 ["input", "blur", "focus", "clear", "compositionend", "compositionstart",
                  "compositionupdate", "keydown", "mouseenter", "mouseleave"], [], {
                     "keydown": "the key: `list(key, code, ctrl, shift, alt, meta)`"}),
    "el_input_number": ("input-number", "", {"": "the number"}, ["blur", "focus"], [], {}),
    "el_input_otp": ("input-otp", "", {"": "the value"}, ["change", "finish", "focus", "blur"], ["finish"], {}),
    "el_input_tag": ("input-tag", "", {"": "the tags"},
                     ["input", "add-tag", "remove-tag", "drag-tag", "focus", "blur", "clear"], [], {}),
    "el_link": ("link", "", {"": "with an `id`, the number of clicks, as `actionLink()` reports it"}, [], [], {}),
    "el_mention": ("mention", "", {"": "the text"}, ["search", "select", "whole-remove"], ["search", "select"], {
        "search": "`list(pattern, prefix)`; answer with `update_el_mention(options =)`",
        "select": "`list(option, prefix)`", "whole-remove": "`list(pattern, prefix)`"}),
    "el_menu": ("menu", "Menu", {
        "": "the `index` of the selected item",
        "path": "the indexes down to it"}, ["open", "close"], [], {
            "open": "`list(index, path)` of the submenu", "close": "`list(index, path)` of the submenu"}),
    "el_page_header": ("page-header", "", {}, ["back"], ["back"], {}),
    "el_pagination": ("pagination", "", {
        "": "the current page, from 1",
        "page_size": "the page size"}, ["prev-click", "next-click", "change"], [], {}),
    "el_popconfirm": ("popconfirm", "", {
        "confirm": "fires when the user confirms",
        "cancel": "fires when the user backs out"}, [], [], {}),
    "el_popover": ("popover", "", {},
                   ["show", "hide", "after-enter", "after-leave", "before-enter", "before-leave"], [], {}),
    "el_radio_group": ("radio", "RadioGroup", {"": "the value picked"}, [], [], {}),
    "el_rate": ("rate", "", {"": "the rating"}, [], [], {}),
    "el_scrollbar": ("scrollbar", "", {}, ["scroll", "end-reached"], ["end-reached"], {
        "scroll": "`list(scrollLeft, scrollTop)`, at most every 200 ms"}),
    "el_segmented": ("segmented", "", {"": "the value"}, [], [], {}),
    "el_select": ("select", "Select", {
        "": "the value, several with `multiple`",
        "query": "with `remote = TRUE`, the text typed; answer with `update_el_select(choices =)`"},
        ["visible-change", "remove-tag", "clear", "blur", "focus", "end-reached", "popup-scroll"],
        ["end-reached"], {"popup-scroll": "`list(scroll_left, scroll_top)`, at most every 200 ms"}),
    "el_select_v2": ("select-v2", "", {"": "the value, several with `multiple`"},
                     ["visible-change", "remove-tag", "clear", "blur", "focus", "end-reached"],
                     ["end-reached"], {}),
    "el_slider": ("slider", "", {"": "the value, two for a range, once the drag ends"}, ["input"], [], {
        "input": "the value while it is dragged, at most every 200 ms"}),
    "el_splitter": ("splitter", "Splitter", {},
                    ["resize-start", "resize", "resize-end", "collapse"], ["resize-end", "collapse"], {
                        "resize": "the sizes, at most every 200 ms"}),
    "el_countdown": ("statistic", "Countdown", {}, ["finish", "change"], ["finish"], {
        "change": "the milliseconds left, at most once a second"}),
    "el_steps": ("steps", "Steps", {}, ["change"], [], {}),
    "el_switch": ("switch", "", {"": "`active_value` when on, `inactive_value` when off"}, [], [], {}),
    "el_table": ("table", "Table", {
        "selection_rows": "the selected row numbers",
        "selection_change": "the selected rows, `data[rows, , drop = FALSE]`",
        "cell_edit": "an edited cell: `list(row, column, value, old)`",
        "load": "with `lazy = TRUE`, a row asking for its children; answer with `el_load_children()`"},
        ["select", "select-all", "cell-mouse-enter", "cell-mouse-leave", "cell-click", "cell-dblclick",
         "cell-contextmenu", "row-click", "row-contextmenu", "row-dblclick", "header-click",
         "header-contextmenu", "sort-change", "filter-change", "current-change", "header-dragend",
         "expand-change", "scroll"],
        ["current-change", "sort-change", "filter-change", "expand-change"], {
            "current-change": "`list(row_index, row, previous_index)`",
            "sort-change": "`list(column, order)`",
            "filter-change": "the filters, `list(<column key> = values)`",
            "expand-change": "`list(row_index, expanded)`",
            "select": "`list(rows, row_index)`: the selected row numbers, and the row ticked or unticked",
            "select-all": "`list(rows)`, the selected row numbers",
            "cell-mouse-enter": "`list(row_index, row, column, value)`",
            "cell-mouse-leave": "`list(row_index, row, column, value)`",
            "cell-click": "`list(row_index, row, column, value)`",
            "cell-dblclick": "`list(row_index, row, column, value)`",
            "cell-contextmenu": "`list(row_index, row, column, value)`",
            "row-click": "`list(row_index, row, column)`",
            "row-contextmenu": "`list(row_index, row, column)`",
            "row-dblclick": "`list(row_index, row, column)`",
            "header-click": "`list(column, label)`",
            "header-contextmenu": "`list(column, label)`",
            "header-dragend": "`list(column, width, previous_width)`",
            "scroll": "`list(scroll_left, scroll_top)`, at most every 200 ms"}),
    "el_table_v2": ("table-v2", "TableV2", {},
                    ["column-sort", "expanded-rows-change", "end-reached", "scroll", "rows-rendered",
                     "row-expand"], ["column-sort", "end-reached"], {
                        "scroll": "at most every 200 ms", "rows-rendered": "at most every 200 ms"}),
    "el_tabs": ("tabs", "Tabs", {"": "the name of the selected tab"},
                ["tab-click", "tab-change", "tab-remove", "tab-add", "edit"], ["tab-remove", "tab-add"], {
                    "tab-click": "the name of the tab clicked",
                    "tab-change": "the name of the tab selected",
                    "tab-remove": "the name of the tab closed",
                    "edit": "`list(target, action)`: the tab's name (`NULL` for an add) and `\"add\"` or `\"remove\"`"}),
    "el_tag": ("tag", "Tag", {
        "": "the number of clicks on the tag, as `actionButton()` reports it",
        "close": "fires when the user closes it (`closable = TRUE`)"}, [], [], {}),
    "el_time_picker": ("time-picker", "", {"": "the time, two for a range"},
                       ["blur", "focus", "clear", "visible-change"], [], {}),
    "el_time_select": ("time-select", "", {"": "the time"}, ["blur", "focus", "clear"], [], {}),
    "el_tour": ("tour", "Tour", {
        "": "`TRUE` while it is open",
        "close": "the step it was closed on"}, ["change", "finish"], ["change", "finish"], {
            "change": "the step, from 0"}),
    "el_tooltip": ("tooltip", "", {}, ["show", "hide", "before-show", "before-hide"], [], {}),
    "el_transfer": ("transfer", "Transfer", {"": "the keys on the right"},
                    ["change", "left-check-change", "right-check-change"], [], {
                        "change": "`list(value, direction, moved)`",
                        "left-check-change": "`list(checked, changed)`",
                        "right-check-change": "`list(checked, changed)`"}),
    "el_tree": ("tree", "", {
        "": "the key of the node last clicked",
        "checked": "the keys of the checked nodes",
        "load": "with `lazy = TRUE`, a node asking for its children; answer with `el_load_children()`"},
        ["check-change", "current-change", "node-expand", "node-collapse", "node-contextmenu",
         "node-drag-start", "node-drag-enter", "node-drag-leave", "node-drag-over", "node-drag-end",
         "node-drop"], [], {
            "check-change": "`list(data, checked, indeterminate)`",
            "current-change": "`list(data, key, level)` of the current node",
            "node-expand": "`list(data, key, level)`", "node-collapse": "`list(data, key, level)`",
            "node-contextmenu": "`list(data, key, level)`",
            "node-drag-start": "`list(data)` of the dragged node",
            "node-drag-enter": "`list(dragging, drop)`, the nodes' data",
            "node-drag-leave": "`list(dragging, drop)`, the nodes' data",
            "node-drag-over": "`list(dragging, drop)`, the nodes' data, at most every 200 ms",
            "node-drag-end": "`list(dragging, drop, type)`",
            "node-drop": "`list(dragging, drop, type)`: `type` `\"before\"`, `\"after\"` or `\"inner\"`"}),
    "el_tree_select": ("tree-select", "", {
        "": "the value, several with `multiple`",
        "load": "with `lazy = TRUE`, a node asking for its children; answer with `el_load_children()`"},
        ["visible-change", "clear", "remove-tag", "node-click", "check"], [], {}),
    "el_tree_v2": ("tree-v2", "", {},
                   ["node-click", "node-drop", "node-contextmenu", "check-change", "check",
                    "current-change", "node-expand", "node-collapse"], ["node-click", "check"], {}),
    "el_upload": ("upload", "", {
        "": "the files, as `fileInput()` reports them (without `action`)",
        "success": "with `action`, the names of the files uploaded",
        "error": "the name of a file that failed"}, [], [], {}),
}


FALLBACK = {"el_tree_select": [("select", "Select"), ("tree", "")]}


def clean(s):
    s = re.sub(r"\^\[[^\]]*\]", "", s or "")
    s = s.replace("\\|", "|").replace("`", "").strip()
    s = re.sub(r"\s*=>\s*void$", "", s)
    return s


def element_rows(page, prefix):
    rows = {}
    for t in API.get(page, []):
        if t["kind"] != "Events":
            continue
        if prefix and not t["title"].lower().startswith(prefix.lower()):
            continue
        for r in t["rows"]:
            name = re.sub(r"\s.*$", "", clean(r["name"]))
            rows.setdefault(name, (clean(r["desc"]), clean(r["type"])))
    return rows


def rstr(s):
    return '"' + s.replace("\\", "\\\\").replace('"', '\\"') + '"'


out = [
    "# Generated by tools/events-registry.py -- edit that, not this.",
    "#",
    "# Every Shiny input each component reports: `inputs`, always reported,",
    "# by suffix (\"\" for input$<id> itself); `events`, Element's events it",
    "# forwards as input$<id>_<event>, `default` the ones reported unasked.",
    "# Descriptions and arguments are Element Plus's own.",
    "",
    ".el_event_registry <- list(",
]
entries = []
missing = []
for fn, (page, prefix, inputs, events, default, values) in sorted(SPEC.items()):
    rows = element_rows(page, prefix)
    # tree-select's events are its select's and its tree's
    for more in FALLBACK.get(fn, []):
        for k, v in element_rows(*more).items():
            rows.setdefault(k, v)
    ins = ",\n".join(
        f"      list(input = {rstr(k)}, about = {rstr(v)})" for k, v in inputs.items()
    )
    evs = []
    for e in events:
        desc, args = rows.get(e, ("", ""))
        if not desc:
            missing.append(f"{fn}: {e}")
        evs.append(
            f"      list(event = {rstr(e)}, default = {'TRUE' if e in default else 'FALSE'}, "
            f"about = {rstr(desc)}, args = {rstr(args)}, value = {rstr(values.get(e, ''))})"
        )
    assert set(default) <= set(events), fn
    entries.append(
        f"  {fn} = list(\n"
        f"    inputs = list(\n{ins}\n    ),\n" if inputs else f"  {fn} = list(\n    inputs = list(),\n"
    )
    entries[-1] += (
        f"    events = list(\n" + ",\n".join(evs) + "\n    )\n  )" if evs else "    events = list()\n  )"
    )
out.append(",\n".join(entries))
out.append(")")
open("R/el_events_registry.R", "w").write("\n".join(out) + "\n")
if missing:
    print("no Element description for:\n  " + "\n  ".join(missing))
