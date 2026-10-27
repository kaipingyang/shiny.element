# vue_router() and update_vue_router(): what they write and send

test_that("vue_router() starts the router, with vue-router after Vue", {
  ui <- vue_router("route")
  html <- as.character(ui)
  expect_match(html, "shinyVue.createRouter(", fixed = TRUE)
  expect_match(html, '"id":"route"', fixed = TRUE)
  expect_match(html, '"history":"hash"', fixed = TRUE)
  deps <- vapply(htmltools::findDependencies(ui), `[[`, "", "name")
  expect_true(match("vue-router", deps) > match("vue", deps))
  expect_match(
    as.character(vue_router("r", history = "memory")),
    '"history":"memory"',
    fixed = TRUE
  )
  expect_error(vue_router("r", history = "web"))
})

test_that("vue-router's production build is bundled, its development one beside it", {
  prod <- .vue_router_dependency(dev = FALSE)
  expect_true(file.exists(system.file(
    "vue-router",
    prod$script,
    package = "shiny.element"
  )))
  dev <- .vue_router_dependency(dev = TRUE)
  expect_equal(dev$script, "vue-router.global.js")
  expect_true(numeric_version(dev$version) > numeric_version(prod$version))
})

test_that("update_vue_router() sends the path to the page's router", {
  s <- mock_session()
  update_vue_router(s, "route", "/orders", replace = TRUE)
  env <- s$captured()
  expect_equal(env$type, "shinyVueRouter")
  expect_equal(env$msg, list(id = "route", path = "/orders", replace = TRUE))
  expect_error(update_vue_router(s, "route", c("/a", "/b")), "single string")
})

test_that("a menu in router mode follows the route", {
  spec <- vue_spec_of(el_menu(
    "m",
    router = TRUE,
    items = list(el_menu_item("A", "/a"))
  ))
  watch <- spec$options$watch$`$route.path`
  expect_true(watch$immediate)
  expect_match(watch$handler, "this.active = p", fixed = TRUE)
})

test_that("a bookmark brings the route back as the router's first", {
  ctx <- shiny:::RestoreContext$new("?_inputs_&route=%22%2Forders%22")
  html <- shiny:::withRestoreContext(ctx, as.character(vue_router("route")))
  expect_match(html, '"initial":"/orders"', fixed = TRUE)
  expect_match(
    as.character(vue_router("route")),
    '"initial":null',
    fixed = TRUE
  )
})
