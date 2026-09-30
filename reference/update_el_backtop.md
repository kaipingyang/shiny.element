# Update Element UI Back to Top

Server-side update for
[`el_backtop()`](https://kaipingyang.github.io/shiny.element/reference/el_backtop.md).

## Usage

``` r
update_el_backtop(
  session,
  id,
  visibility_height = NULL,
  right = NULL,
  bottom = NULL
)
```

## Arguments

- session:

  Shiny session object.

- id:

  Button ID (un-namespaced).

- visibility_height, right, bottom:

  New values; `NULL` leaves one unchanged.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$compact, {
    update_el_backtop(session, "top", right = 10, bottom = 10)
  })
}
```
