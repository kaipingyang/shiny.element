# Placeholder for an unset optional prop

A field left out of a Vue instance's `data` is not reactive, so an
update can never set it later. Unset optional props are therefore
declared as `NA`, which serialises to `null`; for the props of an
`$optional()` group
([`.vue_optional_props()`](https://kaipingyang.github.io/shiny.element/dev/reference/dot-vue_optional_props.md))
the bridge makes that `null` `undefined`, so the component applies its
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
