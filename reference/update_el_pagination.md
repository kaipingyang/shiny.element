# Update Element UI Pagination

Server-side update for
[`el_pagination()`](https://kaipingyang.github.io/shiny.element/reference/el_pagination.md).

## Usage

``` r
update_el_pagination(
  session,
  id,
  total = NULL,
  current_page = NULL,
  page_size = NULL,
  disabled = NULL
)
```

## Arguments

- session:

  Shiny session object.

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
