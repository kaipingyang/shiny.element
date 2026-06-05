# Update Element UI Slider

Server-side update for
[`el_slider()`](https://kaipingyang.github.io/shiny.element/reference/el_slider.md).
Supports updating value, range bounds, step size, and disabled state.

## Usage

``` r
update_el_slider(
  session,
  id,
  value = NULL,
  min = NULL,
  max = NULL,
  step = NULL,
  disabled = NULL
)
```

## Arguments

- session:

  Shiny session object.

- id:

  Slider ID (un-namespaced).

- value:

  New slider value. A single number or two-element vector for range
  mode.

- min:

  New minimum value.

- max:

  New maximum value.

- step:

  New step size.

- disabled:

  New disabled state.
