# Update Element Plus Autocomplete

Server-side update for
[`el_autocomplete()`](https://kaipingyang.github.io/shiny.element/reference/el_autocomplete.md).

## Usage

``` r
update_el_autocomplete(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  suggestions = NULL,
  placeholder = NULL,
  disabled = NULL,
  label = NULL,
  error = NULL,
  clearable = NULL,
  value_key = NULL,
  debounce = NULL,
  placement = NULL,
  trigger_on_focus = NULL,
  select_when_unmatched = NULL,
  highlight_first_item = NULL,
  hide_loading = NULL,
  icon = NULL,
  prefix_icon = NULL,
  suffix_icon = NULL,
  name = NULL,
  popper_class = NULL,
  append_to = NULL,
  aria_label = NULL,
  fit_input_width = NULL,
  loop_navigation = NULL,
  popper_options = NULL,
  popper_style = NULL,
  show_arrow = NULL,
  teleported = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Input ID (un-namespaced).

- value, suggestions, placeholder, disabled:

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

- clearable:

  Whether to show a clear button.

- value_key:

  Field of a suggestion object to display. Default `"value"`.

- debounce:

  Debounce while typing, in milliseconds. Default `300`.

- placement:

  Where the list appears: `"bottom-start"` (default), `"bottom-end"`,
  `"top-start"`, `"top-end"`.

- trigger_on_focus:

  Whether to suggest as soon as the input is focused. Default `TRUE`.

- select_when_unmatched:

  Whether to fire `select` when nothing matched.

- highlight_first_item:

  Whether to preselect the first suggestion.

- hide_loading:

  Whether to hide the loading spinner.

- icon, prefix_icon, suffix_icon:

  Icon classes.

- name:

  Native `name` attribute.

- popper_class:

  Extra class name for the suggestion list.

- append_to:

  Which select dropdown appends to. Element Plus's `append-to`
  (CSSSelector / HTMLElement).

- aria_label:

  Native `aria-label` attribute. Element Plus's `aria-label` (string).

- fit_input_width:

  Whether the width of the dropdown is the same as the input. Element
  Plus's `fit-input-width` (boolean).

- loop_navigation:

  Whether keyboard navigation loops from end to start. Element Plus's
  `loop-navigation` (boolean).

- popper_options:

  Popper.js parameters. Element Plus's `popper-options` (object).

- popper_style:

  Custom style for autocomplete's dropdown. Element Plus's
  `popper-style` (string / object).

- show_arrow:

  Whether the dropdown has an arrow. Element Plus's `show-arrow`
  (boolean).

- teleported:

  Whether select dropdown is teleported to the body. Element Plus's
  `teleported` (boolean).

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

Every other argument of
[`el_autocomplete()`](https://kaipingyang.github.io/shiny.element/reference/el_autocomplete.md)
that can change once it is drawn is an argument here too, under the same
name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$country, {
    update_el_autocomplete(
      session,
      "city",
      suggestions = cities_of(input$country)
    )
  })
}
```
