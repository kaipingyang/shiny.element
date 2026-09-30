# What works, and what does not

Everything Element UI 2.13.2 documents is wrapped: 74 components, 506
attributes, 94 events, 53 methods and 26 slots. What follows is the
small print – the places where this package behaves differently from
Element in a browser, and why.

Coverage is measured rather than claimed. `tools/api-coverage.R` renders
every component and reads the markup back; `tools/api-coverage.py`
compares that with the API tables in Element’s own documentation.

## Reading and writing a component

A component reports to `input$<id>`, on load as well as on change:

``` r

el_select("city", choices = c("Beijing", "Shanghai"))
# server: input$city
```

Three separate channels reach back into it, and they do different
things:

|  | Reaches | Example |
|----|----|----|
| `update_el_*()` | the component’s props | `update_el_select(session, "city", value = "Beijing")` |
| [`el_call()`](https://kaipingyang.github.io/shiny.element/reference/el_call.md) | the component’s methods | `el_call(session, "tbl", "clearSelection")` |
| [`update_vue_data()`](https://kaipingyang.github.io/shiny.element/reference/update_vue_data.md) | the Vue instance’s fields directly | `update_vue_data(session, "tip", list(tipContent = "..."))` |

`update_el_*()` cannot call a method, because it assigns into the Vue
instance’s data and a method is a function. That is what
[`el_call()`](https://kaipingyang.github.io/shiny.element/reference/el_call.md)
is for. A method with a return value answers asynchronously, as
`input$<id>_<method>`:

``` r

observeEvent(input$ask, {
  el_call(session, "tree", "getCheckedKeys")
})
observeEvent(input$tree_get_checked_keys, {
  message("checked: ", paste(input$tree_get_checked_keys, collapse = ", "))
})
```

## Events are event inputs

Every forwarded Element event sets its input with event priority, which
Shiny resets to `NULL` after each flush. That is what lets the same
value fire twice, and it means polling the input almost always reads the
`NULL`:

``` r

# Wrong: reads NULL nearly every time
output$last <- renderPrint({
  invalidateLater(1000, session)
  input$tbl_row_click
})

# Right
observeEvent(input$tbl_row_click, {
  last_row(input$tbl_row_click)
})
```

An event whose arguments cannot cross the wire – a native `FocusEvent`,
a DOM node, a whole Vue instance – reports `TRUE` instead, so an
observer can still tell that it happened.

## Nesting components

Two kinds of component wrap other content, and they behave differently.

**Containers are plain markup.**
[`el_row()`](https://kaipingyang.github.io/shiny.element/reference/el_row.md),
[`el_col()`](https://kaipingyang.github.io/shiny.element/reference/el_col.md),
[`el_container()`](https://kaipingyang.github.io/shiny.element/reference/el_container.md),
[`el_collapse()`](https://kaipingyang.github.io/shiny.element/reference/el_collapse.md),
[`el_tabs()`](https://kaipingyang.github.io/shiny.element/reference/el_tabs.md),
[`el_dialog()`](https://kaipingyang.github.io/shiny.element/reference/el_dialog.md)
and
[`el_drawer()`](https://kaipingyang.github.io/shiny.element/reference/el_drawer.md)
render Element’s own CSS classes and drive their state through a Shiny
input binding. They hold anything, and what is inside keeps working as
it would on its own.

``` r

el_collapse("panels", items = list(
  list(name = "one", title = "Settings", content = el_switch("dark", value = TRUE))
))
```

**Wrappers absorb what they are given.**
[`el_tooltip()`](https://kaipingyang.github.io/shiny.element/reference/el_tooltip.md),
[`el_popover()`](https://kaipingyang.github.io/shiny.element/reference/el_popover.md),
[`el_popconfirm()`](https://kaipingyang.github.io/shiny.element/reference/el_popconfirm.md)
and
[`el_infinite_scroll()`](https://kaipingyang.github.io/shiny.element/reference/el_infinite_scroll.md)
compile their content into their own Vue instance, so a component handed
to one is folded in rather than nested: the two become a single instance
carrying both sets of markup, data and methods.

``` r

el_tooltip("hint", el_button("save", "Save"), content = "Writes to disk")
# input$save still reports
```

This costs one thing. An absorbed component has no widget of its own, so
`HTMLWidgets.find()` cannot reach it and its `update_el_*()` stops
working. Drive it through the wrapper instead:

``` r

# Not this
update_el_button(session, "save", label = "Saving...")

# This
update_vue_data(session, "hint", list(label = "Saving..."))
```

If two absorbed components declare the same field – most declare a
`label`, a `type` and a `disabled` – the second one’s fields are renamed
on the way in (`el3_label`), and the markup that names them is rewritten
to match. You only notice when reaching in with
[`update_vue_data()`](https://kaipingyang.github.io/shiny.element/reference/update_vue_data.md),
where the renamed field is what to set.

## Slots

Every component takes `slots`, a named list:

``` r

el_alert("a", slots = list(title = tags$b("Something went wrong")))
```

A scoped slot – one where Element hands the template variables that only
exist while Vue renders – is written with
[`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md)
and passed through untouched:

``` r

el_calendar("cal", slots = list(
  dateCell = template(
    htmltools::HTML("<p>{{ data.day.slice(8) }}</p>"),
    slot = "dateCell", scope = "{date, data}"
  )
))
```

Filling a slot replaces what Element put there, default and all.
Element’s `el-form-item` error slot, for instance, wraps the message in
`div.el-form-item__error`; a template that renders only the message
loses the styling with it.

## Sizing

`width` is accepted by every component and behaves like the `width` of a
Shiny input – `"200px"`, `"50%"`, or a number meaning pixels. It lands
on Element’s own markup, because the host element carries
`display: contents` and generates no box of its own.

`height` is only where Element gives it a meaning:
[`el_table()`](https://kaipingyang.github.io/shiny.element/reference/el_table.md)
fixes the header and scrolls the body,
[`el_slider()`](https://kaipingyang.github.io/shiny.element/reference/el_slider.md)
sizes a vertical track,
[`el_carousel()`](https://kaipingyang.github.io/shiny.element/reference/el_carousel.md)
sets the frame. Element sizes controls through `size` (`"medium"`,
`"small"`, `"mini"`) rather than a height.

## Element’s own markup

`el` holds a generator for every Element tag, for markup that needs no
Vue instance of its own:

``` r

el$button(type = "primary", "Save")   # markup only, no input
el_button("save", "Save")             # a component, reports input$save
```

Use the raw tag where a component would be wasted – inside a
[`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md),
or as a wrapper’s trigger when you do not need to know it was clicked.

## Building your own

[`el_widget()`](https://kaipingyang.github.io/shiny.element/reference/el_widget.md)
assembles a component the way this package assembles its own, and is
exported for wrapping anything not covered here, or covered differently:

``` r

my_avatar <- function(id, src, size = 50) {
  el_widget(
    id     = id,
    markup = el$avatar(":src" = "src", ":size" = "size"),
    data   = list(src = src, size = size),
    dependency = element_ui_dependency()
  )
}
```

Calling [`vueR::vue()`](https://rdrr.io/pkg/vueR/man/vue.html) yourself
works too. What
[`el_widget()`](https://kaipingyang.github.io/shiny.element/reference/el_widget.md)
carries, and what is then yours to remember, is `display: contents` on
the host, a zero-sized widget element, and the `el` selector – each of
which is there because of a bug.

## Where the argument name differs from Element’s

Arguments are snake_case versions of Element’s prop names, with six
exceptions. Each is deliberate; the rest translate mechanically
(`show-overflow-tooltip` becomes `show_overflow_tooltip`).

| Element | Here | Why |
|----|----|----|
| `default-active` | `active` | It is the current item, and [`update_el_menu()`](https://kaipingyang.github.io/shiny.element/reference/update_el_menu.md) changes it – “default” would suggest it is only read once |
| `default-expanded-keys` | `expanded` | As above, for [`el_tree()`](https://kaipingyang.github.io/shiny.element/reference/el_tree.md) |
| `default-checked-keys` | `checked` | As above |
| `props` | `label_field`, `children_field`, `disabled_field`, `is_leaf_field` | [`el_tree()`](https://kaipingyang.github.io/shiny.element/reference/el_tree.md)’s field map is four arguments rather than a nested list |
| `data` (upload) | `extra_data` | [`el_upload()`](https://kaipingyang.github.io/shiny.element/reference/el_upload.md)’s `data` would read as the file, not the fields sent beside it |
| `width` (popover) | `popover_width` | Every component takes `width` for its own size; this one sizes the card |

A component’s `value` prop is its `v-model`, so it is the `value`
argument where the component has one and the binding elsewhere –
[`el_tooltip()`](https://kaipingyang.github.io/shiny.element/reference/el_tooltip.md)
and
[`el_popover()`](https://kaipingyang.github.io/shiny.element/reference/el_popover.md)
use `value` for whether they are open, which `update_el_*(value =)`
sets.

[`el_upload()`](https://kaipingyang.github.io/shiny.element/reference/el_upload.md)’s
`on-success`, `on-error` and `http-request` are taken: they are how
files reach Shiny. The other hooks (`on-change`, `on-progress`,
`before-upload`, …) are yours.

Where a name does differ, the component’s help page documents both.

## Known gaps

**Three attributes are deliberately unbound.** `value` on `el-checkbox`
and `el-radio`, which a group owns through `v-model`, and the deprecated
`auto-complete` spellings on `el-select` and `el-input`, which upstream
marks `@DEPRECATED` beside the `autocomplete` this package binds. They
are listed in `tools/api-coverage.py` with the reason.

**Element’s i18n covers the component text, not yours.**
`el_page(locale =)` switches Element’s own strings – a date picker’s
month names, a table’s “No Data”. Text you pass in is yours to
translate.

**A component inside a
[`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html) is
re-created, not updated.** That is Shiny’s behaviour rather than this
package’s, but it matters more here: the new instance starts from its
arguments, so anything the user had changed is lost. Prefer
`update_el_*()` where you can.
