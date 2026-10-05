# shiny.element

<!-- badges: start -->
[![R-CMD-check](https://github.com/kaipingyang/shiny.element/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/kaipingyang/shiny.element/actions/workflows/R-CMD-check.yaml)
[![browser tests](https://github.com/kaipingyang/shiny.element/actions/workflows/browser.yaml/badge.svg)](https://github.com/kaipingyang/shiny.element/actions/workflows/browser.yaml)
[![Codecov test coverage](https://codecov.io/gh/kaipingyang/shiny.element/graph/badge.svg)](https://app.codecov.io/gh/kaipingyang/shiny.element)
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/kaipingyang/shiny.element)
<!-- badges: end -->

Use [Element Plus](https://element-plus.org/), the Vue 3 component library,
in Shiny — inputs, tables, trees, dialogs, menus, every component it
documents — each reporting through `input$<id>` and updatable from the
server, like any other Shiny input.

Element Plus 2.14.7, its icons and Vue 3.5 ship inside the package, so apps
work without a network connection.

## Lifecycle

shiny.element is experimental: until 1.0.0 an argument or a function may
change when a better design turns up, and every such change is listed under
"Breaking changes" in NEWS. From the first CRAN release on, nothing is
removed without first being deprecated, with a warning, for at least one
minor release. Element Plus is followed as upstream changes: what it
deprecates is deprecated here too, and what it removes goes with the next
upgrade.

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

`el_theme()` is the page's look: a bslib theme carrying Element Plus's own
colours, font and sizes, so Shiny's `actionButton()` or `textInput()` sit
beside Element Plus components without clashing. It is `el_page()`'s default.
`el_theme(primary = "#7c3aed")` changes the brand colour -- on Element Plus's
components as well as Bootstrap's -- and `el_theme(element =)` any of
its CSS variables; any
`bslib::bs_theme()` replaces it, and `theme = NULL` leaves Shiny's plain
Bootstrap.

## Components

The components follow Element Plus's own documentation, group by group:

| | |
|---|---|
| **Basic** | `el_button()` `el_button_group()` `el_container()` `el_icon()` `el_row()` `el_col()` `el_link()` `el_text()` `el_scrollbar()` `el_space()` `el_splitter()` |
| **Configuration** | `el_config_provider()` |
| **Form** | `el_autocomplete()` `el_cascader()` `el_checkbox()` `el_checkbox_group()` `el_color_picker()` `el_color_picker_panel()` `el_date_picker()` `el_date_picker_panel()` `el_form()` `el_input()` `el_input_number()` `el_input_tag()` `el_input_otp()` `el_mention()` `el_radio_group()` `el_rate()` `el_select()` `el_select_v2()` `el_slider()` `el_switch()` `el_time_picker()` `el_time_select()` `el_transfer()` `el_tree_select()` `el_upload()` |
| **Data** | `el_avatar()` `el_badge()` `el_calendar()` `el_card()` `el_carousel()` `el_collapse()` `el_descriptions()` `el_empty()` `el_image()` `el_infinite_scroll()` `el_pagination()` `el_progress()` `el_result()` `el_skeleton()` `el_table()` `el_table_v2()` `el_tag()` `el_timeline()` `el_tour()` `el_tree()` `el_tree_v2()` `el_statistic()` `el_segmented()` |
| **Navigation** | `el_affix()` `el_anchor()` `el_backtop()` `el_breadcrumb()` `el_dropdown()` `el_menu()` `el_page_header()` `el_steps()` `el_tabs()` |
| **Feedback** | `el_alert()` `el_dialog()` `el_drawer()` `el_loading()` `el_message()` `el_message_box()` `el_notification()` `el_popconfirm()` `el_popover()` `el_tooltip()` |
| **Others** | `el_divider()` `el_watermark()` |

[Each has a page](https://kaipingyang.github.io/shiny.element/articles/components.html),
as on element-plus.org: its demos in R and its API tables beside the R names.

<img src="https://kaipingyang.github.io/shiny.element/shots/button-basic.png" width="49%" alt="Buttons"> <img src="https://kaipingyang.github.io/shiny.element/shots/form-basic-form.png" width="49%" alt="Form">
<img src="https://kaipingyang.github.io/shiny.element/shots/table-fixed-column-and-group-header.png" width="49%" alt="Table"> <img src="https://kaipingyang.github.io/shiny.element/shots/tree-checking-tree.png" width="49%" alt="Tree">

`el_page(dev = TRUE)` loads Vue's development build, which reports template
errors in the browser console instead of failing silently. The package's own
test suite runs in this mode and asserts that the console stays clean.

## Learn more

* [Installation & Quick Start](https://kaipingyang.github.io/shiny.element/articles/shiny.element.html)
* [Components](https://kaipingyang.github.io/shiny.element/articles/components.html) -- one page per Element Plus component
* Element Plus's guides from R: [i18n](https://kaipingyang.github.io/shiny.element/articles/i18n.html), [Theming](https://kaipingyang.github.io/shiny.element/articles/theming.html), [Dark Mode](https://kaipingyang.github.io/shiny.element/articles/dark-mode.html), [Custom Defaults](https://kaipingyang.github.io/shiny.element/articles/custom-defaults.html), [Built-in Transitions](https://kaipingyang.github.io/shiny.element/articles/transitions.html), [Migration from Element UI](https://kaipingyang.github.io/shiny.element/articles/migration.html)
* [Forms and validation](https://kaipingyang.github.io/shiny.element/articles/forms.html), [Shiny integration](https://kaipingyang.github.io/shiny.element/articles/shiny.html)
* [Dashboards](https://kaipingyang.github.io/shiny.element/articles/dashboards.html) -- whole apps: an admin layout, a sales overview, an orders admin page
* [Function reference](https://kaipingyang.github.io/shiny.element/reference/index.html)

## Licence

MIT. The bundled Element Plus, its icons and Vue are MIT-licensed by their
authors; see `LICENSE.note`.
