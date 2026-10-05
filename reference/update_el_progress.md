# Update Element Plus Progress

Server-side update for
[`el_progress()`](https://kaipingyang.github.io/shiny.element/reference/el_progress.md).

## Usage

``` r
update_el_progress(
  session = shiny::getDefaultReactiveDomain(),
  id,
  percentage = NULL,
  type = NULL,
  status = NULL,
  color = NULL,
  stroke_width = NULL,
  show_text = NULL,
  text_inside = NULL,
  stroke_linecap = NULL,
  format = NULL,
  duration = NULL,
  indeterminate = NULL,
  striped = NULL,
  striped_flow = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Progress ID (un-namespaced).

- percentage:

  New percentage value (`0`–`100`).

- type:

  New progress type.

- status:

  New status theme.

- color:

  New custom colour string.

- stroke_width:

  New stroke width in pixels.

- show_text:

  New show-text flag.

- text_inside:

  New text-inside flag.

- stroke_linecap:

  Shape of the bar's ends: `"round"` (default), `"butt"` or `"square"`.

- format:

  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function `function(percentage)` returning the text shown.

- duration:

  Control the animation duration of indeterminate progress or striped
  flow progress. Element Plus's `duration` (number).

- indeterminate:

  Set indeterminate progress. Element Plus's `indeterminate` (boolean).

- striped:

  Stripe over the progress bar's color. Element Plus's `striped`
  (boolean).

- striped_flow:

  Get the stripes to flow. Element Plus's `striped-flow` (boolean).

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

Every other argument of
[`el_progress()`](https://kaipingyang.github.io/shiny.element/reference/el_progress.md)
that can change once it is drawn is an argument here too, under the same
name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_progress(session, "pct", percentage = 100)
  })
}
```
