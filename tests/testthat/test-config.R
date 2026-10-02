# Element's global config -- Vue.use(Element, {size, zIndex}) -- and the
# stylesheet upstream ships beside index.css.

test_that("size and z_index set Element's global config", {
  deps <- htmltools::findDependencies(el_page(size = "small", z_index = 3000))
  cfg <- Filter(function(d) d$name == "element-ui-config", deps)
  expect_length(cfg, 1)
  expect_match(cfg[[1]]$head, 'Vue.prototype.$ELEMENT = {"size":"small","zIndex":3000}',
               fixed = TRUE)
})

test_that("no config is written unless asked for", {
  deps <- htmltools::findDependencies(el_page())
  expect_false("element-ui-config" %in% vapply(deps, `[[`, "", "name"))
  expect_null(.el_config_dependency())
})

test_that("the config is checked", {
  expect_error(use_element(size = "large"), "should be one of")
  expect_error(use_element(z_index = "high"), "single number")
})

test_that("Element's display classes are carried", {
  dep <- element_ui_dependency()
  expect_true("theme-chalk/display.css" %in% unlist(dep$stylesheet))
  expect_true(file.exists(system.file("element-ui", "theme-chalk", "display.css",
                                      package = "shiny.element")))
})
