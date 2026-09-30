# Call a method on the Element UI component behind a widget

[`update_el_table()`](https://kaipingyang.github.io/shiny.element/reference/update_el_table.md)
and the other `update_el_*()` functions assign into the Vue instance's
data, which reaches a component's props. Element also documents
*methods* – `clearSelection()`, `setCheckedKeys()`,
[`validate()`](https://rdrr.io/pkg/shiny/man/validate.html) – which are
functions on the component and cannot be reached that way. `el_call()`
invokes one.

## Usage

``` r
el_call(session, id, method, args = list(), result = TRUE, component = NULL)
```

## Arguments

- session:

  Shiny session object.

- id:

  Component ID (un-namespaced).

- method:

  Name of the Element method to call.

- args:

  A list of arguments, passed positionally.

- result:

  Whether to report the return value as an input. Default `TRUE`.

- component:

  Optional Element component name (`"ElTable"`) to look for under the
  widget. Only needed when a component nests another of its own.

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

A method that returns something reports it as `input$<id>_<method>`,
with the method name in snake_case, matching how events are reported:
`getCheckedKeys` arrives as `input$<id>_get_checked_keys`. The input is
set with event priority, so Shiny resets it to `NULL` after each flush –
read it in an
[`observeEvent()`](https://rdrr.io/pkg/shiny/man/observeEvent.html)
rather than polling it.

A method that returns nothing reports `TRUE`, so an
[`observeEvent()`](https://rdrr.io/pkg/shiny/man/observeEvent.html) can
still tell that it ran. Pass `result = FALSE` to send nothing back.

Each component's methods are listed in its own help page, under "Element
methods".

## Examples

``` r
if (interactive()) {
  library(shiny)
  library(shiny.element)

  ui <- el_page(
    el_table("tbl", data = head(iris, 5), selection = TRUE),
    el_button("clear", "Clear selection"),
    el_button("ask", "Which rows are checked?"),
    verbatimTextOutput("answer")
  )

  server <- function(input, output, session) {
    observeEvent(input$clear, {
      el_call(session, "tbl", "clearSelection")
    })

    # A method with a return value answers asynchronously
    observeEvent(input$ask, {
      el_call(session, "tbl", "getSelectionRows")
    })
    output$answer <- renderPrint(input$tbl_get_selection_rows)
  }

  shinyApp(ui, server)
}
```
