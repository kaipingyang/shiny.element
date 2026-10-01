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
  session,
  id,
  name,
  label,
  content = NULL,
  closable = NULL,
  select = TRUE
)

remove_el_tab(session, id, name)
```

## Arguments

- session:

  Shiny session object.

- id:

  Tabs ID (un-namespaced).

- name, label:

  The new tab's name and label.

- content:

  The new tab's content.

- closable:

  Whether it can be closed. `NULL` follows the tabs' own setting.

- select:

  Whether to switch to it. Default `TRUE`.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  library(shiny)
  ui <- el_page(el_tabs("docs", editable = TRUE, tabs = list(
    list(name = "t1", label = "Tab 1", content = tags$p("First"))
  )))
  server <- function(input, output, session) {
    n <- 1
    observeEvent(input$docs_tab_add, {
      n <<- n + 1
      insert_el_tab(session, "docs", name = paste0("t", n),
                    label = paste("Tab", n), content = tags$p("New"))
    })
  }
  shinyApp(ui, server)
}
```
