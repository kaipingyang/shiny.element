# Accept the pre-0.1.0 `el_table(data, columns, id)` argument order

[`el_table()`](https://kaipingyang.github.io/shiny.element/reference/el_table.md)
used to take `data` first, which put it out of step with every other
component. Positional calls written against the old order land a
data.frame in `id`, so shift them back one slot and warn, rather than
letting the data be used as an element id.

## Usage

``` r
.el_table_args(id, data, columns)
```

## Arguments

- id, data, columns:

  The arguments as received by
  [`el_table()`](https://kaipingyang.github.io/shiny.element/reference/el_table.md).

## Value

A list with elements `id`, `data` and `columns`.
