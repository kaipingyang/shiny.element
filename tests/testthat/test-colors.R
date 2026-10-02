# Element's colours, from the page's theme -- as Element's theme picker
# recolours its stylesheet.

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

test_that("Element's own colours change nothing", {
  expect_length(.el_theme_colors(el_theme()), 0)
  deps <- htmltools::findDependencies(el_page())
  versions <- vapply(Filter(function(d) d$name == "element-ui", deps), `[[`, "", "version")
  expect_false("2.15.14.1" %in% versions)
})

test_that("a theme's primary recolours Element, replacing its stylesheet", {
  page <- el_page(theme = el_theme(primary = "#7c3aed"), el_button("b", "B", type = "primary"))
  deps <- htmltools::resolveDependencies(htmltools::findDependencies(page))
  el_dep <- Filter(function(d) d$name == "element-ui", deps)
  expect_length(el_dep, 1)
  expect_equal(el_dep[[1]]$version, "2.15.14.1")
  css <- paste(readLines(file.path(el_dep[[1]]$src$file, "theme-chalk", "index.css"),
                         warn = FALSE), collapse = "\n")
  expect_match(css, "#7c3aed", fixed = TRUE)
  expect_false(grepl("#409eff", css, ignore.case = TRUE))
  # the script and the icon font travel with it
  expect_true(file.exists(file.path(el_dep[[1]]$src$file, "index.js")))
  expect_true(file.exists(file.path(el_dep[[1]]$src$file, "theme-chalk", "fonts",
                                    "element-icons.woff")))
})

test_that("colours can be given as a list, and are checked", {
  expect_equal(unname(.el_theme_colors(list(danger = "red"))), "#ff0000")
  expect_error(.el_theme_colors(list(info = "#000")), 'not "info"')
  expect_error(.el_theme_colors(list(primary = "nope")), "not a colour")
})
