# Update an Element UI Form

Update an Element UI Form

## Usage

``` r
update_el_form(
  session = shiny::getDefaultReactiveDomain(),
  id,
  model = NULL,
  rules = NULL,
  label_width = NULL,
  fields = NULL,
  errors = NULL
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

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # Prefill the form from the server
  update_el_form(session, "signup", model = list(name = "Ada", age = 36))

  # A check only the server can make
  update_el_form(session, "signup", errors = list(email = "That address is taken"))
}
```
