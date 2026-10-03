render_html <- function(tag) {
  paste(as.character(tag), collapse = "")
}

# ── .el_table_rows ────────────────────────────────────────────────────────────

test_that(".el_table_rows: data.frame becomes one named list per row", {
  rows <- .el_table_rows(data.frame(a = 1:2, b = c("x", "y")))
  expect_length(rows, 2)
  expect_equal(rows[[1]], list(a = 1L, b = "x"))
  expect_equal(rows[[2]], list(a = 2L, b = "y"))
})

test_that(".el_table_rows: numeric columns keep their type", {
  rows <- .el_table_rows(data.frame(v = c(5.1, 4.9)))
  expect_type(rows[[1]]$v, "double")
  expect_equal(rows[[1]]$v, 5.1)
})

test_that(".el_table_rows: factors become character", {
  rows <- .el_table_rows(data.frame(f = factor(c("lo", "hi"))))
  expect_type(rows[[1]]$f, "character")
  expect_equal(rows[[1]]$f, "lo")
})

test_that(".el_table_rows: dots in names become underscores", {
  # el-table resolves `prop` as a dotted path, so `Sepal.Length` would be
  # looked up as row$Sepal$Length and render blank.
  rows <- .el_table_rows(data.frame(Sepal.Length = 5.1))
  expect_named(rows[[1]], "Sepal_Length")
})

test_that(".el_table_rows: a row-shaped list passes through untouched", {
  input <- list(list(a = 1), list(a = 2))
  expect_identical(.el_table_rows(input), input)
})

test_that(".el_table_rows: empty data.frame gives an empty list", {
  expect_length(.el_table_rows(data.frame(a = integer(0))), 0)
})

# ── .el_table_infer_columns ───────────────────────────────────────────────────

test_that(".el_table_infer_columns: prop is sanitised, label keeps the original", {
  cols <- .el_table_infer_columns(data.frame(Sepal.Length = 1, Species = "a"))
  expect_equal(cols[[1]], list(prop = "Sepal_Length", label = "Sepal.Length"))
  expect_equal(cols[[2]], list(prop = "Species", label = "Species"))
})

test_that(".el_table_infer_columns: infers from the first row of a list", {
  cols <- .el_table_infer_columns(list(list(a = 1, b = 2)))
  expect_length(cols, 2)
  expect_equal(cols[[1]]$prop, "a")
})

test_that(".el_table_infer_columns: empty input gives no columns", {
  expect_length(.el_table_infer_columns(list()), 0)
  expect_length(.el_table_infer_columns(data.frame()), 0)
})

# ── .el_table_sanitize_columns ────────────────────────────────────────────────

test_that(".el_table_sanitize_columns: rewrites prop, leaves label and width", {
  cols <- .el_table_sanitize_columns(
    list(list(prop = "a.b", label = "A.B", width = "100"))
  )
  expect_equal(cols[[1]]$prop, "a_b")
  expect_equal(cols[[1]]$label, "A.B")
  expect_equal(cols[[1]]$width, "100")
})

test_that(".el_table_sanitize_columns: a config without prop survives", {
  cols <- .el_table_sanitize_columns(list(list(label = "L")))
  expect_null(cols[[1]]$prop)
  expect_equal(cols[[1]]$label, "L")
})

# ── el_table ──────────────────────────────────────────────────────────────────

test_that("el_table: returns a tagList with the container id", {
  tb <- el_table(id = "t1", data = head(iris, 2))
  expect_true(inherits(tb, "shiny.tag.list"))
  expect_match(render_html(tb), 'id="t1_container"')
})

test_that("el_table: columns render via v-for so they stay updatable", {
  html <- render_html(el_table(id = "t1", data = head(iris, 2)))
  expect_match(
    html,
    'v-for="col in (columns.length ? columns : autoColumns)"',
    fixed = TRUE
  )
  expect_match(html, ':prop="col.prop"')
})

test_that("el_table: data and border are bound, not baked in", {
  html <- render_html(el_table(id = "t1", data = head(iris, 2)))
  expect_match(html, ':data="tableData"')
  expect_match(html, ':border="border"')
})

test_that("el_table: a data.frame is serialised row-wise", {
  html <- render_html(el_table(id = "t1", data = data.frame(a = 1:2)))
  expect_match(html, '\\{"a":1\\}')
  expect_false(grepl('"a":\\[1,2\\]', html))
})

test_that("el_table: selection column is bound to the reactive flag", {
  html <- render_html(el_table(id = "t1", data = head(iris, 2)))
  expect_match(html, 'v-if="selection"')
  # Bound unconditionally so update_el_table(selection = TRUE) still wires up.
  expect_match(html, '@selection-change')
})

