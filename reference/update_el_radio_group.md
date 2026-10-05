# Update Element Plus Radio Group

Server-side update for
[`el_radio_group()`](https://kaipingyang.github.io/shiny.element/reference/el_radio_group.md).
Sends a custom message to update reactive fields on the underlying Vue
instance.

## Usage

``` r
update_el_radio_group(
  session = shiny::getDefaultReactiveDomain(),
  id,
  selected = NULL,
  choices = NULL,
  disabled = NULL,
  value = NULL,
  options = NULL,
  label = NULL,
  error = NULL,
  size = NULL,
  fill = NULL,
  text_color = NULL,
  aria_label = NULL,
  props = NULL,
  type = NULL,
  validate_event = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Radio group input ID (un-namespaced).

- selected, value:

  New selected value. `selected` is Shiny's name, `value` Element's;
  give either.

- choices, options:

  New choices, as for
  [`el_radio_group()`](https://kaipingyang.github.io/shiny.element/reference/el_radio_group.md).
  `choices` is Shiny's name, `options` Element's; give either.

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

- size:

  Size: `"large"`, `"default"` or `"small"`; `NULL` follows the form or
  the page. Only affects button-style radios (`button = TRUE`).

- fill:

  Border and background colour of a checked radio button.

- text_color:

  Text colour of a checked radio button.

- aria_label:

  Same as `aria-label` in RadioGroup. Element Plus's `aria-label`
  (string).

- props:

  Configuration options. Element Plus's `props`
  (`{ value?: string, label?: string, disabled?: string}`).

- type:

  Component type to render options (e.g. `'button'`). Element Plus's
  `type` ('radio' \| 'button').

- validate_event:

  Whether to trigger form validation. Element Plus's `validate-event`
  (boolean).

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

Every other argument of
[`el_radio_group()`](https://kaipingyang.github.io/shiny.element/reference/el_radio_group.md)
that can change once it is drawn is an argument here too, under the same
name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_radio_group(session, "plan", selected = "pro")
  })
}
```
