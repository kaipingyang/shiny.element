# Update Element Plus Checkbox

Server-side update for
[`el_checkbox()`](https://kaipingyang.github.io/shiny.element/reference/el_checkbox.md).

## Usage

``` r
update_el_checkbox(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  label = NULL,
  indeterminate = NULL,
  disabled = NULL,
  border = NULL,
  size = NULL,
  true_label = NULL,
  false_label = NULL,
  name = NULL,
  checked = NULL,
  aria_controls = NULL,
  aria_label = NULL,
  controls = NULL,
  false_value = NULL,
  tabindex = NULL,
  true_value = NULL,
  validate_event = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateCheckboxInput()`](https://rdrr.io/pkg/shiny/man/updateCheckboxInput.html).

- id:

  Checkbox ID (un-namespaced).

- value:

  Whether the box is ticked.

- label:

  The box's new text.

- indeterminate, disabled:

  New states; `NULL` leaves one unchanged.

- border:

  Draw the box with a border.

- size:

  Size: `"large"`, `"default"` or `"small"`; `NULL` follows the form or
  the page.

- true_label, false_label:

  Values to report instead of `TRUE` and `FALSE`.

- name:

  Native `name` attribute.

- checked:

  Element's `checked`: tick the box when it is created, whatever `value`
  says. The same as `value = TRUE`, kept for code written from Element's
  documentation.

- aria_controls:

  Same as aria-controls, takes effect when `indeterminate` is `true`.
  Element Plus's `aria-controls` (string).

- aria_label:

  Native `aria-label` attribute. Element Plus's `aria-label` (string).

- controls:

  Same as aria-controls, takes effect when `indeterminate` is `true`.
  Element Plus's `controls` (string).

- false_value:

  Value of the Checkbox if it's not checked. Element Plus's
  `false-value` (string / number).

- tabindex:

  Input tabindex. Element Plus's `tabindex` (string / number).

- true_value:

  Value of the Checkbox if it's checked. Element Plus's `true-value`
  (string / number).

- validate_event:

  Whether to trigger form validation. Element Plus's `validate-event`
  (boolean).

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

Every other argument of
[`el_checkbox()`](https://kaipingyang.github.io/shiny.element/reference/el_checkbox.md)
that can change once it is drawn is an argument here too, under the same
name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

## Examples

``` r
if (interactive()) {
  # inside a server function: the "check all" box follows the group
  observeEvent(
    input$cities,
    {
      n <- length(input$cities)
      update_el_checkbox(
        session,
        "all",
        value = n == 4,
        indeterminate = n > 0 && n < 4
      )
    },
    ignoreNULL = FALSE
  )
}
```
