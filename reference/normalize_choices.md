# Normalize choices for el_checkbox_group

Converts various choice formats into a uniform list of
`list(value = ..., label = ...)` items.

## Usage

``` r
normalize_choices(choices)
```

## Arguments

- choices:

  Named character vector, list of lists, or unnamed vector.

## Value

A list of `list(value, label)` items.
