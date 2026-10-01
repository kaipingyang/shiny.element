# Serialise a component's Vue options for the page

JSON as htmlwidgets writes it – `NA` and `NULL` as `null`, single values
unboxed – with the paths of every
[`htmlwidgets::JS()`](https://rdrr.io/pkg/htmlwidgets/man/JS.html)
listed in `evals`, so the bridge can turn their source back into
functions. `</` is escaped, or a `header_html` holding `</b>` would end
the script element early.

## Usage

``` r
.el_vue_json(spec)
```

## Arguments

- spec:

  The list to write: `options`, and `input`, `rate`, `type`.

## Value

The JSON, as a single string.
