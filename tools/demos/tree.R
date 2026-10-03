## basic
#' Nodes are `list(id =, label =, children =)`; `df_to_tree_data()` builds
#' them from a data frame. `input$<id>` is the key of the node last clicked,
#' `input$<id>_checked` the keys checked.
levels <- list(
  list(
    id = 1,
    label = "Level one 1",
    children = list(
      list(
        id = 4,
        label = "Level two 1-1",
        children = list(list(id = 9, label = "Level three 1-1-1"))
      )
    )
  ),
  list(
    id = 2,
    label = "Level one 2",
    children = list(
      list(id = 5, label = "Level two 2-1"),
      list(id = 6, label = "Level two 2-2")
    )
  ),
  list(
    id = 3,
    label = "Level one 3",
    children = list(
      list(id = 7, label = "Level two 3-1"),
      list(id = 8, label = "Level two 3-2")
    )
  )
)
el_tree("basic", data = levels, node_key = "id")

## selectable
#' With `lazy = TRUE` each node's children come from the server, asked for
#' through `input$<id>_load` and answered with `el_load_children()`.
#| shot_js = "document.querySelector('#shot .el-tree-node__content').click()", shot_wait = 2
ui <- el_page(el_tree(
  "zones",
  lazy = TRUE,
  node_key = "id",
  show_checkbox = TRUE
))

server <- function(input, output, session) {
  observeEvent(input$zones_load, {
    q <- input$zones_load
    kids <- if (q$level == 0) {
      list(
        list(id = "region1", label = "Region"),
        list(id = "region2", label = "Region2")
      )
    } else if (q$level > 3) {
      list()
    } else {
      lapply(1:2, function(i) {
        list(id = paste0(q$key, "-", i), label = paste0("zone", i))
      })
    }
    el_load_children(id = "zones", request = q, children = kids)
  })
}

shinyApp(ui, server)

## custom-leaf
#' `is_leaf_field` names the field that says a node has no children, so it
#' draws no expand arrow.
#| shot_js = "document.querySelector('#shot .el-tree-node__content').click()", shot_wait = 2
ui <- el_page(el_tree(
  "zones",
  lazy = TRUE,
  node_key = "id",
  show_checkbox = TRUE,
  is_leaf_field = "leaf"
))

server <- function(input, output, session) {
  observeEvent(input$zones_load, {
    q <- input$zones_load
    kids <- if (q$level == 0) {
      list(list(id = "region", label = "region"))
    } else {
      lapply(1:2, function(i) {
        list(
          id = paste0(q$key, i),
          label = paste0("zone", i),
          leaf = q$level >= 2
        )
      })
    }
    el_load_children(id = "zones", request = q, children = kids)
  })
}

shinyApp(ui, server)

## multiple-times-load
#' A load can fail: `el_load_children(reject = TRUE)` is Element Plus's
#' `reject()`, and the node can be expanded again to retry. Here the server
#' refuses the first three tries.
#| shot_js = "document.querySelector('#shot .el-tree-node__content').click()", shot_wait = 2
ui <- el_page(el_tree("regions", lazy = TRUE, is_leaf_field = "leaf"))

server <- function(input, output, session) {
  tries <- 0
  observeEvent(input$regions_load, {
    q <- input$regions_load
    if (q$level == 0) {
      el_load_children(
        id = "regions",
        request = q,
        children = list(list(label = "region"))
      )
      return()
    }
    tries <<- tries + 1
    later::later(
      function() {
        if (tries > 3) {
          el_load_children(
            id = "regions",
            request = q,
            children = lapply(1:3, function(i) {
              list(label = paste0("zone", i), leaf = TRUE)
            }),
            session = session
          )
        } else {
          el_load_children(
            id = "regions",
            request = q,
            reject = TRUE,
            session = session
          )
        }
      },
      3
    )
  })
}

shinyApp(ui, server)

## disabled
el_tree(
  "dis",
  show_checkbox = TRUE,
  node_key = "id",
  default_expand_all = TRUE,
  data = list(
    list(
      id = 1,
      label = "Level one 1",
      children = list(
        list(
          id = 3,
          label = "Level two 2-1",
          children = list(
            list(id = 4, label = "Level three 3-1-1"),
            list(id = 5, label = "Level three 3-1-2", disabled = TRUE)
          )
        ),
        list(
          id = 2,
          label = "Level two 2-2",
          disabled = TRUE,
          children = list(
            list(id = 6, label = "Level three 3-2-1"),
            list(id = 7, label = "Level three 3-2-2", disabled = TRUE)
          )
        )
      )
    )
  )
)

## default-state
#' `expanded` and `checked` are Element Plus's `default-expanded-keys` and
#' `default-checked-keys` -- renamed, since `update_el_tree(checked =)`
#' changes them later.
el_tree(
  "defs",
  show_checkbox = TRUE,
  node_key = "id",
  expanded = c(2, 3),
  checked = 5,
  data = list(
    list(
      id = 1,
      label = "Level one 1",
      children = list(list(id = 4, label = "Level two 1-1"))
    ),
    list(
      id = 2,
      label = "Level one 2",
      children = list(
        list(id = 5, label = "Level two 2-1"),
        list(id = 6, label = "Level two 2-2")
      )
    ),
    list(
      id = 3,
      label = "Level one 3",
      children = list(
        list(id = 7, label = "Level two 3-1"),
        list(id = 8, label = "Level two 3-2")
      )
    )
  )
)

