# What each tree event reports

Element hands tree events the node's data, its internal TreeNode – which
points at its parent and children – and sometimes the component. Each is
shaped into a named list of the node's `data`, its `key` and its
`level`.

## Usage

``` r
.el_tree_event_shapes()
```

## Value

A named list of JavaScript functions, one per event.
