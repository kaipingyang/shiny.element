# Name a table row or an uploaded file for a method

Element's table methods take the row object itself –
`toggleRowSelection(row)`, `setCurrentRow(row)`,
`toggleRowExpansion(row)` – and compare it by identity, so a copy sent
from R would match nothing. Likewise the upload's `abort(file)`. These
stand for the object instead, and the page puts the real one in its
place before the method runs.

## Usage

``` r
el_table_row(index)

el_upload_file(name)
```

## Arguments

- index:

  A row's number, 1-based, as `input$<id>_selected_rows` reports them.

- name:

  A file's name, as it shows in the upload's list.

## Value

A reference, for
[`el_call()`](https://kaipingyang.github.io/shiny.element/reference/el_call.md)'s
`args`.

## Examples

``` r
if (interactive()) {
  # inside a server function: select the third row, then make it current
  el_call(session, "tbl", "toggleRowSelection", list(el_table_row(3), TRUE))
  el_call(session, "tbl", "setCurrentRow", list(el_table_row(3)))
  # stop one file
  el_call(session, "docs", "abort", list(el_upload_file("big.csv")))
}
```
