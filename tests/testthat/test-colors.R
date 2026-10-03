# Element Plus's look, set for the page's theme through its CSS variables,
# as its theming guide does: no build, no stylesheet of our own.

theme_css <- function(page) {
  deps <- htmltools::findDependencies(page)
  d <- Filter(function(d) d$name == "element-plus-theme", deps)
  if (length(d)) d[[1]]$head else NULL
}

test_that("a colour's tints are Sass's mix(), as Element Plus computes them", {
  # #409eff's light-3, light-9 and dark-2, as theme-chalk's index.css has them
  expect_equal(.el_mix("#409eff", "#ffffff", 0.3), "#79bbff")
  expect_equal(.el_mix("#409eff", "#ffffff", 0.9), "#ecf5ff")
  expect_equal(.el_mix("#409eff", "#000000", 0.2), "#337ecc")
  css <- paste(
    readLines(
      system.file(
        "element-plus",
        "theme-chalk",
        "index.css",
        package = "shiny.element"
      ),
      warn = FALSE
    ),
    collapse = ""
  )
  for (x in c("#79bbff", "#ecf5ff", "#337ecc")) {
    expect_match(css, x, fixed = TRUE)
  }
})

test_that("Element's own theme sets nothing", {
  expect_length(.el_element_vars(el_theme()), 0)
  expect_null(theme_css(el_page()))
})

test_that("a brand colour sets the variable and its tints, light and dark", {
  css <- theme_css(el_page(theme = el_theme(primary = "#7c3aed")))
  expect_match(css, "--el-color-primary: #7c3aed;", fixed = TRUE)
  expect_match(css, "--el-color-primary-light-9:", fixed = TRUE)
  expect_match(css, "--el-color-primary-dark-2:", fixed = TRUE)
  expect_match(css, "html.dark {", fixed = TRUE)
})

test_that("any other Element Plus variable is set as given", {
  css <- theme_css(el_page(
    theme = el_theme(
      info = "#123456",
      element = list("border-radius-base" = "10px")
    )
  ))
  expect_match(css, "--el-border-radius-base: 10px;", fixed = TRUE)
  expect_match(css, "--el-color-info: #123456;", fixed = TRUE)
})

test_that("a focused Bootstrap input follows the brand colour", {
  vars <- bslib::bs_get_variables(
    el_theme(primary = "#7c3aed"),
    "input-focus-border-color"
  )
  expect_equal(unname(vars), "#7c3aed")
})

test_that("Element variables are checked by name, and use_element() takes the theme", {
  expect_error(
    el_theme(element = list("border-radius-bas" = "1px")),
    "no theme variable"
  )
  expect_error(el_theme(element = list("8px")), "must be named")
  # Element UI's Sass spelling and the CSS variable's both reach the name
  expect_equal(
    unname(.el_element_vars(list("$--font-size-base" = "13px"))),
    "13px"
  )
  expect_equal(
    names(.el_element_vars(list("--el-font-size-base" = "13px"))),
    "font-size-base"
  )
  css <- theme_css(htmltools::tagList(use_element(
    theme = el_theme(danger = "#d63384")
  )))
  expect_match(css, "#d63384", fixed = TRUE)
})

test_that("each theme's variables travel under their own version", {
  a <- Filter(
    function(d) d$name == "element-plus-theme",
    htmltools::findDependencies(el_page(theme = el_theme(primary = "#7c3aed")))
  )[[1]]
  b <- Filter(
    function(d) d$name == "element-plus-theme",
    htmltools::findDependencies(el_page(theme = el_theme(primary = "#0f766e")))
  )[[1]]
  expect_false(identical(a$version, b$version))
})
