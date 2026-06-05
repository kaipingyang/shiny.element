test_that("el_icon: basic element-ui icon", {
  icon <- el_icon("search")
  expect_equal(icon$name, "i")
  expect_match(icon$attribs$class, "el-icon-search")
})

test_that("el_icon: backward compat — same output as old el_icon", {
  old <- el_icon("search")
  new <- el_icon("search", a11y = "none")
  expect_equal(old$name,          new$name)
  expect_equal(old$attribs$class, new$attribs$class)
})

# ── name normalization ──────────────────────────────────────────────────────

test_that("el_icon: name uppercased → lowercased", {
  icon <- el_icon("SEARCH")
  expect_match(icon$attribs$class, "el-icon-search")
})

test_that("el_icon: spaces in name → dashes", {
  icon <- el_icon("arrow left")
  expect_match(icon$attribs$class, "el-icon-arrow-left")
})

test_that("el_icon: el-icon- prefix not doubled", {
  icon <- el_icon("el-icon-search")
  expect_equal(icon$attribs$class, "el-icon-search")
})

# ── size ────────────────────────────────────────────────────────────────────

test_that("el_icon: size adds font-size style", {
  icon <- el_icon("search", size = "2em")
  expect_match(icon$attribs$style, "font-size:2em")
})

test_that("el_icon: size NULL produces no style", {
  icon <- el_icon("search")
  expect_null(icon$attribs$style)
})

test_that("el_icon: size validates CSS unit (px)", {
  icon <- el_icon("search", size = "20px")
  expect_match(icon$attribs$style, "font-size:20px")
})

# ── extra class ─────────────────────────────────────────────────────────────

test_that("el_icon: extra class is appended", {
  icon <- el_icon("search", class = "my-class")
  expect_match(icon$attribs$class, "el-icon-search")
  expect_match(icon$attribs$class, "my-class")
})

# ── a11y ────────────────────────────────────────────────────────────────────

test_that("el_icon: a11y auto + no title → deco (aria-hidden)", {
  icon <- el_icon("search")
  expect_equal(icon$attribs[["aria-hidden"]], "true")
  expect_equal(icon$attribs$role, "img")
  expect_null(icon$attribs[["aria-label"]])
})

test_that("el_icon: a11y auto + title → sem (aria-label)", {
  icon <- el_icon("search", title = "Search")
  expect_equal(icon$attribs[["aria-label"]], "Search")
  expect_equal(icon$attribs$role, "img")
  expect_null(icon$attribs[["aria-hidden"]])
})

test_that("el_icon: a11y deco adds aria-hidden", {
  icon <- el_icon("search", a11y = "deco")
  expect_equal(icon$attribs[["aria-hidden"]], "true")
  expect_equal(icon$attribs$role, "img")
})

test_that("el_icon: a11y sem + title → aria-label uses title", {
  icon <- el_icon("search", title = "Search here", a11y = "sem")
  expect_equal(icon$attribs[["aria-label"]], "Search here")
})

test_that("el_icon: a11y sem + no title → aria-label falls back to name", {
  icon <- el_icon("search", a11y = "sem")
  expect_equal(icon$attribs[["aria-label"]], "search")
})

test_that("el_icon: a11y none → no aria attributes", {
  icon <- el_icon("search", a11y = "none")
  expect_null(icon$attribs[["aria-hidden"]])
  expect_null(icon$attribs[["aria-label"]])
  expect_null(icon$attribs$role)
})

# ── title attribute ──────────────────────────────────────────────────────────

test_that("el_icon: title attribute set on tag when provided", {
  icon <- el_icon("search", title = "Search")
  expect_equal(icon$attribs$title, "Search")
})

test_that("el_icon: no title attribute when title is NULL", {
  icon <- el_icon("search")
  expect_null(icon$attribs$title)
})

# ── lib = "none" ─────────────────────────────────────────────────────────────

test_that("el_icon: lib=none returns plain <i> tag", {
  icon <- el_icon("search", lib = "none")
  expect_equal(icon$name, "i")
  expect_null(icon$attribs$class)
})

test_that("el_icon: lib=none with extra class", {
  icon <- el_icon("search", lib = "none", class = "custom")
  expect_equal(icon$attribs$class, "custom")
})

# ── lib = "font-awesome" ─────────────────────────────────────────────────────

test_that("el_icon: lib=font-awesome errors without fontawesome pkg", {
  # Skip if fontawesome IS installed
  skip_if(requireNamespace("fontawesome", quietly = TRUE),
          "fontawesome is installed; skipping missing-package test")

  expect_error(
    el_icon("search", lib = "font-awesome"),
    "fontawesome"
  )
})

test_that("el_icon: lib=font-awesome delegates to fontawesome::fa_i", {
  skip_if_not_installed("fontawesome")

  icon <- el_icon("magnifying-glass", lib = "font-awesome")
  # fontawesome::fa_i returns an <i> tag with fa classes
  expect_equal(icon$name, "i")
})

# ── extra HTML attributes ─────────────────────────────────────────────────────

test_that("el_icon: extra ... attrs passed through", {
  icon <- el_icon("search", id = "my-icon")
  expect_equal(icon$attribs$id, "my-icon")
})
