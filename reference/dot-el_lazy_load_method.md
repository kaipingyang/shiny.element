# The loader a lazy tree or tree table uses when none is given

The loader a lazy tree or tree table uses when none is given

## Usage

``` r
.el_lazy_load_method(ns_id, kind = c("tree", "table"))
```

## Arguments

- ns_id:

  The component's id.

- kind:

  `"tree"` – `load(node, resolve)` – or `"table"` –
  `load(row, treeNode, resolve)`.

## Value

A JS function, a method of the component.
