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

# ── el_notification ───────────────────────────────────────────────────────────

test_that("el_notification: sends under the right message type", {
  out <- sent_message(function(s) el_notification(s, message = "hi"))
  expect_equal(out$type, "elNotification")
  expect_equal(out$msg$message, "hi")
})

test_that("el_notification: snake_case arguments become camelCase JS keys", {
  out <- sent_message(function(s) {
    el_notification(s, message = "hi", show_close = FALSE)
  })
  expect_false(out$msg$showClose)
  expect_null(out$msg$show_close)
})

test_that("el_notification: defaults match Element UI's", {
  out <- sent_message(function(s) el_notification(s, message = "hi"))
  expect_equal(out$msg$title, "")
  expect_equal(out$msg$type, "info")
  expect_equal(out$msg$duration, 4500)
  expect_equal(out$msg$position, "top-right")
  expect_true(out$msg$showClose)
  expect_equal(out$msg$offset, 0)
})

test_that("el_notification: every field passes through", {
  out <- sent_message(function(s) {
    el_notification(s, message = "body", title = "Done", type = "success",
                    duration = 0, position = "bottom-left", show_close = FALSE,
                    offset = 40)
  })
  expect_equal(out$msg$title, "Done")
  expect_equal(out$msg$type, "success")
  # 0 disables auto-close and must survive rather than being dropped.
  expect_equal(out$msg$duration, 0)
  expect_equal(out$msg$position, "bottom-left")
  expect_false(out$msg$showClose)
  expect_equal(out$msg$offset, 40)
})

test_that("el_notification: message is required", {
  expect_error(sent_message(function(s) el_notification(s)))
})

# ── el_message ────────────────────────────────────────────────────────────────

test_that("el_message: sends under the right message type", {
  out <- sent_message(function(s) el_message(s, message = "hi"))
  expect_equal(out$type, "elMessage")
  expect_equal(out$msg$message, "hi")
})

test_that("el_message: defaults match Element UI's", {
  out <- sent_message(function(s) el_message(s, message = "hi"))
  expect_equal(out$msg$type, "info")
  expect_equal(out$msg$duration, 3000)
  expect_false(out$msg$showClose)
  expect_false(out$msg$center)
})

test_that("el_message: every field passes through", {
  out <- sent_message(function(s) {
    el_message(s, message = "careful", type = "warning", duration = 0,
               show_close = TRUE, center = TRUE)
  })
  expect_equal(out$msg$type, "warning")
  expect_equal(out$msg$duration, 0)
  expect_true(out$msg$showClose)
  expect_true(out$msg$center)
})

test_that("el_message: carries no notification-only fields", {
  # The two share a shape; sending title/position here would be ignored by the
  # handler and is a sign of a copy-paste slip.
  out <- sent_message(function(s) el_message(s, message = "hi"))
  expect_null(out$msg$title)
  expect_null(out$msg$position)
  expect_null(out$msg$offset)
})

test_that("el_message: message is required", {
  expect_error(sent_message(function(s) el_message(s)))
})

# ── handler wiring ────────────────────────────────────────────────────────────

test_that("the feedback handler registers both message types", {
  js <- readLines(
    system.file("js", "el-feedback-handler.js", package = "shiny.element"),
    warn = FALSE
  )
  js <- paste(js, collapse = "\n")
  # Neither function renders any UI, so a missing handler fails silently.
  expect_match(js, "elNotification", fixed = TRUE)
  expect_match(js, "elMessage", fixed = TRUE)
})
