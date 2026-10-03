# Virtualized Tree

Tree view with blazing fast scrolling performance for any amount of data

## Basic usage

Basic tree structure.

Nodes are `list(id =, label =, children =)`; only those in view are
drawn, so ten thousand cost little.

``` r

make_nodes <- function(depth, prefix = "") lapply(1:10, function(i) {
  key <- paste0(prefix, i)
  node <- list(id = key, label = paste("Node", key))
  if (depth > 1) node$children <- make_nodes(depth - 1, paste0(key, "-"))
  node
})
el_tree_v2("tv2_basic", data = make_nodes(3), height = 208)
```

## Selectable

Used for node selection.

``` r

make_nodes <- function(depth, prefix = "") lapply(1:10, function(i) {
  key <- paste0(prefix, i)
  node <- list(id = key, label = paste("Node", key))
  if (depth > 1) node$children <- make_nodes(depth - 1, paste0(key, "-"))
  node
})
el_tree_v2("tv2_sel", data = make_nodes(3), show_checkbox = TRUE, height = 208)
```

> **Warning**
>
> When using show-checkbox, since `check-on-click-leaf` is true by
> default, last tree children’s can be checked by clicking their nodes.

## Disabled checkbox

The checkbox of a node can be set as disabled.

In the example, `disabled` property is declared in defaultProps, and
some nodes are set as `disabled: true`. The corresponding checkboxes are
disabled and can’t be clicked.

``` r

nodes <- list(
  list(id = "1", label = "Level one 1", children = list(
    list(id = "1-1", label = "Level two 1-1", disabled = TRUE),
    list(id = "1-2", label = "Level two 1-2"))),
  list(id = "2", label = "Level one 2", disabled = TRUE))
el_tree_v2("tv2_dis", data = nodes, show_checkbox = TRUE, default_expanded_keys = "1", height = 208)
```

## Default expanded and default checked

Tree nodes can be initially expanded or checked

Use `default-expanded-keys` and `default-checked-keys` to set initially
expanded and initially checked nodes respectively.

``` r

make_nodes <- function(depth, prefix = "") lapply(1:10, function(i) {
  key <- paste0(prefix, i)
  node <- list(id = key, label = paste("Node", key))
  if (depth > 1) node$children <- make_nodes(depth - 1, paste0(key, "-"))
  node
})
el_tree_v2("tv2_def", data = make_nodes(3), show_checkbox = TRUE, height = 208,
           default_expanded_keys = c("1", "1-1"), default_checked_keys = c("1-1-1", "1-1-2"))
```

## Custom node content

The content of tree nodes can be customized, so you can add icons or
buttons as you will

The default slot, scoped with `node`, draws each node.

``` r

make_nodes <- function(depth, prefix = "") lapply(1:10, function(i) {
  key <- paste0(prefix, i)
  node <- list(id = key, label = paste("Node", key))
  if (depth > 1) node$children <- make_nodes(depth - 1, paste0(key, "-"))
  node
})
el_tree_v2("tv2_cus", data = make_nodes(3), height = 208, slots = list(default = template(
  tags$span(class = "prefix", style = "color: var(--el-color-primary); margin-right: 6px",
            "[{{ node.isLeaf ? 'leaf' : 'node' }}]"),
  tags$span("{{ node.label }}"), scope = "{ node }")))
```

## Custom node class

The class of tree nodes can be customized

> **In R**
>
> Upstream builds each node’s class with `props.class`; in R, draw the
> node with the default slot and give its markup the class.

## Custom node icon

You can customize icons for different node states. Tree nodes expose the
`expanded` property and `isLeaf` property, allowing you to dynamically
render different icons based on the node’s state: leaf nodes, expanded
nodes, or collapsed nodes.

``` r

make_nodes <- function(depth, prefix = "") lapply(1:10, function(i) {
  key <- paste0(prefix, i)
  node <- list(id = key, label = paste("Node", key))
  if (depth > 1) node$children <- make_nodes(depth - 1, paste0(key, "-"))
  node
})
el_tree_v2("tv2_icon", data = make_nodes(3), icon = "ArrowRightBold", height = 208)
```

## Tree node filtering

The `filter-method` method can only accept the third parameter after
version `2.9.1`. Tree nodes can be filtered

Invoke the `filter` method of the Tree instance to filter tree nodes.
Its parameter is the filtering keyword. Note that for it to work,
`filter-method` is required, and its value is the filtering method.

