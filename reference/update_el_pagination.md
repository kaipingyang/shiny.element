# Update Element Plus Pagination

Server-side update for
[`el_pagination()`](https://kaipingyang.github.io/shiny.element/reference/el_pagination.md).

## Usage

``` r
update_el_pagination(
  session = shiny::getDefaultReactiveDomain(),
  id,
  total = NULL,
  current_page = NULL,
  page_size = NULL,
  disabled = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Pagination ID (un-namespaced).

- total:

  New total item count.

- current_page:

  New current page number.

- page_size:

  New page size.

- disabled:

  New disabled state.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_pagination(session, "pager", current_page = 2)
  })
}
```
