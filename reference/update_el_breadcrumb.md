# Update Element Plus Breadcrumb

Server-side update for
[`el_breadcrumb()`](https://kaipingyang.github.io/shiny.element/reference/el_breadcrumb.md).

## Usage

``` r
update_el_breadcrumb(
  session = shiny::getDefaultReactiveDomain(),
  id,
  items = NULL,
  separator = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Breadcrumb ID (un-namespaced).

- items, separator:

  New values; `NULL` leaves one unchanged.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$open_detail, {
    update_el_breadcrumb(session, "trail", items = list(
      list(label = "Home"), list(label = "Detail")
    ))
  })
}
```
