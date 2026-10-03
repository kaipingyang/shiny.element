## basic
#' Nodes are `list(id =, label =, children =)`; only those in view are
#' drawn, so ten thousand cost little.
make_nodes <- function(depth, prefix = "") {
  lapply(1:10, function(i) {
    key <- paste0(prefix, i)
    node <- list(id = key, label = paste("Node", key))
    if (depth > 1) {
      node$children <- make_nodes(depth - 1, paste0(key, "-"))
    }
    node
  })
}
el_tree_v2("tv2_basic", data = make_nodes(3), height = 208)

## selectable
make_nodes <- function(depth, prefix = "") {
  lapply(1:10, function(i) {
    key <- paste0(prefix, i)
    node <- list(id = key, label = paste("Node", key))
    if (depth > 1) {
      node$children <- make_nodes(depth - 1, paste0(key, "-"))
    }
    node
  })
}
el_tree_v2("tv2_sel", data = make_nodes(3), show_checkbox = TRUE, height = 208)

## disabled
nodes <- list(
  list(
    id = "1",
    label = "Level one 1",
    children = list(
      list(id = "1-1", label = "Level two 1-1", disabled = TRUE),
      list(id = "1-2", label = "Level two 1-2")
    )
  ),
  list(id = "2", label = "Level one 2", disabled = TRUE)
)
el_tree_v2(
  "tv2_dis",
  data = nodes,
  show_checkbox = TRUE,
  default_expanded_keys = "1",
  height = 208
)

## default-state
make_nodes <- function(depth, prefix = "") {
  lapply(1:10, function(i) {
    key <- paste0(prefix, i)
    node <- list(id = key, label = paste("Node", key))
    if (depth > 1) {
      node$children <- make_nodes(depth - 1, paste0(key, "-"))
    }
    node
  })
}
el_tree_v2(
  "tv2_def",
  data = make_nodes(3),
  show_checkbox = TRUE,
  height = 208,
  default_expanded_keys = c("1", "1-1"),
  default_checked_keys = c("1-1-1", "1-1-2")
)

## custom-node
#' The default slot, scoped with `node`, draws each node.
make_nodes <- function(depth, prefix = "") {
  lapply(1:10, function(i) {
    key <- paste0(prefix, i)
    node <- list(id = key, label = paste("Node", key))
    if (depth > 1) {
      node$children <- make_nodes(depth - 1, paste0(key, "-"))
    }
    node
  })
}
el_tree_v2(
  "tv2_cus",
  data = make_nodes(3),
  height = 208,
  slots = list(
    default = template(
      tags$span(
        class = "prefix",
        style = "color: var(--el-color-primary); margin-right: 6px",
        "[{{ node.isLeaf ? 'leaf' : 'node' }}]"
      ),
      tags$span("{{ node.label }}"),
      scope = "{ node }"
    )
  )
)

## custom-node-class !skip
Upstream builds each node's class with `props.class`; in R, draw the node
with the default slot and give its markup the class.

## custom-icon
make_nodes <- function(depth, prefix = "") {
  lapply(1:10, function(i) {
    key <- paste0(prefix, i)
    node <- list(id = key, label = paste("Node", key))
    if (depth > 1) {
      node$children <- make_nodes(depth - 1, paste0(key, "-"))
    }
    node
  })
}
el_tree_v2(
  "tv2_icon",
  data = make_nodes(3),
  icon = "ArrowRightBold",
  height = 208
)

## filter
#' `filter()`, run with `el_call()`, keeps the nodes `filter_method` passes.
#| shot_js = "var i = document.querySelector('#q_container input'); i.value = '1-1'; i.dispatchEvent(new Event('input'));", shot_wait = 2
make_nodes <- function(depth, prefix = "") {
  lapply(1:10, function(i) {
    key <- paste0(prefix, i)
    node <- list(id = key, label = paste("Node", key))
    if (depth > 1) {
      node$children <- make_nodes(depth - 1, paste0(key, "-"))
    }
    node
  })
}

ui <- el_page(
  el_input("q", placeholder = "Please enter keyword", width = "240px"),
  el_tree_v2(
    "tv2_filter",
    data = make_nodes(3),
    height = 208,
    filter_method = JS(
      "function(query, node) { return node.label.includes(query); }"
    )
  )
)

server <- function(input, output, session) {
  observeEvent(
    input$q,
    el_call(session, "tv2_filter", "filter", list(input$q), result = FALSE)
  )
}

shinyApp(ui, server)
