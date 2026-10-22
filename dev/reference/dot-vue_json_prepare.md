# A value made ready for yyjsonr, as jsonlite would have written it

A named atomic vector becomes a list (an object, as jsonlite's
`keep_vec_names` had it); a date-time an ISO 8601 string in UTC; a
double holding whole numbers within integer range an integer, which
yyjsonr writes `1` where it writes a double `1.0`.
[`JS()`](https://kaipingyang.github.io/shiny.element/dev/reference/JS.md)
and `json` values stay as they are;
[`I()`](https://rdrr.io/r/base/AsIs.html) keeps its class.

## Usage

``` r
.vue_json_prepare(x)
```

## Arguments

- x:

  A value.

## Value

The value.
