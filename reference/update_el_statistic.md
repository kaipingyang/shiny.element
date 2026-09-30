# Update Element UI Statistic

Server-side update for
[`el_statistic()`](https://kaipingyang.github.io/shiny.element/reference/el_statistic.md).

## Usage

``` r
update_el_statistic(
  session,
  id,
  value = NULL,
  title = NULL,
  prefix = NULL,
  suffix = NULL
)
```

## Arguments

- session:

  Shiny session object.

- id:

  Component ID (un-namespaced).

- value, title, prefix, suffix:

  New values; `NULL` leaves one unchanged.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observe({
    invalidateLater(5000)
    update_el_statistic(session, "users", value = count_active_users())
  })
}
```
