# Update Element Plus Slider

Server-side update for
[`el_slider()`](https://kaipingyang.github.io/shiny.element/reference/el_slider.md).
Supports updating value, range bounds, step size, and disabled state.

## Usage

``` r
update_el_slider(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  min = NULL,
  max = NULL,
  step = NULL,
  disabled = NULL,
  label = NULL,
  error = NULL,
  show_input = NULL,
  show_stops = NULL,
  show_tooltip = NULL,
  vertical = NULL,
  height = NULL,
  marks = NULL,
  input_size = NULL,
  show_input_controls = NULL,
  tooltip_class = NULL,
  format_tooltip = NULL,
  aria_label = NULL,
  format_value_text = NULL,
  persistent = NULL,
  placement = NULL,
  range_end_label = NULL,
  range_start_label = NULL,
  size = NULL,
  validate_event = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Slider ID (un-namespaced).

- value:

  New slider value. A single number or two-element vector for range
  mode.

- min:

  New minimum value.

- max:

  New maximum value.

- step:

  New step size.

- disabled:

  New disabled state.

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

- show_input:

  Whether to display a numeric input box beside the slider (non-range
  mode only). Default `FALSE`.

- show_stops:

  Whether to display stop markers at each step. Default `FALSE`.

- show_tooltip:

  Whether to display the tooltip when dragging. Default `TRUE`.

- vertical:

  Whether to display in vertical orientation. Default `FALSE`.

- height:

  Height of the slider in vertical mode (e.g., `"200px"`). Defaults to
  `"200px"` when `vertical = TRUE` and not explicitly provided.

- marks:

  Named list of mark labels, e.g., `list("0" = "0km", "50" = "50km")`.
  Default `NULL` (no marks).

- input_size:

  Size of the companion input when `show_input = TRUE`.

- show_input_controls:

  Whether the companion input shows its spinner buttons.

- tooltip_class:

  Extra class name for the value tooltip.

- format_tooltip:

  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function formatting the value shown in the tooltip.

- aria_label:

  Native `aria-label` attribute. Element Plus's `aria-label` (string).

- format_value_text:

  Format to display the `aria-valuenow` attribute for screen readers.
  Element Plus's `format-value-text` ((value: number) =\> string).

- persistent:

  When slider tooltip inactive and `persistent` is `false` , tooltip
  will be destroyed. `persistent` always be `false` when `show-tooltip `
  is `false`. Element Plus's `persistent` (boolean).

- placement:

  Position of Tooltip. Element Plus's `placement` (enum).

- range_end_label:

  When `range` is true, screen reader label for the end of the range.
  Element Plus's `range-end-label` (string).

- range_start_label:

  When `range` is true, screen reader label for the start of the range.
  Element Plus's `range-start-label` (string).

- size:

  Size of the slider wrapper, will not work in vertical mode. Element
  Plus's `size` (” \| 'large' \| 'default' \| 'small').

- validate_event:

  Whether to trigger form validation. Element Plus's `validate-event`
  (boolean).

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

Every other argument of
[`el_slider()`](https://kaipingyang.github.io/shiny.element/reference/el_slider.md)
that can change once it is drawn is an argument here too, under the same
name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_slider(session, "score", value = 80)
  })
}
```
