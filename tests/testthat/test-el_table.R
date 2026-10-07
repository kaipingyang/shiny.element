render_html <- function(tag) {
  paste(as.character(tag), collapse = "")
}

# ── .el_table_rows ────────────────────────────────────────────────────────────

test_that(".el_table_rows: data.frame becomes one named list per row", {
  rows <- rows_of(.el_table_rows(data.frame(a = 1:2, b = c("x", "y"))))
  expect_length(rows, 2)
  expect_equal(rows[[1]], list(a = 1L, b = "x"))
  expect_equal(rows[[2]], list(a = 2L, b = "y"))
})

test_that(".el_table_rows: numeric columns keep their type", {
  rows <- rows_of(.el_table_rows(data.frame(v = c(5.1, 4.9))))
  expect_type(rows[[1]]$v, "double")
  expect_equal(rows[[1]]$v, 5.1)
})

test_that(".el_table_rows: factors become character", {
  rows <- rows_of(.el_table_rows(data.frame(f = factor(c("lo", "hi")))))
  expect_type(rows[[1]]$f, "character")
  expect_equal(rows[[1]]$f, "lo")
})

test_that(".el_table_rows: dots in names become underscores", {
  # el-table resolves `prop` as a dotted path, so `Sepal.Length` would be
  # looked up as row$Sepal$Length and render blank.
  rows <- rows_of(.el_table_rows(data.frame(Sepal.Length = 5.1)))
  expect_named(rows[[1]], "Sepal_Length")
})

test_that(".el_table_rows: a row-shaped list passes through untouched", {
  input <- list(list(a = 1), list(a = 2))
  expect_identical(.el_table_rows(input), input)
})

