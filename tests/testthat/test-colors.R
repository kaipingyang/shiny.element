# Element's own stylesheet, built for the page's theme: brand colours
# recoloured in place, as Element's theme picker does; anything more
# compiled from its Sass, as its theme tool does.

element_dep <- function(page) {
  deps <- htmltools::resolveDependencies(htmltools::findDependencies(page))
  Filter(function(d) d$name == "element-ui", deps)[[1]]
}
css_of <- function(dep) {
  paste(readLines(file.path(dep$src$file, "theme-chalk", "index.css"), warn = FALSE),
        collapse = "\n")
}

test_that("a colour's cluster matches what Element's Sass compiled", {
  css <- paste(readLines(system.file("element-ui", "theme-chalk", "index.css",
                                     package = "shiny.element"), warn = FALSE),
               collapse = "\n")
  # #409EFF's tints at 20%, 50% and 90%, and its shade -- all in the stylesheet
  cl <- .el_color_cluster("#409EFF")
  expect_equal(cl[c(1, 3, 6, 10, 11)],
               c("#409eff", "#66b1ff", "#a0cfff", "#ecf5ff", "#3a8ee6"))
  for (x in cl[c(3, 6, 10, 11)]) expect_match(css, x, ignore.case = TRUE)
})

test_that("Element's own theme changes nothing", {
  expect_length(.el_element_vars(el_theme()), 0)
  expect_equal(element_dep(el_page())$version, "2.15.14")
})

test_that("a brand colour recolours the shipped stylesheet", {
  dep <- element_dep(el_page(theme = el_theme(primary = "#7c3aed")))
  expect_match(dep$version, "^2\\.15\\.14\\.1\\.")
  css <- css_of(dep)
  expect_match(css, "#7c3aed", fixed = TRUE)
  expect_false(grepl("#409eff", css, ignore.case = TRUE))
  # the script and the icon font travel with it
  expect_true(file.exists(file.path(dep$src$file, "index.js")))
  expect_true(file.exists(file.path(dep$src$file, "theme-chalk", "fonts", "element-icons.woff")))
})

test_that("anything else compiles Element's Sass with the variables set", {
  dep <- element_dep(el_page(theme = el_theme(
    info = "#123456", element = list("border-radius-base" = "10px"))))
  css <- css_of(dep)
  expect_match(css, "border-radius:10px", fixed = TRUE)
  # info, which recolouring cannot reach: compiled, the secondary text keeps
  # Element's grey
  expect_match(css, "#123456", fixed = TRUE)
  expect_match(css, "#909399", ignore.case = TRUE)
})

test_that("a focused Bootstrap input follows the brand colour", {
  vars <- bslib::bs_get_variables(el_theme(primary = "#7c3aed"), "input-focus-border-color")
  expect_equal(unname(vars), "#7c3aed")
})

test_that("Element variables are checked by name, and use_element() takes the theme", {
  expect_error(el_theme(element = list("border-radius-bas" = "1px")), "no theme variable")
  expect_error(el_theme(element = list("8px")), "must be named")
  expect_equal(unname(.el_element_vars(list("$--font-size-base" = "13px"))), "13px")
  dep <- element_dep(htmltools::tagList(use_element(theme = el_theme(danger = "#d63384"))))
  expect_match(css_of(dep), "#d63384", fixed = TRUE)
})

test_that("each theme's stylesheet has its own URL", {
  a <- element_dep(el_page(theme = el_theme(primary = "#7c3aed")))
  b <- element_dep(el_page(theme = el_theme(primary = "#0f766e")))
  expect_false(identical(a$version, b$version))
  expect_true(numeric_version(a$version) > numeric_version("2.15.14"))
})
