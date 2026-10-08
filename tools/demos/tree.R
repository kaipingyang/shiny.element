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
#' `update_el_tree(checked =)` sets them; `call_el()` runs Element Plus's
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
  observeEvent(input$get, call_el(session, "tree", "getCheckedKeys"))
  output$keys <- renderPrint(input$tree_checked)
}

shinyApp(ui, server)

## customized-node
#' The first tree draws its nodes with `render_content`, a function given
#' `h`; the second with the default slot, scoped with `node` and `data`.
#' Their buttons ask the server, which appends or removes the node in both
#' trees with `call_el(session, id, "append" | "remove", ...)`.
#| shot_js = c("document.querySelector('#cus_slot .el-button--primary').click()", "document.querySelectorAll('#cus_render .el-button--danger')[1].click()")
#| shot_wait = 2
#| shot_expect = c("document.querySelectorAll('#cus_slot .el-tree-node__label, #cus_slot .custom-tree-node > span').length === 8", "document.querySelector('#cus_render').innerText.indexOf('Level two 1-1') < 0", "document.querySelector('#cus_slot').innerText.indexOf('testtest') >= 0")
node <- function(id, label, ...) {
  list(id = id, label = label, children = list(...))
}
tree_data <- list(
  node(
    1,
    "Level one 1",
    node(
      4,
      "Level two 1-1",
      node(9, "Level three 1-1-1"),
      node(10, "Level three 1-1-2")
    )
  ),
  node(2, "Level one 2", node(5, "Level two 2-1"), node(6, "Level two 2-2")),
  node(3, "Level one 3", node(7, "Level two 3-1"), node(8, "Level two 3-2"))
)
tree <- function(id, ...) {
  el_tree(
    id,
    data = tree_data,
    show_checkbox = TRUE,
    node_key = "id",
    default_expand_all = TRUE,
    expand_on_click_node = FALSE,
    width = "600px",
    ...
  )
}
ui <- el_page(
  tags$style(
    ".custom-tree-node { flex: 1; display: flex; align-items: center;
       justify-content: space-between; font-size: 14px; padding-right: 8px; }"
  ),
  tags$p("Using render-content"),
  tree(
    "cus_render",
    render_content = JS(
      "function(h, ctx) {",
      "  var send = function(what) { Shiny.setInputValue('cus_' + what, ctx.data.id, {priority: 'event'}); };",
      "  return h('div', { class: 'custom-tree-node' }, [",
      "    h('span', null, ctx.node.label),",
      "    h('div', null, [",
      "      h(ElementPlus.ElButton, { type: 'primary', link: true, onClick: function() { send('append'); } }, { default: function() { return 'Append'; } }),",
      "      h(ElementPlus.ElButton, { type: 'danger', link: true, style: 'margin-left: 4px', onClick: function() { send('remove'); } }, { default: function() { return 'Delete'; } })",
      "    ])",
      "  ]);",
      "}"
    )
  ),
  tags$p("Using scoped slot"),
  tree(
    "cus_slot",
    slots = list(
      default = template(
        scope = "{ node, data }",
        tags$div(
          class = "custom-tree-node",
          tags$span("{{ node.label }}"),
          tags$div(
            el$button(
              type = "primary",
              link = NA,
              `@click` = "$setInput('cus_append', data.id)",
              "Append"
            ),
            el$button(
              style = "margin-left: 4px",
              type = "danger",
              link = NA,
              `@click` = "$setInput('cus_remove', data.id)",
              "Delete"
            )
          )
        )
      )
    )
  )
)
server <- function(input, output, session) {
  next_id <- 1000
  observeEvent(input$cus_append, {
    child <- list(id = next_id, label = "testtest", children = list())
    next_id <<- next_id + 1
    for (id in c("cus_render", "cus_slot")) {
      call_el(session, id, "append", list(child, input$cus_append))
    }
  })
  observeEvent(input$cus_remove, {
    for (id in c("cus_render", "cus_slot")) {
      call_el(session, id, "remove", list(input$cus_remove))
    }
  })
}
shinyApp(ui, server)

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
    call_el(session, "filtered", "filter", list(input$q), result = FALSE)
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
