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
  current = NULL,
  show_arrow = NULL,
  placement = NULL,
  content_style = NULL,
  mask = NULL,
  gap = NULL,
  type = NULL,
  scroll_into_view_options = NULL,
  z_index = NULL,
  show_close = NULL,
  close_icon = NULL,
  close_on_press_escape = NULL,
  target_area_clickable = NULL,
  append_to = NULL
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

- show_arrow, placement, content_style, mask, gap, type,
  scroll_into_view_options, z_index, show_close, close_icon,
  close_on_press_escape, target_area_clickable, append_to:

  Element Plus's tour props of those names: the defaults for every step.

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

Every other argument of
[`el_tour()`](https://kaipingyang.github.io/shiny.element/reference/el_tour.md)
that can change once it is drawn is an argument here too, under the same
name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(
    input$help,
    update_el_tour(session, "intro", open = TRUE, current = 0)
  )
}
```
