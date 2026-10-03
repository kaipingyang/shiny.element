# Update Element Plus Badge

Server-side update for an
[`el_badge()`](https://kaipingyang.github.io/shiny.element/reference/el_badge.md)
given an `id`.

## Usage

``` r
update_el_badge(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  max = NULL,
  is_dot = NULL,
  hidden = NULL,
  type = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Badge ID (un-namespaced).

- value, max, is_dot, hidden, type:

  New values; `NULL` leaves one unchanged.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observe(update_el_badge(session, "unread", value = unread_count(),
                          hidden = unread_count() == 0))
}
```
