# A data.frame as rows, as `v-for` walks it and table components take it

Factors become strings; a dot in a name becomes an underscore, since a
template expression cannot name `a.b`.

## Usage

``` r
.vue_rows(data)
```

## Arguments

- data:

  A data.frame, or anything else (returned as is).

## Value

A list of rows.
