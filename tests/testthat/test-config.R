# Element Plus's global config -- app.use(ElementPlus, {size, zIndex}) --
# and the stylesheets upstream ships beside index.css.

test_that("size and z_index set Element Plus's global config", {
  deps <- htmltools::findDependencies(el_page(size = "small", z_index = 3000))
  cfg <- Filter(function(d) d$name == "element-plus-config", deps)
  expect_length(cfg, 1)
  expect_match(cfg[[1]]$head, '{"size":"small","zIndex":3000}', fixed = TRUE)
  expect_match(cfg[[1]]$head, "shinyElementConfig", fixed = TRUE)
})

test_that("no config is written unless asked for", {
  deps <- htmltools::findDependencies(el_page())
  expect_false("element-plus-config" %in% vapply(deps, `[[`, "", "name"))
  expect_null(.el_config_dependency())
})

test_that("the config is checked", {
  expect_error(use_element(size = "medium"), "should be one of")
  expect_error(use_element(z_index = "high"), "single number")
})

test_that("Element Plus's display classes and dark mode are carried", {
  dep <- element_plus_dependency()[[1]]
  expect_true(all(
    c("theme-chalk/display.css", "theme-chalk/dark/css-vars.css") %in%
      unlist(dep$stylesheet)
  ))
  root <- system.file("element-plus", package = "shiny.element")
  expect_true(file.exists(file.path(root, "theme-chalk", "display.css")))
  expect_true(file.exists(file.path(
    root,
    "theme-chalk",
    "dark",
    "css-vars.css"
  )))
})
