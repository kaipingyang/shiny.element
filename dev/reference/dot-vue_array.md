# A value as a field holding an array

`NULL` is an empty array and a vector a list, so jsonlite writes an
array for one value too; a
[`vue_bind()`](https://kaipingyang.github.io/shiny.element/dev/reference/vue_bind.md)
is kept, for the bridge to follow.

## Usage

``` r
.vue_array(x)
```

## Arguments

- x:

  A vector, `NULL` or a binding.

## Value

A list, or the binding.
