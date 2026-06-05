render_html <- function(tag) {
  paste(as.character(tag), collapse = "")
}

# ── 基础结构 ──────────────────────────────────────────────────────────────────

test_that("el_checkbox_group: returns a tagList", {
  cb <- el_checkbox_group("cb1", choices = c("A" = "a"))
  expect_true(inherits(cb, "shiny.tag.list"))
})

test_that("el_checkbox_group: container div has correct id", {
  cb   <- el_checkbox_group("cb1", choices = c("A" = "a"), session = NULL)
  html <- render_html(cb)
  expect_match(html, 'id="cb1_container"')
})

test_that("el_checkbox_group: auto-generated id when NULL", {
  cb   <- el_checkbox_group(NULL, choices = c("A" = "a"), session = NULL)
  html <- render_html(cb)
  expect_match(html, 'id="el_checkbox_group_.*_container"')
})

# ── Vue data ──────────────────────────────────────────────────────────────────

test_that("el_checkbox_group: value is empty array when selected is NULL", {
  cb   <- el_checkbox_group("cb1", choices = c("A" = "a"), selected = NULL, session = NULL)
  html <- render_html(cb)
  expect_match(html, '"value"\\s*:\\s*\\[\\]')
})

test_that("el_checkbox_group: selected values appear in Vue data value array", {
  cb   <- el_checkbox_group("cb1", choices = c("A" = "a", "B" = "b"),
                            selected = c("a", "b"), session = NULL)
  html <- render_html(cb)
  expect_match(html, '"value"\\s*:\\s*\\[')
  expect_match(html, '"a"')
  expect_match(html, '"b"')
})

test_that("el_checkbox_group: options contain choice labels and values", {
  cb   <- el_checkbox_group("cb1", choices = c("Label A" = "val_a"), session = NULL)
  html <- render_html(cb)
  expect_match(html, '"options"')
  expect_match(html, '"val_a"')
  expect_match(html, '"Label A"')
})

test_that("el_checkbox_group: disabled appears in Vue data", {
  cb   <- el_checkbox_group("cb1", choices = c("A" = "a"), disabled = TRUE, session = NULL)
  html <- render_html(cb)
  expect_match(html, '"disabled"\\s*:\\s*true')
})

test_that("el_checkbox_group: size appears in Vue data when set", {
  cb   <- el_checkbox_group("cb1", choices = c("A" = "a"), size = "small", session = NULL)
  html <- render_html(cb)
  expect_match(html, '"size"\\s*:\\s*"small"')
})

test_that("el_checkbox_group: min/max appear in Vue data when set", {
  cb   <- el_checkbox_group("cb1", choices = c("A" = "a", "B" = "b"),
                            min = 1, max = 2, session = NULL)
  html <- render_html(cb)
  expect_match(html, '"min"\\s*:\\s*1')
  expect_match(html, '"max"\\s*:\\s*2')
})

# ── button 样式 ───────────────────────────────────────────────────────────────

test_that("el_checkbox_group: button=FALSE uses el-checkbox tag", {
  cb   <- el_checkbox_group("cb1", choices = c("A" = "a"), button = FALSE, session = NULL)
  html <- render_html(cb)
  expect_match(html, "<el-checkbox")
  expect_false(grepl("<el-checkbox-button", html))
})

test_that("el_checkbox_group: button=TRUE uses el-checkbox-button tag", {
  cb   <- el_checkbox_group("cb1", choices = c("A" = "a"), button = TRUE, session = NULL)
  html <- render_html(cb)
  expect_match(html, "<el-checkbox-button")
})

# ── Vue 属性绑定 ──────────────────────────────────────────────────────────────

test_that("el_checkbox_group: v-model binding present on group tag", {
  cb   <- el_checkbox_group("cb1", choices = c("A" = "a"), session = NULL)
  html <- render_html(cb)
  expect_match(html, 'v-model')
})

test_that("el_checkbox_group: @change binding present on group tag", {
  cb   <- el_checkbox_group("cb1", choices = c("A" = "a"), session = NULL)
  html <- render_html(cb)
  expect_match(html, '@change')
})

test_that("el_checkbox_group: v-for binding present on checkbox tag", {
  cb   <- el_checkbox_group("cb1", choices = c("A" = "a"), session = NULL)
  html <- render_html(cb)
  expect_match(html, 'v-for')
})

# ── list 类型 choices ─────────────────────────────────────────────────────────

test_that("el_checkbox_group: list choices passed through", {
  cb   <- el_checkbox_group("cb1",
                            choices = list(list(value = "x", label = "X")),
                            session = NULL)
  html <- render_html(cb)
  expect_match(html, '"x"')
  expect_match(html, '"X"')
})

# ── update_el_checkbox_group ──────────────────────────────────────────────────

test_that("update_el_checkbox_group: sends correct fields", {
  captured     <- NULL
  mock_session <- list(
    ns = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  update_el_checkbox_group(mock_session, "cb1",
    value    = c("a"),
    disabled = TRUE,
    min      = 1,
    max      = 3
  )
  expect_equal(captured$value,    c("a"))
  expect_true(captured$disabled)
  expect_equal(captured$min,      1)
  expect_equal(captured$max,      3)
})

test_that("update_el_checkbox_group: NULL fields are excluded from message", {
  captured     <- NULL
  mock_session <- list(
    ns = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  update_el_checkbox_group(mock_session, "cb1", value = c("b"))
  expect_equal(captured$value, c("b"))
  expect_null(captured$disabled)
  expect_null(captured$min)
  expect_null(captured$max)
  expect_null(captured$options)
})
