## basic
#' Nodes are `list(value =, label =, children =)`; `input$<id>` is the value
#' picked.
n <- function(value, label, ...) {
  list(value = value, label = label, children = list(...))
}
nodes <- list(
  n(
    "1",
    "Level one 1",
    n("1-1", "Level two 1-1", n("1-1-1", "Level three 1-1-1"))
  ),
  n(
    "2",
    "Level one 2",
    n("2-1", "Level two 2-1", n("2-1-1", "Level three 2-1-1")),
    n("2-2", "Level two 2-2", n("2-2-1", "Level three 2-2-1"))
  ),
  n(
    "3",
    "Level one 3",
    n("3-1", "Level two 3-1", n("3-1-1", "Level three 3-1-1")),
    n("3-2", "Level two 3-2", n("3-2-1", "Level three 3-2-1"))
  )
)
tagList(
  el_tree_select(
    "ts_basic",
    data = nodes,
    render_after_expand = FALSE,
    width = "240px"
  ),
  el_divider(),
  "show checkbox:",
  el_tree_select(
    "ts_basic_check",
    data = nodes,
    render_after_expand = FALSE,
    show_checkbox = TRUE,
    width = "240px"
  )
)

## check-strictly
#' `check_strictly` lets any level be picked, not only the leaves.
n <- function(value, label, ...) {
  list(value = value, label = label, children = list(...))
}
nodes <- list(
  n(
    "1",
    "Level one 1",
    n("1-1", "Level two 1-1", n("1-1-1", "Level three 1-1-1"))
  ),
  n(
    "2",
    "Level one 2",
    n("2-1", "Level two 2-1", n("2-1-1", "Level three 2-1-1")),
    n("2-2", "Level two 2-2", n("2-2-1", "Level three 2-2-1"))
  ),
  n(
    "3",
    "Level one 3",
    n("3-1", "Level two 3-1", n("3-1-1", "Level three 3-1-1")),
    n("3-2", "Level two 3-2", n("3-2-1", "Level three 3-2-1"))
  )
)
tagList(
  el_tree_select(
    "ts_strict",
    data = nodes,
    check_strictly = TRUE,
    render_after_expand = FALSE,
    width = "240px"
  ),
  el_divider(),
  "show checkbox:",
  el_tree_select(
    "ts_strict_check",
    data = nodes,
    check_strictly = TRUE,
    render_after_expand = FALSE,
    show_checkbox = TRUE,
    width = "240px"
  ),
  el_divider(),
  "show checkbox with `check-on-click-node`:",
  el_tree_select(
    "ts_strict_click",
    data = nodes,
    check_strictly = TRUE,
    render_after_expand = FALSE,
    show_checkbox = TRUE,
    check_on_click_node = TRUE,
    width = "240px"
  )
)