test_that("el_table: reports selected rows as well as selected row objects", {
  html <- render_html(el_table(
    id = "t1",
    data = head(iris, 2),
    selection = TRUE
  ))
  expect_match(html, 't1_selected', fixed = TRUE)
  expect_match(html, 't1_selected_rows', fixed = TRUE)
})

test_that("el_table: empty table renders without columns", {
  html <- render_html(el_table(id = "t1"))
  expect_match(html, '"columns":\\[\\]')
  expect_match(html, '"tableData":\\[\\]')
})

# ── update_el_table ───────────────────────────────────────────────────────────

mock_session <- function() {
  env <- new.env()
  list(
    ns = function(id) id,
    sendCustomMessage = function(type, msg) {
      env$type <- type
      env$msg <- msg
    },
    captured = function() env
  )
}

test_that("update_el_table: sends row-shaped data under the right message type", {
  s <- mock_session()
  update_el_table(s, "t1", data = data.frame(a = 1:2))
  expect_equal(s$captured()$type, "shinyVueUpdate")
  expect_equal(s$captured()$msg$id, "t1")
  # The field is named tableData because the shared updater assigns straight
  # onto the Vue data field of that name.
  expect_equal(s$captured()$msg$tableData[[1]], list(a = 1L))
})

test_that("update_el_table: infers columns when only data is given", {
  s <- mock_session()
  update_el_table(s, "t1", data = data.frame(Sepal.Length = 1))
  expect_equal(s$captured()$msg$autoColumns[[1]]$prop, "Sepal_Length")
  expect_equal(s$captured()$msg$autoColumns[[1]]$label, "Sepal.Length")
  # Written columns are left alone: a new data set must not discard the
  # labels, formatters and cell templates the table was created with
  expect_null(s$captured()$msg$columns)
})

test_that("update_el_table: list() goes back to inferring the columns", {
  s <- mock_session()
  update_el_table(s, "t1", columns = list())
  expect_identical(s$captured()$msg$columns, list())
})

test_that("el_table keeps written and inferred columns apart", {
  d <- vue_data_of(el_table(
    "t",
    data = data.frame(a = 1, b = 2),
    columns = list(list(prop = "a", label = "A"))
  ))
  expect_equal(length(d$columns), 1L)
  expect_equal(length(d$autoColumns), 2L)
  d <- vue_data_of(el_table("t", data = data.frame(a = 1, b = 2)))
  expect_equal(d$columns, list())
  expect_equal(length(d$autoColumns), 2L)
})

test_that("update_el_table: explicit columns win and are sanitised", {
  s <- mock_session()
  update_el_table(
    s,
    "t1",
    data = data.frame(a.b = 1),
    columns = list(list(prop = "a.b", label = "Custom"))
  )
  expect_length(s$captured()$msg$columns, 1)
  expect_equal(s$captured()$msg$columns[[1]]$prop, "a_b")
  expect_equal(s$captured()$msg$columns[[1]]$label, "Custom")
})

test_that("update_el_table: border and selection pass through", {
  s <- mock_session()
  update_el_table(s, "t1", border = FALSE, selection = TRUE)
  expect_false(s$captured()$msg$border)
  expect_true(s$captured()$msg$selection)
})

test_that("update_el_table: NULL fields are excluded from the message", {
  s <- mock_session()
  update_el_table(s, "t1", border = FALSE)
  expect_null(s$captured()$msg$tableData)
  expect_null(s$captured()$msg$columns)
  expect_null(s$captured()$msg$selection)
})

# ── el_table_config (superseded, kept working) ────────────────────────────────

test_that("el_table_config: still produces rows plus columns", {
  cfg <- el_table_config(head(iris, 2))
  expect_length(cfg$data, 2)
  expect_equal(cfg$columns[[1]]$prop, "name")
  expect_true(all(c("Sepal_Length", "name") %in% names(cfg$data[[1]])))
})

test_that("el_table_config: max_rows caps the row count", {
  expect_length(el_table_config(iris, max_rows = 3)$data, 3)
})

# ── argument order (id first since 0.1.0) ─────────────────────────────────────

test_that(".el_table_args: the documented order passes through untouched", {
  df <- data.frame(name = c("A", "B"), value = c(1, 2))
  cols <- list(list(prop = "name", label = "Name"))

  expect_silent(res <- .el_table_args("tbl", df, cols))
  expect_equal(res$id, "tbl")
  expect_equal(res$data, df)
  expect_equal(res$columns, cols)
})

test_that(".el_table_args: an absent id stays NULL, for the caller to generate", {
  df <- data.frame(name = "A")
  expect_silent(res <- .el_table_args(NULL, df, list()))
  expect_null(res$id)
  expect_equal(res$data, df)
})

