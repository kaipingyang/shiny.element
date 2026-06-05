render_html <- function(tag) {
  paste(as.character(tag), collapse = "")
}

# ── 基础结构 ──────────────────────────────────────────────────────────────────

test_that("el_switch: returns a tagList", {
  sw <- el_switch("sw1")
  expect_true(inherits(sw, "shiny.tag.list"))
})

test_that("el_switch: container div has correct id", {
  sw   <- el_switch("sw1", session = NULL)
  html <- render_html(sw)
  expect_match(html, 'id="sw1_container"')
})

test_that("el_switch: auto-generated id when NULL", {
  sw   <- el_switch(NULL, session = NULL)
  html <- render_html(sw)
  expect_match(html, 'id="el_switch_.*_container"')
})

# ── Vue data ──────────────────────────────────────────────────────────────────

test_that("el_switch: value=FALSE appears in Vue data", {
  sw   <- el_switch("sw1", value = FALSE, session = NULL)
  html <- render_html(sw)
  expect_match(html, '"value"\\s*:\\s*false')
})

test_that("el_switch: value=TRUE appears in Vue data", {
  sw   <- el_switch("sw1", value = TRUE, session = NULL)
  html <- render_html(sw)
  expect_match(html, '"value"\\s*:\\s*true')
})

test_that("el_switch: disabled=TRUE appears in Vue data", {
  sw   <- el_switch("sw1", disabled = TRUE, session = NULL)
  html <- render_html(sw)
  expect_match(html, '"disabled"\\s*:\\s*true')
})

test_that("el_switch: active_text appears in Vue data", {
  sw   <- el_switch("sw1", active_text = "On", session = NULL)
  html <- render_html(sw)
  expect_match(html, '"activeText"\\s*:\\s*"On"')
})

test_that("el_switch: inactive_text appears in Vue data", {
  sw   <- el_switch("sw1", inactive_text = "Off", session = NULL)
  html <- render_html(sw)
  expect_match(html, '"inactiveText"\\s*:\\s*"Off"')
})

test_that("el_switch: active_color appears in Vue data", {
  sw   <- el_switch("sw1", active_color = "#409EFF", session = NULL)
  html <- render_html(sw)
  expect_match(html, '"activeColor"\\s*:\\s*"#409EFF"')
})

test_that("el_switch: inactive_color appears in Vue data", {
  sw   <- el_switch("sw1", inactive_color = "#C0CCDA", session = NULL)
  html <- render_html(sw)
  expect_match(html, '"inactiveColor"\\s*:\\s*"#C0CCDA"')
})

test_that("el_switch: activeText defaults to empty string when active_text is NULL", {
  sw   <- el_switch("sw1", active_text = NULL, session = NULL)
  html <- render_html(sw)
  expect_match(html, '"activeText"\\s*:\\s*""')
})

test_that("el_switch: width appears in Vue data when set", {
  sw   <- el_switch("sw1", width = 100L, session = NULL)
  html <- render_html(sw)
  expect_match(html, '"width"\\s*:\\s*100')
})

# ── Vue 属性绑定 ──────────────────────────────────────────────────────────────

test_that("el_switch: v-model binding present", {
  sw   <- el_switch("sw1", session = NULL)
  html <- render_html(sw)
  expect_match(html, 'v-model')
})

test_that("el_switch: @change binding present", {
  sw   <- el_switch("sw1", session = NULL)
  html <- render_html(sw)
  expect_match(html, '@change')
})

test_that("el_switch: :disabled binding present", {
  sw   <- el_switch("sw1", session = NULL)
  html <- render_html(sw)
  expect_match(html, ':disabled')
})

test_that("el_switch: :active-text binding present", {
  sw   <- el_switch("sw1", session = NULL)
  html <- render_html(sw)
  expect_match(html, ':active-text')
})

test_that("el_switch: :inactive-text binding present", {
  sw   <- el_switch("sw1", session = NULL)
  html <- render_html(sw)
  expect_match(html, ':inactive-text')
})

test_that("el_switch: :active-value binding present", {
  sw   <- el_switch("sw1", session = NULL)
  html <- render_html(sw)
  expect_match(html, ':active-value')
})

test_that("el_switch: :inactive-value binding present", {
  sw   <- el_switch("sw1", session = NULL)
  html <- render_html(sw)
  expect_match(html, ':inactive-value')
})

# ── update_el_switch ──────────────────────────────────────────────────────────

test_that("update_el_switch: sends correct fields", {
  captured     <- NULL
  mock_session <- list(
    ns = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  update_el_switch(mock_session, "sw1",
    value          = TRUE,
    disabled       = TRUE,
    active_text    = "Yes",
    inactive_text  = "No",
    active_color   = "#67C23A",
    inactive_color = "#F56C6C"
  )
  expect_true(captured$value)
  expect_true(captured$disabled)
  expect_equal(captured$activeText,    "Yes")
  expect_equal(captured$inactiveText,  "No")
  expect_equal(captured$activeColor,   "#67C23A")
  expect_equal(captured$inactiveColor, "#F56C6C")
})

test_that("update_el_switch: NULL fields are excluded from message", {
  captured     <- NULL
  mock_session <- list(
    ns = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  update_el_switch(mock_session, "sw1", value = FALSE)
  expect_false(captured$value)
  expect_null(captured$disabled)
  expect_null(captured$activeText)
  expect_null(captured$inactiveText)
  expect_null(captured$activeColor)
  expect_null(captured$inactiveColor)
})
