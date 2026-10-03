# Name a table row, an uploaded file or a tree node for a method

Element's table methods take the row object itself –
`toggleRowSelection(row)`, `setCurrentRow(row)`,
`toggleRowExpansion(row)` – and compare it by identity, so a copy sent
from R would match nothing. Likewise the upload's `abort(file)` and
`handleRemove(file)`, and a virtualized tree's `expandNode(node)` and
`collapseNode(node)`. These stand for the object instead, and the page
puts the real one in its place before the method runs.

## Usage

``` r
el_table_row(index)

el_upload_file(name)

el_tree_node(key)
```

## Arguments

- index:

  A row's number, 1-based, as `input$<id>_selected_rows` reports them.

- name:

  A file's name, as it shows in the upload's list.

- key:

  A node's key: the field `node_key` names, or the tree's `props$value`.

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
  # open a node of a virtualized tree
  el_call(session, "files", "expandNode", list(el_tree_node("src")))
}
```
