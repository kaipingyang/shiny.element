# A data.frame as rows, as `v-for` walks it and table components take it

Factors become strings; a dot in a name becomes an underscore, since a
template expression cannot name `a.b`. A data.frame further in – a row's
list of rows, a cell of a list column – is rows too, and a list column's
cell is its value, not a list of one.

## Usage

``` r
.vue_rows(data)
```

## Arguments

- data:

  A data.frame, a list holding some, or anything else (returned as is).

## Value

A list of rows.
