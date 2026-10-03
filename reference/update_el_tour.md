# Update Element Plus Tour

Open or close an
[`el_tour()`](https://kaipingyang.github.io/shiny.element/reference/el_tour.md),
or move it to a step.

## Usage

``` r
update_el_tour(
  session = shiny::getDefaultReactiveDomain(),
  id,
  open = NULL,
  current = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Tour ID (un-namespaced).

- open, current:

  New values; `NULL` leaves one unchanged.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$help, update_el_tour(session, "intro", open = TRUE, current = 0))
}
```
