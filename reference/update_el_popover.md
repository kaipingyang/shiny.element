# Update Element Plus Popover

Server-side update for
[`el_popover()`](https://kaipingyang.github.io/shiny.element/reference/el_popover.md).
Setting `visible` opens or closes the card, which then stays as set:
Element Plus's popover is controlled by its `visible` once that is
given.

## Usage

``` r
update_el_popover(
  session = shiny::getDefaultReactiveDomain(),
  id,
  title = NULL,
  content = NULL,
  disabled = NULL,
  visible = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Popover ID (un-namespaced).

- title, content, disabled, visible:

  New values; `NULL` leaves one unchanged.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$explain, {
    update_el_popover(session, "info", content = summary_text(), visible = TRUE)
  })
}
```
