render_html <- function(tag) {
  paste(as.character(tag), collapse = "")
}

sent_message <- function(expr) {
  captured <- NULL
  session <- list(
    ns = function(id) id,
    sendCustomMessage = function(type, msg) captured <<- list(type = type, msg = msg)
  )
  expr(session)
  captured
}

demo_nodes <- list(
  list(id = "fruit", label = "Fruit", children = list(
    list(id = "apple", label = "Apple"),
    list(id = "plum",  label = "Plum", disabled = TRUE)
  )),
  list(id = "grain", label = "Grains")
)

# ── el_tree ───────────────────────────────────────────────────────────────────

test_that("el_tree: returns a tagList with the container id", {
  t <- el_tree(id = "picker", data = demo_nodes)
  expect_true(inherits(t, "shiny.tag.list"))
  expect_match(render_html(t), 'id="picker_container"')
})

test_that("el_tree: attaches the shared bridge", {
  deps <- htmltools::findDependencies(el_tree(id = "picker"))
  expect_true("shiny-vue" %in% vapply(deps, function(d) d$name, character(1)))
})

test_that("el_tree: the node data goes through as nested JSON", {
  # Unlike the menu, a tree takes its structure through a prop, so the nesting
  # stays plain data rather than becoming tags.
  html <- render_html(el_tree(id = "picker", data = demo_nodes))
  expect_match(html, ':data="treeData"')
  expect_match(html, '"id":"apple"', fixed = TRUE)
  expect_match(html, '"children"', fixed = TRUE)
})

test_that("el_tree: the props map names disabled as well as label and children", {
  # Element replaces its default props map wholesale rather than merging, so
  # leaving disabled out makes a disabled node render as a normal one.
  html <- render_html(el_tree(id = "picker", data = demo_nodes))
  expect_match(html, '"disabled":"disabled"', fixed = TRUE)
  expect_match(html, '"label":"label"', fixed = TRUE)
  expect_match(html, '"children":"children"', fixed = TRUE)
})

test_that("el_tree: custom field names reach the props map", {
  html <- render_html(el_tree(id = "picker", label_field = "name",
                              children_field = "kids", node_key = "key"))
  expect_match(html, '"label":"name"', fixed = TRUE)
  expect_match(html, '"children":"kids"', fixed = TRUE)
  expect_match(html, '"nodeKey":"key"', fixed = TRUE)
})

test_that("el_tree: the tree is named so the handler can reach its methods", {
  # setCheckedKeys() is the only way to replace a selection; see the handler.
  expect_match(render_html(el_tree(id = "picker")), 'ref="tree"', fixed = TRUE)
})

test_that("el_tree: flags reach the Vue data", {
  html <- render_html(el_tree(
    id = "picker", data = demo_nodes, show_checkbox = TRUE,
    check_strictly = TRUE, default_expand_all = TRUE,
    expand_on_click_node = FALSE, accordion = TRUE, highlight_current = TRUE
  ))
  expect_match(html, '"showCheckbox":true')
  expect_match(html, '"checkStrictly":true')
  expect_match(html, '"defaultExpandAll":true')
  expect_match(html, '"expandOnClickNode":false')
  expect_match(html, '"accordion":true')
  expect_match(html, '"highlightCurrent":true')
})

test_that("el_tree: initial expanded and checked keys are arrays", {
  html <- render_html(el_tree(id = "picker", data = demo_nodes,
                              expanded = "fruit", checked = c("apple", "plum")))
  expect_match(html, '"expandedKeys":\\["fruit"\\]')
  expect_match(html, '"checkedKeys":\\["apple","plum"\\]')

  # Empty rather than null, so v-bind gets an array either way.
  empty <- render_html(el_tree(id = "picker"))
  expect_match(empty, '"expandedKeys":\\[\\]')
  expect_match(empty, '"checkedKeys":\\[\\]')
})

test_that("el_tree: empty_text falls back to Element's own", {
  expect_match(render_html(el_tree(id = "picker")), '"emptyText":null', fixed = TRUE)
  expect_match(render_html(el_tree(id = "picker")),
               .el_optional_bind("emptyText"), fixed = TRUE)
  expect_match(render_html(el_tree(id = "picker", empty_text = "Nothing here")),
               '"emptyText":"Nothing here"', fixed = TRUE)
})

test_that("el_tree: reports the clicked node and the checked set", {
  html <- render_html(el_tree(id = "picker", data = demo_nodes))
  expect_match(html, "picker_checked", fixed = TRUE)
  expect_match(html, "checkedKeys", fixed = TRUE)
  expect_match(html, '"mounted"')
})

# ── update_el_tree ────────────────────────────────────────────────────────────

test_that("update_el_tree: sends under the right message type", {
  out <- sent_message(function(s) update_el_tree(s, "picker", data = demo_nodes))
  expect_equal(out$type, "shinyVueUpdate")
  expect_equal(out$msg$id, "picker")
  expect_equal(out$msg$treeData, demo_nodes)
})

test_that("update_el_tree: key arguments are sent as lists", {
  out <- sent_message(function(s) {
    update_el_tree(s, "picker", expanded = c("a", "b"), checked = "c")
  })
  expect_equal(out$msg$expandedKeys, list("a", "b"))
  expect_equal(out$msg$checkedKeys, list("c"))
})

