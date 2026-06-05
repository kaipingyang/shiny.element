# Update Element UI Progress

Server-side update for
[`el_progress()`](https://kaipingyang.github.io/shiny.element/reference/el_progress.md).

## Usage

``` r
update_el_progress(
  session,
  id,
  percentage = NULL,
  type = NULL,
  status = NULL,
  color = NULL,
  stroke_width = NULL,
  show_text = NULL,
  text_inside = NULL
)
```

## Arguments

- session:

  Shiny session object.

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
