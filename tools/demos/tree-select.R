## basic
#' Nodes are `list(value =, label =, children =)`; `input$<id>` is the value
#' picked.
nodes <- list(
  list(value = "1", label = "Level one 1", children = list(
    list(value = "1-1", label = "Level two 1-1", children = list(
      list(value = "1-1-1", label = "Level three 1-1-1"))))),
  list(value = "2", label = "Level one 2", children = list(
    list(value = "2-1", label = "Level two 2-1"), list(value = "2-2", label = "Level two 2-2"))),
  list(value = "3", label = "Level one 3", children = list(
    list(value = "3-1", label = "Level two 3-1"), list(value = "3-2", label = "Level two 3-2"))))
el_tree_select("ts_basic", data = nodes, width = "240px")

## check-strictly
#' `check_strictly` lets any node be picked, not only leaves.
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

## multiple
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

## disabled
#' A node with `disabled = TRUE` cannot be picked.
nodes <- list(
  list(value = "1", label = "Level one 1", children = list(
    list(value = "1-1", label = "Level two 1-1", disabled = TRUE))),
  list(value = "2", label = "Level one 2", children = list(
    list(value = "2-1", label = "Level two 2-1"), list(value = "2-2", label = "Level two 2-2"))))
el_tree_select("ts_disabled", data = nodes, width = "240px")

## filterable
nodes <- list(
  list(value = "1", label = "Level one 1", children = list(
    list(value = "1-1", label = "Level two 1-1", children = list(
      list(value = "1-1-1", label = "Level three 1-1-1"))))),
  list(value = "2", label = "Level one 2", children = list(
    list(value = "2-1", label = "Level two 2-1"), list(value = "2-2", label = "Level two 2-2"))))
el_tree_select("ts_filter", data = nodes, filterable = TRUE, width = "240px")

## slots
#' The default slot, scoped with `data`, draws each node.
nodes <- list(
  list(value = "1", label = "Level one 1", children = list(
    list(value = "1-1", label = "Level two 1-1"))),
  list(value = "2", label = "Level one 2", children = list(
    list(value = "2-1", label = "Level two 2-1"), list(value = "2-2", label = "Level two 2-2"))))
el_tree_select("ts_slots", data = nodes, width = "240px", slots = list(default = template(
  tags$span("{{ data.label }}", tags$span(style = "color: gray", "({{ data.value }})")),
  scope = "{ data }")))

## lazy !skip
Upstream loads a node's children with a `load` function. A lazy tree
in R asks the server; `el_tree(lazy = TRUE)` with `el_load_children()`
shows the pattern.

## node-key
#' With `node_key`, two nodes may share a label and the value names one.
nodes <- list(
  list(id = 1, label = "Level one 1", children = list(list(id = 3, label = "Level two 1-1"))),
  list(id = 2, label = "Level one 2", children = list(list(id = 4, label = "Level two 1-1"))))
el_tree_select("ts_key", data = nodes, node_key = "id", value = 4, width = "240px",
               props = list(label = "label", children = "children"))
