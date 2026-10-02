# A component's props, with the server answering lazyLoad

el-cascader and el-cascader-panel take their loader inside `props`, so a
computed property adds one that asks the server – unless the user gave
their own, or the cascader is not lazy.

## Usage

``` r
.el_lazy_props(ns_id)
```

## Arguments

- ns_id:

  The component's id.

## Value

A JS function, the computed property.
