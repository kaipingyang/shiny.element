# The fields of a component's data bound with vue_bind()

A bound field keeps a placeholder (`NA`) in the data and its path in the
spec's `bound`, which the bridge follows. Only whole fields are bound; a
component's value only to a store.

## Usage

``` r
.vue_bound(spec)
```

## Arguments

- spec:

  A host's spec, as
  [`.vue_host()`](https://kaipingyang.github.io/shiny.element/dev/reference/dot-vue_host.md)
  receives it.

## Value

The spec, with `bound` when a field is.
