test_that("el_theme carries Element's tokens", {
  t <- el_theme()
  expect_s3_class(t, "bs_theme")
  v <- bslib::bs_get_variables(t, c("primary", "success", "warning", "danger",
                                     "font-size-base", "border-radius",
                                     "font-family-base", "min-contrast-ratio"))
  expect_equal(unname(v[c("primary", "success", "warning", "danger")]),
               c("#409EFF", "#67C23A", "#E6A23C", "#F56C6C"))
  expect_equal(unname(v["font-size-base"]), "0.875rem")
  expect_equal(unname(v["border-radius"]), "4px")
  expect_match(v[["font-family-base"]], "Helvetica Neue", fixed = TRUE)
  expect_match(v[["font-family-base"]], "PingFang SC", fixed = TRUE)
  # White text on all five colours, as Element has it
  expect_equal(unname(v["min-contrast-ratio"]), "2")
})

test_that("el_theme overrides replace the Element value of the same name", {
  v <- bslib::bs_get_variables(
    el_theme(primary = "#7c3aed", "font-size-base" = "1rem"),
    c("primary", "font-size-base", "danger"))
  expect_equal(toupper(unname(v)), c("#7C3AED", "1REM", "#F56C6C"))
})

test_that("el_page uses el_theme by default, and NULL leaves plain Bootstrap", {
  deps <- function(ui) htmltools::renderTags(ui)$dependencies
  ver <- function(ui) {
    d <- Filter(function(x) x$name == "bootstrap", deps(ui))
    as.character(d[[1]]$version)
  }
  expect_match(ver(el_page()), "^5")
  expect_match(ver(el_page(theme = NULL)), "^3")
})
