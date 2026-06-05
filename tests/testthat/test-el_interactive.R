library(shiny)
library(shiny.element)

render_html <- function(tag) paste(as.character(tag), collapse = "")

# ── el_tag ────────────────────────────────────────────────────────────────────
test_that("el_tag: renders with label", {
  tag <- el_tag("t1", "My Tag")
  html <- render_html(tag)
  expect_match(html, "el-tag")
  expect_match(html, "My Tag")
})

test_that("el_tag: type attribute", {
  tag <- el_tag("t1", "Success", type = "success")
  html <- render_html(tag)
  expect_match(html, "success")
})

test_that("el_tag: closable attribute", {
  tag <- el_tag("t1", "Close", closable = TRUE)
  html <- render_html(tag)
  expect_match(html, ":closable")
})

test_that("el_tag: click handler fires Shiny.setInputValue", {
  tag <- el_tag("t1", "Tag")
  html <- render_html(tag)
  expect_match(html, "Shiny.setInputValue")
  expect_match(html, "handleClick")
})

test_that("el_tag: close handler fires _closed input", {
  tag <- el_tag("t1", "Tag", closable = TRUE)
  html <- render_html(tag)
  expect_match(html, "t1_closed")
})

test_that("el_tag: size attribute optional", {
  tag1 <- el_tag("t1", "T")
  html1 <- render_html(tag1)
  expect_no_match(html1, ":size")

  tag2 <- el_tag("t2", "T", size = "small")
  html2 <- render_html(tag2)
  expect_match(html2, ":size")
})

test_that("update_el_tag: sends correct message", {
  captured <- NULL
  mock_session <- list(ns = function(id) id,
                       sendCustomMessage = function(type, msg) { captured <<- msg })
  update_el_tag(mock_session, "t1", label = "New", type = "danger")
  expect_equal(captured$id, "t1")
  expect_equal(captured$label, "New")
  expect_equal(captured$type, "danger")
})

test_that("update_el_tag: only sends provided fields", {
  captured <- NULL
  mock_session <- list(ns = function(id) id,
                       sendCustomMessage = function(type, msg) { captured <<- msg })
  update_el_tag(mock_session, "t1", label = "X")
  expect_null(captured$type)
  expect_null(captured$closable)
})

# ── el_alert ─────────────────────────────────────────────────────────────────
test_that("el_alert: renders with title", {
  tag <- el_alert("a1", title = "Success!", type = "success")
  html <- render_html(tag)
  expect_match(html, "el-alert")
  expect_match(html, "Success!")
})

test_that("el_alert: type in Vue data", {
  tag <- el_alert("a1", type = "warning")
  html <- render_html(tag)
  expect_match(html, "warning")
})

test_that("el_alert: description in Vue data when provided", {
  tag <- el_alert("a1", description = "More details")
  html <- render_html(tag)
  expect_match(html, "More details")
})

test_that("el_alert: no description field when NULL", {
  tag <- el_alert("a1", title = "Alert")
  html <- render_html(tag)
  expect_no_match(html, ":description")
})

test_that("el_alert: close handler fires _closed input", {
  tag <- el_alert("a1")
  html <- render_html(tag)
  expect_match(html, "a1_closed")
  expect_match(html, "handleClose")
})

test_that("update_el_alert: sends correct message", {
  captured <- NULL
  mock_session <- list(ns = function(id) id,
                       sendCustomMessage = function(type, msg) { captured <<- msg })
  update_el_alert(mock_session, "a1", title = "Updated", type = "error")
  expect_equal(captured$id, "a1")
  expect_equal(captured$title, "Updated")
  expect_equal(captured$type, "error")
})

test_that("update_el_alert: only sends provided fields", {
  captured <- NULL
  mock_session <- list(ns = function(id) id,
                       sendCustomMessage = function(type, msg) { captured <<- msg })
  update_el_alert(mock_session, "a1", title = "X")
  expect_null(captured$type)
  expect_null(captured$description)
})