## checking-tree
#' `update_el_tree(checked =)` sets them; `el_call()` runs Element Plus's
#' `getCheckedKeys()`, `setCheckedKeys()` and the rest.
#| shot_js = "document.querySelector('#set_container button').click()", shot_wait = 2
nodes <- list(
  list(
    id = 1,
    label = "Level one 1",
    children = list(list(id = 4, label = "Level two 1-1"))
  ),
  list(
    id = 2,
    label = "Level one 2",
    children = list(
      list(id = 5, label = "Level two 2-1"),
      list(id = 6, label = "Level two 2-2")
    )
  )
)

ui <- el_page(
  el_tree(
    "tree",
    data = nodes,
    show_checkbox = TRUE,
    node_key = "id",
    default_expand_all = TRUE
  ),
  el_button("set", "Check 4 and 6", size = "small"),
  el_button("get", "Get checked keys", size = "small"),
  el_button("reset", "Reset", size = "small"),
  verbatimTextOutput("keys")
)

server <- function(input, output, session) {
  observeEvent(input$set, update_el_tree(id = "tree", checked = c(4, 6)))
  observeEvent(input$reset, update_el_tree(id = "tree", checked = character(0)))
  observeEvent(input$get, el_call(session, "tree", "getCheckedKeys"))
  output$keys <- renderPrint(input$tree_checked)
}

shinyApp(ui, server)

## customized-node
#' The default slot, scoped with `node` and `data`, draws each node.
el_tree(
  "cus",
  node_key = "id",
  default_expand_all = TRUE,
  expand_on_click_node = FALSE,
  data = list(list(
    id = 1,
    label = "Level one 1",
    children = list(
      list(id = 4, label = "Level two 1-1"),
      list(id = 5, label = "Level two 1-2")
    )
  )),
  slots = list(
    default = template(
      tags$span(
        style = "flex: 1; display: flex; justify-content: space-between; padding-right: 8px",
        tags$span("{{ node.label }}"),
        tags$span(
          el$button(link = TRUE, type = "primary", size = "small", "Append"),
          el$button(link = TRUE, type = "danger", size = "small", "Delete")
        )
      ),
      scope = "{ node, data }"
    )
  )
)

## custom-node-class
#' `class_field` gives each node a class of its own: a field, or a `JS()`
#' function of the node's data, Element Plus's `props.class`.
nodes <- list(
  list(
    id = 1,
    label = "Level one 1",
    children = list(list(
      id = 4,
      label = "Level two 1-1",
      isPenultimate = TRUE,
      children = list(
        list(id = 9, label = "Level three 1-1-1"),
        list(id = 10, label = "Level three 1-1-2")
      )
    ))
  ),
  list(
    id = 2,
    label = "Level one 2",
    children = list(
      list(
        id = 5,
        label = "Level two 2-1",
        isPenultimate = TRUE,
        children = list(
          list(id = 11, label = "Level three 2-1-1"),
          list(id = 12, label = "Level three 2-1-2")
        )
      ),
      list(id = 6, label = "Level two 2-2")
    )
  )
)
tagList(
  el_tree(
    "classed",
    data = nodes,
    show_checkbox = TRUE,
    default_expand_all = TRUE,
    expand_on_click_node = FALSE,
    class_field = JS(
      "function(data) { return data.isPenultimate ? 'is-penultimate' : ''; }"
    )
  ),
  tags$style(HTML(
    ".is-penultimate > .el-tree-node__content { color: #626aef; }
    .el-tree-node.is-expanded.is-penultimate > .el-tree-node__children {
      display: flex;
      flex-direction: row;
    }
    .is-penultimate > .el-tree-node__children > div { width: 25%; }"
  ))
)

## filtering
#' `filter()` keeps the nodes whose label contains the text; give
#' `filter_node_method` to decide otherwise.
#| shot_js = "var i = document.querySelector('#q_container input'); i.value = 'two'; i.dispatchEvent(new Event('input'));", shot_wait = 2
ui <- el_page(
  el_input("q", placeholder = "Filter keyword", width = "300px"),
  el_tree(
    "filtered",
    node_key = "id",
    default_expand_all = TRUE,
    data = list(
      list(
        id = 1,
        label = "Level one 1",
        children = list(list(id = 4, label = "Level two 1-1"))
      ),
      list(
        id = 2,
        label = "Level one 2",
        children = list(list(id = 5, label = "Level three 2-1"))
      )
    )
  )
)

server <- function(input, output, session) {
  observeEvent(
    input$q,
    el_call(session, "filtered", "filter", list(input$q), result = FALSE)
  )
}

shinyApp(ui, server)

## accordion
#' Only one node of a level open at a time.
el_tree(
  "acc",
  accordion = TRUE,
  node_key = "id",
  data = list(
    list(
      id = 1,
      label = "Level one 1",
      children = list(list(id = 4, label = "Level two 1-1"))
    ),
    list(
      id = 2,
      label = "Level one 2",
      children = list(list(id = 5, label = "Level two 2-1"))
    ),
    list(
      id = 3,
      label = "Level one 3",
      children = list(list(id = 6, label = "Level two 3-1"))
    )
  )
)

## draggable
#' `draggable` lets nodes be dragged; `allow_drag` and `allow_drop`, `JS()`
#' functions, say which and where, and `input$<id>_node_drop` reports where
#' one landed.
el_tree(
  "drag",
  draggable = TRUE,
  node_key = "id",
  default_expand_all = TRUE,
  allow_drop = JS(
    "function(dragging, drop, type) {",
    "  return drop.data.label !== 'Level two 3-1' || type !== 'inner';",
    "}"
  ),
  data = list(
    list(
      id = 1,
      label = "Level one 1",
      children = list(list(id = 4, label = "Level two 1-1"))
    ),
    list(
      id = 3,
      label = "Level one 3",
      children = list(list(id = 7, label = "Level two 3-1"))
    )
  )
)
