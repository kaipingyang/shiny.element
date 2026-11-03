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
#' With `lazy = TRUE` a node's children come from `load`, as upstream's
#' `loadNode`: here a [JS()] function making them up after a moment. With
#' no `load`, the server answers: `input$<id>_load`, then
#' `el_load_children()`.
#| shot_js = "document.querySelector('#shot .el-tree-node__content').click()", shot_wait = 2
el_tree(
  "zones_sel",
  width = "600px",
  props = list(label = "name", children = "zones"),
  lazy = TRUE,
  show_checkbox = TRUE,
  load = JS(
    "(function() {",
    "  var count = 1;",
    "  return function(node, resolve) {",
    "    if (node.level === 0) return resolve([{ name: 'Root1' }, { name: 'Root2' }]);",
    "    if (node.level > 3) return resolve([]);",
    "    var hasChild = node.data.name === 'region1' ? true :",
    "      node.data.name === 'region2' ? false : Math.random() > 0.5;",
    "    setTimeout(function() {",
    "      resolve(hasChild ? [{ name: 'zone' + count++ }, { name: 'zone' + count++ }] : []);",
    "    }, 500);",
    "  };",
    "})()"
  ),
  on = list(
    check_change = "(data, checked, indeterminate) => console.log(data, checked, indeterminate)"
  )
)

## custom-leaf
#' `props = list(isLeaf =)` names the field that says a node has no
#' children, so it draws no expand arrow.
#| shot_js = "document.querySelector('#shot .el-tree-node__content').click()", shot_wait = 2
el_tree(
  "zones_leaf",
  width = "600px",
  props = list(label = "name", children = "zones", isLeaf = "leaf"),
  lazy = TRUE,
  show_checkbox = TRUE,
  load = JS(
    "function(node, resolve) {",
    "  if (node.level === 0) return resolve([{ name: 'region' }]);",
    "  if (node.level > 1) return resolve([]);",
    "  setTimeout(function() {",
    "    resolve([{ name: 'leaf', leaf: true }, { name: 'zone' }]);",
    "  }, 500);",
    "}"
  )
)

## multiple-times-load
#' A load can fail: `reject()`, and the node can be expanded again to retry.
#' Here the first three tries are refused. From the server it is
#' `el_load_children(reject = TRUE)`.
#| shot_js = "document.querySelector('#shot .el-tree-node__content').click()", shot_wait = 2
el_tree(
  "regions_retry",
  width = "600px",
  props = list(label = "name", children = "zones", isLeaf = "leaf"),
  lazy = TRUE,
  load = JS(
    "(function() {",
    "  var time = 0;",
    "  return function(node, resolve, reject) {",
    "    if (node.level === 0) return resolve([{ name: 'region' }]);",
    "    time++;",
    "    setTimeout(function() {",
    "      if (time > 3) {",
    "        resolve([",
    "          { name: 'zone1', leaf: true },",
    "          { name: 'zone2', leaf: true },",
    "          { name: 'zone3', leaf: true }",
    "        ]);",
    "      } else {",
    "        reject();",
    "      }",
    "    }, 3000);",
    "  };",
    "})()"
  )
)

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
#' The tree keeps its own state from the keys it is given; `update_el_tree()`
#' sets them again, and `input$defs_checked` reports what is checked.
el_tree(
  "defs",
  show_checkbox = TRUE,
  node_key = "id",
  default_expanded_keys = c(2, 3),
  default_checked_keys = 5,
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
#' The buttons call the tree's `setCheckedKeys()` and `getCheckedKeys()` in
#' the browser, through `$find(id)`. From the server it is
#' `update_el_tree(default_checked_keys =)` and `call_el()`; the keys
#' checked arrive as `input$tree_checked`.
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
el_tree(
  "tree",
  data = nodes,
  show_checkbox = TRUE,
  node_key = "id",
  default_expand_all = TRUE
)
el_button(
  "set",
  "Check 4 and 6",
  size = "small",
  on = list(click = v_on("$find('tree').setCheckedKeys([4, 6])"))
)
el_button(
  "get",
  "Get checked keys",
  size = "small",
  on = list(
    click = v_on(
      "$message('Checked: ' + $find('tree').getCheckedKeys().join(', '))"
    )
  )
)
el_button(
  "reset",
  "Reset",
  size = "small",
  on = list(click = v_on("$find('tree').setCheckedKeys([])"))
)

## customized-node
#' The first tree draws its nodes with `render_content`, a function given
#' `h`; the second with the default slot, scoped with `node` and `data`.
#' Their buttons append or remove the node in both trees, in the browser:
#' a store keeps the next id, and `$find(id)` reaches each tree's
#' `append()` and `remove()`. The render function is made by `v_bind()`, so
#' it sees `$find` and `$vueStore` as a template does.
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
vue_store(
  "tree_ops",
  state = list(next_id = 1000),
  actions = list(
    append = JS(
      "function(trees, parent) {",
      "  var child = { id: this.next_id++, label: 'testtest', children: [] };",
      "  trees.forEach(function(t) { t.append(child, parent); });",
      "}"
    ),
    remove = JS(
      "function(trees, key) { trees.forEach(function(t) { t.remove(key); }); }"
    )
  )
)
# both trees, and what their buttons do with a node's data
trees <- "[$find('cus_render'), $find('cus_slot')]"
append <- sprintf("$vueStore.tree_ops.append(%s, data.id)", trees)
remove <- sprintf("$vueStore.tree_ops.remove(%s, data.id)", trees)
tags$style(
  ".custom-tree-node { flex: 1; display: flex; align-items: center;
     justify-content: space-between; font-size: 14px; padding-right: 8px; }"
)
tags$p("Using render-content")
tree(
  "cus_render",
  render_content = v_bind(sprintf(
    paste(
      "(h, { node, data }) => h('div', { class: 'custom-tree-node' }, [",
      "  h('span', null, node.label),",
      "  h('div', null, [",
      "    h(ElementPlus.ElButton, { type: 'primary', link: true, onClick: () => %s },",
      "      { default: () => 'Append' }),",
      "    h(ElementPlus.ElButton, { type: 'danger', link: true, style: 'margin-left: 4px',",
      "      onClick: () => %s }, { default: () => 'Delete' })",
      "  ])",
      "])",
      sep = "\n"
    ),
    append,
    remove
  ))
)
tags$p("Using scoped slot")
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
            v_on(click = append),
            "Append"
          ),
          el$button(
            style = "margin-left: 4px",
            type = "danger",
            link = NA,
            v_on(click = remove),
            "Delete"
          )
        )
      )
    )
  )
)

## custom-node-class
#' `props = list(class =)` gives each node a class of its own: a field, or a
#' `JS()` function of the node's data.
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
    props = list(
      class = JS(
        "function(data) { return data.isPenultimate ? 'is-penultimate' : ''; }"
      )
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
#' `filter()` keeps the nodes whose label contains the text, called in the
#' browser as it changes, through `$find(id)`; give `filter_node_method` to
#' decide otherwise.
#| shot_js = "var i = document.querySelector('#q_container input'); i.value = 'two'; i.dispatchEvent(new Event('input'));", shot_wait = 2
el_input(
  "q",
  placeholder = "Filter keyword",
  width = "300px",
  on = list(input = v_on("$find('filtered').filter($event)"))
)
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
