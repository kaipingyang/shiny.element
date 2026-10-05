# A data.frame as rows, as `v-for` walks it and table components take it

Factors become strings; a dot in a name becomes an underscore, since a
template expression cannot name `a.b`. A data.frame further in – a row's
list of rows, a cell of a list column – is rows too, and a list column's
cell is its value, not a list of one; `NA` is `null`.

## Usage

``` r
.vue_rows(data)
```

## Arguments

- data:

  A data.frame, a list holding some, or anything else (returned as is).

## Value

The rows: JSON of class `json`, or a list of row lists.

## Details

The rows are written by jsonlite, as JSON kept verbatim (class `json`):
its `dataframe = "rows"` is one vectorised pass, where a list of row
lists took jsonlite seconds for a table-v2's ten thousand rows. A
data.frame holding tags or
[`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md) in
a list column is turned into row lists instead, so they are rendered and
revived as anywhere else.
