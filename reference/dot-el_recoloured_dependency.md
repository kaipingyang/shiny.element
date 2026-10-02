# Element's dependency, with its stylesheet recoloured

Carries Element's script too, under Element's own name and a later
version, so that it replaces – rather than joins – the copy every
component brings. Written once per set of colours, to the session's
temporary directory.

## Usage

``` r
.el_recoloured_dependency(colors)
```

## Arguments

- colors:

  Output of
  [`.el_theme_colors()`](https://kaipingyang.github.io/shiny.element/reference/dot-el_theme_colors.md).

## Value

An htmlDependency, or `NULL` when nothing changes.
