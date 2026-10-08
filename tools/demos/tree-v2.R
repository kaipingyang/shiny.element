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
#' The default slot, scoped with `node`, draws each node: an icon by its
#' state, and a prefix coloured by whether it is a leaf.
#| shot_js = c("document.querySelectorAll('#tv2_cus .el-tree-node__content')[0].click()", "document.querySelectorAll('#tv2_cus .el-tree-node__content')[1].click()")
#| shot_expect = c("document.querySelectorAll('#tv2_cus [data-el-icon=FolderOpened], #tv2_cus .el-tree-node__content .el-icon--left').length > 0", "document.querySelectorAll('#tv2_cus .prefix.is-leaf').length > 0")
make_nodes <- function(depth, key = "node") {
  lapply(seq_len(if (depth == 1) 10 else 4), function(i) {
    id <- paste0(key, "-", i)
    node <- list(id = id, label = id)
    if (depth < 3) {
      node$children <- make_nodes(depth + 1, id)
    }
    node
  })
}
tagList(
  tags$style(
    ".prefix { color: var(--el-color-primary); margin-right: 10px; }
     .prefix.is-leaf { color: var(--el-color-success); }"
  ),
  el_tree_v2(
    "tv2_cus",
    data = make_nodes(1),
    props = list(value = "id", label = "label", children = "children"),
    height = 200,
    width = "600px",
    slots = list(
      default = template(
        scope = "{ node }",
        htmltools::HTML(paste0(
          "<el-icon class=\"el-icon--left\"><Document v-if=\"node.isLeaf\" />",
          "<Folder v-else-if=\"!node.expanded\" /><FolderOpened v-else /></el-icon>",
          "<span class=\"prefix\" :class=\"{ 'is-leaf': node.isLeaf }\">[ElementPlus]</span>",
          "<span>{{ node.label }}</span>"
        ))
      )
    )
  )
)

## custom-node-class
#' `props = list(class =)` gives each node a class of its own, from a
#' `JS()` function of its data.
nodes <- list(
  list(
    id = "1",
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
  el_tree_v2(
    "tv2_classed",
    data = nodes,
    show_checkbox = TRUE,
    expand_on_click_node = FALSE,
    height = 208,
    default_expanded_keys = c("1", "2"),
    props = list(
      value = "id",
      label = "label",
      children = "children",
      class = JS(
        "function(data) { return data.isPenultimate ? 'is-penultimate' : ''; }"
      )
    )
  ),
  tags$style(".is-penultimate .el-tree-node__label { color: #626aef; }")
)

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
#' `filter()`, run with `call_el()`, keeps the nodes `filter_method` passes.
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
    call_el(session, "tv2_filter", "filter", list(input$q), result = FALSE)
  )
}

shinyApp(ui, server)
