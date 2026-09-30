# shiny.element

<!-- badges: start -->
[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/kaipingyang/shiny.element)
<!-- badges: end -->

Use [Element UI](https://element.eleme.io/) components in Shiny — inputs,
tables, trees, dialogs, menus — each reporting through `input$<id>` and
updatable from the server, like any other Shiny input.

Element UI ships inside the package, so apps work without a network connection.

## Installation

``` r
remotes::install_github("kaipingyang/shiny.element")
```

## Quick start

``` r
library(shiny)
library(shiny.element)

ui <- el_page(
  el_input("name", label = "Name", placeholder = "Your name"),
  el_rate("score", value = 3),
  el_button("save", "Save", type = "primary"),
  el_alert("hint", title = "Nothing saved yet", type = "info")
)

server <- function(input, output, session) {
  observeEvent(input$save, {
    update_el_alert(session, "hint",
      title = paste0("Saved ", input$name, " (", input$score, "/5)"),
      type = "success"
    )
  })
}

shinyApp(ui, server)
```

`el_page()` sets up the Vue root and loads the dependencies. Inside an existing
layout — a `fluidPage()`, or bslib's `page_sidebar()` — call `use_element()`
once at the top instead:

``` r
ui <- bslib::page_sidebar(
  use_element(),
  sidebar = bslib::sidebar(el_select("metric", choices = c("Mean", "Median"))),
  el_table(data = head(iris), id = "summary")
)
```

## Components

| | |
|---|---|
| **Input** | `el_input()` `el_input_number()` `el_select()` `el_radio_group()` `el_checkbox_group()` `el_switch()` `el_slider()` `el_rate()` `el_date_picker()` `el_color_picker()` `el_cascader()` `el_upload()` |
| **Display** | `el_table()` `el_tag()` `el_progress()` `el_alert()` `el_badge()` `el_card()` `el_calendar()` `el_tree()` `el_timeline()` `el_carousel()` `el_icon()` `el_link()` `el_divider()` |
| **Navigation** | `el_menu()` `el_tabs()` `el_steps()` `el_pagination()` `el_dropdown()` |
| **Container** | `el_collapse()` `el_dialog()` `el_drawer()` `el_form()` `el_row()` `el_col()` `el_container()` `el_header()` `el_aside()` `el_main()` `el_footer()` |
| **Feedback** | `el_message()` `el_notification()` |

The [component gallery](https://kaipingyang.github.io/shiny.element/articles/components.html)
shows each one rendered, with the code that produced it.

<img src="man/figures/component-button.png" width="49%" alt="Buttons"> <img src="man/figures/component-steps.png" width="49%" alt="Steps">
<img src="man/figures/component-table.png" width="49%" alt="Table"> <img src="man/figures/component-tree.png" width="49%" alt="Tree">

## Reading and writing values

Every component reports through `input$<id>`, and every component has a matching
`update_el_*()`:

``` r
server <- function(input, output, session) {
  # read
  output$chosen <- renderText(input$city)

  # write
  observeEvent(input$reset, {
    update_el_select(session, "city", value = "beijing")
  })
}
```

Tables take a data frame directly, and `el_table_config()` derives the column
definitions from it:

``` r
cfg <- el_table_config(iris, max_rows = 20)
el_table(data = cfg$data, columns = cfg$columns, id = "iris")
```

## Layout

`el_row()` / `el_col()` implement Element's 24-column grid, and
`el_container()` its header/aside/main/footer frame. Both nest freely and
accept any Shiny UI inside, including other Element components.

For whole-page structure, bslib's `page_sidebar()` and `layout_columns()`
remain the better tool — they handle responsive breakpoints and theming that
Element's grid does not. Mixing the two is supported: use bslib for the page,
Element for the controls.

## Debugging

`el_page(dev = TRUE)` loads Vue's development build, which reports template
errors in the browser console instead of failing silently. The package's own
test suite runs in this mode and asserts that the console stays clean.

## Learn more

* [Component gallery](https://kaipingyang.github.io/shiny.element/articles/components.html)
* [Function reference](https://kaipingyang.github.io/shiny.element/reference/index.html)

## Licence

MIT. The bundled Element UI distribution is MIT-licensed by ElemeFE; see
`LICENSE.note`.
