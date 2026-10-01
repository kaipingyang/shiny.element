# A value as a bookmarked session left it

[`shiny::restoreInput()`](https://rdrr.io/pkg/shiny/man/restoreInput.html),
keeping the shape the component expects: a field that is an array stays
one, so a restored one-item selection is not unboxed to a string, and an
empty selection comes back as an empty array rather than `NULL`.

## Usage

``` r
.el_restore(id, default)
```

## Arguments

- id:

  The input id, namespaced as the page has it.

- default:

  The value to use when nothing is being restored.

## Value

The restored value, or `default`.