test_that(".el_table_args: the pre-0.1.0 order is shifted back, with a warning", {
  df <- data.frame(name = c("A", "B"), value = c(1, 2))
  cols <- list(list(prop = "name", label = "Name"))

  # el_table(data, columns, id)
  expect_warning(res <- .el_table_args(df, cols, "t2"), "takes `id` first")
  expect_equal(res$id, "t2")
  expect_equal(res$data, df)
  expect_equal(res$columns, cols)

  # el_table(data, columns)
  expect_warning(res <- .el_table_args(df, cols, list()), "takes `id` first")
  expect_null(res$id)
  expect_equal(res$columns, cols)

  # el_table(data)
  expect_warning(res <- .el_table_args(df, list(), list()), "takes `id` first")
  expect_null(res$id)
  expect_equal(res$data, df)
  expect_equal(res$columns, list())
})

test_that("el_table: a data.frame in the id slot still renders its rows", {
  df <- data.frame(name = c("A", "B"), value = c(1, 2))
  expect_warning(ui <- el_table(df), "takes `id` first")
  html <- paste(as.character(htmltools::renderTags(ui)$html), collapse = "")
  expect_match(html, "el-table")

  # the same data, addressed the documented way, produces the same markup
  quiet <- el_table(data = df)
  expect_equal(
    gsub("el_table_[a-f0-9-]+", "<id>", paste(as.character(ui), collapse = "")),
    gsub(
      "el_table_[a-f0-9-]+",
      "<id>",
      paste(as.character(quiet), collapse = "")
    )
  )
})

test_that("el_table: columns given as something other than a list is caught", {
  expect_error(
    el_table("tbl", data = data.frame(a = 1), columns = "oops"),
    "must be a list of column definitions"
  )
})

# ── column props in either spelling ───────────────────────────────────────────

test_that("a column prop written in snake_case reaches the template", {
  # The template reads col.showOverflowTooltip, so a key left as
  # show_overflow_tooltip would sit in the object and never be looked at --
  # the column would render with the prop silently doing nothing.
  cols <- .el_table_sanitize_columns(list(
    list(
      prop = "a",
      label = "A",
      show_overflow_tooltip = TRUE,
      min_width = "100",
      sort_by = "b"
    )
  ))
  expect_named(
    cols[[1]],
    c("prop", "label", "showOverflowTooltip", "minWidth", "sortBy")
  )
  expect_true(cols[[1]]$showOverflowTooltip)
})

test_that("camelCase column props are left as they are", {
  cols <- .el_table_sanitize_columns(list(
    list(prop = "a", showOverflowTooltip = TRUE, minWidth = "100")
  ))
  expect_true(cols[[1]]$showOverflowTooltip)
  expect_equal(cols[[1]]$minWidth, "100")
})

test_that("header_html keeps its own spelling rule", {
  cols <- .el_table_sanitize_columns(list(
    list(prop = "a", header_html = "<b>A</b>")
  ))
  expect_equal(cols[[1]]$headerHtml, "<b>A</b>")
  expect_null(cols[[1]]$header_html)
})

# ── row names ─────────────────────────────────────────────────────────────────

test_that("row names that name something are kept as the first column", {
  # mtcars keeps its car names in the row names; dropping them dropped the
  # one column saying what each row was.
  cols <- vapply(
    vue_data_of(el_table("t", data = head(mtcars[, 1:2], 2)))$autoColumns,
    `[[`,
    "",
    "prop"
  )
  expect_equal(cols[1], "rowname")
})

test_that("row numbers are not treated as names", {
  for (d in list(head(iris[, 1:2], 2), iris[3:5, 1:2])) {
    cols <- vapply(
      vue_data_of(el_table("t", data = d))$autoColumns,
      `[[`,
      "",
      "prop"
    )
    expect_false("rowname" %in% cols)
  }
})

test_that("rownames can be forced either way", {
  props <- function(...) {
    vapply(vue_data_of(el_table("t", ...))$autoColumns, `[[`, "", "prop")
  }
  expect_false(
    "rowname" %in% props(data = head(mtcars[, 1:2]), rownames = FALSE)
  )
  expect_true("rowname" %in% props(data = head(iris[, 1:2]), rownames = TRUE))
})

test_that("every forwarded table event with arguments has a shape", {
  shapes <- .el_table_event_shapes()
  expect_true(all(
    c(
      "row-click",
      "cell-click",
      "sort-change",
      "current-change",
      "select",
      "expand-change"
    ) %in%
      names(shapes)
  ))
  html <- paste(
    as.character(el_table("t", data = head(iris, 2))),
    collapse = ""
  )
  expect_match(html, "rowIndex", fixed = TRUE)
})

test_that("el_table draws no borders unless asked, as Element", {
  expect_false(vue_data_of(el_table("t", data = head(iris, 2)))$border)
  expect_true(
    vue_data_of(el_table("t", data = head(iris, 2), border = TRUE))$border
  )
})
