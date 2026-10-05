# Update Element Plus Segmented

Server-side update for
[`el_segmented()`](https://kaipingyang.github.io/shiny.element/reference/el_segmented.md).

## Usage

``` r
update_el_segmented(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  disabled = NULL,
  label = NULL,
  error = NULL,
  size = NULL,
  block = NULL,
  validate_event = NULL,
  aria_label = NULL,
  direction = NULL,
  props = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Component ID (un-namespaced).

- value, disabled:

  New values; `NULL` leaves one unchanged.

- label:

  New label, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html):
  text, or tags or
  [`HTML()`](https://rstudio.github.io/htmltools/reference/HTML.html)
  drawn as markup. Only a component built with a `label` has one to
  change.

- error:

  An error message to show on the component; `""` clears it.

- size:

  Size of component. Element Plus's `size` (” \| 'large' \| 'default' \|
  'small').

- block:

  Fit width of parent content. Element Plus's `block` (boolean).

- validate_event:

  Whether to trigger form validation. Element Plus's `validate-event`
  (boolean).

- aria_label:

  Native `aria-label` attribute. Element Plus's `aria-label` (string).

- direction:

  Display direction. Element Plus's `direction` ('horizontal' \|
  'vertical').

- props:

  Which field of an option holds what, when the options are records
  named otherwise: `list(value =, label =, disabled =)`, Element Plus's
  `props`.

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

Every other argument of
[`el_segmented()`](https://kaipingyang.github.io/shiny.element/reference/el_segmented.md)
that can change once it is drawn is an argument here too, under the same
name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$reset, update_el_segmented(session, "x", value = NULL))
}
```
