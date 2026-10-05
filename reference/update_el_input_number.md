# Update Element Plus Input Number

Server-side update for
[`el_input_number()`](https://kaipingyang.github.io/shiny.element/reference/el_input_number.md).

## Usage

``` r
update_el_input_number(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  min = NULL,
  max = NULL,
  disabled = NULL,
  label = NULL,
  error = NULL,
  step = NULL,
  step_strictly = NULL,
  precision = NULL,
  size = NULL,
  controls = NULL,
  controls_position = NULL,
  placeholder = NULL,
  name = NULL,
  align = NULL,
  aria_label = NULL,
  disabled_scientific = NULL,
  formatter = NULL,
  inputmode = NULL,
  parser = NULL,
  readonly = NULL,
  tabindex = NULL,
  validate_event = NULL,
  value_on_clear = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Input ID (un-namespaced).

- value:

  New numeric value.

- min:

  New minimum.

- max:

  New maximum.

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

- step:

  Step increment. Default `1`.

- step_strictly:

  Force the value to be a multiple of `step`. Default `FALSE`.

- precision:

  Decimal precision (non-negative integer). `NULL` for auto.

- size:

  Size: `"large"`, `"default"` or `"small"`; `NULL` follows the form or
  the page.

- controls:

  Whether to show the +/- control buttons. Default `TRUE`.

- controls_position:

  Button layout: `""` (default, left-right) or `"right"` (both on the
  right).

- placeholder:

  Placeholder text. `NULL` for none.

- name:

  Native `name` attribute of the inner input.

- align:

  Alignment for the inner input text. Element Plus's `align` ('left' \|
  'center' \| 'right').

- aria_label:

  Same as `aria-label` in native input. Element Plus's `aria-label`
  (string).

- disabled_scientific:

  Disables input of scientific notation (e.g. 'e'). Element Plus's
  `disabled-scientific` (boolean).

- formatter:

  Specifies the format of the value presented in the input. Element
  Plus's `formatter` ((value: string) =\> string).

- inputmode:

  Same as `inputmode` in native input. Element Plus's `inputmode`
  (string).

- parser:

  Specifies the value extracted from the formatted input. Element Plus's
  `parser` ((value: string) =\> string).

- readonly:

  Same as `readonly` in native input. Element Plus's `readonly`
  (boolean).

- tabindex:

  Same as `tabindex` in native input. Element Plus's `tabindex` (string
  / number).

- validate_event:

  Whether to trigger form validation. Element Plus's `validate-event`
  (boolean).

- value_on_clear:

  Value should be set when input box is cleared. Element Plus's
  `value-on-clear` (number / null / 'min' \| 'max').

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

Every other argument of
[`el_input_number()`](https://kaipingyang.github.io/shiny.element/reference/el_input_number.md)
that can change once it is drawn is an argument here too, under the same
name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_input_number(session, "age", value = 42)
  })
}
```
