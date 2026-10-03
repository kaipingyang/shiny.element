# Update Element Plus Infinite Scroll

Server-side update for
[`el_infinite_scroll()`](https://kaipingyang.github.io/shiny.element/reference/el_infinite_scroll.md).
Setting `disabled` is how a feed stops asking once everything has been
sent.

## Usage

``` r
update_el_infinite_scroll(
  session = shiny::getDefaultReactiveDomain(),
  id,
  disabled = NULL,
  delay = NULL,
  distance = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Container ID (un-namespaced).

- disabled, delay, distance:

  New values; `NULL` leaves one unchanged.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$feed_load, {
    if (all_rows_sent()) {
      update_el_infinite_scroll(session, "feed", disabled = TRUE)
    }
  })
}
```
