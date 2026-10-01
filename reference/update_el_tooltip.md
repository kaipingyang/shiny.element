# Update Element UI Tooltip

Server-side update for
[`el_tooltip()`](https://kaipingyang.github.io/shiny.element/reference/el_tooltip.md).
Setting `value` only shows or hides the hint when the tooltip was
created with `manual = TRUE`.

## Usage

``` r
update_el_tooltip(
  session = shiny::getDefaultReactiveDomain(),
  id,
  content = NULL,
  disabled = NULL,
  value = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Tooltip ID (un-namespaced).

- content, disabled, value:

  New values; `NULL` leaves one unchanged.

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
