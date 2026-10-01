# Update Element UI Transfer

Server-side update for
[`el_transfer()`](https://kaipingyang.github.io/shiny.element/reference/el_transfer.md).

## Usage

``` r
update_el_transfer(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  data = NULL,
  titles = NULL,
  filterable = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Transfer ID (un-namespaced).

- value, data, titles, filterable:

  New values; `NULL` leaves one unchanged.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$reset, {
    update_el_transfer(session, "cols", value = list())
  })
}
```
