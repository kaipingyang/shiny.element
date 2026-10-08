# Answer a component that asked the server for data

Element loads some components a piece at a time: a lazy tree its nodes'
children, a lazy cascader its next column, a lazy tree table its rows'
children. Upstream, a JavaScript function you write fetches them. Here
the server does: the component asks through an input – `input$<id>_load`
for a tree or table, `input$<id>_lazy_load` for a cascader – and waits
until this function answers.

## Usage

``` r
el_load_children(
  session = shiny::getDefaultReactiveDomain(),
  id,
  request,
  children = list(),
  reject = FALSE
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  The component's ID (un-namespaced).

- request:

  The question, as it arrived in `input$<id>_load` or
  `input$<id>_lazy_load` – or just its `request` number.

- children:

  What to load. For a tree, nodes such as
  `list(id =, label =, leaf = TRUE)`; for a cascader, options such as
  `list(value =, label =, leaf = TRUE)`; for a table, rows, as a
  data.frame or a list. An empty list means there is nothing below.

- reject:

  `TRUE` to answer that the load failed, Element Plus's `reject()`: a
  tree node stops spinning and can be loaded again when it is next
  expanded. A cascader or table takes it as nothing below.

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

Each question carries a `request` number, so answers find their way back
even when several are open at once; pass the question back whole.

## Examples

``` r
if (interactive()) {
  library(shiny)
  ui <- el_page(el_tree(
    "files",
    lazy = TRUE,
    node_key = "id",
    props = list(isLeaf = "leaf")
  ))
  server <- function(input, output, session) {
    observeEvent(input$files_load, {
      q <- input$files_load
      dir <- if (q$level == 0) "~" else q$key
      entries <- list.files(dir, full.names = TRUE)
      el_load_children(
        id = "files",
        request = q,
        children = lapply(entries, function(f) {
          list(id = f, label = basename(f), leaf = !dir.exists(f))
        })
      )
    })
  }
  shinyApp(ui, server)
}
```
