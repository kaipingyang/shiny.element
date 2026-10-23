# Vue binding for a prop that may be unset

A Vue prop falls back to its default when passed `undefined`, but takes
`null` as a value: a select bound to a null placeholder renders an empty
one instead of its own. R has no way to send `undefined` through JSON,
so an unsupplied field arrives as `null` and the expression has to map
it back.

## Usage

``` r
.vue_optional_bind(field)
```

## Arguments

- field:

  Name of the Vue data field.

## Value

A template expression yielding the field, or `undefined` when unset.

## Details

A conditional is used rather than `??` because a template expression is
evaluated at runtime, where a polyfill cannot help with syntax.
