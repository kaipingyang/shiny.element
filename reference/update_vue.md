# Set fields of a Vue component from the server

The Vue layer's `update*Input()`: assigns fields of a component's state
– its `data`, or what its `setup()` returned, or a
[`vue_store()`](https://kaipingyang.github.io/shiny.element/reference/vue_store.md)'s
– and the component, and every template showing them, follow. As with
Shiny's updaters, the component's value is reported back to `input$<id>`
afterwards, and the update is sent with the flush, after the outputs
([`flush_vue()`](https://kaipingyang.github.io/shiny.element/reference/flush_vue.md)).

## Usage

``` r
update_vue(
  session = shiny::getDefaultReactiveDomain(),
  id,
  ...,
  value = NULL,
  insert = NULL,
  replace = NULL,
  delete = NULL,
  at = NULL,
  key = NULL,
  set = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  The component's id (un-namespaced).

- ...:

  Fields to set, `<field> = <value>`. A function is
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md).

- value:

  The component's value: sets whichever field its `input` names.

- insert, replace, delete:

  Rows to insert, rows to put in place of others, or the rows to delete
  – each `list(<field> = ...)`, one of them per call.

- at:

  Positions, counting from 1: where `insert` goes, which rows `replace`
  and `delete` change.

- key:

  A field the rows are found by, instead of positions.

- set:

  Values at paths, `list("<path>" = value)`.

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

A field given in `...` is replaced whole. A long list, or a deep object,
can be changed in place instead, sending only what changes:

- `insert`, `replace`, `delete`: rows of a list field – one field per
  call, `list(items = rows)`. Rows are a data.frame or a list of rows.
  `at` says where, counting from 1: the position `insert` goes before
  (the end when `NULL`), the positions `replace` and `delete` change.
  With `key`, rows are found by that field's value instead: `replace`
  puts each row in place of the one with its key (or at the end), and
  `delete = list(items = c("a", "c"))` takes away the rows with those
  keys.

- `set`: values at paths,
  `list("items[3].done" = TRUE, "user.name" = "Ann")` – fields, then
  list positions counting from 1 and names.

## See also

[`vue_app()`](https://kaipingyang.github.io/shiny.element/reference/vue_app.md),
[`call_vue()`](https://kaipingyang.github.io/shiny.element/reference/call_vue.md),
[`flush_vue()`](https://kaipingyang.github.io/shiny.element/reference/flush_vue.md).

## Examples

``` r
if (interactive()) {
  # inside a server function
  update_vue(id = "counter", value = 0)
  update_vue(id = "cart", note = "Free delivery today")
  # a list changed in place: one row added, one ticked
  update_vue(id = "todo", insert = list(items = list(text = "Call Ann")))
  update_vue(id = "todo", set = list("items[2].done" = TRUE))
  update_vue(id = "todo", delete = list(items = "t3"), key = "id")
}
```
