# Update Element Plus Back to Top

Server-side update for
[`el_backtop()`](https://kaipingyang.github.io/shiny.element/reference/el_backtop.md).

## Usage

``` r
update_el_backtop(
  session = shiny::getDefaultReactiveDomain(),
  id,
  visibility_height = NULL,
  right = NULL,
  bottom = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

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
