# Prepare Data for Element Table

Prepare Data for Element Table

## Usage

``` r
el_table_config(df, max_rows = NULL, add_name = TRUE)
```

## Arguments

- df:

  Data frame

- max_rows:

  Max rows to show

- add_name:

  Add row names

## Value

List with data and columns

## Details

Superseded:
[`el_table()`](https://kaipingyang.github.io/shiny.element/reference/el_table.md)
now accepts a data.frame directly and infers its columns, so this helper
is only needed for its extra behaviour (dropping incomplete rows,
capping row count, prepending a row-name column).

Note it drops rows with any `NA` via
[`stats::na.omit()`](https://rdrr.io/r/stats/na.fail.html) and
overwrites a column literally named `name` when `add_name = TRUE`.
