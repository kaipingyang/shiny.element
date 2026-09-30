# shiny.element 0.1.0

First release.

## Components

Wrappers for 40 Element UI (Vue 2) component families, exposed as 94 functions:

* **Input** — `el_input()`, `el_input_number()`, `el_select()`, `el_radio_group()`,
  `el_checkbox_group()`, `el_switch()`, `el_slider()`, `el_rate()`,
  `el_date_picker()`, `el_time_picker()`, `el_color_picker()`, `el_cascader()`,
  `el_transfer()`, `el_upload()`, `el_autocomplete()`.
* **Display** — `el_table()`, `el_tag()`, `el_progress()`, `el_alert()`,
  `el_badge()`, `el_card()`, `el_avatar()`, `el_calendar()`, `el_tree()`,
  `el_timeline()`, `el_carousel()`, `el_descriptions()`, `el_image()`,
  `el_statistic()`, `el_empty()`, `el_skeleton()`.
* **Navigation** — `el_menu()`, `el_tabs()`, `el_steps()`, `el_breadcrumb()`,
  `el_pagination()`, `el_dropdown()`, `el_page_header()`, `el_backtop()`.
* **Containers** — `el_collapse()`, `el_dialog()`, `el_drawer()`, `el_row()`,
  `el_col()`, `el_container()`, `el_form()`, `el_tooltip()`, `el_popover()`.
* **Feedback** — `el_message()`, `el_notification()`, `el_message_box()`,
  `el_loading()`.

Every component has a matching `update_el_*()` for server-side updates, and
reports its value through `input$<id>` like any other Shiny input.

## Design notes

* Controls render as Vue instances wrapped in htmlwidgets; containers render as
  plain markup driven by Shiny input bindings, so they can nest freely.
* Element UI is bundled in `inst/element-ui/` rather than loaded from a CDN, so
  apps work offline.
* `el_page(dev = TRUE)` loads Vue's development build, which surfaces template
  warnings in the browser console.
