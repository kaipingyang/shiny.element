# Update Element Plus Cascader Panel

Server-side update for
[`el_cascader_panel()`](https://kaipingyang.github.io/shiny.element/reference/el_cascader_panel.md).

## Usage

``` r
update_el_cascader_panel(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  options = NULL,
  label = NULL,
  error = NULL,
  props = NULL,
  height = NULL,
  item_size = NULL,
  virtual_scroll = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Panel ID (un-namespaced).

- value, options:

  New values; `NULL` leaves one unchanged.

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

- props:

  Element's `props`, as a named list: `multiple`, `checkStrictly`,
  `expandTrigger` (`"click"` or `"hover"`), `lazy`, `lazyLoad`, and the
  field names `value`, `label`, `children`, `disabled`, `leaf`. With
  `lazy = TRUE` and no `lazyLoad` of your own, the server loads each
  column.

- height:

  Menu height for virtual scrolling (px). Element Plus's `height`
  (number).

- item_size:

  Node height for virtual scrolling (px). Element Plus's `item-size`
  (number).

- virtual_scroll:

  Whether to enable virtual scrolling for large data. Element Plus's
  `virtual-scroll` (boolean).

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

Every other argument of
[`el_cascader_panel()`](https://kaipingyang.github.io/shiny.element/reference/el_cascader_panel.md)
that can change once it is drawn is an argument here too, under the same
name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(
    input$reset,
    update_el_cascader_panel(session, "where", value = list())
  )
}
```
