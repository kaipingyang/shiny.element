# Element Plus props reached under R names, and the ways R stands in for
# what upstream writes in JavaScript. The browser side of each is in
# test-browser-methods.R.

html_of <- function(ui) {
  paste(as.character(htmltools::renderTags(ui)$html), collapse = "")
}

test_that("el_tooltip(): trigger is Element's, the element described is reference", {
  ui <- el_tooltip(
    "t",
    htmltools::tags$b("x"),
    content = "c",
    trigger = "click"
  )
  expect_true(binds_attr(ui, "trigger"))
  expect_equal(vue_data_of(ui)$tipTrigger, "click")
  expect_match(html_of(ui), "<b>x</b>", fixed = TRUE)
  # the old meaning of `trigger`, a tag, says where it went
  expect_error(
    el_tooltip("t", trigger = htmltools::tags$b("x"), content = "c"),
    "reference"
  )
})

test_that("el_popconfirm(popconfirm_width =) is the prompt's width", {
  ui <- el_popconfirm("p", reference = el$button("x"), popconfirm_width = 420)
  expect_true(binds_attr(ui, "width"))
  expect_equal(vue_data_of(ui)$pcWidth, 420)
})

test_that("popover and popconfirm take the tooltip's other attributes", {
  ui <- el_popover("p", reference = el$button("x"), enterable = FALSE)
  expect_true(binds_attr(ui, "enterable"))
  ui <- el_popconfirm("p", reference = el$button("x"), offset = 20)
  expect_true(binds_attr(ui, "offset"))
})

test_that("virtual_ref is a selector looked up in the browser", {
  for (ui in list(
    el_tooltip("t", content = "c", virtual_ref = "#b"),
    el_popover("p", content = "c", virtual_ref = "#b"),
    el_dropdown("d", items = list(list(command = "a")), virtual_ref = "#b")
  )) {
    html <- html_of(ui)
    expect_match(html, ':virtual-ref="$elRef(', fixed = TRUE)
    # virtual triggering turns on with it
    d <- vue_data_of(ui)
    expect_true(isTRUE(d[[grep(
      "VirtualTriggering$|^virtualTriggering$",
      names(d),
      value = TRUE
    )]]))
  }
  # a dropdown attached elsewhere draws no trigger of its own
  expect_no_match(
    html_of(el_dropdown(
      "d",
      items = list(list(command = "a")),
      virtual_ref = "#b"
    )),
    "el-dropdown-link",
    fixed = TRUE
  )
})

test_that("el_table_v2(): methods for the slots, and auto_resize", {
  ui <- el_table_v2(
    "t",
    data = data.frame(x = 1),
    methods = list(rowCells = JS("function(p) { return p.cells; }")),
    slots = list(row = template("x", slot = "row", scope = "props"))
  )
  expect_true("rowCells" %in% names(vue_payload_of(ui)$methods))
  expect_error(el_table_v2("t", methods = list(JS("1"))), "named list")

  ui <- el_table_v2(
    "t",
    data = data.frame(x = 1),
    auto_resize = TRUE,
    slots = list(cell = template("c", slot = "cell", scope = "s"))
  )
  html <- html_of(ui)
  expect_match(html, "<el-auto-resizer>", fixed = TRUE)
  expect_match(html, ':width="size.width"', fixed = TRUE)
  # the table's slot is on the table, inside the resizer's
  expect_match(
    html,
    "v-slot:default=\"size\">\\s*<el-table-v2[^>]*>.*v-slot:cell"
  )
  expect_null(vue_data_of(ui)$height)
})

test_that("update_el_table_v2() sends rows as rows", {
  s <- mock_session()
  update_el_table_v2(s, "t", data = data.frame(a.b = 1:2))
  msg <- s$captured()$msg
  expect_equal(msg$id, "t")
  expect_equal(rows_of(msg$data)[[2]]$a_b, 2)
})

test_that("el_select(props =) renames the fields of record choices", {
  ui <- el_select(
    "s",
    choices = list(
      list(id = "a", name = "A", off = TRUE),
      list(id = "b", name = "B")
    ),
    props = list(value = "id", label = "name", disabled = "off")
  )
  opts <- vue_data_of(ui)$options
  expect_equal(opts[[1]]$value, "a")
  expect_equal(opts[[1]]$label, "A")
  expect_true(opts[[1]]$disabled)
  expect_true(binds_attr(
    el_select("s", choices = "a", tag_tooltip = list(placement = "top")),
    "tag-tooltip"
  ))
})

