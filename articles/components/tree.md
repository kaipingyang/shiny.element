# Tree

Display a set of data with hierarchies.

## Basic usage

Basic tree structure.

Nodes are `list(id =, label =, children =)`;
[`df_to_tree_data()`](https://kaipingyang.github.io/shiny.element/reference/df_to_tree_data.md)
builds them from a data frame. `input$<id>` is the key of the node last
clicked, `input$<id>_checked` the keys checked.

``` r

levels <- list(
  list(id = 1, label = "Level one 1", children = list(
    list(id = 4, label = "Level two 1-1", children = list(list(id = 9, label = "Level three 1-1-1"))))),
  list(id = 2, label = "Level one 2", children = list(
    list(id = 5, label = "Level two 2-1"), list(id = 6, label = "Level two 2-2"))),
  list(id = 3, label = "Level one 3", children = list(
    list(id = 7, label = "Level two 3-1"), list(id = 8, label = "Level two 3-2"))))
el_tree("basic", data = levels, node_key = "id")
```

## Selectable

Used for node selection.

This example also shows how to load node data asynchronously.

With `lazy = TRUE` each node’s children come from the server, asked for
through `input$<id>_load` and answered with
[`el_load_children()`](https://kaipingyang.github.io/shiny.element/reference/el_load_children.md).

``` r

ui <- el_page(el_tree("zones", lazy = TRUE, node_key = "id", show_checkbox = TRUE))

server <- function(input, output, session) {
  observeEvent(input$zones_load, {
    q <- input$zones_load
    kids <- if (q$level == 0) list(list(id = "region1", label = "Region"), list(id = "region2", label = "Region2"))
            else if (q$level > 3) list()
            else lapply(1:2, function(i) list(id = paste0(q$key, "-", i), label = paste0("zone", i)))
    el_load_children(id = "zones", request = q, children = kids)
  })
}

shinyApp(ui, server)
```

![The selectable example, running](../../shots/tree-selectable.png)

> **Warning**
>
> When using show-checkbox, since `check-on-click-leaf` is true by
> default, last tree children’s can be checked by clicking their nodes.

## Custom leaf node in lazy mode

A node’s data is not fetched until it is clicked, so the Tree cannot
predict whether a node is a leaf node. That’s why a drop-down button is
added to each node, and if it is a leaf node, the drop-down button will
disappear when clicked. That being said, you can also tell the Tree in
advance whether the node is a leaf node, avoiding the render of the
drop-down button before a leaf node.

`is_leaf_field` names the field that says a node has no children, so it
draws no expand arrow.

``` r

ui <- el_page(el_tree("zones", lazy = TRUE, node_key = "id", show_checkbox = TRUE,
                      is_leaf_field = "leaf"))

server <- function(input, output, session) {
  observeEvent(input$zones_load, {
    q <- input$zones_load
    kids <- if (q$level == 0) list(list(id = "region", label = "region"))
            else lapply(1:2, function(i) list(id = paste0(q$key, i), label = paste0("zone", i),
                                               leaf = q$level >= 2))
    el_load_children(id = "zones", request = q, children = kids)
  })
}

shinyApp(ui, server)
```

![The custom-leaf example, running](../../shots/tree-custom-leaf.png)

## Lazy loading multiple times

When lazily loading node data remotely, lazy loading may sometimes fail.
In this case, you can call reject to keep the node status as is and
allow remote loading to continue.

> **In R**
>
> Upstream, a failed load calls `reject()` so the node can be loaded
> again. In R the server answers every `input$<id>_load`; to let a node
> retry, answer it later – the node keeps spinning until
> [`el_load_children()`](https://kaipingyang.github.io/shiny.element/reference/el_load_children.md)
> comes.

## Disabled checkbox

The checkbox of a node can be set as disabled.

In the example, ‘disabled’ property is declared in defaultProps, and
some nodes are set as ‘disabled:true’. The corresponding checkboxes are
disabled and can’t be clicked.

``` r

el_tree("dis", show_checkbox = TRUE, node_key = "id", default_expand_all = TRUE, data = list(
  list(id = 1, label = "Level one 1", children = list(
    list(id = 3, label = "Level two 2-1", children = list(
      list(id = 4, label = "Level three 3-1-1"),
      list(id = 5, label = "Level three 3-1-2", disabled = TRUE))),
    list(id = 2, label = "Level two 2-2", disabled = TRUE, children = list(
      list(id = 6, label = "Level three 3-2-1"),
      list(id = 7, label = "Level three 3-2-2", disabled = TRUE)))))))
```

## Default expanded and default checked

Tree nodes can be initially expanded or checked

Use `default-expanded-keys` and `default-checked-keys` to set initially
expanded and initially checked nodes respectively. Note that for them to
work, `node-key` is required. Its value is the name of a key in the data
object, and the value of that key should be unique across the whole
tree.

`expanded` and `checked` are Element Plus’s `default-expanded-keys` and
`default-checked-keys` – renamed, since `update_el_tree(checked =)`
changes them later.

``` r

el_tree("defs", show_checkbox = TRUE, node_key = "id", expanded = c(2, 3), checked = 5, data = list(
  list(id = 1, label = "Level one 1", children = list(list(id = 4, label = "Level two 1-1"))),
  list(id = 2, label = "Level one 2", children = list(
    list(id = 5, label = "Level two 2-1"), list(id = 6, label = "Level two 2-2"))),
  list(id = 3, label = "Level one 3", children = list(
    list(id = 7, label = "Level two 3-1"), list(id = 8, label = "Level two 3-2")))))
```

## Checking tree nodes

This example shows how to get and set checked nodes. They both can be
done in two approaches: node and key. If you are taking the key
approach, `node-key` is required.

`update_el_tree(checked =)` sets them;
[`el_call()`](https://kaipingyang.github.io/shiny.element/reference/el_call.md)
runs Element Plus’s `getCheckedKeys()`, `setCheckedKeys()` and the rest.

``` r

nodes <- list(
  list(id = 1, label = "Level one 1", children = list(list(id = 4, label = "Level two 1-1"))),
  list(id = 2, label = "Level one 2", children = list(
    list(id = 5, label = "Level two 2-1"), list(id = 6, label = "Level two 2-2"))))

ui <- el_page(
  el_tree("tree", data = nodes, show_checkbox = TRUE, node_key = "id", default_expand_all = TRUE),
  el_button("set", "Check 4 and 6", size = "small"), el_button("get", "Get checked keys", size = "small"),
  el_button("reset", "Reset", size = "small"), verbatimTextOutput("keys"))

server <- function(input, output, session) {
  observeEvent(input$set, update_el_tree(id = "tree", checked = c(4, 6)))
  observeEvent(input$reset, update_el_tree(id = "tree", checked = character(0)))
  observeEvent(input$get, el_call(session, "tree", "getCheckedKeys"))
  output$keys <- renderPrint(input$tree_checked)
}

shinyApp(ui, server)
```

![The checking-tree example,
running](../../shots/tree-checking-tree.png)

## Custom node content

The content of tree nodes can be customized, so you can add icons or
buttons as you will

There are two ways to customize template for tree nodes:
`render-content` and scoped slot. Use `render-content` to assign a
render function that returns the content of tree nodes. See Vue’s
documentation for a detailed introduction of render functions. If you
prefer scoped slot, you’ll have access to `node` and `data` in the
scope, standing for the TreeNode object and node data of the current
node respectively. Note that the `render-content` demo can’t run in
JSFiddle because it doesn’t support JSX syntax. In a real project,
`render-content` will work if relevant dependencies are correctly
configured.

The default slot, scoped with `node` and `data`, draws each node.

``` r

el_tree("cus", node_key = "id", default_expand_all = TRUE, expand_on_click_node = FALSE,
  data = list(list(id = 1, label = "Level one 1", children = list(
    list(id = 4, label = "Level two 1-1"), list(id = 5, label = "Level two 1-2")))),
  slots = list(default = template(
    tags$span(style = "flex: 1; display: flex; justify-content: space-between; padding-right: 8px",
      tags$span("{{ node.label }}"),
      tags$span(el$button(link = TRUE, type = "primary", size = "small", "Append"),
                el$button(link = TRUE, type = "danger", size = "small", "Delete"))),
    scope = "{ node, data }")))
```

## Custom node class

The class of tree nodes can be customized

. Use `props.class` to build class name of nodes.

> **In R**
>
> Upstream builds each node’s class with `props.class`. In R, style
> nodes with the default slot: give the `<span>` a class from the node’s
> data, as `:class="data.isPenultimate ? 'is-penultimate' : ''"`.

## Tree node filtering

Tree nodes can be filtered

Invoke the `filter` method of the Tree instance to filter tree nodes.
Its parameter is the filtering keyword. Note that for it to work,
`filter-node-method` is required, and its value is the filtering method.

[`filter()`](https://rdrr.io/r/stats/filter.html) keeps the nodes whose
label contains the text; give `filter_node_method` to decide otherwise.

``` r

ui <- el_page(
  el_input("q", placeholder = "Filter keyword", width = "300px"),
  el_tree("filtered", node_key = "id", default_expand_all = TRUE, data = list(
    list(id = 1, label = "Level one 1", children = list(list(id = 4, label = "Level two 1-1"))),
    list(id = 2, label = "Level one 2", children = list(list(id = 5, label = "Level three 2-1"))))))

server <- function(input, output, session) {
  observeEvent(input$q, el_call(session, "filtered", "filter", list(input$q), result = FALSE))
}

shinyApp(ui, server)
```

![The filtering example, running](../../shots/tree-filtering.png)

## Accordion

Only one node among the same level can be expanded at one time.

Only one node of a level open at a time.

``` r

el_tree("acc", accordion = TRUE, node_key = "id", data = list(
  list(id = 1, label = "Level one 1", children = list(list(id = 4, label = "Level two 1-1"))),
  list(id = 2, label = "Level one 2", children = list(list(id = 5, label = "Level two 2-1"))),
  list(id = 3, label = "Level one 3", children = list(list(id = 6, label = "Level two 3-1")))))
```

## Draggable

You can drag and drop Tree nodes by adding a `draggable` attribute.

`draggable` lets nodes be dragged; `allow_drag` and `allow_drop`,
[`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
functions, say which and where, and `input$<id>_node_drop` reports where
one landed.

``` r

el_tree("drag", draggable = TRUE, node_key = "id", default_expand_all = TRUE,
  allow_drop = JS("function(dragging, drop, type) {",
                  "  return drop.data.label !== 'Level two 3-1' || type !== 'inner';",
                  "}"),
  data = list(
    list(id = 1, label = "Level one 1", children = list(list(id = 4, label = "Level two 1-1"))),
    list(id = 3, label = "Level one 3", children = list(list(id = 7, label = "Level two 3-1")))))
```

## API

Element Plus’s tables, and beside each entry where it is in R.

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `data` | `data` | tree data | [^1]`Array<{[key: string]: any}>` |  | — |
| `empty-text` | `empty_text` | text displayed when data is void | [^2] |  | — |
| `node-key` | `node_key` | unique identity key name for nodes, its value should be unique across the whole tree | [^3] |  | — |
| `render-after-expand` | `render_after_expand` | whether to render child nodes only after a parent node is expanded for the first time | [^4] |  | true |
| `load` | `load` | method for loading subtree data, only works when `lazy` is true | [^5]`(node, resolve, reject) => void` |  | — |
| `render-content` | `render_content` | render function for tree node | [^6]`(h, { node, data, store }) => void` |  | — |
| `highlight-current` | `highlight_current` | whether current node is highlighted | [^7] |  | false |
| `default-expand-all` | `default_expand_all` | whether to expand all nodes by default | [^8] |  | false |
| `expand-on-click-node` | `expand_on_click_node` | whether to expand or collapse node when clicking on the node, if false, then expand or collapse node only when clicking on the arrow icon. | [^9] |  | true |
| `check-on-click-node` | `check_on_click_node` | whether to check or uncheck node when clicking on the node, if false, the node can only be checked or unchecked by clicking on the checkbox. | [^10] |  | false |
| `check-on-click-leaf` | `check_on_click_leaf` | whether to check or uncheck node when clicking on leaf node (last children). | [^11] |  | true |
| `auto-expand-parent` | `auto_expand_parent` | whether to expand father node when a child node is expanded | [^12] |  | true |
| `default-expanded-keys` | `expanded` | array of keys of initially expanded nodes | [^13]`Array<string \\| number>` |  | — |
| `show-checkbox` | `show_checkbox` | whether node is selectable | [^14] |  | false |
| `check-strictly` | `check_strictly` | whether checked state of a node not affects its father and child nodes when `show-checkbox` is `true` | [^15] |  | false |
| `default-checked-keys` | `checked` | array of keys of initially checked nodes | [^16]`Array<string \\| number>` |  | — |
| `current-node-key` | `current_node_key` | key of initially selected node | [^17] / [^18] |  | — |
| `filter-node-method` | `filter_node_method` | this function will be executed on each node when use filter method. if return `false`, tree node will be hidden. | [^19]`(value, data, node) => boolean` |  | — |
| `accordion` | `accordion` | whether only one node among the same level can be expanded at one time | [^20] |  | false |
| `indent` | `indent` | horizontal indentation of nodes in adjacent levels in pixels | [^21] |  | 18 |
| `icon` | `icon` | custom tree node icon component | [^22] / [^23] |  | — |
| `lazy` | `lazy` | whether to lazy load leaf node, used with `load` attribute | [^24] |  | false |
| `draggable` | `draggable` | whether enable tree nodes drag and drop | [^25] |  | false |
| `allow-drag` | `allow_drag` | this function will be executed before dragging a node. If `false` is returned, the node can not be dragged | [^26]`(node) => boolean` |  | — |
| `allow-drop` | `allow_drop` | this function will be executed before the dragging node is dropped. If `false` is returned, the dragging node can not be dropped at the target node. `type` has three possible values: ‘prev’ (inserting the dragging node before the target node), ‘inner’ (inserting the dragging node to the target node) and ‘next’ (inserting the dragging node after the target node) | [^27]`(draggingNode, dropNode, type) => boolean` |  | — |

### Events

| Element | In R | Description |
|----|----|----|
| `node-click` | one of the component’s inputs – see its reference page | triggers when a node is clicked |
| `node-contextmenu` | `input$<id>_node_contextmenu` | triggers when a node is clicked by right button |
| `check-change` | `input$<id>_check_change` | triggers when the selected state of the node changes |
| `check` | one of the component’s inputs – see its reference page | triggers after clicking the checkbox of a node |
| `current-change` | `input$<id>_current_change` | triggers when current node changes |
| `node-expand` | `input$<id>_node_expand` | triggers when current node open |
| `node-collapse` | `input$<id>_node_collapse` | triggers when current node close |
| `node-drag-start` | `input$<id>_node_drag_start` | triggers when dragging starts |
| `node-drag-enter` | `input$<id>_node_drag_enter` | triggers when the dragging node enters another node |
| `node-drag-leave` | `input$<id>_node_drag_leave` | triggers when the dragging node leaves a node |
| `node-drag-over` | `input$<id>_node_drag_over` | triggers when dragging over a node (like mouseover event) |
| `node-drag-end` | `input$<id>_node_drag_end` | triggers when dragging ends |
| `node-drop` | `input$<id>_node_drop` | triggers after the dragging node is dropped |

### Slots

| Element   | In R                     | Description                       |
|-----------|--------------------------|-----------------------------------|
| `default` | default content          | custom content for tree nodes     |
| `empty`   | `slots = list(empty = )` | custom content when data is empty |

[^1]: array

[^2]: string

[^3]: string

[^4]: boolean

[^5]: Function

[^6]: Function

[^7]: boolean

[^8]: boolean

[^9]: boolean

[^10]: boolean

[^11]: boolean

[^12]: boolean

[^13]: array

[^14]: boolean

[^15]: boolean

[^16]: array

[^17]: string

[^18]: number

[^19]: Function

[^20]: boolean

[^21]: number

[^22]: string

[^23]: Component

[^24]: boolean

[^25]: boolean

[^26]: Function

[^27]: Function
