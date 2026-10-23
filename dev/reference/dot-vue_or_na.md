# Placeholder for an unset optional prop

A field left out of a Vue instance's `data` is not reactive, so an
update can never set it later. Unset optional props are therefore
declared as `NA`, which serialises to `null`, and read back through
[`.vue_optional_bind()`](https://kaipingyang.github.io/shiny.element/dev/reference/dot-vue_optional_bind.md),
which turns that `null` into `undefined` so the component applies its
own default.

## Usage

``` r
.vue_or_na(x)
```

## Arguments

- x:

  A value, or `NULL` when the user did not supply one.

## Value

`x`, or `NA` when `x` is `NULL`.
