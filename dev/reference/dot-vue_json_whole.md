# Whole doubles as integers, so yyjsonr writes `1` rather than `1.0`

Whole doubles as integers, so yyjsonr writes `1` rather than `1.0`

## Usage

``` r
.vue_json_whole(x)
```

## Arguments

- x:

  A double vector, plain or [`I()`](https://rdrr.io/r/base/AsIs.html).

## Value

`x`, an integer vector when every value is whole and within integer
range (`NA` allowed).