test_that("update_el_tree: an empty checked set clears rather than being dropped", {
  out <- sent_message(function(s) update_el_tree(s, "picker", checked = list()))
  expect_equal(out$msg$checkedKeys, list())
})

test_that("update_el_tree: NULL fields are excluded", {
  out <- sent_message(function(s) update_el_tree(s, "picker", expanded = "a"))
  expect_null(out$msg$treeData)
  expect_null(out$msg$checkedKeys)
})

test_that("an update replaces the tree's selection through setCheckedKeys", {
  # Assigning default-checked-keys only ever adds: Element runs it through
  # _initDefaultCheckedNodes(), which never unchecks anything.
  m <- vue_payload_of(el_tree("t", data = list(list(id = 1, label = "a"))))$methods
  expect_match(m$shinyVueReceive, "setCheckedKeys", fixed = TRUE)
  # setCheckedKeys fires no check event; the field it sets is reported after
  expect_match(m$shinyVueReceive, "this.checked = keys", fixed = TRUE)
})

# ── df_to_tree_data ───────────────────────────────────────────────────────────

demo_df <- data.frame(
  region = c("North", "North", "South"),
  city   = c("Leeds", "York", "Bath"),
  stringsAsFactors = FALSE
)

test_that("df_to_tree_data: one level per column", {
  nodes <- df_to_tree_data(demo_df, c("region", "city"))
  expect_length(nodes, 2)
  expect_equal(nodes[[1]]$label, "North")
  expect_length(nodes[[1]]$children, 2)
  expect_equal(nodes[[2]]$children[[1]]$label, "Bath")
})

test_that("df_to_tree_data: keys are built from the path, so labels may repeat", {
  # A city name appearing under two regions must still get distinct keys.
  df <- data.frame(region = c("North", "South"), city = c("Newport", "Newport"),
                   stringsAsFactors = FALSE)
  nodes <- df_to_tree_data(df, c("region", "city"))
  keys  <- c(nodes[[1]]$children[[1]]$id, nodes[[2]]$children[[1]]$id)
  expect_equal(keys, c("North/Newport", "South/Newport"))
  expect_equal(length(unique(keys)), 2)
})

test_that("df_to_tree_data: the separator is configurable", {
  nodes <- df_to_tree_data(demo_df, c("region", "city"), sep = "::")
  expect_equal(nodes[[1]]$children[[1]]$id, "North::Leeds")
})

test_that("df_to_tree_data: leaves carry no children", {
  nodes <- df_to_tree_data(demo_df, c("region", "city"))
  expect_null(nodes[[1]]$children[[1]]$children)
})

test_that("df_to_tree_data: a single column gives a flat list", {
  nodes <- df_to_tree_data(demo_df, "region")
  expect_length(nodes, 2)
  expect_null(nodes[[1]]$children)
})

test_that("df_to_tree_data: values keep the order they appear in", {
  # Unlike df_to_cascader_options(), which sorts through split().
  df <- data.frame(g = c("b", "a", "c"), stringsAsFactors = FALSE)
  expect_equal(vapply(df_to_tree_data(df, "g"), function(n) n$label, character(1)),
               c("b", "a", "c"))
})

test_that("df_to_tree_data: factors are handled as their labels", {
  df <- data.frame(g = factor(c("x", "y")), stringsAsFactors = TRUE)
  nodes <- df_to_tree_data(df, "g")
  expect_equal(vapply(nodes, function(n) n$label, character(1)), c("x", "y"))
})

# ── the field map ─────────────────────────────────────────────────────────────

test_that("every field of Element's props map is settable", {
  # Element replaces the whole map rather than merging, so each field has to
  # be named here: leaving one out makes that feature stop working silently.
  # isLeaf in particular tells lazy loading which nodes have no children.
  ui <- el_tree("t", data = list(list(label = "A")))
  props <- vue_data_of(ui)$treeProps
  expect_named(props, c("label", "children", "disabled", "isLeaf"))
})

test_that("the field map follows the data's own names", {
  ui <- el_tree("t", data = list(list(name = "A")),
                label_field = "name", children_field = "kids",
                disabled_field = "locked", is_leaf_field = "leaf")
  props <- vue_data_of(ui)$treeProps
  expect_equal(props$label, "name")
  expect_equal(props$children, "kids")
  expect_equal(props$disabled, "locked")
  expect_equal(props$isLeaf, "leaf")
})

# ── the field map ─────────────────────────────────────────────────────────────

test_that("every field of Element's props map is settable", {
  # Element replaces the whole map rather than merging it, so each field has
  # to be named: leaving one out makes that feature stop working silently.
  # isLeaf in particular tells lazy loading which nodes have no children.
  ui <- el_tree("t", data = list(list(label = "A")))
  props <- vue_data_of(ui)$treeProps
  expect_named(props, c("label", "children", "disabled", "isLeaf"))
})

test_that("the field map follows the data's own names", {
  ui <- el_tree("t", data = list(list(name = "A")),
                label_field = "name", children_field = "kids",
                disabled_field = "locked", is_leaf_field = "leaf")
  props <- vue_data_of(ui)$treeProps
  expect_equal(props$label, "name")
  expect_equal(props$children, "kids")
  expect_equal(props$disabled, "locked")
  expect_equal(props$isLeaf, "leaf")
})