[`filter()`](https://rdrr.io/r/stats/filter.html), run with
[`el_call()`](https://kaipingyang.github.io/shiny.element/reference/el_call.md),
keeps the nodes `filter_method` passes.

``` r

make_nodes <- function(depth, prefix = "") lapply(1:10, function(i) {
  key <- paste0(prefix, i)
  node <- list(id = key, label = paste("Node", key))
  if (depth > 1) node$children <- make_nodes(depth - 1, paste0(key, "-"))
  node
})

ui <- el_page(
  el_input("q", placeholder = "Please enter keyword", width = "240px"),
  el_tree_v2("tv2_filter", data = make_nodes(3), height = 208,
             filter_method = JS("function(query, node) { return node.label.includes(query); }")))

server <- function(input, output, session) {
  observeEvent(input$q, el_call(session, "tv2_filter", "filter", list(input$q), result = FALSE))
}

shinyApp(ui, server)
```

![The filter example, running](../../shots/tree-v2-filter.png)

## API

Element Plus’s tables, and beside each entry where it is in R.

### TreeV2 Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `data` | `data` | tree data | [^1]`Array<{[key: string]: any}>` |  | — |
| `empty-text` | `empty_text` | text displayed when data is void | [^2] |  | — |
| `highlight-current` | `highlight_current` | whether current node is highlighted | [^3] |  | false |
| `expand-on-click-node` | `expand_on_click_node` | whether to expand or collapse node when clicking on the node, if false, then expand or collapse node only when clicking on the arrow icon. | [^4] |  | true |
| `check-on-click-node` | `check_on_click_node` | whether to check or uncheck node when clicking on the node, if false, the node can only be checked or unchecked by clicking on the checkbox. | [^5] |  | false |
| `check-on-click-leaf` | `check_on_click_leaf` | whether to check or uncheck node when clicking on leaf node (last children). | [^6] |  | true |
| `default-expanded-keys` | `default_expanded_keys` | array of keys of initially expanded nodes | [^7]`Array<string \\| number>` |  | — |
| `show-checkbox` | `show_checkbox` | whether node is selectable | [^8] |  | false |
| `check-strictly` | `check_strictly` | whether checked state of a node not affects its father and child nodes when `show-checkbox` is `true` | [^9] |  | false |
| `default-checked-keys` | `default_checked_keys` | array of keys of initially checked nodes | [^10]`Array<string \\| number>` |  | — |
| `current-node-key` | `current_node_key` | key of initially selected node | [^11] / [^12] |  | — |
| `filter-method` | `filter_method` | this function will be executed on each node when use filter method. if return `false`, tree node will be hidden. | [^13]`(query: string, data: TreeNodeData, node: TreeNode) => boolean` |  | — |
| `indent` | `indent` | horizontal indentation of nodes in adjacent levels in pixels | [^14] |  | 16 |
| `icon` | `icon` | custom tree node icon component | [^15] / [^16] |  | — |
| `item-size` | `item_size` | custom tree node height | [^17] |  | 26 |
| `scrollbar-always-on` | `scrollbar_always_on` | always show scrollbar | [^18] |  | false |
| `height` | `height` | height of the tree | [^19] |  | 200 |

### TreeV2 Events

| Element | In R | Description |
|----|----|----|
| `node-click` | `input$<id>_node_click` | triggers when a node is clicked |
| `node-drop` | `input$<id>_node_drop` | triggers when drag something and drop on a node |
| `node-contextmenu` | `input$<id>_node_contextmenu` | triggers when a node is clicked by right button |
| `check-change` | `input$<id>_check_change` | triggers when the selected state of the node changes |
| `check` | `input$<id>_check` | triggers after clicking the checkbox of a node |
| `current-change` | `input$<id>_current_change` | triggers when current node changes |
| `node-expand` | `input$<id>_node_expand` | triggers when current node open |
| `node-collapse` | `input$<id>_node_collapse` | triggers when current node close |

### TreeV2 Slots

| Element   | In R                     | Description                       |
|-----------|--------------------------|-----------------------------------|
| `default` | default content          | custom content for tree nodes     |
| `empty`   | `slots = list(empty = )` | custom content when data is empty |

[^1]: array

[^2]: string

[^3]: boolean

[^4]: boolean

[^5]: boolean

[^6]: boolean

[^7]: array

[^8]: boolean

[^9]: boolean

[^10]: array

[^11]: string

[^12]: number

[^13]: Function

[^14]: number

[^15]: string

[^16]: Component

[^17]: number

[^18]: boolean

[^19]: number
