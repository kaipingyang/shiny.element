# Coerce table data to a list of rows

Element UI's `el-table` binds `:data` to an array of row objects. An R
data.frame handed straight to htmlwidgets serialises column-wise into
`{col: [...]}`, which the component silently renders as an empty table.

## Usage

``` r
.el_table_rows(data)
```

## Arguments

- data:

  A data.frame or an already row-shaped list.

## Value

A list of named lists, one per row.

## Details

Column names are sanitised because `el-table-column`'s `prop` is
resolved as a dotted path (`getPropByPath`), so a column literally named
`Sepal.Length` would be looked up as `row$Sepal$Length` and come back
empty.
