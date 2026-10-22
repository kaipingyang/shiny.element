# Keep a data.frame's row names as a column, when they mean something

`mtcars` keeps its car names in the row names, and a table that drops
them drops the one column saying what each row is. Automatic row names –
1 to n – say nothing, so they are left out unless asked for.

## Usage

``` r
.el_table_rownames(data, rownames = NULL)
```

## Arguments

- data:

  A data.frame, or anything else (returned unchanged).

- rownames:

  `TRUE` or `FALSE` to force it; `NULL` keeps them only when they are
  not the automatic ones.

## Value

The data, with a `rowname` column first when kept.
