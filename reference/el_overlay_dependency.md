# Overlay Binding Dependency

Shared by
[`el_dialog()`](https://kaipingyang.github.io/shiny.element/reference/el_dialog.md)
and
[`el_drawer()`](https://kaipingyang.github.io/shiny.element/reference/el_drawer.md):
both are Shiny input bindings rather than htmlwidgets, and both need the
same backdrop, scroll lock and z-index stacking.

## Usage

``` r
el_overlay_dependency()
```

## Value

An htmlDependency object.
