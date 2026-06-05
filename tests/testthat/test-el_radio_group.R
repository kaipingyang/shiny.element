render_html <- function(tag) {
  paste(as.character(tag), collapse = "")
}

# ── 基础结构 ─────────────────────────────────────────────────────────────────

test_that("el_radio_group: returns a tagList", {
  rg <- el_radio_group("rg1", choices = c(A = "a", B = "b"))
  expect_true(inherits(rg, "shiny.tag.list"))
})

test_that("el_radio_group: container div has correct id", {
  rg   <- el_radio_group("rg1", choices = c(A = "a"), session = NULL)
  html <- render_html(rg)
  expect_match(html, 'id="rg1_container"')
})

test_that("el_radio_group: auto-generated id when NULL", {
  rg   <- el_radio_group(NULL, choices = c(A = "a"), session = NULL)
  html <- render_html(rg)
  expect_match(html, 'id="el_radio_group_.*_container"')
})

# ── Vue data fields ───────────────────────────────────────────────────────────

test_that("el_radio_group: named vector choices normalised to value/label pairs", {
  rg   <- el_radio_group("rg1", choices = c(Yes = "yes", No = "no"), session = NULL)
  html <- render_html(rg)
  expect_match(html, '"value"\\s*:\\s*"yes"')
  expect_match(html, '"label"\\s*:\\s*"Yes"')
})

test_that("el_radio_group: list of list choices passed through", {
  opts <- list(list(value = "x", label = "X"), list(value = "y", label = "Y"))
  rg   <- el_radio_group("rg1", choices = opts, session = NULL)
  html <- render_html(rg)
  expect_match(html, '"value"\\s*:\\s*"x"')
  expect_match(html, '"label"\\s*:\\s*"X"')
})

test_that("el_radio_group: unnamed vector uses element as both value and label", {
  rg   <- el_radio_group("rg1", choices = c("alpha", "beta"), session = NULL)
  html <- render_html(rg)
  expect_match(html, '"value"\\s*:\\s*"alpha"')
  expect_match(html, '"label"\\s*:\\s*"alpha"')
})

# ── selected 初始值 ───────────────────────────────────────────────────────────

test_that("el_radio_group: selected=NULL defaults to empty string", {
  rg   <- el_radio_group("rg1", choices = c(A = "a"), session = NULL)
  html <- render_html(rg)
  # The first "value" key in the data object should be ""
  expect_match(html, '"value"\\s*:\\s*""')
})

test_that("el_radio_group: selected value written to Vue data", {
  rg   <- el_radio_group("rg1", choices = c(A = "a", B = "b"), selected = "b", session = NULL)
  html <- render_html(rg)
  expect_match(html, '"value"\\s*:\\s*"b"')
})

# ── button=FALSE: uses el-radio ───────────────────────────────────────────────

test_that("el_radio_group: button=FALSE renders el-radio tag", {
  rg   <- el_radio_group("rg1", choices = c(A = "a"), button = FALSE, session = NULL)
  html <- render_html(rg)
  expect_match(html, "<el-radio")
  expect_false(grepl("<el-radio-button", html))
})

# ── button=TRUE: uses el-radio-button ────────────────────────────────────────

test_that("el_radio_group: button=TRUE renders el-radio-button tag", {
  rg   <- el_radio_group("rg1", choices = c(A = "a"), button = TRUE, session = NULL)
  html <- render_html(rg)
  expect_match(html, "<el-radio-button")
})

# ── v-for 绑定 ────────────────────────────────────────────────────────────────

test_that("el_radio_group: v-for attribute present on radio tag", {
  rg   <- el_radio_group("rg1", choices = c(A = "a"), session = NULL)
  html <- render_html(rg)
  expect_match(html, "v-for")
  expect_match(html, "opt in options")
})

test_that("el_radio_group: {{opt.label}} interpolation present", {
  rg   <- el_radio_group("rg1", choices = c(A = "a"), session = NULL)
  html <- render_html(rg)
  expect_match(html, "\\{\\{opt\\.label\\}\\}")
})

# ── @change 绑定 ──────────────────────────────────────────────────────────────

test_that("el_radio_group: @change binding present", {
  rg   <- el_radio_group("rg1", choices = c(A = "a"), session = NULL)
  html <- render_html(rg)
  expect_match(html, "@change")
})

test_that("el_radio_group: handleChange uses correct Shiny id", {
  rg   <- el_radio_group("rg1", choices = c(A = "a"), session = NULL)
  html <- render_html(rg)
  expect_match(html, "Shiny.setInputValue\\('rg1'")
})

# ── disabled ─────────────────────────────────────────────────────────────────

test_that("el_radio_group: disabled=TRUE written to Vue data", {
  rg   <- el_radio_group("rg1", choices = c(A = "a"), disabled = TRUE, session = NULL)
  html <- render_html(rg)
  expect_match(html, '"disabled"\\s*:\\s*true')
})

# ── size ─────────────────────────────────────────────────────────────────────

test_that("el_radio_group: size written to Vue data when provided", {
  rg   <- el_radio_group("rg1", choices = c(A = "a"), size = "mini", button = TRUE, session = NULL)
  html <- render_html(rg)
  expect_match(html, '"size"\\s*:\\s*"mini"')
})

# ── update_el_radio_group ─────────────────────────────────────────────────────

test_that("update_el_radio_group: sends correct message", {
  captured <- NULL
  mock_session <- list(
    ns = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  update_el_radio_group(mock_session, "rg1", value = "b", disabled = TRUE)
  expect_equal(captured$value, "b")
  expect_true(captured$disabled)
})

test_that("update_el_radio_group: NULL fields excluded from message", {
  captured <- NULL
  mock_session <- list(
    ns = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  update_el_radio_group(mock_session, "rg1", value = "a")
  expect_equal(captured$value, "a")
  expect_null(captured$disabled)
  expect_null(captured$options)
})

test_that("update_el_radio_group: options normalised when named vector passed", {
  captured <- NULL
  mock_session <- list(
    ns = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  update_el_radio_group(mock_session, "rg1", options = c(Cat = "cat", Dog = "dog"))
  expect_equal(captured$options[[1]]$value, "cat")
  expect_equal(captured$options[[1]]$label, "Cat")
})

test_that("update_el_radio_group: all fields sent when provided", {
  captured <- NULL
  mock_session <- list(
    ns = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  update_el_radio_group(mock_session, "rg1",
    value    = "y",
    options  = list(list(value = "y", label = "Y")),
    disabled = FALSE
  )
  expect_equal(captured$value,            "y")
  expect_equal(captured$options[[1]]$value, "y")
  expect_false(captured$disabled)
})
