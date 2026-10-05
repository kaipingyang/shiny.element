# Normalise the data/columns pair for `el_table()`

The columns a user wrote and the columns inferred from the data are kept
apart – `columns` and `autoColumns` in the Vue data, the template
showing the first when there are any. A new data set then brings new
inferred columns without touching written ones:
[`update_el_table()`](https://kaipingyang.github.io/shiny.element/reference/el_table.md)
given only `data` used to re-infer and send `columns`, which threw away
every label, formatter and cell template the table was created with.

## Usage

``` r
.el_table_prep(data = list(), columns = list())
```

## Arguments

- data:

  A data.frame or a row-shaped list.

- columns:

  A list of column configs, possibly empty.

## Value

A list: `rows`, `columns` (as written, possibly empty), `auto` (inferred
from `data`) and `cells` (the templates lifted out of `columns`).