test_that(".el_table_rows: empty data.frame gives an empty list", {
  expect_length(rows_of(.el_table_rows(data.frame(a = integer(0)))), 0)
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

test_that("el_table: returns its specification, drawn as a tagList", {
  tb <- el_table(id = "t1", data = head(iris, 2))
  expect_s3_class(tb, c("el_table", "el_component"))
  expect_s3_class(htmltools::as.tags(tb), "shiny.tag.list")
  expect_match(render_html(tb), 'id="t1_container"')
  expect_identical(as.character(tb), as.character(htmltools::as.tags(tb)))
  # placed in other UI, it is drawn there
  expect_match(render_html(htmltools::div(tb)), 'id="t1_container"')
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

test_that("el_table: reports the selected row numbers and the rows", {
  html <- render_html(el_table(
    id = "t1",
    data = head(iris, 2),
    selection = TRUE
  ))
  # input$t1_selection_rows: the row numbers, typed by their handler;
  # input$t1 is left free, the host no input
  expect_match(html, "t1_selection_rows:shiny.element.rows", fixed = TRUE)
  expect_match(html, '"input":null', fixed = TRUE)
  expect_match(
    html,
    "t1_selection_change:shiny.element.selection",
    fixed = TRUE
  )
  expect_match(html, "table: 't1'", fixed = TRUE)
  expect_false(grepl("t1_selected", html, fixed = TRUE))
})

test_that("el_table: the default events are reported, others when asked", {
  html <- render_html(el_table(id = "t1", data = head(iris, 2)))
  for (event in c("current_change", "sort_change", "filter_change")) {
    expect_match(html, paste0("'t1', '", event, "'"), fixed = TRUE)
  }
  expect_false(grepl("row_dblclick", html, fixed = TRUE))
  expect_false(grepl("cell_mouse_enter", html, fixed = TRUE))

  asked <- render_html(el_table(
    id = "t1",
    data = head(iris, 2),
    events = c("row-dblclick", picked = "cell-click")
  ))
  expect_match(asked, "'t1', 'row_dblclick'", fixed = TRUE)
  # a named event reports under that input, whole
  expect_match(asked, "emit('picked', ''", fixed = TRUE)
  expect_false(grepl("cell_click", asked, fixed = TRUE))
})

test_that("el_on() adds events to a table's specification", {
  tb <- el_table(data = head(iris, 2)) |>
    el_on("row-dblclick") |>
    el_on("cell-click", input = "picked")
  expect_identical(tb$args$events, c("row-dblclick", picked = "cell-click"))
  piped <- render_html(
    el_table(id = "t1", data = head(iris, 2)) |> el_on("row-dblclick")
  )
  expect_match(piped, "'t1', 'row_dblclick'", fixed = TRUE)

  expect_error(el_on(htmltools::div(), "row-click"), "must be a component")
  expect_error(el_on(tb, c("a", "b"), input = "x"), "one event")
  expect_error(el_table(events = "row-tap"), "Not an event of el-table")
  expect_error(el_on(tb, "row-tap"), "Not an event of el-table")
})

test_that("a table's selection arrives as R subsets its data", {
  rows <- shiny:::inputHandlers$get("shiny.element.rows")
  expect_identical(rows(list(2L, 4L)), c(2L, 4L))
  expect_null(rows(list()))

  selection <- shiny:::inputHandlers$get("shiny.element.selection")
  session <- list(userData = new.env())
  cars <- head(mtcars[, 1:3], 4)
  cars$made <- as.Date("2020-01-01") + 0:3
  .el_table_data_set(session, "tbl", cars)
  got <- selection(list(table = "tbl", rows = list(2, 4)), session, "x")
  expect_identical(got, cars[c(2, 4), , drop = FALSE])
  expect_null(selection(list(table = "tbl", rows = list()), session, "x"))

  # a table the server did not render: the rows as the browser sent them
  sent <- list(list(a = 1, b = "x"), list(a = 2, b = "y"))
  got <- selection(
    list(table = "nope", rows = list(1, 2), data = sent),
    session,
    "x"
  )
  expect_equal(got, data.frame(a = c(1, 2), b = c("x", "y")))
})

test_that("render_el_table() draws the table under the output's id", {
  cars <- head(mtcars[, 1:3], 3)
  shiny::testServer(
    function(input, output, session) {
      output$tbl <- render_el_table(el_table(data = cars, selection = TRUE))
    },
    {
      html <- output$tbl$html
      expect_match(html, 'id="tbl-el"', fixed = TRUE)
      expect_match(html, 'data-shiny-vue-id="tbl"', fixed = TRUE)
      expect_match(html, "tbl_selection_change", fixed = TRUE)
      expect_true(length(output$tbl$deps) > 0)
      # the data rendered is kept for input$tbl_selection_change
      expect_identical(.el_table_data(session, "tbl"), cars)
    }
  )
  expect_error(
    shiny::testServer(
      function(input, output, session) {
        output$tbl <- render_el_table(htmltools::div())
      },
      output$tbl
    ),
    "renders an el_table"
  )
})

test_that("el_table_output() is the output's placeholder", {
  html <- render_html(el_table_output("tbl"))
  expect_match(html, 'id="tbl"', fixed = TRUE)
  expect_match(html, 'class="shiny-vue-output"', fixed = TRUE)
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
  expect_equal(rows_of(s$captured()$msg$tableData)[[1]], list(a = 1L))
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

test_that("a column's header is a template, components and all", {
  html <- paste(
    as.character(
      htmltools::renderTags(el_table(
        "t",
        data = data.frame(a = 1),
        columns = list(list(
          prop = "a",
          label = "A",
          header = el$input(size = "small", placeholder = "Type to search")
        ))
      ))$html
    ),
    collapse = ""
  )
  expect_match(html, "headerKey === &#39;header_a&#39;", fixed = TRUE)
  expect_match(html, "<el-input size=\"small\"", fixed = TRUE)
})

test_that("group headers nest as deep as the columns given", {
  deep <- list(list(
    label = "L1",
    children = list(list(
      label = "L2",
      children = list(list(
        label = "L3",
        children = list(list(prop = "a", label = "A"))
      ))
    ))
  ))
  html <- paste(
    as.character(
      htmltools::renderTags(el_table(
        "t",
        data = data.frame(a = 1),
        columns = deep
      ))$html
    ),
    collapse = ""
  )
  # three levels below the top, each its own v-for
  expect_match(html, "colxxx in colxx.children", fixed = TRUE)
})

test_that("a data.frame inside the rows is rows too", {
  rows <- .vue_rows(list(list(
    name = "Tom",
    family = data.frame(name = c("Jerry", "Spike"))
  )))
  expect_equal(
    rows_of(rows[[1]]$family),
    list(list(name = "Jerry"), list(name = "Spike"))
  )
  df <- data.frame(id = 1:2)
  df$tags <- list(c("a", "b"), "c")
  expect_equal(unlist(rows_of(.vue_rows(df))[[1]]$tags), c("a", "b"))
})

test_that("I() keeps a one-element cell an array", {
  df <- data.frame(id = 1:2)
  df$tags <- list(c("a", "b"), I("c"))
  json <- .vue_json(list(rows = .vue_rows(df)))
  expect_match(json, '"tags":["c"]', fixed = TRUE)
})

test_that("a bookmark brings a table's ticked rows back", {
  ctx <- shiny:::RestoreContext$new("?_inputs_&t1_selection_rows=%5B2%2C4%5D")
  html <- shiny:::withRestoreContext(
    ctx,
    render_html(el_table(id = "t1", data = head(iris, 5), selection = TRUE))
  )
  expect_match(html, '"restoredRows":[2,4]', fixed = TRUE)
  # ticked again once drawn, through Element's own toggleRowSelection
  expect_match(html, "toggleRowSelection(r, true)", fixed = TRUE)
  plain <- render_html(el_table(id = "t1", data = head(iris, 5)))
  expect_match(plain, '"restoredRows":[]', fixed = TRUE)
})

test_that("a table folded into a wrapper keeps its bookmark watcher", {
  html <- render_html(el_config_provider(
    table = list(showOverflowTooltip = TRUE),
    el_table(data = data.frame(a = 1))
  ))
  # renamed with the rest of its fields, handler included
  watch <- regmatches(html, regexpr('"watch":\\{"[^"]*restoredRows', html))
  expect_length(watch, 1)
  prefixed <- sub('.*"(\\w*restoredRows)$', "\\1", watch)
  expect_match(
    html,
    paste0("self.", sub("restoredRows", "tableData", prefixed)),
    fixed = TRUE
  )
})

# ── rows from the server ──────────────────────────────────────────────────────

edit_session <- function() {
  sent <- list()
  session <- list(
    ns = function(id) id,
    userData = new.env(),
    sendCustomMessage = function(type, msg) sent[[length(sent) + 1L]] <<- msg
  )
  list(session = session, sent = function() sent)
}

test_that("an edit changes the server's data as R would", {
  cars <- head(mtcars[, 1:2], 4)
  ins <- .el_table_apply_edit(
    cars,
    list(op = "insert", rows = mtcars[10, 1:2], at = 2L)
  )
  expect_equal(rownames(ins), rownames(mtcars)[c(1, 10, 2, 3, 4)])
  end <- .el_table_apply_edit(cars, list(op = "insert", rows = mtcars[10, 1:2]))
  expect_equal(rownames(end)[5], rownames(mtcars)[10])
  rep <- .el_table_apply_edit(
    cars,
    list(op = "replace", rows = data.frame(mpg = 0, cyl = 0), at = 3L)
  )
  expect_equal(rep$mpg, c(21, 21, 0, 21.4))
  expect_equal(rownames(rep), rownames(cars))
  del <- .el_table_apply_edit(cars, list(op = "delete", at = c(1L, 3L)))
  expect_identical(del, cars[c(2, 4), ])
  # a list of rows
  rows <- list(list(a = 1), list(a = 2))
  expect_equal(
    .el_table_apply_edit(
      rows,
      list(op = "insert", rows = list(list(a = 9)), at = 1L)
    ),
    list(list(a = 9), list(a = 1), list(a = 2))
  )
  expect_equal(
    .el_table_apply_edit(rows, list(op = "delete", at = 2L)),
    list(list(a = 1))
  )
})

test_that("update_el_table() sends only the rows edited, as the server holds them", {
  m <- edit_session()
  cars <- head(mtcars[, 1:2], 4)
  .el_table_rendered(m$session, "tbl", cars)
  update_el_table(m$session, "tbl", insert = mtcars[10, 1:2], at = 1)
  msg <- m$sent()[[1]]
  expect_null(msg$tableData)
  expect_equal(msg$tableEdit$op, "insert")
  json <- as.character(msg$tableEdit$rows)
  # the row name, as the table draws it
  expect_match(json, rownames(mtcars)[10], fixed = TRUE)
  expect_equal(nrow(.el_table_data(m$session, "tbl")), 5)

  update_el_table(m$session, "tbl", delete = c(1, 5))
  expect_equal(
    rownames(.el_table_data(m$session, "tbl")),
    rownames(cars)[1:3]
  )
  update_el_table(
    m$session,
    "tbl",
    replace = data.frame(mpg = 1, cyl = 2),
    at = 2
  )
  expect_equal(.el_table_data(m$session, "tbl")$mpg[2], 1)
  expect_equal(unclass(m$sent()[[3]]$tableEdit$at), 2L)

  expect_error(update_el_table(m$session, "tbl", delete = 9), "has 3 rows")
  expect_error(
    update_el_table(m$session, "tbl", insert = cars, delete = 1),
    "one of"
  )
  expect_error(update_el_table(m$session, "tbl", replace = cars), "needs `at`")
  expect_error(
    update_el_table(m$session, "tbl", replace = cars, at = 1),
    "4 rows for 1"
  )
  expect_error(update_el_table(m$session, "tbl", at = 1), "places")
})

test_that("a render after an update leaves the update's data unless its own changed", {
  m <- edit_session()
  a <- head(mtcars, 2)
  b <- head(mtcars, 5)
  .el_table_rendered(m$session, "tbl", a)
  update_el_table(m$session, "tbl", data = b)
  expect_identical(.el_table_data(m$session, "tbl"), b)
  # rendered again for another reason, with the same data: the browser
  # keeps b, and so does the server
  .el_table_rendered(m$session, "tbl", a)
  expect_identical(.el_table_data(m$session, "tbl"), b)
  # the render's own data changed: it is shown on both sides
  .el_table_rendered(m$session, "tbl", head(mtcars, 3))
  expect_identical(.el_table_data(m$session, "tbl"), head(mtcars, 3))
})

test_that("el_table_data() is a reactive read of the data shown", {
  m <- edit_session()
  expect_null(shiny::isolate(el_table_data(m$session, "tbl")))
  .el_table_rendered(m$session, "tbl", head(mtcars, 2))
  rows <- shiny::reactive(nrow(el_table_data(m$session, "tbl")))
  expect_equal(shiny::isolate(rows()), 2)
  update_el_table(m$session, "tbl", insert = mtcars[3, ])
  expect_equal(shiny::isolate(rows()), 3)
})

# ── editable cells ────────────────────────────────────────────────────────────

test_that("an editable column draws Element's editor for its cells", {
  html <- render_html(el_table(
    id = "t1",
    data = data.frame(a.b = 1, n = "x", d = "2020-01-01", k = "u"),
    columns = list(
      el_table_column("a.b", "A", editable = "number", editor = list(min = 0)),
      el_table_column("n", "N", editable = TRUE),
      el_table_column("d", "D", editable = "date"),
      el_table_column(
        "k",
        "K",
        editable = "select",
        editor = list(choices = c("u", "v"))
      )
    )
  ))
  expect_match(html, "<el-input-number", fixed = TRUE)
  expect_match(html, ':min="0"', fixed = TRUE)
  # the prop as the table has it, dots made underscores
  expect_match(html, "startEdit(scope, &#39;a_b&#39;)", fixed = TRUE)
  expect_match(html, "<el-input v-if", fixed = TRUE)
  expect_match(html, "<el-date-picker", fixed = TRUE)
  expect_match(html, "value-format=\"YYYY-MM-DD\"", fixed = TRUE)
  expect_match(html, "<el-select", fixed = TRUE)
  expect_match(html, "&#39;value&#39;:&#39;v&#39;", fixed = TRUE)
  expect_match(html, "t1_cell_edit:shiny.element.cell_edit", fixed = TRUE)
  expect_match(html, '"editableProp":"a_b"', fixed = TRUE)

  expect_error(
    render_html(el_table(
      data = data.frame(a = 1),
      columns = list(el_table_column("a", editable = "slider"))
    )),
    "one of"
  )
  expect_error(
    el_table(
      data = data.frame(a = 1),
      columns = list(el_table_column("a", editable = TRUE, cell = "x"))
    ),
    "not both"
  )
  expect_error(
    el_table(
      data = data.frame(a = 1),
      columns = list(list(label = "A", editable = TRUE))
    ),
    "needs a `prop`"
  )
  # a quote in a choice does not end the template's attribute
  html <- render_html(el_table(
    data = data.frame(k = "u"),
    columns = list(
      el_table_column("k", editable = "select", editor = list(choices = "it's"))
    )
  ))
  expect_match(html, "it\\u0027s", fixed = TRUE)
})

test_that("a cell edit is applied to the server's data, with the column's type", {
  m <- edit_session()
  cars <- head(mtcars[, 1:2], 3)
  cars$made <- as.Date("2020-01-01") + 0:2
  cars$kind <- factor(c("a", "b", "a"))
  cars$n_obs <- 1:3
  .el_table_rendered(m$session, "tbl", cars)
  edit <- function(column, value, row = 2) {
    .el_table_cell_edit(
      list(
        table = "tbl",
        row = row,
        column = column,
        value = value,
        old = NULL
      ),
      m$session
    )
  }
  got <- edit("mpg", 33.5)
  expect_equal(got, list(row = 2L, column = "mpg", value = 33.5, old = 21))
  got <- edit("made", "2024-02-29")
  expect_equal(got$value, as.Date("2024-02-29"))
  expect_equal(got$old, as.Date("2020-01-02"))
  got <- edit("kind", "c")
  expect_s3_class(got$value, "factor")
  expect_equal(as.character(got$value), "c")
  # the prop n_obs is the column n_obs; integers stay integers
  got <- edit("n_obs", 7)
  expect_identical(got$value, 7L)
  data <- .el_table_data(m$session, "tbl")
  expect_equal(data$mpg[2], 33.5)
  expect_equal(levels(data$kind), c("a", "b", "c"))
  expect_identical(rownames(data), rownames(cars))
  # a dotted column, reached by its prop
  .el_table_rendered(m$session, "ir", head(iris, 2))
  got <- .el_table_cell_edit(
    list(table = "ir", row = 1, column = "Sepal_Length", value = 9, old = 5.1),
    m$session
  )
  expect_equal(got$column, "Sepal.Length")
  expect_equal(.el_table_data(m$session, "ir")$Sepal.Length[1], 9)
  # a table the server does not hold: reported as sent
  got <- .el_table_cell_edit(
    list(table = "nope", row = 1, column = "a", value = "x", old = "y"),
    m$session
  )
  expect_equal(got, list(row = 1L, column = "a", value = "x", old = "y"))
})

# ── what a render sends ───────────────────────────────────────────────────────
#
# The wire, read with testServer(): the value render_el_table() hands Shiny
# is what crosses the websocket.

test_that("a render sends the table once, then only the data that changed", {
  shiny::testServer(
    function(input, output, session) {
      n <- shiny::reactiveVal(2)
      events <- shiny::reactiveVal(NULL)
      fail <- shiny::reactiveVal(FALSE)
      bump <- shiny::reactiveVal(0)
      session$userData$bump <- bump
      session$userData$n <- n
      session$userData$events <- events
      session$userData$fail <- fail
      output$tbl <- render_el_table({
        shiny::req(!fail())
        bump()
        el_table(
          data = head(mtcars[, 1:2], n()),
          selection = TRUE,
          events = events()
        )
      })
    },
    {
      set <- function(what, value) {
        session$userData[[what]](value)
        session$flushReact()
      }
      first <- output$tbl
      expect_named(first, c("html", "deps"))

      # other rows: the rows alone, as JSON the page reads
      set("n", 3)
      second <- output$tbl
      expect_named(second, "patch")
      expect_equal(second$patch$host, "tbl-el")
      expect_named(second$patch$fields, "tableData")
      sent <- jsonlite::fromJSON(second$patch$fields$tableData)
      expect_equal(nrow(sent$value), 3)
      expect_true(nchar(second$patch$fields$tableData) < nchar(first$html) / 3)
      # the server's copy follows
      expect_equal(nrow(.el_table_data(session, "tbl")), 3)

      # rendered again, nothing changed: an empty patch
      set("bump", 1)
      expect_named(output$tbl, "patch")
      expect_length(output$tbl$patch$fields, 0)

      # another event bound: the markup changed, so the table is sent whole
      set("events", "row-click")
      expect_named(output$tbl, c("html", "deps"))

      # an error empties the output: the next render draws it whole
      set("fail", TRUE)
      expect_error(output$tbl)
      set("fail", FALSE)
      expect_named(output$tbl, c("html", "deps"))
      set("n", 2)
      expect_named(output$tbl, "patch")

      # the page asks for the markup when it cannot patch
      session$setInputs(tbl__vue_redraw = 1)
      expect_named(output$tbl, c("html", "deps"))
    }
  )
})

test_that("el_table_output() trades Shiny's fading for the loading mask", {
  html <- render_html(el_table_output("tbl"))
  expect_match(html, "data-shiny-vue-loading", fixed = TRUE)
  expect_match(html, "--shiny-fade-opacity: 1", fixed = TRUE)
  plain <- render_html(el_table_output("tbl", loading = FALSE))
  expect_false(grepl("shiny-vue-loading", plain, fixed = TRUE))
})

test_that("a cached table output still sends each page only what changed", {
  runs <- 0
  shiny::testServer(
    function(input, output, session) {
      n <- shiny::reactiveVal(3)
      session$userData$n <- n
      table <- function() {
        runs <<- runs + 1
        el_table(data = head(mtcars[, 1:2], n()), selection = TRUE)
      }
      output$a <- shiny::bindCache(render_el_table(table()), n())
      output$b <- shiny::bindCache(render_el_table(table()), n())
    },
    {
      expect_named(output$a, c("html", "deps"))
      # the same table for another output: from the cache, but its page
      # has nothing yet, so it gets the markup
      expect_named(output$b, c("html", "deps"))
      expect_equal(runs, 1)
      session$userData$n(4)
      session$flushReact()
      expect_named(output$a, "patch")
      expect_equal(runs, 2)
      # back to a table seen before: read from the cache, compared with what
      # this page has, and the server's copy of the data follows
      session$userData$n(3)
      session$flushReact()
      back <- output$a
      expect_named(back, "patch")
      expect_named(back$patch$fields, "tableData")
      expect_equal(runs, 2)
      expect_equal(nrow(.el_table_data(session, "a")), 3)
    }
  )
  # bindEvent() works on it too
  expect_s3_class(
    shiny::bindEvent(render_el_table(el_table(data = head(mtcars))), 1),
    "shiny.render.function"
  )
})

test_that("render_el_table() waits for a promise", {
  skip_if_not_installed("promises")
  shiny::testServer(
    function(input, output, session) {
      output$tbl <- render_el_table(
        promises::promise_resolve(el_table(data = head(mtcars[, 1:2], 2)))
      )
    },
    {
      expect_named(output$tbl, c("html", "deps"))
      expect_equal(nrow(.el_table_data(session, "tbl")), 2)
    }
  )
})

test_that("a masked table output draws no busy spinner of Shiny's", {
  deps <- htmltools::findDependencies(el_table_output("tbl"))
  css <- Filter(function(d) d$name == "shiny-element-output", deps)
  expect_length(css, 1)
  expect_match(
    css[[1]]$head,
    "[data-shiny-busy-spinners] .shiny-vue-output[data-shiny-vue-loading].recalculating::after",
    fixed = TRUE
  )
})
