# Update Element Plus Skeleton

Server-side update for
[`el_skeleton()`](https://kaipingyang.github.io/shiny.element/reference/el_skeleton.md).
`loading = FALSE` swaps the placeholder for the real content.

## Usage

``` r
update_el_skeleton(
  session = shiny::getDefaultReactiveDomain(),
  id,
  loading = NULL,
  rows = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Component ID (un-namespaced).

- loading, rows:

  New values; `NULL` leaves one unchanged.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(result(), {
    update_el_skeleton(session, "report", loading = FALSE)
  })
}
```
