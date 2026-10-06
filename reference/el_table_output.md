# An Element Plus table as a Shiny output

The table of a Shiny app, as DT's `DTOutput()` and `renderDT()`: the
page holds `el_table_output()`, the server renders
[`el_table()`](https://kaipingyang.github.io/shiny.element/reference/el_table.md)
into it with its data. Rendering again with new data updates the table
in place – the user's sort, ticks and open rows stay (see
[`render_vue()`](https://kaipingyang.github.io/shiny.element/reference/vue_output.md)).

## Usage

``` r
el_table_output(outputId, width = "100%")

render_el_table(expr, env = parent.frame(), quoted = FALSE)
```

## Arguments

- outputId:

  The output's id.

- width:

  The table's width, as a CSS unit.

- expr:

  An expression returning
  [`el_table()`](https://kaipingyang.github.io/shiny.element/reference/el_table.md),
  given no `id`.

- env, quoted:

  As for
  [`shiny::renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html).

## Value

`el_table_output()`, a tag; `render_el_table()`, a render function.

## Details

The output id names the table's inputs:

- `input$<id>_selection_rows` – the selected row numbers, integers;
  `NULL` with none.

- `input$<id>_selection_change` – the selected rows,
  `data[rows, , drop = FALSE]` of the data shown: its columns, types and
  row names.

- `input$<id>_current_change`, `_sort_change`, `_filter_change`,
  `_expand_change` – reported by every table; any other of Element's
  events with `el_table(events =)` or
  [`el_on()`](https://kaipingyang.github.io/shiny.element/reference/el_on.md).

[`update_el_table()`](https://kaipingyang.github.io/shiny.element/reference/el_table.md)
and
[`call_el()`](https://kaipingyang.github.io/shiny.element/reference/call_el.md)
reach the table by the output id;
[`el_table_data()`](https://kaipingyang.github.io/shiny.element/reference/el_table_data.md)
reads the data it shows.

## See also

[`el_table()`](https://kaipingyang.github.io/shiny.element/reference/el_table.md),
[`el_on()`](https://kaipingyang.github.io/shiny.element/reference/el_on.md).

## Examples

``` r
if (interactive()) {
  library(shiny)
  ui <- el_page(el_table_output("cars"), verbatimTextOutput("picked"))
  server <- function(input, output, session) {
    output$cars <- render_el_table(
      el_table(data = head(mtcars), selection = TRUE)
    )
    output$picked <- renderPrint(input$cars_selection_change)
  }
  shinyApp(ui, server)
}
```
