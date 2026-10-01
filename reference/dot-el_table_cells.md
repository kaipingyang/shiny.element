# Take the cell templates out of a table's columns

A column's `cell` is markup, rendered once per row with `scope` – `row`,
`column`, `$index` – in reach. It cannot travel in the column object,
which is JSON in the Vue data, so it is lifted out into the template and
the column keeps a `cellKey` naming its branch there. `slot` decides
whether the column gets a default slot at all: a column without one must
have none, or Element's own rendering – index numbers, formatters, the
tree's expand arrow – would be replaced by an empty slot.

## Usage

``` r
.el_table_cells(columns)
```

## Arguments

- columns:

  Sanitised column configs.

## Value

A list: `columns`, without `cell`, and `cells`, a named list of markup
keyed by `cellKey`.

## Details

The key is built from the column's prop or label, so that
[`update_el_table()`](https://kaipingyang.github.io/shiny.element/reference/update_el_table.md)
given the same columns finds the same template.
