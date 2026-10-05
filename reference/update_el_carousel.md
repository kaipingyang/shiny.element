# Update an Element Plus Carousel

Update an Element Plus Carousel

## Usage

``` r
update_el_carousel(
  session = shiny::getDefaultReactiveDomain(),
  id,
  active = NULL,
  autoplay = NULL,
  interval = NULL,
  height = NULL,
  initial_index = NULL,
  trigger = NULL,
  indicator_position = NULL,
  arrow = NULL,
  loop = NULL,
  direction = NULL
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

- height:

  Slide height, e.g. `"300px"`.

- initial_index:

  Index of the slide shown first, 0-based.

- trigger:

  What switches slides when an indicator is used: `"hover"` (default) or
  `"click"`.

- indicator_position:

  `"outside"`, `"none"`, or NULL for inside.

- arrow:

  When to show the arrows: `"hover"` (default), `"always"` or `"never"`.

- loop:

  Return to the first slide after the last.

- direction:

  `"horizontal"` (default) or `"vertical"`.

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

Every other argument of
[`el_carousel()`](https://kaipingyang.github.io/shiny.element/reference/el_carousel.md)
that can change once it is drawn is an argument here too, under the same
name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_carousel(session, "banner", active = 2)
  })
}
```
