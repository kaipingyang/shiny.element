render_html <- function(tag) {
  paste(as.character(tag), collapse = "")
}

# Capture the custom message a server-side function sends. Named to avoid
# shadowing testthat::capture_message(), which catches conditions instead.
sent_message <- function(expr) {
  captured <- NULL
  session <- list(
    ns = function(id) id,
    sendCustomMessage = function(type, msg) captured <<- list(type = type, msg = msg)
  )
  expr(session)
  captured
}

# ── 基础结构 ──────────────────────────────────────────────────────────────────

test_that("el_calendar: returns a tagList with the container id", {
  cal <- el_calendar(id = "c1")
  expect_true(inherits(cal, "shiny.tag.list"))
  expect_match(render_html(cal), 'id="c1_container"')
})

test_that("el_calendar: binds value and first-day-of-week", {
  html <- render_html(el_calendar(id = "c1"))
  expect_match(html, 'v-model="value"')
  expect_match(html, ':first-day-of-week="firstDayOfWeek"')
})

test_that("el_calendar: attaches its own handler dependency", {
  deps <- htmltools::findDependencies(el_calendar(id = "c1"))
  expect_true("el-calendar-handler" %in% vapply(deps, function(d) d$name, character(1)))
})

# ── value ─────────────────────────────────────────────────────────────────────

test_that("el_calendar: defaults to today", {
  html <- render_html(el_calendar(id = "c1"))
  expect_match(html, sprintf('"value":"%s"', format(Sys.Date(), "%Y-%m-%d")))
})

test_that("el_calendar: a Date is formatted, a string passes through", {
  expect_match(render_html(el_calendar(id = "c1", value = as.Date("2026-03-01"))),
               '"value":"2026-03-01"')
  expect_match(render_html(el_calendar(id = "c1", value = "2026-03-01")),
               '"value":"2026-03-01"')
})

test_that("el_calendar: first_day_of_week reaches the data", {
  expect_match(render_html(el_calendar(id = "c1", first_day_of_week = 7)),
               '"firstDayOfWeek":7')
})

# ── range ─────────────────────────────────────────────────────────────────────

test_that("el_calendar: range is always bound, null when not supplied", {
  # Declared and bound even when not supplied: a field missing from the Vue
  # data is not reactive, so the matching update_*() argument would be a
  # silent no-op. NA serialises to JSON null, which Element treats as unset.
  expect_match(render_html(el_calendar(id = "c1")),
               sprintf(':range="%s"', .el_optional_bind("range")), fixed = TRUE)
  expect_match(render_html(el_calendar(id = "c1")), '"range":null', fixed = TRUE)

  html <- render_html(el_calendar(id = "c1", range = c("2026-03-01", "2026-03-31")))
  expect_match(html, sprintf(':range="%s"', .el_optional_bind("range")), fixed = TRUE)
  expect_match(html, '"range":\\["2026-03-01","2026-03-31"\\]')
})

test_that("el_calendar: Date ranges are coerced to strings", {
  html <- render_html(el_calendar(
    id = "c1", range = as.Date(c("2026-03-01", "2026-03-31"))
  ))
  expect_match(html, '"range":\\["2026-03-01","2026-03-31"\\]')
})

# ── reporting to Shiny ────────────────────────────────────────────────────────

test_that("el_calendar: reports its value on mount as well as on change", {
  # watch alone never fires on mount, so input$c1 would stay NULL until the
  # user picked a date. The value is the binding's: read on load, watched after.
  expect_equal(vue_spec_of(el_calendar(id = "c1"))$input, "value")
})

# ── update_el_calendar ────────────────────────────────────────────────────────

test_that("update_el_calendar: sends under the right message type", {
  out <- sent_message(function(s) update_el_calendar(s, "c1", value = "2026-05-05"))
  expect_equal(out$type, "updateElCalendar")
  expect_equal(out$msg$id, "c1")
  expect_equal(out$msg$value, "2026-05-05")
})

test_that("update_el_calendar: formats Dates the same way the UI does", {
  out <- sent_message(function(s) {
    update_el_calendar(s, "c1", value = as.Date("2026-05-05"))
  })
  expect_equal(out$msg$value, "2026-05-05")
})

test_that("update_el_calendar: range is coerced to character", {
  out <- sent_message(function(s) {
    update_el_calendar(s, "c1", range = as.Date(c("2026-05-01", "2026-05-31")))
  })
  expect_equal(out$msg$range, c("2026-05-01", "2026-05-31"))
})

test_that("update_el_calendar: NULL fields are excluded", {
  out <- sent_message(function(s) update_el_calendar(s, "c1", first_day_of_week = 7))
  expect_equal(out$msg$firstDayOfWeek, 7)
  expect_null(out$msg$value)
  expect_null(out$msg$range)
})
