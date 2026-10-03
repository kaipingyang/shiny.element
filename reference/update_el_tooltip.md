# Update Element Plus Tooltip

Server-side update for
[`el_tooltip()`](https://kaipingyang.github.io/shiny.element/reference/el_tooltip.md).
Setting `visible` shows or hides the hint, which then stays as set:
Element Plus's tooltip is controlled by its `visible` once that is
given.

## Usage

``` r
update_el_tooltip(
  session = shiny::getDefaultReactiveDomain(),
  id,
  content = NULL,
  disabled = NULL,
  visible = NULL,
  virtual_ref = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Tooltip ID (un-namespaced).

- content, disabled, visible:

  New values; `NULL` leaves one unchanged.

- virtual_ref:

  A new CSS selector for the element the tooltip is attached to, as in
  [`el_tooltip()`](https://kaipingyang.github.io/shiny.element/reference/el_tooltip.md).

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$explain, {
    update_el_tooltip(session, "hint", content = why_disabled())
  })
}
```