test_that("props reach select-v2, segmented and tree-v2", {
  expect_true(binds_attr(
    el_select_v2("s", props = list(value = "id")),
    "props"
  ))
  expect_true(binds_attr(
    el_segmented("s", options = list(), props = list(value = "id")),
    "props"
  ))
  expect_true(binds_attr(el_tree_v2("t", props = list(value = "id")), "props"))
})

test_that("el_tree(class_field =) is Element Plus's props.class", {
  d <- vue_data_of(el_tree("t", class_field = "cls"))
  expect_equal(d$treeProps$class, "cls")
  # left out when not given, rather than sent as an empty object
  expect_null(vue_data_of(el_tree("t"))$treeProps$class)
})

test_that("el_load_children(reject = TRUE) refuses the load", {
  s <- mock_session()
  el_load_children(s, "t", request = 3, reject = TRUE)
  expect_equal(s$captured()$msg$.resolve, list(request = 3, failed = TRUE))
})

test_that("el_tree_select() loads lazily from the server", {
  ui <- el_tree_select("ts", lazy = TRUE)
  expect_match(
    html_of(ui),
    ':load="load === null ? elLoad : load"',
    fixed = TRUE
  )
  expect_true("elLoad" %in% names(vue_payload_of(ui)$methods))
  expect_match(vue_payload_of(ui)$methods$elLoad, "ts_load", fixed = TRUE)
})

test_that("el_tree_node() names a node for call_el()", {
  expect_equal(el_tree_node("a"), list(.ref = "node", value = "a"))
})

test_that("a message box's message can be JS()", {
  s <- mock_session()
  el_message_box(s, "q", JS("Vue.h('p', 'x')"))
  msg <- s$captured()$msg
  expect_equal(msg$message, "Vue.h('p', 'x')")
  expect_true("message" %in% msg$.functions)
})

test_that("an absorbed component's directives follow its renamed fields", {
  # el_table's v-loading="loading" once kept the old name inside a config
  # provider, which had renamed the field: Vue warned at render
  html <- html_of(el_config_provider(el_table("t", data = data.frame(x = 1))))
  loading <- regmatches(html, regexpr('v-loading="[^"]*"', html))
  field <- sub('v-loading="([^"]*)"', "\\1", loading)
  ui <- el_config_provider(el_table("t", data = data.frame(x = 1)))
  expect_true(field %in% names(vue_payload_of(ui)$data))
})

test_that("a component as a dropdown's trigger is folded in, not nested", {
  ui <- el_dropdown(
    "d",
    items = list(list(command = "a")),
    trigger_label = el_button("b", "Open")
  )
  html <- html_of(ui)
  # one component on the page: no host of the button's inside the template
  expect_equal(
    lengths(regmatches(html, gregexpr("data-shiny-vue-template", html))),
    1
  )
  expect_match(html, "<el-button", fixed = TRUE)
})

test_that("a picker's default value and time become Dates in the browser", {
  expect_match(
    html_of(el_date_picker("d", default_value = "2010-10-01")),
    ':default-value="$elDate(defaultValue)"',
    fixed = TRUE
  )
  expect_match(
    html_of(el_time_picker("t", default_value = "12:00:00")),
    ':default-value="$elDate(',
    fixed = TRUE
  )
})

test_that("el_calendar keeps its value a YYYY-MM-DD string", {
  m <- vue_payload_of(el_calendar("c", value = as.Date("2026-01-02")))$methods
  expect_true(all(c("elDate", "elDay", "elPick") %in% names(m)))
})

test_that("a single value for an array-only prop stays an array", {
  ui <- el_tree_v2("t", data = list(), default_expanded_keys = "1")
  expect_match(html_of(ui), '"defaultExpandedKeys":["1"]', fixed = TRUE)
  ui <- el_color_picker_panel("p", predefine = "#ff0000")
  expect_match(html_of(ui), '"predefine":["#ff0000"]', fixed = TRUE)
})

test_that("el$ writes logical attributes as Vue booleans", {
  html <- as.character(el$button(link = TRUE, plain = FALSE, "Go"))
  expect_match(html, "<el-button link :plain=\"false\">", fixed = TRUE)
})

test_that("el_select_v2() starts with an empty list of options", {
  expect_equal(vue_data_of(el_select_v2("s"))$options, list())
})

test_that("updaters send a single key as a list", {
  s <- mock_session()
  update_el_table_v2(s, "t", expanded_row_keys = "row-1")
  expect_equal(s$captured()$msg$expandedRowKeys, list("row-1"))
  update_el_checkbox_group(s, "c", selected = "a")
  expect_equal(s$captured()$msg$value, list("a"))
  update_el_input_tag(s, "i", value = "a")
  expect_equal(s$captured()$msg$value, list("a"))
})
