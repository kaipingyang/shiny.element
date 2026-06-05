render_html <- function(tag) {
  paste(as.character(tag), collapse = "")
}

# ── 基础结构 ─────────────────────────────────────────────────────────────────

test_that("el_pagination: returns a tagList", {
  pg <- el_pagination("pg1", total = 100, session = NULL)
  expect_true(inherits(pg, "shiny.tag.list"))
})

test_that("el_pagination: container div has correct id", {
  pg   <- el_pagination("pg1", total = 100, session = NULL)
  html <- render_html(pg)
  expect_match(html, 'id="pg1_container"')
})

test_that("el_pagination: auto-generated id when NULL", {
  pg   <- el_pagination(NULL, total = 50, session = NULL)
  html <- render_html(pg)
  expect_match(html, 'id="el_pagination_.*_container"')
})

# ── Vue data 字段 ─────────────────────────────────────────────────────────────

test_that("el_pagination: total appears in Vue data", {
  pg   <- el_pagination("pg1", total = 200, session = NULL)
  html <- render_html(pg)
  expect_match(html, '"total"\\s*:\\s*200')
})

test_that("el_pagination: pageSize appears in Vue data", {
  pg   <- el_pagination("pg1", total = 100, page_size = 20, session = NULL)
  html <- render_html(pg)
  expect_match(html, '"pageSize"\\s*:\\s*20')
})

test_that("el_pagination: currentPage appears in Vue data", {
  pg   <- el_pagination("pg1", total = 100, current_page = 3, session = NULL)
  html <- render_html(pg)
  expect_match(html, '"currentPage"\\s*:\\s*3')
})

test_that("el_pagination: pageSizes is a list in Vue data", {
  pg   <- el_pagination("pg1", total = 100, page_sizes = c(10, 20, 50), session = NULL)
  html <- render_html(pg)
  # as.list() gives JSON array, check for array notation
  expect_match(html, '"pageSizes"\\s*:\\s*\\[')
})

test_that("el_pagination: layout appears in Vue data", {
  layout_str <- "prev, pager, next"
  pg         <- el_pagination("pg1", total = 100, layout = layout_str, session = NULL)
  html       <- render_html(pg)
  expect_match(html, '"layout"\\s*:\\s*"prev, pager, next"')
})

test_that("el_pagination: background=TRUE appears in Vue data", {
  pg   <- el_pagination("pg1", total = 100, background = TRUE, session = NULL)
  html <- render_html(pg)
  expect_match(html, '"background"\\s*:\\s*true')
})

test_that("el_pagination: small=TRUE appears in Vue data", {
  pg   <- el_pagination("pg1", total = 100, small = TRUE, session = NULL)
  html <- render_html(pg)
  expect_match(html, '"small"\\s*:\\s*true')
})

test_that("el_pagination: disabled=TRUE appears in Vue data", {
  pg   <- el_pagination("pg1", total = 100, disabled = TRUE, session = NULL)
  html <- render_html(pg)
  expect_match(html, '"disabled"\\s*:\\s*true')
})

test_that("el_pagination: pagerCount appears in Vue data", {
  pg   <- el_pagination("pg1", total = 100, pager_count = 9, session = NULL)
  html <- render_html(pg)
  expect_match(html, '"pagerCount"\\s*:\\s*9')
})

# ── Vue 属性绑定 ───────────────────────────────────────────────────────────────

test_that("el_pagination: @current-change binding present", {
  pg   <- el_pagination("pg1", total = 100, session = NULL)
  html <- render_html(pg)
  expect_match(html, "@current-change")
})

test_that("el_pagination: @size-change binding present", {
  pg   <- el_pagination("pg1", total = 100, session = NULL)
  html <- render_html(pg)
  expect_match(html, "@size-change")
})

# ── update_el_pagination ──────────────────────────────────────────────────────

test_that("update_el_pagination: sends correct message with total and currentPage", {
  captured     <- NULL
  mock_session <- list(
    ns                = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  update_el_pagination(mock_session, "pg1", total = 500, current_page = 2)
  expect_equal(captured$total,       500)
  expect_equal(captured$currentPage, 2)
})

test_that("update_el_pagination: sends correct message with pageSize and disabled", {
  captured     <- NULL
  mock_session <- list(
    ns                = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  update_el_pagination(mock_session, "pg1", page_size = 50, disabled = TRUE)
  expect_equal(captured$pageSize, 50)
  expect_true(captured$disabled)
})

test_that("update_el_pagination: NULL fields excluded from message", {
  captured     <- NULL
  mock_session <- list(
    ns                = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  update_el_pagination(mock_session, "pg1", total = 300)
  expect_equal(captured$total, 300)
  expect_null(captured$currentPage)
  expect_null(captured$pageSize)
  expect_null(captured$disabled)
})

test_that("update_el_pagination: id is namespaced in message", {
  captured     <- NULL
  mock_session <- list(
    ns                = function(id) paste0("ns-", id),
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  update_el_pagination(mock_session, "pg1", total = 100)
  expect_equal(captured$id, "ns-pg1")
})
