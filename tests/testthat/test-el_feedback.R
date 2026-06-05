# ── el_notification ───────────────────────────────────────────────────────────

test_that("el_notification: sends 'elNotification' custom message", {
  msg_type     <- NULL
  captured     <- NULL
  mock_session <- list(
    ns                = function(id) id,
    sendCustomMessage = function(type, msg) {
      msg_type <<- type
      captured <<- msg
    }
  )
  el_notification(mock_session, message = "Hello world")
  expect_equal(msg_type, "elNotification")
})

test_that("el_notification: message field is passed correctly", {
  captured     <- NULL
  mock_session <- list(
    ns                = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  el_notification(mock_session, message = "Test notification body")
  expect_equal(captured$message, "Test notification body")
})

test_that("el_notification: title field is passed correctly", {
  captured     <- NULL
  mock_session <- list(
    ns                = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  el_notification(mock_session, message = "body", title = "My Title")
  expect_equal(captured$title, "My Title")
})

test_that("el_notification: type field is passed correctly", {
  captured     <- NULL
  mock_session <- list(
    ns                = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  el_notification(mock_session, message = "body", type = "success")
  expect_equal(captured$type, "success")
})

test_that("el_notification: duration field is passed correctly", {
  captured     <- NULL
  mock_session <- list(
    ns                = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  el_notification(mock_session, message = "body", duration = 0)
  expect_equal(captured$duration, 0)
})

test_that("el_notification: position field is passed correctly", {
  captured     <- NULL
  mock_session <- list(
    ns                = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  el_notification(mock_session, message = "body", position = "bottom-left")
  expect_equal(captured$position, "bottom-left")
})

test_that("el_notification: showClose field is passed correctly", {
  captured     <- NULL
  mock_session <- list(
    ns                = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  el_notification(mock_session, message = "body", show_close = FALSE)
  expect_false(captured$showClose)
})

test_that("el_notification: offset field is passed correctly", {
  captured     <- NULL
  mock_session <- list(
    ns                = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  el_notification(mock_session, message = "body", offset = 50)
  expect_equal(captured$offset, 50)
})

test_that("el_notification: defaults are correct", {
  captured     <- NULL
  mock_session <- list(
    ns                = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  el_notification(mock_session, message = "body")
  expect_equal(captured$title,     "")
  expect_equal(captured$type,      "info")
  expect_equal(captured$duration,  4500)
  expect_equal(captured$position,  "top-right")
  expect_true(captured$showClose)
  expect_equal(captured$offset,    0)
})

# ── el_message ────────────────────────────────────────────────────────────────

test_that("el_message: sends 'elMessage' custom message", {
  msg_type     <- NULL
  captured     <- NULL
  mock_session <- list(
    ns                = function(id) id,
    sendCustomMessage = function(type, msg) {
      msg_type <<- type
      captured <<- msg
    }
  )
  el_message(mock_session, message = "Toast text")
  expect_equal(msg_type, "elMessage")
})

test_that("el_message: message field is passed correctly", {
  captured     <- NULL
  mock_session <- list(
    ns                = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  el_message(mock_session, message = "Info toast")
  expect_equal(captured$message, "Info toast")
})

test_that("el_message: type field is passed correctly", {
  captured     <- NULL
  mock_session <- list(
    ns                = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  el_message(mock_session, message = "body", type = "error")
  expect_equal(captured$type, "error")
})

test_that("el_message: duration field is passed correctly", {
  captured     <- NULL
  mock_session <- list(
    ns                = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  el_message(mock_session, message = "body", duration = 5000)
  expect_equal(captured$duration, 5000)
})

test_that("el_message: showClose field is passed correctly", {
  captured     <- NULL
  mock_session <- list(
    ns                = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  el_message(mock_session, message = "body", show_close = TRUE)
  expect_true(captured$showClose)
})

test_that("el_message: center field is passed correctly", {
  captured     <- NULL
  mock_session <- list(
    ns                = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  el_message(mock_session, message = "body", center = TRUE)
  expect_true(captured$center)
})

test_that("el_message: defaults are correct", {
  captured     <- NULL
  mock_session <- list(
    ns                = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  el_message(mock_session, message = "body")
  expect_equal(captured$type,      "info")
  expect_equal(captured$duration,  3000)
  expect_false(captured$showClose)
  expect_false(captured$center)
})
