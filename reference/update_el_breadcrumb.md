# Update Element UI Breadcrumb

Server-side update for
[`el_breadcrumb()`](https://kaipingyang.github.io/shiny.element/reference/el_breadcrumb.md).

## Usage

``` r
update_el_breadcrumb(session, id, items = NULL, separator = NULL)
```

## Arguments

- session:

  Shiny session object.

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
