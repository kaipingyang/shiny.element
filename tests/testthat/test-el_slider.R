render_html <- function(tag) {
  paste(as.character(tag), collapse = "")
}

# ── 基础结构 ──────────────────────────────────────────────────────────────────

test_that("el_slider: returns a tagList", {
  s <- el_slider("slider1")
  expect_true(inherits(s, "shiny.tag.list"))
})

test_that("el_slider: container div has correct id", {
  s    <- el_slider("slider1", session = NULL)
  html <- render_html(s)
  expect_match(html, 'id="slider1_container"')
})

test_that("el_slider: auto-generated id when NULL", {
  s    <- el_slider(NULL, session = NULL)
  html <- render_html(s)
  expect_match(html, 'id="el_slider_.*_container"')
})

# ── Vue data 参数 ─────────────────────────────────────────────────────────────

test_that("el_slider: min appears in Vue data", {
  s    <- el_slider("s1", min = 10, session = NULL)
  html <- render_html(s)
  expect_match(html, '"min"\\s*:\\s*10')
})

test_that("el_slider: max appears in Vue data", {
  s    <- el_slider("s1", max = 50, session = NULL)
  html <- render_html(s)
  expect_match(html, '"max"\\s*:\\s*50')
})

test_that("el_slider: step appears in Vue data", {
  s    <- el_slider("s1", step = 5, session = NULL)
  html <- render_html(s)
  expect_match(html, '"step"\\s*:\\s*5')
})

test_that("el_slider: disabled=TRUE appears in Vue data", {
  s    <- el_slider("s1", disabled = TRUE, session = NULL)
  html <- render_html(s)
  expect_match(html, '"disabled"\\s*:\\s*true')
})

# ── value 处理 ────────────────────────────────────────────────────────────────

test_that("el_slider: scalar value appears in Vue data", {
  s    <- el_slider("s1", value = 30, session = NULL)
  html <- render_html(s)
  expect_match(html, '"value"\\s*:\\s*30')
})

test_that("el_slider: range value converts to array in Vue data", {
  s    <- el_slider("s1", value = c(20, 80), range = TRUE, session = NULL)
  html <- render_html(s)
  expect_match(html, '"value"\\s*:\\s*\\[20,\\s*80\\]')
})

test_that("el_slider: range=TRUE with scalar value extends to c(value, max)", {
  s    <- el_slider("s1", value = 10, range = TRUE, max = 100, session = NULL)
  html <- render_html(s)
  expect_match(html, '"value"\\s*:\\s*\\[10,\\s*100\\]')
})

# ── Vue 属性绑定 ───────────────────────────────────────────────────────────────

test_that("el_slider: @change binding present on el-slider tag", {
  s    <- el_slider("s1", session = NULL)
  html <- render_html(s)
  expect_match(html, "@change")
})

test_that("el_slider: handleChange contains ns_id for Shiny input", {
  s    <- el_slider("s1", session = NULL)
  html <- render_html(s)
  expect_match(html, "setInputValue[^']*'s1'")
})

test_that("el_slider: :min and :max bindings present", {
  s    <- el_slider("s1", session = NULL)
  html <- render_html(s)
  expect_match(html, ":min")
  expect_match(html, ":max")
})

# ── update_el_slider ──────────────────────────────────────────────────────────

test_that("update_el_slider: sends correct fields", {
  captured     <- NULL
  mock_session <- list(
    ns                 = function(id) id,
    sendCustomMessage  = function(type, msg) { captured <<- msg }
  )
  update_el_slider(mock_session, "s1",
    value    = 60,
    min      = 0,
    max      = 100,
    step     = 5,
    disabled = TRUE
  )
  expect_equal(captured$value,    60)
  expect_equal(captured$min,      0)
  expect_equal(captured$max,      100)
  expect_equal(captured$step,     5)
  expect_true(captured$disabled)
})

test_that("update_el_slider: NULL fields excluded from message", {
  captured     <- NULL
  mock_session <- list(
    ns                = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  update_el_slider(mock_session, "s1", value = 40)
  expect_equal(captured$value, 40)
  expect_null(captured$min)
  expect_null(captured$max)
  expect_null(captured$step)
  expect_null(captured$disabled)
})

test_that("update_el_slider: message id is namespaced", {
  captured     <- NULL
  mock_session <- list(
    ns                = function(id) paste0("ns-", id),
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  update_el_slider(mock_session, "s1", value = 10)
  expect_equal(captured$id, "ns-s1")
})
