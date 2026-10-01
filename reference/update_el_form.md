# Update an Element UI Form

Update an Element UI Form

## Usage

``` r
update_el_form(
  session = shiny::getDefaultReactiveDomain(),
  id,
  model = NULL,
  rules = NULL,
  label_width = NULL
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

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # Prefill the form from the server
  update_el_form(session, "signup", model = list(name = "Ada", age = 36))
}
```
