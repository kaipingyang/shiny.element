# Clear an Element Plus Form's validation messages

Leaves the values alone and only removes the error state.

## Usage

``` r
el_form_clear_validate(
  session = shiny::getDefaultReactiveDomain(),
  id,
  props = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Form ID (un-namespaced).

- props:

  Fields to clear. `NULL` clears all of them.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    el_form_clear_validate(session, "signup")
  })
}
```
