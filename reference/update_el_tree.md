# Update an Element Plus Tree

Update an Element Plus Tree

## Usage

``` r
update_el_tree(
  session = shiny::getDefaultReactiveDomain(),
  id,
  data = NULL,
  expanded = NULL,
  checked = NULL,
  label = NULL,
  error = NULL,
  node_key = NULL,
  show_checkbox = NULL,
  check_strictly = NULL,
  expand_on_click_node = NULL,
  accordion = NULL,
  highlight_current = NULL,
  empty_text = NULL,
  indent = NULL,
  lazy = NULL,
  draggable = NULL,
  auto_expand_parent = NULL,
  check_on_click_node = NULL,
  current_node_key = NULL,
  render_after_expand = NULL,
  load = NULL,
  filter_node_method = NULL,
  render_content = NULL,
  allow_drag = NULL,
  allow_drop = NULL,
  check_on_click_leaf = NULL,
  icon = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Tree ID (un-namespaced).

- data:

  Replacement node data.

- expanded:

  Keys to expand. Expanding is additive: a node already open is not
  closed by leaving it out, because Element's default-expanded-keys only
  ever opens nodes.

- checked:

  Keys to check, replacing the current selection entirely. Pass
  [`list()`](https://rdrr.io/r/base/list.html) to clear it.

- label:

  New label, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html):
  text, or tags or
  [`HTML()`](https://rstudio.github.io/htmltools/reference/HTML.html)
  drawn as markup. Only a component built with a `label` has one to
  change.

- error:

  An error message to show on the component, as Element's `error` does –
  for a check only the server can make, such as whether a name is taken.
  `""` clears it.

- node_key:

  Field holding each node's unique key. The keys are what the server
  sees and what `expanded` and `checked` refer to.

- show_checkbox:

  Show a checkbox beside every node.

- check_strictly:

  Treat a parent's checkbox as independent of its children, rather than
  checking them together.

- expand_on_click_node:

  Expand a node when its label is clicked, as well as its arrow. Set
  `FALSE` to make clicking select rather than expand.

- accordion:

  Keep only one node expanded per level.

- highlight_current:

  Highlight the clicked node.

- empty_text:

  Text shown when `data` is empty.

- indent:

  Horizontal indent between levels, in pixels. Default `16`.

- lazy:

  Whether child nodes are loaded on demand – from the server, unless
  `load` is given. See "Shiny inputs".

- draggable:

  Whether nodes can be dragged.

- auto_expand_parent:

  Whether expanding a node expands its parents. Default `TRUE`.

- check_on_click_node:

  Whether clicking a node's label also checks it.

- current_node_key:

  Key of the node that starts out highlighted.

- render_after_expand:

  Whether child nodes are rendered only once expanded. Default `TRUE`.

- load:

  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function loading child nodes in the browser instead of from the
  server. Needs `lazy = TRUE`.

- filter_node_method:

  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function deciding whether a node survives filtering. By default a node
  is kept when its label contains the text, ignoring case, so
  `call_el(session, id, "filter", list(text))` works as it stands.

- render_content:

  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  render function for a node's content.

- allow_drag:

  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function deciding whether a node may be dragged.

- allow_drop:

  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function deciding whether a node may be dropped somewhere.

- check_on_click_leaf:

  Whether to check or uncheck node when clicking on leaf node (last
  children). Element Plus's `check-on-click-leaf` (boolean).

- icon:

  Custom tree node icon component. Element Plus's `icon` (string /
  Component). An icon's name, such as `"Search"`.

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

Every other argument of
[`el_tree()`](https://kaipingyang.github.io/shiny.element/reference/el_tree.md)
that can change once it is drawn is an argument here too, under the same
name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_tree(session, "picker", checked = c("apple"))
  })
}
```
