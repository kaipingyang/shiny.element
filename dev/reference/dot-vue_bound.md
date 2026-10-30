# The fields of a component's data given v_bind() or v_model()

A bound field keeps a placeholder (`NA`) in the data and its binding in
the spec's `bound`, which the bridge follows. Only whole fields are
bound.

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
