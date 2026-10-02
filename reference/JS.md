# Mark a string as JavaScript

A prop that takes a function – a table's `formatter`, a tree's
`filter_node_method`, a date picker's shortcuts – takes JavaScript
source marked with `JS()`, which the page evaluates rather than passing
on as text. It is the same mark
[`htmlwidgets::JS()`](https://rdrr.io/pkg/htmlwidgets/man/JS.html)
makes, so either works, and so does `DT::JS()`.

## Usage

``` r
JS(...)
```

## Arguments

- ...:

  JavaScript source, as one or more strings, joined by newlines.

## Value

The source, classed `"JS_EVAL"`.

## Examples

``` r
JS("function(row, column, value) { return value.toFixed(2); }")
#> [1] "function(row, column, value) { return value.toFixed(2); }"
#> attr(,"class")
#> [1] "JS_EVAL"
```
