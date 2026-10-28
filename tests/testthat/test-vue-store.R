# vue_store(): Pinia's parts in the spec, data deprecated

test_that("a store carries Pinia's getters and actions, and Pinia", {
  ui <- vue_store(
    "cart",
    state = list(count = 0),
    getters = list(double = JS("function(state) { return state.count * 2; }")),
    actions = list(add = JS("function(n) { this.count += n; }")),
    input = "double"
  )
  spec <- vue_spec_of(ui)
  expect_true(spec$store)
  expect_equal(spec$options$data$count, 0)
  expect_named(spec$storeDef, c("getters", "actions"))
  expect_true("storeDef.getters.double" %in% unlist(spec$evals))
  expect_equal(spec$input, "double")
  deps <- vapply(htmltools::findDependencies(ui), `[[`, "", "name")
  expect_true(match("pinia", deps) > match("vue", deps))
})

test_that("a setup store, and what is refused", {
  spec <- vue_spec_of(vue_store("s", setup = JS("function() { return {}; }")))
  expect_true("storeDef.setup" %in% unlist(spec$evals))
  expect_error(
    vue_store("s", state = list(a = 1), setup = JS("function() {}")),
    "not both"
  )
  expect_error(vue_store("s", getters = list(a = "x")), "JS\\(\\) functions")
  expect_error(vue_store("s", state = list(a = 1), input = "b"), "not a field")
})

test_that("`data` still works, deprecated", {
  expect_warning(ui <- vue_store("s", data = list(n = 1)), "deprecated")
  expect_equal(vue_spec_of(ui)$options$data$n, 1)
  expect_error(
    suppressWarnings(vue_store("s", state = list(a = 1), data = list(n = 1))),
    "not both"
  )
})

test_that("Pinia's production build is bundled, its development one beside it", {
  prod <- .vue_pinia_dependency(dev = FALSE)
  expect_true(file.exists(system.file(
    "pinia",
    prod$script,
    package = "shiny.element"
  )))
  dev <- .vue_pinia_dependency(dev = TRUE)
  expect_true(numeric_version(dev$version) > numeric_version(prod$version))
})
