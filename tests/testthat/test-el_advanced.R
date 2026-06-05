library(shiny)
library(shiny.element)

render_html <- function(tag) paste(as.character(tag), collapse = "")

# ── el_color_picker ───────────────────────────────────────────────────────────
test_that("el_color_picker: renders component", {
  tag <- el_color_picker("cp1", value = "#409EFF")
  html <- render_html(tag)
  expect_match(html, "el-color-picker")
})

test_that("el_color_picker: value in Vue data", {
  tag <- el_color_picker("cp1", value = "#ff0000")
  html <- render_html(tag)
  expect_match(html, "ff0000")
})

test_that("el_color_picker: show_alpha", {
  tag <- el_color_picker("cp1", show_alpha = TRUE)
  html <- render_html(tag)
  expect_match(html, "showAlpha")
  expect_match(html, "true")
})

test_that("el_color_picker: predefine list", {
  tag <- el_color_picker("cp1", predefine = c("#ff0000", "#00ff00"))
  html <- render_html(tag)
  expect_match(html, "ff0000")
  expect_match(html, "00ff00")
})

test_that("el_color_picker: change handler", {
  tag <- el_color_picker("cp1")
  html <- render_html(tag)
  expect_match(html, "handleChange")
})

test_that("update_el_color_picker: sends value", {
  captured <- NULL
  mock_session <- list(ns = function(id) id,
                       sendCustomMessage = function(type, msg) { captured <<- msg })
  update_el_color_picker(mock_session, "cp1", value = "#123456")
  expect_equal(captured$value, "#123456")
})

test_that("update_el_color_picker: sends disabled", {
  captured <- NULL
  mock_session <- list(ns = function(id) id,
                       sendCustomMessage = function(type, msg) { captured <<- msg })
  update_el_color_picker(mock_session, "cp1", disabled = TRUE)
  expect_true(captured$disabled)
})

# ── el_drawer ─────────────────────────────────────────────────────────────────
test_that("el_drawer: renders component", {
  tag <- el_drawer("d1", title = "Settings",
                   content = tags$p("Settings here."))
  html <- render_html(tag)
  expect_match(html, "el-drawer")
})

test_that("el_drawer: title in Vue data", {
  tag <- el_drawer("d1", title = "My Drawer")
  html <- render_html(tag)
  expect_match(html, "My Drawer")
})

test_that("el_drawer: direction attribute", {
  tag <- el_drawer("d1", direction = "ltr")
  html <- render_html(tag)
  expect_match(html, "ltr")
})

test_that("el_drawer: visible.sync binding", {
  tag <- el_drawer("d1")
  html <- render_html(tag)
  expect_match(html, "visible.sync")
})

test_that("el_drawer: open/close handlers fire _visible input", {
  tag <- el_drawer("d1")
  html <- render_html(tag)
  expect_match(html, "d1_visible")
  expect_match(html, "handleOpen")
  expect_match(html, "handleClose")
})

test_that("el_drawer: content rendered inside drawer", {
  tag <- el_drawer("d1", content = tags$p("Hello Drawer"))
  html <- render_html(tag)
  expect_match(html, "Hello Drawer")
})

test_that("update_el_drawer: sends visible TRUE", {
  captured <- NULL
  mock_session <- list(ns = function(id) id,
                       sendCustomMessage = function(type, msg) { captured <<- msg })
  update_el_drawer(mock_session, "d1", visible = TRUE)
  expect_equal(captured$id, "d1")
  expect_true(captured$visible)
})

test_that("update_el_drawer: sends title and size", {
  captured <- NULL
  mock_session <- list(ns = function(id) id,
                       sendCustomMessage = function(type, msg) { captured <<- msg })
  update_el_drawer(mock_session, "d1", title = "New Title", size = "50%")
  expect_equal(captured$title, "New Title")
  expect_equal(captured$size, "50%")
})

# ── el_dropdown ───────────────────────────────────────────────────────────────
test_that("el_dropdown: renders component", {
  tag <- el_dropdown("dd1", "Actions",
    items = list(
      list(command = "edit",   label = "Edit"),
      list(command = "delete", label = "Delete")
    )
  )
  html <- render_html(tag)
  expect_match(html, "el-dropdown")
  expect_match(html, "el-dropdown-menu")
  expect_match(html, "el-dropdown-item")
})

test_that("el_dropdown: trigger label rendered", {
  tag <- el_dropdown("dd1", "My Menu", items = list())
  html <- render_html(tag)
  expect_match(html, "My Menu")
})

test_that("el_dropdown: items rendered", {
  tag <- el_dropdown("dd1", "X",
    items = list(
      list(command = "c1", label = "Label One"),
      list(command = "c2", label = "Label Two")
    )
  )
  html <- render_html(tag)
  expect_match(html, "Label One")
  expect_match(html, "Label Two")
})

test_that("el_dropdown: command handler fires Shiny input", {
  tag <- el_dropdown("dd1", "X", items = list())
  html <- render_html(tag)
  expect_match(html, "handleCommand")
  expect_match(html, "Shiny.setInputValue")
})

test_that("el_dropdown: _count input registered", {
  tag <- el_dropdown("dd1", "X", items = list())
  html <- render_html(tag)
  expect_match(html, "dd1_count")
})

test_that("el_dropdown: item with icon", {
  tag <- el_dropdown("dd1", "X",
    items = list(list(command = "edit", icon = "el-icon-edit"))
  )
  html <- render_html(tag)
  expect_match(html, "el-icon-edit")
})

test_that("el_dropdown: divided item", {
  tag <- el_dropdown("dd1", "X",
    items = list(
      list(command = "a"),
      list(command = "b", divided = TRUE)
    )
  )
  html <- render_html(tag)
  expect_match(html, ":divided")
})

test_that("update_el_dropdown: sends disabled", {
  captured <- NULL
  mock_session <- list(ns = function(id) id,
                       sendCustomMessage = function(type, msg) { captured <<- msg })
  update_el_dropdown(mock_session, "dd1", disabled = TRUE)
  expect_equal(captured$id, "dd1")
  expect_true(captured$disabled)
})
