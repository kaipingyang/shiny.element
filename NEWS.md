# shiny.element 0.1.0

First release.

## Components

Every component Element UI 2.15.14 documents is wrapped -- 83 of them -- with
everything each one documents reachable from R: 552 attributes, 94 events,
54 methods and 42 slots.

* **Input** — `el_input()`, `el_input_number()`, `el_select()`,
  `el_radio_group()`, `el_checkbox_group()`, `el_switch()`, `el_slider()`,
  `el_rate()`, `el_date_picker()`, `el_color_picker()`, `el_cascader()`,
  `el_upload()`, `el_autocomplete()`, `el_transfer()`.
* **Display** — `el_table()`, `el_tag()`, `el_progress()`, `el_alert()`,
  `el_badge()`, `el_card()`, `el_calendar()`, `el_tree()`, `el_timeline()`,
  `el_carousel()`, `el_icon()`, `el_link()`, `el_divider()`, `el_avatar()`,
  `el_image()`, `el_tooltip()`, `el_popover()`, `el_popconfirm()`.
* **Navigation** — `el_menu()`, `el_tabs()`, `el_steps()`, `el_pagination()`,
  `el_dropdown()`, `el_breadcrumb()`, `el_page_header()`, `el_backtop()`,
  `el_infinite_scroll()`.
* **Containers** — `el_collapse()`, `el_dialog()`, `el_drawer()`, `el_form()`,
  `el_row()`, `el_col()`, `el_container()`, `el_header()`, `el_aside()`,
  `el_main()`, `el_footer()`.
* **Feedback** — `el_message()`, `el_notification()`, `el_message_box()`,
  `el_loading()`, `el_loading_close()`.
* **Helpers** — `el_page()`, `use_element()`, `el_table_config()`,
  `df_to_tree_data()`, `df_to_cascader_options()`, `el_form_validate()`.

Most components have a matching `update_el_*()` for server-side updates, and
report their value through `input$<id>` like any other Shiny input.

## Note for users of the development version

`el_table()` now takes `id` first, like every other component:

```r
el_table("my_table", data = df)     # new
el_table(data = df, id = "my_table")  # also fine, and always was
```

Positional calls written against the old `el_table(data, columns, id)` order
still work -- the arguments are shifted back with a warning -- but naming them
is the way to keep it quiet.

## Filling a slot

Every component takes `slots`, a named list, one entry per Element slot:

```r
el_alert("a", slots = list(title = tags$b("Something went wrong")))

# A component works as slot content too, and keeps reporting its inputs
el_alert("a", slots = list(title = el_tag("sev", "critical", type = "danger")))
```

A scoped slot, where Element hands the template its own data, is written with
`template()`:

```r
el_calendar("cal", slots = list(
  dateCell = template(
    htmltools::HTML("<p>{{ data.day.slice(8) }}</p>"),
    slot = "dateCell", scope = "{date, data}"
  )
))
```

## Reaching a component's methods

Element documents methods as well as props. `el_call()` invokes one:

```r
observeEvent(input$clear, {
  el_call(session, "tbl", "clearSelection")
})

# A method with a return value answers asynchronously
observeEvent(input$ask, {
  el_call(session, "tree", "getCheckedKeys")
})
observeEvent(input$tree_get_checked_keys, {
  message("checked: ", paste(input$tree_get_checked_keys, collapse = ", "))
})
```

The answer arrives as `input$<id>_<method>` with the method name in
snake_case. Each component's help page lists what it accepts under
"Element methods".

## Element UI 2.15.14, and English by default

The bundled Element UI is 2.15.14, the last 2.x release; 2.13.2 was two
minor versions behind. That brings `el_descriptions()`, `el_statistic()`,
`el_empty()`, `el_result()` and `el_skeleton()`, and a handful of new props
on existing components.

`el_page()` and `use_element()` now load English for Element's built-in text
-- placeholders, empty-table messages, date-picker buttons. Element's own
default is Simplified Chinese, which is what every page showed before. All 59
of Element's locales are bundled (`el_locales()`), and
`options(shiny.element.locale = "zh-CN")` sets one for a whole session.

## Design notes

* Controls render as Vue instances wrapped in htmlwidgets; containers render as
  plain markup driven by Shiny input bindings, so they can nest freely.
* Element UI is bundled in `inst/element-ui/` rather than loaded from a CDN, so
  apps work offline.
* `el_page(dev = TRUE)` loads Vue's development build, which surfaces template
  warnings in the browser console.
