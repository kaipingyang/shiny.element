# Update Element Plus Input OTP

Server-side update for
[`el_input_otp()`](https://kaipingyang.github.io/shiny.element/reference/el_input_otp.md).

## Usage

``` r
update_el_input_otp(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  disabled = NULL,
  label = NULL,
  error = NULL,
  length = NULL,
  validator = NULL,
  inputmode = NULL,
  type = NULL,
  size = NULL,
  mask = NULL,
  separator = NULL,
  validate_event = NULL,
  readonly = NULL,
  aria_label = NULL
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

- length:

  The OTP fields length. Element Plus's `length` (number).

- validator:

  Custom validator function. Element Plus's `validator` ((char: string,
  index: number) =\> boolean). Give it as
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md).

- inputmode:

  Native `inputmode` attribute. Element Plus's `inputmode` (string).

- type:

  The type of the OTP fields. Element Plus's `type` ('outlined' \|
  'filled' \| 'underlined').

- size:

  The size of the OTP fields. Element Plus's `size` ('large' \|
  'default' \| 'small').

- mask:

  Whether to enable password mode. Element Plus's `mask` (boolean).

- separator:

  The separator between OTP fields. Element Plus's `separator` (string /
  VNode / () =\> string \| VNode). Give it as
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md).

- validate_event:

  Whether to trigger form validation. Element Plus's `validate-event`
  (boolean).

- readonly:

  Same as `readonly` in native input. Element Plus's `readonly`
  (boolean).

- aria_label:

  Native `aria-label` attribute. Element Plus's `aria-label` (string).

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

Every other argument of
[`el_input_otp()`](https://kaipingyang.github.io/shiny.element/reference/el_input_otp.md)
that can change once it is drawn is an argument here too, under the same
name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$reset, update_el_input_otp(session, "x", value = NULL))
}
```
