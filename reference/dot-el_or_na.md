# Placeholder for an unset optional prop

A field left out of the Vue instance's `data` is not reactive, so
`update_el_*()` can never set it later. Unset optional props are
therefore declared as `NA`, which serialises to `null`, and read back
through
[`.el_optional_bind()`](https://kaipingyang.github.io/shiny.element/reference/dot-el_optional_bind.md),
which turns that `null` into `undefined` so Element applies its own
default.

## Usage

``` r
.el_or_na(x)
```

## Arguments

- x:

  A value, or `NULL` when the user did not supply one.

## Value

`x`, or `NA` when `x` is `NULL`.
