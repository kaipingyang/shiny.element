# Validate an Element Plus Form from the server

Runs the form's rules and reports the outcome the same way a submit
does, so the same `observeEvent` handles both. Use it when the form has
no submit button of its own (`submit_label = NULL`).

## Usage

``` r
el_form_validate(session = shiny::getDefaultReactiveDomain(), id)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Form ID (un-namespaced).

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    el_form_validate(session, "signup")
  })
}
```
