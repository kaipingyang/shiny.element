# The data a table shows

What the browser holds, as R: the data last rendered with
[`render_el_table()`](https://kaipingyang.github.io/shiny.element/reference/el_table_output.md)
or sent with
[`update_el_table()`](https://kaipingyang.github.io/shiny.element/reference/el_table.md),
with every row
[`update_el_table()`](https://kaipingyang.github.io/shiny.element/reference/el_table.md)
has since inserted, replaced or deleted. A reactive read: an observer or
output reading it runs again when the data changes. Row numbers in the
table's inputs – `input$<id>_selection_rows`, a row event's `row_index`
– index it.

## Usage

``` r
el_table_data(session = shiny::getDefaultReactiveDomain(), id)
```

## Arguments

- session:

  The Shiny session, the current one by default.

- id:

  The table's id, the output's.

## Value

The data, as given (a data.frame or a list of rows); `NULL` for a table
the server has not rendered or updated.

## See also

[`render_el_table()`](https://kaipingyang.github.io/shiny.element/reference/el_table_output.md),
[`update_el_table()`](https://kaipingyang.github.io/shiny.element/reference/el_table.md).

## Examples

``` r
if (interactive()) {
  library(shiny)
  ui <- el_page(el_table_output("cars"), verbatimTextOutput("n"))
  server <- function(input, output, session) {
    output$cars <- render_el_table(el_table(data = head(mtcars)))
    output$n <- renderText(nrow(el_table_data(id = "cars")))
  }
  shinyApp(ui, server)
}
```
