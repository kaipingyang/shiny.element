# Update an Element UI Tree

Update an Element UI Tree

## Usage

``` r
update_el_tree(
  session = shiny::getDefaultReactiveDomain(),
  id,
  data = NULL,
  expanded = NULL,
  checked = NULL,
  label = NULL,
  error = NULL
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

  New label text, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).
  Only a component built with a `label` has one to change.

- error:

  An error message to show on the component, as Element's `error` does –
  for a check only the server can make, such as whether a name is taken.
  `""` clears it.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_tree(session, "picker", checked = c("apple"))
  })
}
```
