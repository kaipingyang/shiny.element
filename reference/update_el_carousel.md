# Update an Element UI Carousel

Update an Element UI Carousel

## Usage

``` r
update_el_carousel(
  session = shiny::getDefaultReactiveDomain(),
  id,
  active = NULL,
  autoplay = NULL,
  interval = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Carousel ID (un-namespaced).

- active:

  Index of the slide to show, 0-based.

- autoplay:

  Start or stop cycling.

- interval:

  New interval in milliseconds.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_carousel(session, "banner", active = 2)
  })
}
```
