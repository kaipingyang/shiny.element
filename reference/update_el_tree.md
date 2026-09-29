# Update an Element UI Tree

Update an Element UI Tree

## Usage

``` r
update_el_tree(session, id, data = NULL, expanded = NULL, checked = NULL)
```

## Arguments

- session:

  Shiny session object.

- id:

  Tree ID (un-namespaced).

- data:

  Replacement node data.

- expanded:

  Keys to expand. Expanding is additive: a node already open is not
  closed by leaving it out, because Element's default-expanded-keys only
  ever opens nodes.

- checked:

  Keys to check, replacing the current selection entirely. Pass
  [`list()`](https://rdrr.io/r/base/list.html) to clear it.

## Value

Called for its side effect; returns `NULL` invisibly.
