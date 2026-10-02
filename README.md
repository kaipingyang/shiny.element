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
  theme = el_theme(),
  use_element(),
  sidebar = bslib::sidebar(el_select("metric", choices = c("Mean", "Median"))),
  el_table(data = head(iris), id = "summary")
)
```

`el_theme()` is the page's look: a bslib theme carrying Element's own
colours, font and sizes, so Shiny's `actionButton()` or `textInput()` sit
beside Element components without clashing. It is `el_page()`'s default.
`el_theme(primary = "#7c3aed")` changes the brand colour -- on Element's
components as well as Bootstrap's -- and `el_theme(element =)` any of
Element's own theme variables; any
`bslib::bs_theme()` replaces it, and `theme = NULL` leaves Shiny's plain
Bootstrap.

## Components

The components follow Element's own documentation, group by group:

| | |
|---|---|
| **Basic** | `el_row()` `el_col()` `el_container()` `el_icon()` `el_button()` `el_button_group()` `el_link()` |
| **Form** | `el_radio_group()` `el_checkbox()` `el_checkbox_group()` `el_input()` `el_autocomplete()` `el_input_number()` `el_select()` `el_cascader()` `el_cascader_panel()` `el_switch()` `el_slider()` `el_time_picker()` `el_time_select()` `el_date_picker()` `el_upload()` `el_rate()` `el_color_picker()` `el_transfer()` `el_form()` |
| **Data** | `el_table()` `el_tag()` `el_progress()` `el_tree()` `el_pagination()` `el_badge()` `el_skeleton()` `el_empty()` `el_descriptions()` `el_result()` `el_statistic()` |
| **Notice** | `el_alert()` `el_loading()` `el_message()` `el_message_box()` `el_notification()` |
| **Navigation** | `el_menu()` `el_tabs()` `el_breadcrumb()` `el_page_header()` `el_dropdown()` `el_steps()` |
| **Others** | `el_dialog()` `el_tooltip()` `el_popover()` `el_popconfirm()` `el_card()` `el_carousel()` `el_collapse()` `el_timeline()` `el_divider()` `el_calendar()` `el_image()` `el_backtop()` `el_infinite_scroll()` `el_avatar()` `el_drawer()` |

[Each has a page](https://kaipingyang.github.io/shiny.element/articles/components.html)
with Element's demos in R and Element's API tables beside the R names.

<img src="https://kaipingyang.github.io/shiny.element/shots/button-basic.png" width="49%" alt="Buttons"> <img src="https://kaipingyang.github.io/shiny.element/shots/steps-description.png" width="49%" alt="Steps">
<img src="https://kaipingyang.github.io/shiny.element/shots/table-grouping.png" width="49%" alt="Table"> <img src="https://kaipingyang.github.io/shiny.element/shots/tree-checking.png" width="49%" alt="Tree">

`el_page(dev = TRUE)` loads Vue's development build, which reports template
errors in the browser console instead of failing silently. The package's own
test suite runs in this mode and asserts that the console stays clean.

## Learn more

* [Get started](https://kaipingyang.github.io/shiny.element/articles/shiny.element.html)
* [Components](https://kaipingyang.github.io/shiny.element/articles/components.html) -- one page per Element component
* [Forms and validation](https://kaipingyang.github.io/shiny.element/articles/forms.html), [Shiny integration](https://kaipingyang.github.io/shiny.element/articles/shiny.html), [Theming, sizes and languages](https://kaipingyang.github.io/shiny.element/articles/theming.html)
* [Dashboards](https://kaipingyang.github.io/shiny.element/articles/dashboards.html) -- whole apps: Element's own admin layout, a sales overview, an orders admin page
* [Function reference](https://kaipingyang.github.io/shiny.element/reference/index.html)

## Licence

MIT. The bundled Element UI distribution is MIT-licensed by ElemeFE; see
`LICENSE.note`.
