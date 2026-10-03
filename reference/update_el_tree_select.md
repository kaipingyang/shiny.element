# Update Element Plus Tree Select

Update Element Plus Tree Select

## Usage

``` r
update_el_tree_select(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  data = NULL,
  disabled = NULL,
  label = NULL,
  error = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateSelectInput()`](https://rdrr.io/pkg/shiny/man/updateSelectInput.html).

- id:

  Component ID (un-namespaced).

- value, data, disabled:

  New values; `NULL` leaves one unchanged.

- label:

  New label, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- error:

  An error message to show on the component; `""` clears it.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(
    input$reset,
    update_el_tree_select(session, "dept", value = "ops")
  )
}
```
