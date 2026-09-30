# Normalise autocomplete suggestions

Element reads each suggestion's `value` field, so a character vector is
turned into one object per entry.

## Usage

``` r
.el_autocomplete_suggestions(suggestions)
```

## Arguments

- suggestions:

  A character vector, or a list of objects.

## Value

A list of objects, each with at least a `value`.
