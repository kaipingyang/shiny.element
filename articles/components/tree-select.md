# TreeSelect

The tree selector of the dropdown menu, it combines the functions of
components `el-tree` and `el-select`.

## Basic usage

Selector for tree structures.

Nodes are `list(value =, label =, children =)`; `input$<id>` is the
value picked.

``` r

nodes <- list(
  list(value = "1", label = "Level one 1", children = list(
    list(value = "1-1", label = "Level two 1-1", children = list(
      list(value = "1-1-1", label = "Level three 1-1-1"))))),
  list(value = "2", label = "Level one 2", children = list(
    list(value = "2-1", label = "Level two 2-1"), list(value = "2-2", label = "Level two 2-2"))),
  list(value = "3", label = "Level one 3", children = list(
    list(value = "3-1", label = "Level two 3-1"), list(value = "3-2", label = "Level two 3-2"))))
el_tree_select("ts_basic", data = nodes, width = "240px")
```

## Select any level

When using the `check-strictly=true` attribute, any node can be checked,
otherwise only leaf nodes are supported.

> **Tip**
>
> When using `show-checkbox`, since `check-on-click-node` is false by
> default, it can only be selected by checking, you can set it to true,
> and then click the node to select.

`check_strictly` lets any node be picked, not only leaves.

``` r

nodes <- list(
  list(value = "1", label = "Level one 1", children = list(
    list(value = "1-1", label = "Level two 1-1", children = list(
      list(value = "1-1-1", label = "Level three 1-1-1"))))),
  list(value = "2", label = "Level one 2", children = list(
    list(value = "2-1", label = "Level two 2-1"), list(value = "2-2", label = "Level two 2-2"))))
tagList(
  el_tree_select("ts_strict", data = nodes, check_strictly = TRUE, width = "240px"),
  el_tree_select("ts_strict_box", data = nodes, check_strictly = TRUE, show_checkbox = TRUE,
                 width = "240px"))
```

> **Warning**
>
> When using show-checkbox, since `check-on-click-leaf` is true by
> default, last tree children’s can be checked by clicking their nodes.

## Multiple Selection

Multiple selection using clicks or checkbox.

``` r

nodes <- list(
  list(value = "1", label = "Level one 1", children = list(
    list(value = "1-1", label = "Level two 1-1", children = list(
      list(value = "1-1-1", label = "Level three 1-1-1"))))),
  list(value = "2", label = "Level one 2", children = list(
    list(value = "2-1", label = "Level two 2-1"), list(value = "2-2", label = "Level two 2-2"))))
tagList(
  el_tree_select("ts_multi", data = nodes, multiple = TRUE, render_after_expand = FALSE,
                 width = "240px"),
  el_tree_select("ts_multi_box", data = nodes, multiple = TRUE, render_after_expand = FALSE,
                 show_checkbox = TRUE, width = "240px"))
```

## Disabled Selection

Disable options using the disabled field.

A node with `disabled = TRUE` cannot be picked.

``` r

nodes <- list(
  list(value = "1", label = "Level one 1", children = list(
    list(value = "1-1", label = "Level two 1-1", disabled = TRUE))),
  list(value = "2", label = "Level one 2", children = list(
    list(value = "2-1", label = "Level two 2-1"), list(value = "2-2", label = "Level two 2-2"))))
el_tree_select("ts_disabled", data = nodes, width = "240px")
```

## Filterable

Use keyword filtering or custom filtering methods. `filterMethod` can
custom filter method for data, `filterNodeMethod` can custom filter
method for data node.

``` r

nodes <- list(
  list(value = "1", label = "Level one 1", children = list(
    list(value = "1-1", label = "Level two 1-1", children = list(
      list(value = "1-1-1", label = "Level three 1-1-1"))))),
  list(value = "2", label = "Level one 2", children = list(
    list(value = "2-1", label = "Level two 2-1"), list(value = "2-2", label = "Level two 2-2"))))
el_tree_select("ts_filter", data = nodes, filterable = TRUE, width = "240px")
```

## Custom content

Contents of custom tree nodes.

The default slot, scoped with `data`, draws each node.

``` r

nodes <- list(
  list(value = "1", label = "Level one 1", children = list(
    list(value = "1-1", label = "Level two 1-1"))),
  list(value = "2", label = "Level one 2", children = list(
    list(value = "2-1", label = "Level two 2-1"), list(value = "2-2", label = "Level two 2-2"))))
el_tree_select("ts_slots", data = nodes, width = "240px", slots = list(default = template(
  tags$span("{{ data.label }}", tags$span(style = "color: gray", "({{ data.value }})")),
  scope = "{ data }")))
```

## LazyLoad

Lazy loading of tree nodes, suitable for large data lists.

> **In R**
>
> Upstream loads a node’s children with a `load` function. A lazy tree
> in R asks the server; `el_tree(lazy = TRUE)` with
> [`el_load_children()`](https://kaipingyang.github.io/shiny.element/reference/el_load_children.md)
> shows the pattern.

## Use node-key attribute

By default the `modelValue` is looking for the `value` key. For a
different data structure `node-key` must be provided to work normally.

> **Tip**
>
> 1.  `node-key` should be unique across the whole tree.
> 2.  `value-key` have the same objective as `node-key`.
> 3.  Contrary to the select component, the tree-select can’t retrieve
>     an object value.

With `node_key`, two nodes may share a label and the value names one.

``` r

nodes <- list(
  list(id = 1, label = "Level one 1", children = list(list(id = 3, label = "Level two 1-1"))),
  list(id = 2, label = "Level one 2", children = list(list(id = 4, label = "Level two 1-1"))))
el_tree_select("ts_key", data = nodes, node_key = "id", value = 4, width = "240px",
               props = list(label = "label", children = "children"))
```

## API

Element Plus’s tables, and beside each entry where it is in R.

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `tree, select` | any argument of [`el_tree()`](https://kaipingyang.github.io/shiny.element/reference/el_tree.md) or [`el_select()`](https://kaipingyang.github.io/shiny.element/reference/el_select.md), through `...` | The props of el-tree and el-select. |  |  |  |

### Own Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `cache-data` | `cache_data` | The cached data of the lazy node, the structure is the same as the data, used to get the label of the unloaded data | [^1]`CacheOption[]` |  | \[\] |

### Exposes

| Element | In R | Description |
|----|----|----|
| `focus` | `el_call(session, id, "focus")` | focus the Input component |
| `blur` | `el_call(session, id, "blur")` | blur the Input component, and hide the dropdown |

[^1]: array
