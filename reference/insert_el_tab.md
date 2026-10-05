# Add or remove a tab from the server

Element's addable and editable tabs leave adding to the app: clicking
"+" reports `input$<id>_tab_add`, and the app decides what the new tab
holds. These are how, in the manner of
[`shiny::insertTab()`](https://rdrr.io/pkg/shiny/man/insertTab.html) and
[`shiny::removeTab()`](https://rdrr.io/pkg/shiny/man/insertTab.html).
The content may hold any UI, this package's components included.

## Usage

``` r
insert_el_tab(
  session = shiny::getDefaultReactiveDomain(),
  id,
  tab,
  label = NULL,
  content = NULL,
  closable = NULL,
  select = TRUE
)

remove_el_tab(session = shiny::getDefaultReactiveDomain(), id, name)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Tabs ID (un-namespaced).

- tab:

  The new tab: an
  [`el_tab_pane()`](https://kaipingyang.github.io/shiny.element/reference/el_tab_pane.md),
  as
  [`bslib::nav_insert()`](https://rstudio.github.io/bslib/reference/nav_select.html)
  takes a `nav_panel()` – or its name, with `label` and `content`.

- label, content:

  The new tab's label and content, when `tab` is a name.

- closable:

  Whether it can be closed. `NULL` follows the tabs' own setting.

- select:

  Whether to switch to it. Default `TRUE`.

- name:

  For `remove_el_tab()`, the name of the tab to remove.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  library(shiny)
  ui <- el_page(el_tabs(
    "docs",
    editable = TRUE,
    tabs = list(
      el_tab_pane("Tab 1", tags$p("First"), name = "t1")
    )
  ))
  server <- function(input, output, session) {
    n <- 1
    observeEvent(input$docs_tab_add, {
      n <<- n + 1
      insert_el_tab(
        session,
        "docs",
        el_tab_pane(paste("Tab", n), tags$p("New"), name = paste0("t", n))
      )
    })
  }
  shinyApp(ui, server)
}
```
