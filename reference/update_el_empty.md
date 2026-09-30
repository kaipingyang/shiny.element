# Update Element UI Empty

Server-side update for
[`el_empty()`](https://kaipingyang.github.io/shiny.element/reference/el_empty.md).

## Usage

``` r
update_el_empty(session, id, description = NULL, image = NULL)
```

## Arguments

- session:

  Shiny session object.

- id:

  Component ID (un-namespaced).

- description, image:

  New values; `NULL` leaves one unchanged.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$search, {
    update_el_empty(session, "none",
                    description = paste("Nothing matches", input$search))
  })
}
```
