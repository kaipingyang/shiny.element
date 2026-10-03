# Element Plus Splitter Panel

One panel of an
[`el_splitter()`](https://kaipingyang.github.io/shiny.element/reference/el_splitter.md).

## Usage

``` r
el_splitter_panel(
  ...,
  id = NULL,
  size = NULL,
  min = NULL,
  max = NULL,
  resizable = NULL,
  collapsible = NULL,
  width = NULL,
  slots = NULL
)
```

## Arguments

- ...:

  Its content: any Shiny UI. Components of this package are folded into
  this one's Vue instance, as
  [`el_button_group()`](https://kaipingyang.github.io/shiny.element/reference/el_button_group.md)
  folds its buttons.

- id:

  Component ID. Auto-generated if `NULL`.

- size:

  Size of the panel (in pixels or percentage). Element Plus's `size`
  (string / number).

- min:

  Minimum size of the panel (in pixels or percentage). Element Plus's
  `min` (string / number).

- max:

  Maximum size of the panel (in pixels or percentage). Element Plus's
  `max` (string / number).

- resizable:

  Whether the panel can be resized. Element Plus's `resizable`
  (boolean).

- collapsible:

  Whether the panel can be collapsed. Element Plus's `collapsible`
  (boolean).

- width:

  Component width, as a CSS unit.

- slots:

  Named list of Element slot contents: `start-collapsible`,
  `end-collapsible`. A scoped slot is written with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).

## Value

A Shiny UI element.

## Shiny inputs

None: it reports nothing.
