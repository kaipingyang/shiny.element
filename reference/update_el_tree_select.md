# Update Element Plus Tree Select

Update Element Plus Tree Select

## Usage

``` r
update_el_tree_select(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  data = NULL,
  disabled = NULL,
  label = NULL,
  error = NULL,
  multiple = NULL,
  show_checkbox = NULL,
  check_strictly = NULL,
  check_on_click_node = NULL,
  filterable = NULL,
  clearable = NULL,
  placeholder = NULL,
  node_key = NULL,
  props = NULL,
  render_after_expand = NULL,
  collapse_tags = NULL,
  collapse_tags_tooltip = NULL,
  size = NULL,
  cache_data = NULL,
  lazy = NULL,
  load = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateSelectInput()`](https://rdrr.io/pkg/shiny/man/updateSelectInput.html).

- id:

  Component ID (un-namespaced).

- value, data, disabled:

  New values; `NULL` leaves one unchanged.

- label:

  New label, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- error:

  An error message to show on the component; `""` clears it.

- multiple:

  Whether several nodes can be selected.

- show_checkbox:

  Whether nodes have checkboxes.

- check_strictly:

  Whether any node can be selected, not only leaves.

- check_on_click_node:

  Whether clicking a node checks it, with `show_checkbox`.

- filterable:

  Whether the options can be searched by typing.

- clearable:

  Whether the selection can be cleared.

- placeholder:

  Placeholder text.

- node_key:

  The field that identifies a node. Default `"value"`.

- props:

  Where the tree's fields are:
  `list(label =, children =, disabled =, isLeaf =)`.

- render_after_expand:

  Whether a node's children are drawn only once it is expanded. Default
  `TRUE`.

- collapse_tags, collapse_tags_tooltip:

  With `multiple`, whether the selection is shown as one tag and a
  count, with the rest in a tooltip.

- size:

  `"large"`, `"default"` or `"small"`.

- cache_data:

  The nodes behind a value not yet loaded, for a lazy tree.

- lazy:

  Whether child nodes are loaded on demand – from the server, which
  answers `input$<id>_load` with
  [`el_load_children()`](https://kaipingyang.github.io/shiny.element/reference/el_load_children.md),
  unless `load` is given.

- load:

  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function loading child nodes in the browser instead of from the
  server. Needs `lazy = TRUE`.

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

Every other argument of
[`el_tree_select()`](https://kaipingyang.github.io/shiny.element/reference/el_tree_select.md)
that can change once it is drawn is an argument here too, under the same
name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(
    input$reset,
    update_el_tree_select(session, "dept", value = "ops")
  )
}
```
