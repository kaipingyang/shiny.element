## basic
#' Nodes are `list(value =, label =, children =)`; `input$<id>` is the value
#' picked.
nodes <- list(
  list(
    value = "1",
    label = "Level one 1",
    children = list(
      list(
        value = "1-1",
        label = "Level two 1-1",
        children = list(
          list(value = "1-1-1", label = "Level three 1-1-1")
        )
      )
    )
  ),
  list(
    value = "2",
    label = "Level one 2",
    children = list(
      list(value = "2-1", label = "Level two 2-1"),
      list(value = "2-2", label = "Level two 2-2")
    )
  ),
  list(
    value = "3",
    label = "Level one 3",
    children = list(
      list(value = "3-1", label = "Level two 3-1"),
      list(value = "3-2", label = "Level two 3-2")
    )
  )
)
el_tree_select("ts_basic", data = nodes, width = "240px")

## check-strictly
#' `check_strictly` lets any node be picked, not only leaves.
nodes <- list(
  list(
    value = "1",
    label = "Level one 1",
    children = list(
      list(
        value = "1-1",
        label = "Level two 1-1",
        children = list(
          list(value = "1-1-1", label = "Level three 1-1-1")
        )
      )
    )
  ),
  list(
    value = "2",
    label = "Level one 2",
    children = list(
      list(value = "2-1", label = "Level two 2-1"),
      list(value = "2-2", label = "Level two 2-2")
    )
  )
)
tagList(
  el_tree_select(
    "ts_strict",
    data = nodes,
    check_strictly = TRUE,
    width = "240px"
  ),
  el_tree_select(
    "ts_strict_box",
    data = nodes,
    check_strictly = TRUE,
    show_checkbox = TRUE,
    width = "240px"
  )
)

## multiple
nodes <- list(
  list(
    value = "1",
    label = "Level one 1",
    children = list(
      list(
        value = "1-1",
        label = "Level two 1-1",
        children = list(
          list(value = "1-1-1", label = "Level three 1-1-1")
        )
      )
    )
  ),
  list(
    value = "2",
    label = "Level one 2",
    children = list(
      list(value = "2-1", label = "Level two 2-1"),
      list(value = "2-2", label = "Level two 2-2")
    )
  )
)
tagList(
  el_tree_select(
    "ts_multi",
    data = nodes,
    multiple = TRUE,
    render_after_expand = FALSE,
    width = "240px"
  ),
  el_tree_select(
    "ts_multi_box",
    data = nodes,
    multiple = TRUE,
    render_after_expand = FALSE,
    show_checkbox = TRUE,
    width = "240px"
  )
)

## disabled
#' A node with `disabled = TRUE` cannot be picked.
nodes <- list(
  list(
    value = "1",
    label = "Level one 1",
    children = list(
      list(value = "1-1", label = "Level two 1-1", disabled = TRUE)
    )
  ),
  list(
    value = "2",
    label = "Level one 2",
    children = list(
      list(value = "2-1", label = "Level two 2-1"),
      list(value = "2-2", label = "Level two 2-2")
    )
  )
)
el_tree_select("ts_disabled", data = nodes, width = "240px")

## filterable
nodes <- list(
  list(
    value = "1",
    label = "Level one 1",
    children = list(
      list(
        value = "1-1",
        label = "Level two 1-1",
        children = list(
          list(value = "1-1-1", label = "Level three 1-1-1")
        )
      )
    )
  ),
  list(
    value = "2",
    label = "Level one 2",
    children = list(
      list(value = "2-1", label = "Level two 2-1"),
      list(value = "2-2", label = "Level two 2-2")
    )
  )
)
el_tree_select("ts_filter", data = nodes, filterable = TRUE, width = "240px")

## slots
#' The default slot, scoped with `data`, draws each node.
nodes <- list(
  list(
    value = "1",
    label = "Level one 1",
    children = list(
      list(value = "1-1", label = "Level two 1-1")
    )
  ),
  list(
    value = "2",
    label = "Level one 2",
    children = list(
      list(value = "2-1", label = "Level two 2-1"),
      list(value = "2-2", label = "Level two 2-2")
    )
  )
)
el_tree_select(
  "ts_slots",
  data = nodes,
  width = "240px",
  slots = list(
    default = template(
      tags$span(
        "{{ data.label }}",
        tags$span(style = "color: gray", "({{ data.value }})")
      ),
      scope = "{ data }"
    )
  )
)

## lazy
#' `lazy = TRUE` loads a node's children when it opens, from the server:
#' `input$<id>_load` asks and `el_load_children()` answers. `cache_data`
#' gives the label of a value whose node is not loaded yet.
#| shot_js = "document.querySelectorAll('#shot .el-select__wrapper')[1].click()", shot_sel = ".el-popper", shot_wait = 2
ui <- el_page(
  el_tree_select(
    "lazy1",
    lazy = TRUE,
    props = list(label = "label", children = "children", isLeaf = "isLeaf"),
    width = "240px"
  ),
  el_divider(),
  el_tree_select(
    "lazy2",
    value = 5,
    lazy = TRUE,
    props = list(label = "label", children = "children", isLeaf = "isLeaf"),
    cache_data = list(list(value = 5, label = "lazy load node5")),
    width = "240px"
  )
)

server <- function(input, output, session) {
  id <- 0
  load <- function(q, tree) {
    if (isTRUE(q$data$isLeaf)) {
      return(el_load_children(id = tree, request = q))
    }
    id <<- id + 2
    el_load_children(
      id = tree,
      request = q,
      children = list(
        list(value = id - 1, label = paste0("lazy load node", id - 1)),
        list(value = id, label = paste0("lazy load node", id), isLeaf = TRUE)
      )
    )
  }
  observeEvent(input$lazy1_load, load(input$lazy1_load, "lazy1"))
  observeEvent(input$lazy2_load, load(input$lazy2_load, "lazy2"))
}

shinyApp(ui, server)

## node-key
#' With `node_key`, two nodes may share a label and the value names one.
nodes <- list(
  list(
    id = 1,
    label = "Level one 1",
    children = list(list(id = 3, label = "Level two 1-1"))
  ),
  list(
    id = 2,
    label = "Level one 2",
    children = list(list(id = 4, label = "Level two 1-1"))
  )
)
el_tree_select(
  "ts_key",
  data = nodes,
  node_key = "id",
  value = 4,
  width = "240px",
  props = list(label = "label", children = "children")
)
