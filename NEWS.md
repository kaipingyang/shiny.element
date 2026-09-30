# shiny.element 0.1.0

First release.

## Components

Wrappers for Element UI components, exposed as 94 functions:

* **Input** — `el_input()`, `el_input_number()`, `el_select()`,
  `el_radio_group()`, `el_checkbox_group()`, `el_switch()`, `el_slider()`,
  `el_rate()`, `el_date_picker()`, `el_color_picker()`, `el_cascader()`,
  `el_upload()`.
* **Display** — `el_table()`, `el_tag()`, `el_progress()`, `el_alert()`,
  `el_badge()`, `el_card()`, `el_calendar()`, `el_tree()`, `el_timeline()`,
  `el_carousel()`, `el_icon()`, `el_link()`, `el_divider()`.
* **Navigation** — `el_menu()`, `el_tabs()`, `el_steps()`, `el_pagination()`,
  `el_dropdown()`.
* **Containers** — `el_collapse()`, `el_dialog()`, `el_drawer()`, `el_form()`,
  `el_row()`, `el_col()`, `el_container()`, `el_header()`, `el_aside()`,
  `el_main()`, `el_footer()`.
* **Feedback** — `el_message()`, `el_notification()`.
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

## Design notes

* Controls render as Vue instances wrapped in htmlwidgets; containers render as
  plain markup driven by Shiny input bindings, so they can nest freely.
* Element UI is bundled in `inst/element-ui/` rather than loaded from a CDN, so
  apps work offline.
* `el_page(dev = TRUE)` loads Vue's development build, which surfaces template
  warnings in the browser console.
