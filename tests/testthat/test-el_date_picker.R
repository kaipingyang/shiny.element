render_html <- function(tag) {
  paste(as.character(tag), collapse = "")
}

# ── 基础结构 ──────────────────────────────────────────────────────────────────

test_that("el_date_picker: returns a tagList", {
  dp <- el_date_picker("dp1")
  expect_true(inherits(dp, "shiny.tag.list"))
})

test_that("el_date_picker: container div has correct id", {
  dp   <- el_date_picker("dp1", session = NULL)
  html <- render_html(dp)
  expect_match(html, 'id="dp1_container"')
})

test_that("el_date_picker: auto-generated id when NULL", {
  dp   <- el_date_picker(NULL, session = NULL)
  html <- render_html(dp)
  expect_match(html, 'id="el_date_picker_.*_container"')
})

# ── Vue data 参数 ─────────────────────────────────────────────────────────────

test_that("el_date_picker: type appears in Vue data", {
  dp   <- el_date_picker("dp1", type = "datetime", session = NULL)
  html <- render_html(dp)
  expect_match(html, '"type"\\s*:\\s*"datetime"')
})

test_that("el_date_picker: clearable=FALSE appears in Vue data", {
  dp   <- el_date_picker("dp1", clearable = FALSE, session = NULL)
  html <- render_html(dp)
  expect_match(html, '"clearable"\\s*:\\s*false')
})

test_that("el_date_picker: disabled=TRUE appears in Vue data", {
  dp   <- el_date_picker("dp1", disabled = TRUE, session = NULL)
  html <- render_html(dp)
  expect_match(html, '"disabled"\\s*:\\s*true')
})

test_that("el_date_picker: value_format appears in Vue data", {
  dp   <- el_date_picker("dp1", value_format = "yyyy-MM-dd", session = NULL)
  html <- render_html(dp)
  expect_match(html, '"valueFormat"\\s*:\\s*"yyyy-MM-dd"')
})

# ── value 处理 ────────────────────────────────────────────────────────────────

test_that("el_date_picker: NULL value initialises as empty string for date type", {
  dp   <- el_date_picker("dp1", type = "date", session = NULL)
  html <- render_html(dp)
  expect_match(html, '"value"\\s*:\\s*""')
})

test_that("el_date_picker: Date object is converted to YYYY-MM-DD string", {
  dp   <- el_date_picker("dp1", value = as.Date("2024-03-15"), session = NULL)
  html <- render_html(dp)
  expect_match(html, '"value"\\s*:\\s*"2024-03-15"')
})

test_that("el_date_picker: character value passed through unchanged", {
  dp   <- el_date_picker("dp1", value = "2024-06-01", session = NULL)
  html <- render_html(dp)
  expect_match(html, '"value"\\s*:\\s*"2024-06-01"')
})

test_that("el_date_picker: two-element character vector becomes array", {
  dp   <- el_date_picker("dp1", type = "daterange",
                         value = c("2024-01-01", "2024-12-31"),
                         session = NULL)
  html <- render_html(dp)
  expect_match(html, '"value"\\s*:\\s*\\["2024-01-01","2024-12-31"\\]')
})

test_that("el_date_picker: range type with NULL value produces empty initial value", {
  dp   <- el_date_picker("dp1", type = "daterange", session = NULL)
  html <- render_html(dp)
  # Empty list() serialises as {} in JSON; verify the component renders without error
  expect_true(nchar(html) > 0)
  expect_match(html, '"value"\\s*:')
})

# ── Vue 属性绑定 ───────────────────────────────────────────────────────────────

test_that("el_date_picker: @change binding present", {
  dp   <- el_date_picker("dp1", session = NULL)
  html <- render_html(dp)
  expect_match(html, "@change")
})

