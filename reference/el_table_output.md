# An Element Plus table as a Shiny output

The table of a Shiny app, as DT's `DTOutput()` and `renderDT()`: the
page holds `el_table_output()`, the server renders
[`el_table()`](https://kaipingyang.github.io/shiny.element/reference/el_table.md)
into it with its data. Rendering again with new data updates the table
in place – the user's sort, ticks and open rows stay (see
[`render_vue()`](https://kaipingyang.github.io/shiny.element/reference/vue_output.md)).

## Usage

``` r
el_table_output(outputId, width = "100%", loading = TRUE)

render_el_table(expr, env = parent.frame(), quoted = FALSE)
```

## Arguments

- outputId:

  The output's id.

- width:

  The table's width, as a CSS unit.

- loading:

  Whether Element's loading mask covers the table while Shiny
  recalculates it, in place of Shiny fading the output.

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

The first render sends the table; a render after it whose columns,
templates and options are unchanged sends only the data that changed, as
JSON – as Shiny's own outputs send values rather than markup. Because a
render depends on the last one in the session, `render_el_table()` is
not cached with
[`shiny::bindCache()`](https://rdrr.io/pkg/shiny/man/bindCache.html) (as
DT's server-side table is not); cache the data it shows instead, in a
[`shiny::reactive()`](https://rdrr.io/pkg/shiny/man/reactive.html)
upstream.

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
