library(shiny)
library(shiny.element)

render_html <- function(tag) paste(as.character(tag), collapse = "")

# ── el_divider ────────────────────────────────────────────────────────────────
test_that("el_divider: default horizontal", {
  tag <- el_divider()
  html <- render_html(tag)
  expect_match(html, "el-divider--horizontal")
})

test_that("el_divider: vertical", {
  tag <- el_divider(direction = "vertical")
  html <- render_html(tag)
  expect_match(html, "el-divider--vertical")
})

test_that("el_divider: horizontal with content", {
  tag <- el_divider("Section Title", content_position = "left")
  html <- render_html(tag)
  expect_match(html, "el-divider__text")
  expect_match(html, "is-left")
  expect_match(html, "Section Title")
})

test_that("el_divider: vertical ignores content", {
  tag <- el_divider("ignored", direction = "vertical")
  html <- render_html(tag)
  expect_no_match(html, "el-divider__text")
})

test_that("el_divider: content_position center default", {
  tag <- el_divider("Center")
  html <- render_html(tag)
  expect_match(html, "is-center")
})

# ── el_card ───────────────────────────────────────────────────────────────────
test_that("el_card: renders with body content", {
  tag <- el_card(tags$p("Body"))
  html <- render_html(tag)
  expect_match(html, "el-card")
  expect_match(html, "el-card__body")
  expect_match(html, "Body")
})

test_that("el_card: always shadow is default", {
  tag <- el_card(tags$p("x"))
  html <- render_html(tag)
  expect_match(html, "is-always-shadow")
})

test_that("el_card: hover shadow", {
  tag <- el_card(tags$p("x"), shadow = "hover")
  html <- render_html(tag)
  expect_match(html, "is-hover-shadow")
})

test_that("el_card: with header", {
  tag <- el_card(tags$p("x"), header = "My Header")
  html <- render_html(tag)
  expect_match(html, "el-card__header")
  expect_match(html, "My Header")
})

test_that("el_card: no header by default", {
  tag <- el_card(tags$p("x"))
  html <- render_html(tag)
  expect_no_match(html, "el-card__header")
})

test_that("el_card: body_style applied", {
  tag <- el_card(tags$p("x"), body_style = "padding: 20px;")
  html <- render_html(tag)
  expect_match(html, "padding: 20px")
})

# ── el_badge ─────────────────────────────────────────────────────────────────
test_that("el_badge: numeric value", {
  tag <- el_badge(tags$span("x"), value = 5)
  html <- render_html(tag)
  expect_match(html, "el-badge")
  expect_match(html, "el-badge__content")
  expect_match(html, ">5<")
})

test_that("el_badge: max+ truncation", {
  tag <- el_badge(tags$span("x"), value = 200, max = 99)
  html <- render_html(tag)
  expect_match(html, "99\\+")
})

test_that("el_badge: value within max", {
  tag <- el_badge(tags$span("x"), value = 50, max = 99)
  html <- render_html(tag)
  expect_match(html, ">50<")
  expect_no_match(html, "\\+")
})

test_that("el_badge: is_dot mode", {
  tag <- el_badge(tags$span("x"), is_dot = TRUE)
  html <- render_html(tag)
  expect_match(html, "is-dot")
})

test_that("el_badge: hidden hides badge", {
  tag <- el_badge(tags$span("x"), value = 5, hidden = TRUE)
  html <- render_html(tag)
  expect_no_match(html, "el-badge__content")
})

test_that("el_badge: type class applied", {
  tag <- el_badge(tags$span("x"), value = 5, type = "primary")
  html <- render_html(tag)
  expect_match(html, "el-badge__content--primary")
})

test_that("el_badge: is-fixed when wrapping content", {
  tag <- el_badge(tags$span("x"), value = 5)
  html <- render_html(tag)
  expect_match(html, "is-fixed")
})

# ── el_link ───────────────────────────────────────────────────────────────────
test_that("el_link: default type", {
  tag <- el_link("Click")
  html <- render_html(tag)
  expect_match(html, "el-link--default")
})

test_that("el_link: primary type", {
  tag <- el_link("Click", type = "primary")
  html <- render_html(tag)
  expect_match(html, "el-link--primary")
})

test_that("el_link: href set", {
  tag <- el_link("GitHub", href = "https://github.com")
  html <- render_html(tag)
  expect_match(html, "https://github.com")
})

test_that("el_link: disabled removes href", {
  tag <- el_link("Link", href = "https://example.com", disabled = TRUE)
  html <- render_html(tag)
  expect_match(html, "is-disabled")
  expect_no_match(html, "https://example.com")
})

test_that("el_link: underline class", {
  tag <- el_link("Link", underline = TRUE)
  html <- render_html(tag)
  expect_match(html, "is-underline")
})

test_that("el_link: no underline when disabled", {
  tag <- el_link("Link", disabled = TRUE)
  html <- render_html(tag)
  expect_no_match(html, "is-underline")
})

test_that("el_link: icon rendered", {
  tag <- el_link("Edit", icon = "el-icon-edit")
  html <- render_html(tag)
  expect_match(html, "el-icon-edit")
})