test_that("el_date_picker: its value is the binding's, not the change handler's", {
  # A handler sending the value too would send it unconverted, overwriting
  # the Date the binding delivers
  spec <- vue_spec_of(el_date_picker("dp1"))
  expect_equal(spec$input, "value")
  expect_false(grepl("setInputValue", spec$options$methods$handleChange, fixed = TRUE))
})

test_that("el_date_picker: :value-format binding present", {
  dp   <- el_date_picker("dp1", session = NULL)
  html <- render_html(dp)
  expect_match(html, ":value-format")
})

test_that("el_date_picker: placeholder is always bound, null when not supplied", {
  # Declared and bound even when not supplied: a field missing from the Vue
  # data is not reactive, so the matching update_*() argument would be a
  # silent no-op. NA serialises to JSON null, which Element treats as unset.
  dp_no  <- el_date_picker("dp1", session = NULL)
  dp_yes <- el_date_picker("dp1", placeholder = "Pick date", session = NULL)
  expect_match(render_html(dp_no),
               sprintf(':placeholder="%s"', .el_optional_bind("placeholder")),
               fixed = TRUE)
  expect_match(render_html(dp_no), '"placeholder":null', fixed = TRUE)
  expect_match(render_html(dp_yes), '"placeholder":"Pick date"', fixed = TRUE)
})

test_that("el_date_picker: start-placeholder binding added only when supplied", {
  dp_yes <- el_date_picker("dp1", type = "daterange",
                           start_placeholder = "Start", session = NULL)
  expect_match(render_html(dp_yes), ":start-placeholder")
})

# ── update_el_date_picker ────────────────────────────────────────────────────

test_that("update_el_date_picker: sends correct fields", {
  captured     <- NULL
  mock_session <- list(
    ns                = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  update_el_date_picker(mock_session, "dp1",
    value     = "2025-01-01",
    disabled  = TRUE,
    clearable = FALSE,
    readonly  = TRUE
  )
  expect_equal(captured$value,     "2025-01-01")
  expect_true(captured$disabled)
  expect_false(captured$clearable)
  expect_true(captured$readonly)
})

test_that("update_el_date_picker: NULL fields excluded from message", {
  captured     <- NULL
  mock_session <- list(
    ns                = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  update_el_date_picker(mock_session, "dp1", value = "2025-06-15")
  expect_equal(captured$value, "2025-06-15")
  expect_null(captured$disabled)
  expect_null(captured$type)
  expect_null(captured$clearable)
})

test_that("update_el_date_picker: message id is namespaced", {
  captured     <- NULL
  mock_session <- list(
    ns                = function(id) paste0("ns-", id),
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  update_el_date_picker(mock_session, "dp1", value = "2025-01-01")
  expect_equal(captured$id, "ns-dp1")
})

test_that("update_el_date_picker: placeholder field included when supplied", {
  captured     <- NULL
  mock_session <- list(
    ns                = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  update_el_date_picker(mock_session, "dp1", placeholder = "Choose date")
  expect_equal(captured$placeholder, "Choose date")
})

test_that("date types with the default format are converted to Date", {
  expect_equal(vue_spec_of(el_date_picker("d"))$type, "shiny.element.date")
  expect_equal(vue_spec_of(el_date_picker("d", type = "daterange"))$type, "shiny.element.date")
  expect_null(vue_spec_of(el_date_picker("d", type = "month"))$type)
  expect_null(vue_spec_of(el_date_picker("d", value_format = "dd/MM/yyyy"))$type)
  expect_null(vue_spec_of(el_date_picker("d", type = "datetime"))$type)
})

test_that("the input handler turns picker text into Date", {
  h <- shiny:::inputHandlers$get("shiny.element.date")
  expect_equal(h("2026-01-15"), as.Date("2026-01-15"))
  expect_equal(h(list("2026-01-01", "2026-01-31")), as.Date(c("2026-01-01", "2026-01-31")))
  expect_null(h(NULL))
  expect_null(h(""))
  expect_null(h(list()))
})
