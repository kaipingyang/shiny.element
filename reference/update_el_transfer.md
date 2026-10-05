# Update Element Plus Transfer

Server-side update for
[`el_transfer()`](https://kaipingyang.github.io/shiny.element/reference/el_transfer.md).

## Usage

``` r
update_el_transfer(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  data = NULL,
  titles = NULL,
  filterable = NULL,
  label = NULL,
  error = NULL,
  button_texts = NULL,
  filter_placeholder = NULL,
  filter_method = NULL,
  target_order = NULL,
  format = NULL,
  props = NULL,
  left_default_checked = NULL,
  right_default_checked = NULL,
  render_content = NULL,
  item_size = NULL,
  validate_event = NULL,
  virtual_scroll = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Transfer ID (un-namespaced).

- value, data, titles, filterable:

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

- button_texts:

  Labels of the two buttons, as a length-2 character vector. Default is
  arrows only.

- filter_placeholder:

  Placeholder of the search boxes.

- filter_method:

  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function `function(query, item)` returning whether an item survives
  the search.

- target_order:

  Order of the right-hand panel: `"original"` (default), `"push"` or
  `"unshift"`.

- format:

  Counts shown in each heading, as `list(noChecked =, hasChecked =)`,
  for example
  `list(noChecked = "${total}", hasChecked = "${checked}/${total}")`.

- props:

  Field names when `data` uses other ones, as
  `list(key =, label =, disabled =)`.

- left_default_checked, right_default_checked:

  Keys ticked at the start.

- render_content:

  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  render function for an item.

- item_size:

  Item height for virtual scrolling. Element Plus's `item-size`
  (number).

- validate_event:

  Whether to trigger form validation. Element Plus's `validate-event`
  (boolean).

- virtual_scroll:

  Whether to enable virtual scrolling. Element Plus's `virtual-scroll`
  (boolean).

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

Every other argument of
[`el_transfer()`](https://kaipingyang.github.io/shiny.element/reference/el_transfer.md)
that can change once it is drawn is an argument here too, under the same
name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$reset, {
    update_el_transfer(session, "cols", value = list())
  })
}
```
