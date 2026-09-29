# Normalise the data/columns pair for `el_table()`

Normalise the data/columns pair for
[`el_table()`](https://kaipingyang.github.io/shiny.element/reference/el_table.md)

## Usage

``` r
.el_table_prep(data = list(), columns = list())
```

## Arguments

- data:

  A data.frame or a row-shaped list.

- columns:

  A list of column configs; inferred from `data` when empty.

## Value

A list with elements `rows` and `columns`.
