render_html <- function(tag) {
  paste(as.character(tag), collapse = "")
}

# ── 基础结构 ─────────────────────────────────────────────────────────────────

test_that("el_dialog: returns a tagList", {
  result <- el_dialog("dlg1", session = NULL)
  expect_true(inherits(result, "shiny.tag.list"))
})

test_that("el_dialog: container div has correct id", {
  result <- el_dialog("dlg1", session = NULL)
  html   <- render_html(result)
  expect_match(html, 'id="dlg1_container"')
})

test_that("el_dialog: auto-generated id when NULL", {
  result <- el_dialog(NULL, session = NULL)
  html   <- render_html(result)
  expect_match(html, 'id="el_dialog_.*_container"')
})

# ── Vue data ─────────────────────────────────────────────────────────────────

test_that("el_dialog: visible=FALSE in Vue data by default", {
  result <- el_dialog("dlg1", session = NULL)
  html   <- render_html(result)
  expect_match(html, '"visible"\\s*:\\s*false')
})

test_that("el_dialog: visible=TRUE in Vue data when set", {
  result <- el_dialog("dlg1", visible = TRUE, session = NULL)
  html   <- render_html(result)
  expect_match(html, '"visible"\\s*:\\s*true')
})

test_that("el_dialog: title in Vue data", {
  result <- el_dialog("dlg1", title = "My Title", session = NULL)
  html   <- render_html(result)
  expect_match(html, '"title"\\s*:\\s*"My Title"')
})

test_that("el_dialog: width in Vue data", {
  result <- el_dialog("dlg1", width = "80%", session = NULL)
  html   <- render_html(result)
  expect_match(html, '"width"\\s*:\\s*"80%"')
})

# ── Vue 属性绑定 ──────────────────────────────────────────────────────────────

test_that("el_dialog: :visible.sync binding present", {
  result <- el_dialog("dlg1", session = NULL)
  html   <- render_html(result)
  expect_match(html, ':visible\\.sync="visible"')
})

test_that("el_dialog: :title binding present", {
  result <- el_dialog("dlg1", session = NULL)
  html   <- render_html(result)
  expect_match(html, ':title="title"')
})

test_that("el_dialog: @close binding present", {
  result <- el_dialog("dlg1", session = NULL)
  html   <- render_html(result)
  expect_match(html, '@close="handleClose"')
})

test_that("el_dialog: @open binding present", {
  result <- el_dialog("dlg1", session = NULL)
  html   <- render_html(result)
  expect_match(html, '@open="handleOpen"')
})

# ── footer slot ───────────────────────────────────────────────────────────────

test_that("el_dialog: footer slot rendered when footer provided", {
  result <- el_dialog(
    "dlg1",
    footer  = shiny::tags$button("OK"),
    session = NULL
  )
  html <- render_html(result)
  expect_match(html, 'slot="footer"')
})

test_that("el_dialog: no footer slot when footer is NULL", {
  result <- el_dialog("dlg1", footer = NULL, session = NULL)
  html   <- render_html(result)
  expect_false(grepl('slot="footer"', html))
})

# ── content ───────────────────────────────────────────────────────────────────

test_that("el_dialog: content rendered inside dialog", {
  result <- el_dialog(
    "dlg1",
    content = shiny::tags$p("Hello dialog"),
    session = NULL
  )
  html <- render_html(result)
  expect_match(html, "Hello dialog")
})

# ── update_el_dialog ─────────────────────────────────────────────────────────

test_that("update_el_dialog: visible=TRUE sent in message", {
  captured <- NULL
  mock_session <- list(
    ns = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  update_el_dialog(mock_session, "dlg1", visible = TRUE)
  expect_true(captured$visible)
})

test_that("update_el_dialog: visible=FALSE sent in message", {
  captured <- NULL
  mock_session <- list(
    ns = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  update_el_dialog(mock_session, "dlg1", visible = FALSE)
  expect_false(captured$visible)
})

test_that("update_el_dialog: title updated in message", {
  captured <- NULL
  mock_session <- list(
    ns = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  update_el_dialog(mock_session, "dlg1", title = "New Title")
  expect_equal(captured$title, "New Title")
})

test_that("update_el_dialog: width updated in message", {
  captured <- NULL
  mock_session <- list(
    ns = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  update_el_dialog(mock_session, "dlg1", width = "70%")
  expect_equal(captured$width, "70%")
})

test_that("update_el_dialog: id included in message", {
  captured <- NULL
  mock_session <- list(
    ns = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  update_el_dialog(mock_session, "dlg1", visible = TRUE)
  expect_equal(captured$id, "dlg1")
})

test_that("update_el_dialog: NULL fields excluded from message", {
  captured <- NULL
  mock_session <- list(
    ns = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  update_el_dialog(mock_session, "dlg1", visible = TRUE)
  expect_null(captured$title)
  expect_null(captured$width)
})
