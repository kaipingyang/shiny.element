render_html <- function(tag) {
  paste(as.character(tag), collapse = "")
}

# Capture the custom message a server-side function sends. Named to avoid
# shadowing testthat::capture_message(), which catches conditions instead.
sent_message <- function(expr) {
  captured <- NULL
  session <- list(
    ns = function(id) id,
    sendCustomMessage = function(type, msg) captured <<- list(type = type, msg = msg)
  )
  expr(session)
  captured
}

demo_options <- list(
  list(value = "zj", label = "Zhejiang", children = list(
    list(value = "hz", label = "Hangzhou")
  ))
)

# ── 基础结构 ──────────────────────────────────────────────────────────────────

test_that("el_cascader: returns a tagList with the container id", {
  cs <- el_cascader(id = "c1", options = demo_options)
  expect_true(inherits(cs, "shiny.tag.list"))
  expect_match(render_html(cs), 'id="c1_container"')
})

test_that("el_cascader: loads its own handler, not another component's", {
  # It used to attach el_button_handler_dependency(), so
  # el-cascader-handler.js was never on the page and every update was ignored.
  deps  <- htmltools::findDependencies(el_cascader(id = "c1"))
  names <- vapply(deps, function(d) d$name, character(1))
  expect_true("el-cascader-handler" %in% names)
  expect_false("el-button-handler" %in% names)
})

test_that("el_cascader: binds options and value", {
  html <- render_html(el_cascader(id = "c1", options = demo_options))
  expect_match(html, ':options="options"')
  expect_match(html, 'v-model="value"')
})

# ── value ─────────────────────────────────────────────────────────────────────

test_that("el_cascader: a NULL value serialises as an empty array", {
  # A cascader value is a path, so the empty state must be [] and not null.
  expect_match(render_html(el_cascader(id = "c1")), '"value":\\[\\]')
})

test_that("el_cascader: a path value is kept in order", {
  html <- render_html(el_cascader(id = "c1", options = demo_options,
                                  value = list("zj", "hz")))
  expect_match(html, '"value":\\["zj","hz"\\]')
})

test_that("el_cascader: reports to <id>_value, on mount and on change", {
  html <- render_html(el_cascader(id = "c1"))
  expect_match(html, "c1_value", fixed = TRUE)
  expect_match(html, '"mounted"')
})

# ── optional attributes ───────────────────────────────────────────────────────

test_that("el_cascader: props stays reachable by update even when not supplied", {
  plain <- el_cascader(id = "c1")
  expect_true(binds_attr(plain, "props"))

  supplied <- el_cascader(id = "c1", props = list(expandTrigger = "hover"), size = "small")
  expect_equal(vue_data_of(supplied)$size, "small")
  expect_match(render_html(supplied), '"expandTrigger":"hover"')
})

test_that("el_cascader: flags reach the Vue data", {
  html <- render_html(el_cascader(
    id = "c1", clearable = TRUE, filterable = TRUE, disabled = TRUE,
    show_all_levels = FALSE, collapse_tags = TRUE, separator = " > ",
    debounce = 100, placeholder = "pick"
  ))
  expect_match(html, '"clearable":true')
  expect_match(html, '"filterable":true')
  expect_match(html, '"disabled":true')
  expect_match(html, '"showAllLevels":false')
  expect_match(html, '"collapseTags":true')
  expect_match(html, '"separator":" > "')
  expect_match(html, '"debounce":100')
  expect_match(html, '"placeholder":"pick"')
})

# ── update_el_cascader ────────────────────────────────────────────────────────

test_that("update_el_cascader: sends under the right message type", {
  out <- sent_message(function(s) update_el_cascader(s, "c1", value = list("zj")))
  expect_equal(out$type, "updateElCascader")
  expect_equal(out$msg$id, "c1")
  expect_equal(out$msg$value, list("zj"))
})

test_that("update_el_cascader: every supported field passes through", {
  out <- sent_message(function(s) {
    update_el_cascader(s, "c1", options = demo_options, placeholder = "new",
                       clearable = TRUE, filterable = TRUE, disabled = TRUE)
  })
  expect_equal(out$msg$options, demo_options)
  expect_equal(out$msg$placeholder, "new")
  expect_true(out$msg$clearable)
  expect_true(out$msg$filterable)
  expect_true(out$msg$disabled)
})

test_that("update_el_cascader: NULL fields are excluded", {
  out <- sent_message(function(s) update_el_cascader(s, "c1", disabled = TRUE))
  expect_true(out$msg$disabled)
  expect_null(out$msg$value)
  expect_null(out$msg$options)
  expect_null(out$msg$placeholder)
})

# ── df_to_cascader_options ────────────────────────────────────────────────────

demo_df <- data.frame(
  prov = c("A", "A", "B"),
  city = c("a1", "a2", "b1"),
  prov_label = c("Prov A", "Prov A", "Prov B"),
  city_label = c("City a1", "City a2", "City b1"),
  stringsAsFactors = FALSE
)

test_that("df_to_cascader_options: builds one node per distinct value", {
  opts <- df_to_cascader_options(demo_df, c("prov", "city"))
  expect_length(opts, 2)
  expect_equal(opts[[1]]$value, "A")
  expect_length(opts[[1]]$children, 2)
  expect_equal(opts[[2]]$value, "B")
  expect_length(opts[[2]]$children, 1)
})

test_that("df_to_cascader_options: label falls back to value", {
  opts <- df_to_cascader_options(demo_df, c("prov", "city"))
  expect_equal(opts[[1]]$label, "A")
  expect_equal(opts[[1]]$children[[1]]$label, "a1")
})

test_that("df_to_cascader_options: label columns are used when given", {
  opts <- df_to_cascader_options(demo_df, c("prov", "city"), c("prov_label", "city_label"))
  expect_equal(opts[[1]]$label, "Prov A")
  expect_equal(opts[[1]]$children[[1]]$label, "City a1")
})

test_that("df_to_cascader_options: NA in label_cols falls back for that level", {
  opts <- df_to_cascader_options(demo_df, c("prov", "city"), c(NA, "city_label"))
  expect_equal(opts[[1]]$label, "A")
  expect_equal(opts[[1]]$children[[1]]$label, "City a1")
})

test_that("df_to_cascader_options: leaves carry no children", {
  opts <- df_to_cascader_options(demo_df, c("prov", "city"))
  expect_null(opts[[1]]$children[[1]]$children)
})

test_that("df_to_cascader_options: a single level gives a flat list", {
  opts <- df_to_cascader_options(demo_df, "prov")
  expect_length(opts, 2)
  expect_null(opts[[1]]$children)
})

test_that("df_to_cascader_options: nodes are ordered by split(), not by row order", {
  # split() sorts the grouping values, so the option order is not the order the
  # rows appeared in -- numerically for numeric columns, alphabetically for
  # character ones. Values always arrive as strings.
  num <- df_to_cascader_options(data.frame(code = c(10, 9, 2)), "code")
  expect_equal(vapply(num, function(o) o$value, character(1)), c("2", "9", "10"))

  chr <- df_to_cascader_options(
    data.frame(code = c("b", "c", "a"), stringsAsFactors = FALSE), "code"
  )
  expect_equal(vapply(chr, function(o) o$value, character(1)), c("a", "b", "c"))
})
