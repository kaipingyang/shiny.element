# The `.set` of an update: values by path

`"items[3].done"` is the field `items`, its third element (`2` from 0 in
the browser), its `done`.

## Usage

``` r
.vue_set_paths(set)
```

## Arguments

- set:

  A named list, path to value.

## Value

A list of `list(path, value)`.
