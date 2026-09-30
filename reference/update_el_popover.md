# Update Element UI Popover

Server-side update for
[`el_popover()`](https://kaipingyang.github.io/shiny.element/reference/el_popover.md).
Setting `value` opens or closes the card, which is how
`trigger = "manual"` is driven.

## Usage

``` r
update_el_popover(
  session,
  id,
  title = NULL,
  content = NULL,
  disabled = NULL,
  value = NULL
)
```

## Arguments

- session:

  Shiny session object.

- id:

  Popover ID (un-namespaced).

- title, content, disabled, value:

  New values; `NULL` leaves one unchanged.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$explain, {
    update_el_popover(session, "info", content = summary_text(), value = TRUE)
  })
}
```
