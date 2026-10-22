# Vue binding for a prop that may be unset

Element Plus's props fall back to their own defaults when passed
`undefined`, but treat `null` as a value: an `el-select` bound to a null
placeholder renders an empty one instead of its "Select". R has no way
to send `undefined` through JSON, so an unsupplied field arrives as
`null` and the expression has to map it back.

## Usage

``` r
.el_optional_bind(field)
```

## Arguments

- field:

  Name of the Vue data field.

## Value

A template expression yielding the field, or `undefined` when unset.

## Details

A conditional is used rather than `??` because a template expression is
evaluated at runtime, where a polyfill cannot help with syntax.
