# Normalise descriptions items

A named list or vector is the quick form: names are the labels. Keys
written in snake_case are turned to camelCase, as for table columns.

## Usage

``` r
.el_descriptions_items(items)
```

## Arguments

- items:

  The items as given.

## Value

A list of items, each with `label` and `content`.
