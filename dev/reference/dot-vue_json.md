# A component's spec as the JSON its host carries

Written by yyjsonr, in C: jsonlite walks the value in R, one S4 method
dispatch per element – some 5 ms for a component's few dozen fields,
half of building it. What jsonlite was asked for, yyjsonr is given:
one-element vectors unboxed and
[`I()`](https://rdrr.io/r/base/AsIs.html) ones kept as arrays, `NA` and
`NULL` as `null`, data frames by column,
[`JS()`](https://kaipingyang.github.io/shiny.element/dev/reference/JS.md)
code and `json` verbatim, full precision; and what yyjsonr does
otherwise, done first
([`.vue_json_prepare()`](https://kaipingyang.github.io/shiny.element/dev/reference/dot-vue_json_prepare.md)):
a named vector is an object, a date-time ISO 8601 in UTC, a whole number
kept as a double written `1`, not `1.0`.

## Usage

``` r
.vue_json(spec)
```

## Arguments

- spec:

  `options`, and `input`, `rate`, `type`, `use`, ...

## Value

The JSON, as a single string, safe inside a `<script>`.