## multiple
n <- function(value, label, ...) {
  list(value = value, label = label, children = list(...))
}
nodes <- list(
  n(
    "1",
    "Level one 1",
    n("1-1", "Level two 1-1", n("1-1-1", "Level three 1-1-1"))
  ),
  n(
    "2",
    "Level one 2",
    n("2-1", "Level two 2-1", n("2-1-1", "Level three 2-1-1")),
    n("2-2", "Level two 2-2", n("2-2-1", "Level three 2-2-1"))
  ),
  n(
    "3",
    "Level one 3",
    n("3-1", "Level two 3-1", n("3-1-1", "Level three 3-1-1")),
    n("3-2", "Level two 3-2", n("3-2-1", "Level three 3-2-1"))
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
  el_divider(),
  "show checkbox:",
  el_tree_select(
    "ts_multi_check",
    data = nodes,
    multiple = TRUE,
    render_after_expand = FALSE,
    show_checkbox = TRUE,
    width = "240px"
  ),
  el_divider(),
  "show checkbox with `check-strictly`:",
  el_tree_select(
    "ts_multi_strict",
    data = nodes,
    multiple = TRUE,
    render_after_expand = FALSE,
    show_checkbox = TRUE,
    check_strictly = TRUE,
    check_on_click_node = TRUE,
    width = "240px"
  )
)

## disabled
#' A node with `disabled = TRUE` cannot be picked.
n <- function(value, label, ...) {
  list(value = value, label = label, children = list(...))
}
nodes <- list(
  n(
    "1",
    "Level one 1",
    n("1-1", "Level two 1-1", n("1-1-1", "Level three 1-1-1"))
  ),
  n(
    "2",
    "Level one 2",
    n("2-1", "Level two 2-1", n("2-1-1", "Level three 2-1-1")),
    n("2-2", "Level two 2-2", n("2-2-1", "Level three 2-2-1"))
  ),
  n(
    "3",
    "Level one 3",
    n("3-1", "Level two 3-1", n("3-1-1", "Level three 3-1-1")),
    n("3-2", "Level two 3-2", n("3-2-1", "Level three 3-2-1"))
  )
)
nodes[[1]]$disabled <- TRUE
nodes[[1]]$children[[1]]$disabled <- TRUE
nodes[[1]]$children[[1]]$children[[1]]$disabled <- TRUE
el_tree_select("ts_disabled", data = nodes, width = "240px")

## filterable
#' The second filters on the server: its `filter_method` reports the query,
#' and the server sends back the nodes that match. The third decides node
#' by node in the browser, with `filter_node_method`.
#| shot_js = c("var i = document.querySelector('#ts_filter_server input'); i.focus(); i.value = 'one 2'; i.dispatchEvent(new Event('input', {bubbles: true}));")
#| shot_wait = 2
#| shot_sel = ".el-select__popper"
#| shot_expect = "Array.from(document.querySelectorAll('.el-select__popper')).filter(function(p) { return p.offsetParent; })[0].querySelectorAll('.el-tree > .el-tree-node').length === 1"
n <- function(value, label, ...) {
  list(value = value, label = label, children = list(...))
}
nodes <- list(
  n(
    "1",
    "Level one 1",
    n("1-1", "Level two 1-1", n("1-1-1", "Level three 1-1-1"))
  ),
  n(
    "2",
    "Level one 2",
    n("2-1", "Level two 2-1", n("2-1-1", "Level three 2-1-1")),
    n("2-2", "Level two 2-2", n("2-2-1", "Level three 2-2-1"))
  ),
  n(
    "3",
    "Level one 3",
    n("3-1", "Level two 3-1", n("3-1-1", "Level three 3-1-1")),
    n("3-2", "Level two 3-2", n("3-2-1", "Level three 3-2-1"))
  )
)
ui <- el_page(
  el_tree_select("ts_filter", data = nodes, filterable = TRUE, width = "240px"),
  el_divider(),
  "filter method:",
  el_tree_select(
    "ts_filter_server",
    data = nodes,
    filterable = TRUE,
    filter_method = JS(
      "function(value) { Shiny.setInputValue('ts_filter_query', value, {priority: 'event'}); }"
    ),
    width = "240px"
  ),
  el_divider(),
  "filter node method:",
  el_tree_select(
    "ts_filter_node",
    data = nodes,
    filterable = TRUE,
    filter_node_method = JS(
      "function(value, data) { return data.label.includes(value); }"
    ),
    width = "240px"
  )
)
server <- function(input, output, session) {
  observeEvent(input$ts_filter_query, {
    q <- input$ts_filter_query
    keep <- Filter(function(x) grepl(q, x$label, fixed = TRUE), nodes)
    update_el_tree_select(session, "ts_filter_server", data = keep)
  })
}
shinyApp(ui, server)

## slots
#' The default slot, scoped with `data`, draws each node; the second
#' select draws them with `render_content`.
n <- function(value, label, ...) {
  list(value = value, label = label, children = list(...))
}
nodes <- list(
  n(
    "1",
    "Level one 1",
    n("1-1", "Level two 1-1", n("1-1-1", "Level three 1-1-1"))
  ),
  n(
    "2",
    "Level one 2",
    n("2-1", "Level two 2-1", n("2-1-1", "Level three 2-1-1")),
    n("2-2", "Level two 2-2", n("2-2-1", "Level three 2-2-1"))
  ),
  n(
    "3",
    "Level one 3",
    n("3-1", "Level two 3-1", n("3-1-1", "Level three 3-1-1")),
    n("3-2", "Level two 3-2", n("3-2-1", "Level three 3-2-1"))
  )
)
tagList(
  el_tree_select(
    "ts_slot",
    data = nodes,
    width = "240px",
    slots = list(
      default = template(
        scope = "{ data: { label } }",
        htmltools::HTML(
          "{{ label }}<span style=\"color: gray\">(suffix)</span>"
        )
      )
    )
  ),
  el_divider(),
  "use render content:",
  el_tree_select(
    "ts_render",
    data = nodes,
    width = "240px",
    render_content = JS(
      "function(h, ctx) { return h('span', { style: { color: '#626AEF' } }, ctx.data.label); }"
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
#' With `node_key`, the value names a node by its key.
el_tree_select(
  "ts_key",
  data = list(
    list(
      id = 1,
      label = "Level one 1",
      children = list(
        list(id = 2, label = "Level two 1-1"),
        list(id = 3, label = "Level two 1-2")
      )
    )
  ),
  node_key = "id",
  value = 2,
  show_checkbox = TRUE,
  multiple = TRUE,
  default_expand_all = TRUE,
  width = "240px"
)
