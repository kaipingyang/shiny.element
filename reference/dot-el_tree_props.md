# A tree's field map, as Element Plus's `props`

Element replaces its field map whole rather than merging it, so the
fields not given are filled in with Element's own – left out, `disabled`
would no longer disable a node.

## Usage

``` r
.el_tree_props(props)
```

## Arguments

- props:

  A named list, or `NULL`.

## Value

The full map.
