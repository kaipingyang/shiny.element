# Reset an Element UI Form

Restores every field to the `value` it was declared with and clears the
validation state. Note this is Element UI's `resetFields()`: it restores
the *initial* values, not empty ones, so a field declared with
`value = 18` resets to 18.

## Usage

``` r
el_form_reset(session = shiny::getDefaultReactiveDomain(), id)
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
    el_form_reset(session, "signup")
  })
}
```
