# Update an Element UI Menu

Update an Element UI Menu

## Usage

``` r
update_el_menu(
  session = shiny::getDefaultReactiveDomain(),
  id,
  active = NULL,
  collapse = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Menu ID (un-namespaced).

- active:

  Index of the item to select.

- collapse:

  New collapsed state.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_menu(session, "nav", active = "data")
  })
}
```
