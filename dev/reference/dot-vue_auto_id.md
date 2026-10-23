# An id for a component given none

Drawn at random, and marked as such:
[`render_vue()`](https://kaipingyang.github.io/shiny.element/dev/reference/vue_output.md)
does not take a new one, each render, for another component, as it does
an id the author gave.

## Usage

``` r
.vue_auto_id(prefix)
```

## Arguments

- prefix:

  The component's function name.

## Value

The id, with attribute `generated`.
