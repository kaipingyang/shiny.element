# Check that items are a list of lists

Components built from items – tabs, panels, menu entries – read each
item's fields with `$`, which on a string or a vector fails with R's own
"\$ operator is invalid for atomic vectors". Saying what was expected is
more use.

## Usage

``` r
.el_check_items(x, arg, fields)
```

## Arguments

- x:

  The items as given; `NULL` and an empty list pass.

- arg:

  The argument's name, for the error.

- fields:

  The fields an item has, for the error.

## Value

`x`, invisibly.
