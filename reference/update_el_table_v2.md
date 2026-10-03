# Update Element Plus Virtualized Table

Server-side update for
[`el_table_v2()`](https://kaipingyang.github.io/shiny.element/reference/el_table_v2.md):
new rows, new columns, or the sort indicator. Rows are given as for
[`el_table_v2()`](https://kaipingyang.github.io/shiny.element/reference/el_table_v2.md),
a data.frame or a list of rows; a data.frame without `columns` keeps the
table's columns.

## Usage

``` r
update_el_table_v2(
  session = shiny::getDefaultReactiveDomain(),
  id,
  data = NULL,
  columns = NULL,
  sort_by = NULL,
  expanded_row_keys = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Table ID (un-namespaced).

- data, columns, sort_by, expanded_row_keys:

  New values; `NULL` leaves one unchanged.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$filter_on, {
    update_el_table_v2(id = "big", data = subset(big, keep))
  })
}
```
