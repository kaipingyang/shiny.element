# Update Element Plus Checkbox Group

Server-side update for
[`el_checkbox_group()`](https://kaipingyang.github.io/shiny.element/reference/el_checkbox_group.md).
Pass only the fields to change; `NULL` fields are excluded from the
update message.

## Usage

``` r
update_el_checkbox_group(
  session = shiny::getDefaultReactiveDomain(),
  id,
  selected = NULL,
  choices = NULL,
  disabled = NULL,
  min = NULL,
  max = NULL,
  value = NULL,
  options = NULL,
  label = NULL,
  error = NULL,
  size = NULL,
  fill = NULL,
  text_color = NULL,
  aria_label = NULL,
  props = NULL,
  tag = NULL,
  type = NULL,
  validate_event = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Checkbox group ID (un-namespaced).

- selected, value:

  New character vector of checked values. `selected` is Shiny's name,
  `value` Element's; give either.

- choices, options:

  New choices, as for
  [`el_checkbox_group()`](https://kaipingyang.github.io/shiny.element/reference/el_checkbox_group.md).
  `choices` is Shiny's name, `options` Element's; give either.

- disabled:

  New disabled state.

- min:

  New minimum checked count.

- max:

  New maximum checked count.

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

  `"large"`, `"default"` or `"small"`.

- fill:

  Border and background colour when `button = TRUE` and checked.

- text_color:

  Text colour when `button = TRUE` and checked.

- aria_label:

  Native `aria-label` attribute. Element Plus's `aria-label` (string).

- props:

  Configuration options. Element Plus's `props`
  (`{ value?: string, label?: string, disabled?: string}`).

- tag:

  Element tag of the checkbox group. Element Plus's `tag` (string).

- type:

  Component type to render options (e.g. `'button'`). Element Plus's
  `type` ('checkbox' \| 'button').

- validate_event:

  Whether to trigger form validation. Element Plus's `validate-event`
  (boolean).

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

Every other argument of
[`el_checkbox_group()`](https://kaipingyang.github.io/shiny.element/reference/el_checkbox_group.md)
that can change once it is drawn is an argument here too, under the same
name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_checkbox_group(session, "langs", selected = c("r", "py"))
  })
}
```
