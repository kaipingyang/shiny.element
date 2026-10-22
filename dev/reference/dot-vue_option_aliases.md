# Vue's option names from the R spelling

A snake_case spelling of one of Vue's multi-word options becomes Vue's
(`before_unmount` -\> `beforeUnmount`); every other name is left exactly
as written. Two spellings of one option with different values are an
error.

## Usage

``` r
.vue_option_aliases(opts)
```

## Arguments

- opts:

  A named list of options.

## Value

The list, named as Vue names its options.
