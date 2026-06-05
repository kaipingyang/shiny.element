render_html <- function(tag) {
  paste(as.character(tag), collapse = "")
}

# ── 基础结构 ─────────────────────────────────────────────────────────────────

test_that("el_progress: returns a tagList", {
  pr <- el_progress("pr1", session = NULL)
  expect_true(inherits(pr, "shiny.tag.list"))
})

test_that("el_progress: container div has correct id", {
  pr   <- el_progress("pr1", session = NULL)
  html <- render_html(pr)
  expect_match(html, 'id="pr1_container"')
})

test_that("el_progress: auto-generated id when NULL", {
  pr   <- el_progress(NULL, session = NULL)
  html <- render_html(pr)
  expect_match(html, 'id="el_progress_.*_container"')
})

# ── Vue data 字段 ─────────────────────────────────────────────────────────────

test_that("el_progress: percentage appears in Vue data", {
  pr   <- el_progress("pr1", percentage = 75, session = NULL)
  html <- render_html(pr)
  expect_match(html, '"percentage"\\s*:\\s*75')
})

test_that("el_progress: type appears in Vue data", {
  pr   <- el_progress("pr1", type = "circle", session = NULL)
  html <- render_html(pr)
  expect_match(html, '"type"\\s*:\\s*"circle"')
})

test_that("el_progress: strokeWidth appears in Vue data", {
  pr   <- el_progress("pr1", stroke_width = 10, session = NULL)
  html <- render_html(pr)
  expect_match(html, '"strokeWidth"\\s*:\\s*10')
})

test_that("el_progress: showText=FALSE appears in Vue data", {
  pr   <- el_progress("pr1", show_text = FALSE, session = NULL)
  html <- render_html(pr)
  expect_match(html, '"showText"\\s*:\\s*false')
})

test_that("el_progress: textInside=TRUE appears in Vue data", {
  pr   <- el_progress("pr1", text_inside = TRUE, session = NULL)
  html <- render_html(pr)
  expect_match(html, '"textInside"\\s*:\\s*true')
})

test_that("el_progress: width appears in Vue data", {
  pr   <- el_progress("pr1", width = 200, session = NULL)
  html <- render_html(pr)
  expect_match(html, '"width"\\s*:\\s*200')
})

test_that("el_progress: status included in Vue data when set", {
  pr   <- el_progress("pr1", status = "success", session = NULL)
  html <- render_html(pr)
  expect_match(html, '"status"\\s*:\\s*"success"')
})

test_that("el_progress: status absent from Vue data when NULL", {
  pr   <- el_progress("pr1", status = NULL, session = NULL)
  html <- render_html(pr)
  expect_false(grepl('"status"', html))
})

test_that("el_progress: color included in Vue data when set", {
  pr   <- el_progress("pr1", color = "#409EFF", session = NULL)
  html <- render_html(pr)
  expect_match(html, '"color"\\s*:\\s*"#409EFF"')
})

test_that("el_progress: color absent from Vue data when NULL", {
  pr   <- el_progress("pr1", color = NULL, session = NULL)
  html <- render_html(pr)
  expect_false(grepl('"color"', html))
})

# ── Vue 属性绑定 ───────────────────────────────────────────────────────────────

test_that("el_progress: :percentage binding present on el-progress tag", {
  pr   <- el_progress("pr1", session = NULL)
  html <- render_html(pr)
  expect_match(html, ":percentage")
})

test_that("el_progress: :stroke-width binding present", {
  pr   <- el_progress("pr1", session = NULL)
  html <- render_html(pr)
  expect_match(html, ":stroke-width")
})

test_that("el_progress: :show-text binding present", {
  pr   <- el_progress("pr1", session = NULL)
  html <- render_html(pr)
  expect_match(html, ":show-text")
})

test_that("el_progress: :status binding present when status is set", {
  pr   <- el_progress("pr1", status = "warning", session = NULL)
  html <- render_html(pr)
  expect_match(html, ":status")
})

# ── update_el_progress ────────────────────────────────────────────────────────

test_that("update_el_progress: sends percentage update", {
  captured     <- NULL
  mock_session <- list(
    ns                = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  update_el_progress(mock_session, "pr1", percentage = 80)
  expect_equal(captured$percentage, 80)
})

test_that("update_el_progress: sends status and color update", {
  captured     <- NULL
  mock_session <- list(
    ns                = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  update_el_progress(mock_session, "pr1", status = "exception", color = "#F56C6C")
  expect_equal(captured$status, "exception")
  expect_equal(captured$color,  "#F56C6C")
})

test_that("update_el_progress: sends strokeWidth update", {
  captured     <- NULL
  mock_session <- list(
    ns                = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  update_el_progress(mock_session, "pr1", stroke_width = 12)
  expect_equal(captured$strokeWidth, 12)
})

test_that("update_el_progress: NULL fields excluded from message", {
  captured     <- NULL
  mock_session <- list(
    ns                = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  update_el_progress(mock_session, "pr1", percentage = 50)
  expect_equal(captured$percentage, 50)
  expect_null(captured$type)
  expect_null(captured$status)
  expect_null(captured$color)
})

test_that("update_el_progress: id is namespaced in message", {
  captured     <- NULL
  mock_session <- list(
    ns                = function(id) paste0("ns-", id),
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  update_el_progress(mock_session, "pr1", percentage = 0)
  expect_equal(captured$id, "ns-pr1")
})
