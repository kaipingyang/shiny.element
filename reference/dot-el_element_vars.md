# The Element variables a theme sets

From a
[`bslib::bs_theme()`](https://rstudio.github.io/bslib/reference/bs_theme.html):
its `primary`, `success`, `warning`, `danger` and `info` where they
differ from Element's, and whatever was given to
[`el_theme()`](https://kaipingyang.github.io/shiny.element/reference/el_theme.md)'s
`element`. A plain named list is taken as Element variables directly.

## Usage

``` r
.el_element_vars(theme)
```

## Arguments

- theme:

  A theme, a named list, or `NULL`.

## Value

A named character vector, names without the `--el-` prefix.
