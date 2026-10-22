# Props' values as the component's fields hold them

`NULL` is `NA`, the placeholder that falls back to Element's default; a
prop Element Plus takes only as an array stays one when R gives a single
value (jsonlite would write "1" for c(1), and a tree-v2 handed a string
for its default-expanded-keys fails to mount); a data.frame is rows.

## Usage

``` r
.el_prop_values(values)
```

## Arguments

- values:

  Named list, by the props' R names.

## Value

The list, values prepared.
