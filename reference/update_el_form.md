# Update an Element Plus Form

Update an Element Plus Form

## Usage

``` r
update_el_form(
  session = shiny::getDefaultReactiveDomain(),
  id,
  model = NULL,
  rules = NULL,
  label_width = NULL,
  fields = NULL,
  errors = NULL,
  inline = NULL,
  size = NULL,
  submit_label = NULL,
  reset_label = NULL,
  disabled = NULL,
  status_icon = NULL,
  hide_required_asterisk = NULL,
  validate_on_rule_change = NULL,
  require_asterisk_position = NULL,
  scroll_into_view_options = NULL,
  scroll_to_error = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Form ID (un-namespaced).

- model:

  New field values. Merged into the existing model, so a partial list
  only changes the fields it names.

- rules:

  New validation rules, as a named list of
  [`el_rule()`](https://kaipingyang.github.io/shiny.element/reference/el_rule.md)
  lists keyed by `prop`. Replaces the rule set.

- label_width:

  New label column width.

- fields:

  The form's fields, as
  [`el_form_field()`](https://kaipingyang.github.io/shiny.element/reference/el_form_field.md)s
  – the whole list, in order, so a field can be added, removed or moved:
  Element's "add or delete form items dynamically". A field already in
  the form keeps what was entered; a new one starts from its `value`; a
  removed one leaves the model. Each field's rules come with it.

- errors:

  Error messages from the server, as a named list keyed by `prop` –
  `list(email = "That address is taken")` – shown on the field as
  Element's `error` shows them. `""` clears one.

- inline:

  Lay the fields out in a row.

- size:

  Size: `"large"`, `"default"` or `"small"`; `NULL` follows the form or
  the page.

- submit_label:

  Submit button text. `NULL` renders no button, in which case drive the
  form with
  [`el_form_validate()`](https://kaipingyang.github.io/shiny.element/reference/el_form_validate.md).

- reset_label:

  Reset button text. `NULL` renders no button.

- disabled:

  Whether every control in the form is disabled.

- status_icon:

  Whether to show a validation status icon in each field.

- hide_required_asterisk:

  Whether to hide the asterisk next to required fields' labels.

- validate_on_rule_change:

  Whether changing the rules triggers validation immediately.

- require_asterisk_position:

  Position of asterisk. Element Plus's `require-asterisk-position`
  ('left' \| 'right').

- scroll_into_view_options:

  When validation fails, it scrolls to the first error item based on the
  scrollIntoView option. scrollIntoView. Element Plus's
  `scroll-into-view-options` (ScrollIntoViewOptions / boolean).

- scroll_to_error:

  When validation fails, scroll to the first error form entry. Element
  Plus's `scroll-to-error` (boolean).

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

Every other argument of
[`el_form()`](https://kaipingyang.github.io/shiny.element/reference/el_form.md)
that can change once it is drawn is an argument here too, under the same
name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

## Examples

``` r
if (interactive()) {
  # Prefill the form from the server
  update_el_form(session, "signup", model = list(name = "Ada", age = 36))

  # A check only the server can make
  update_el_form(
    session,
    "signup",
    errors = list(email = "That address is taken")
  )
}
```
