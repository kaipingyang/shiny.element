# Update Element Plus Table

Update Element Plus Table

## Usage

``` r
update_el_table(
  session = shiny::getDefaultReactiveDomain(),
  id,
  data = NULL,
  columns = NULL,
  border = NULL,
  selection = NULL,
  loading = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Table ID (un-namespaced).

- data:

  New data: a data.frame or a list of rows.

- columns:

  New column configs. Omitted, the table keeps the columns it was
  created with – labels, formatters, cell templates – and a table whose
  columns were inferred infers them again from the new `data`.
  [`list()`](https://rdrr.io/r/base/list.html) drops written columns and
  goes back to inferring them.

- border:

  New border state.

- selection:

  New row-selection state.

- loading:

  Show or hide the loading mask.

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

A column's `cell` template is part of the table's markup, made when the
table is. New columns given here keep the template of the column with
the same `prop` (or label) and may drop it, but cannot bring a template
the table was not created with.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_table(session, "tbl", data = head(mtcars, 10))
  })
}
```
