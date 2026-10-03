# Update Element Plus Dropdown

Server-side update for
[`el_dropdown()`](https://kaipingyang.github.io/shiny.element/reference/el_dropdown.md).

## Usage

``` r
update_el_dropdown(
  session = shiny::getDefaultReactiveDomain(),
  id,
  disabled = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Dropdown ID (un-namespaced).

- disabled:

  New disabled state.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_dropdown(session, "actions", disabled = TRUE)
  })
}
```