# ── el_collapse ───────────────────────────────────────────────────────────────
test_that("el_collapse: renders items", {
  tag <- el_collapse("c1",
    items = list(
      list(name = "p1", title = "Panel 1", content = tags$p("Content 1")),
      list(name = "p2", title = "Panel 2", content = tags$p("Content 2"))
    )
  )
  html <- render_html(tag)
  expect_match(html, "el-collapse")
  expect_match(html, "el-collapse-item")
  expect_match(html, "Panel 1")
  expect_match(html, "Content 2")
})

test_that("el_collapse: accordion mode in Vue data", {
  tag <- el_collapse("c1", items = list(), accordion = TRUE)
  html <- render_html(tag)
  expect_match(html, "true")
})

test_that("el_collapse: active value set", {
  tag <- el_collapse("c1",
    items = list(list(name = "p1", title = "T1", content = tags$p("x"))),
    value = "p1"
  )
  html <- render_html(tag)
  expect_match(html, "p1")
})

test_that("el_collapse: change handler fires Shiny input", {
  tag <- el_collapse("c1", items = list())
  html <- render_html(tag)
  expect_match(html, "handleChange")
  expect_match(html, "Shiny.setInputValue")
})

test_that("update_el_collapse: sends correct message", {
  captured <- NULL
  mock_session <- list(ns = function(id) id,
                       sendCustomMessage = function(type, msg) { captured <<- msg })
  update_el_collapse(mock_session, "c1", value = c("p1", "p2"))
  expect_equal(captured$id, "c1")
  expect_equal(captured$activeNames, list("p1", "p2"))
})

# ── el_rate ───────────────────────────────────────────────────────────────────
test_that("el_rate: renders component", {
  tag <- el_rate("r1", value = 3)
  html <- render_html(tag)
  expect_match(html, "el-rate")
})

test_that("el_rate: value in Vue data", {
  tag <- el_rate("r1", value = 4)
  html <- render_html(tag)
  expect_match(html, "\"value\":4")
})

test_that("el_rate: allow_half", {
  tag <- el_rate("r1", allow_half = TRUE)
  html <- render_html(tag)
  expect_match(html, "allowHalf")
  expect_match(html, "true")
})

test_that("el_rate: change handler", {
  tag <- el_rate("r1")
  html <- render_html(tag)
  expect_match(html, "handleChange")
})

test_that("update_el_rate: sends value", {
  captured <- NULL
  mock_session <- list(ns = function(id) id,
                       sendCustomMessage = function(type, msg) { captured <<- msg })
  update_el_rate(mock_session, "r1", value = 4)
  expect_equal(captured$value, 4)
})

test_that("update_el_rate: sends disabled", {
  captured <- NULL
  mock_session <- list(ns = function(id) id,
                       sendCustomMessage = function(type, msg) { captured <<- msg })
  update_el_rate(mock_session, "r1", disabled = TRUE)
  expect_true(captured$disabled)
})

# ── el_input_number ───────────────────────────────────────────────────────────
test_that("el_input_number: renders component", {
  tag <- el_input_number("n1", value = 5, min = 0, max = 100)
  html <- render_html(tag)
  expect_match(html, "el-input-number")
})

test_that("el_input_number: value in Vue data", {
  tag <- el_input_number("n1", value = 42)
  html <- render_html(tag)
  expect_match(html, "\"value\":42")
})

test_that("el_input_number: step attribute", {
  tag <- el_input_number("n1", step = 5)
  html <- render_html(tag)
  expect_match(html, "\"step\":5")
})

test_that("el_input_number: precision optional", {
  tag1 <- el_input_number("n1")
  html1 <- render_html(tag1)
  expect_no_match(html1, ":precision")

  tag2 <- el_input_number("n2", precision = 2)
  html2 <- render_html(tag2)
  expect_match(html2, ":precision")
})

test_that("el_input_number: Inf converted to large number", {
  tag <- el_input_number("n1")
  html <- render_html(tag)
  expect_match(html, "1e\\+308|1e308")
})

test_that("update_el_input_number: sends fields", {
  captured <- NULL
  mock_session <- list(ns = function(id) id,
                       sendCustomMessage = function(type, msg) { captured <<- msg })
  update_el_input_number(mock_session, "n1", value = 10, disabled = TRUE)
  expect_equal(captured$value, 10)
  expect_true(captured$disabled)
})
