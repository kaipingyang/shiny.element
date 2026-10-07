# Element Plus's variables, set for a theme

Element Plus's variables, set for a theme

## Usage

``` r
.el_themed_dependency(vars, live = FALSE)
```

## Arguments

- vars:

  Output of
  [`.el_element_vars()`](https://kaipingyang.github.io/shiny.element/reference/dot-el_element_vars.md).

- live:

  Whether the theme is the page's Bootstrap theme: its colours then
  follow Bootstrap's CSS variables, live; otherwise they are written
  out, and only those that differ from Element's.

## Value

An htmlDependency holding the `<style>`, or `NULL` when nothing changes.
