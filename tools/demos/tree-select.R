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
#' The three share their data and value, as upstream's: a store holds
#' them. The second filters with `filter_method`, the store's action
#' setting the data to the nodes that match; the third decides node by
#' node, with `filter_node_method`. The server can filter as well, the
#' query reported from `filter_method`.
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
vue_store(
  "ts_data",
  state = list(value = NULL, source = nodes, data = nodes),
  actions = list(
    filterMethod = JS(
      "function(value) {",
      "  this.data = this.source.filter(function(item) { return item.label.includes(value); });",
      "}"
    )
  )
)
el_tree_select(
  "ts_filter",
  value = v_model("$vueStore.ts_data.value"),
  data = v_bind("$vueStore.ts_data.data"),
  filterable = TRUE,
  width = "240px"
)
el_divider()
"filter method:"
el_tree_select(
  "ts_filter_server",
  value = v_model("$vueStore.ts_data.value"),
  data = v_bind("$vueStore.ts_data.data"),
  filter_method = v_bind("$vueStore.ts_data.filterMethod"),
  filterable = TRUE,
  width = "240px"
)
el_divider()
"filter node method:"
el_tree_select(
  "ts_filter_node",
  value = v_model("$vueStore.ts_data.value"),
  data = v_bind("$vueStore.ts_data.data"),
  filter_node_method = JS(
    "function(value, data) { return data.label.includes(value); }"
  ),
  filterable = TRUE,
  width = "240px"
)

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
#' `lazy = TRUE` loads a node's children when it opens, from `load`: here
#' a store's action, shared by both, making them up after a moment, as
#' upstream's. With no `load`, the server answers: `input$<id>_load`,
#' then `el_load_children()`. `cache_data` gives the label of a value
#' whose node is not loaded yet.
#| shot_js = "document.querySelectorAll('#shot .el-select__wrapper')[1].click()", shot_sel = ".el-popper", shot_wait = 2
vue_store(
  "ts_lazy",
  state = list(id = 0),
  actions = list(
    load = JS(
      "function(node, resolve) {",
      "  var self = this;",
      "  if (node.isLeaf) return resolve([]);",
      "  setTimeout(function() {",
      "    resolve([",
      "      { value: ++self.id, label: 'lazy load node' + self.id },",
      "      { value: ++self.id, label: 'lazy load node' + self.id, isLeaf: true }",
      "    ]);",
      "  }, 400);",
      "}"
    )
  )
)
el_tree_select(
  "lazy1",
  lazy = TRUE,
  load = v_bind("$vueStore.ts_lazy.load"),
  props = list(label = "label", children = "children", isLeaf = "isLeaf"),
  width = "240px"
)
el_divider()
"show lazy load label:"
el_tree_select(
  "lazy2",
  value = 5,
  lazy = TRUE,
  load = v_bind("$vueStore.ts_lazy.load"),
  props = list(label = "label", children = "children", isLeaf = "isLeaf"),
  cache_data = list(list(value = 5, label = "lazy load node5")),
  width = "240px"
)

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
