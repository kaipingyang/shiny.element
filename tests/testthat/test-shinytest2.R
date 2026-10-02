# shinytest2 drives the components as it drives Shiny's own inputs: through
# their input bindings.

test_that("AppDriver reads and sets components, and sees server updates", {
  skip_on_cran()
  skip_if_not_installed("shinytest2")
  skip_if_no_browser()
  withr::local_envvar(SHINY_ELEMENT_PKG = normalizePath(testthat::test_path("..", "..")),
                      NOT_CRAN = "true")
  use_browser_args()
  app <- shinytest2::AppDriver$new(testthat::test_path("apps", "shinytest2"),
                                   load_timeout = 60000)
  on.exit(app$stop(), add = TRUE)

  vals <- app$get_values(input = c("city", "name", "on"))$input
  expect_equal(vals$name, "")
  expect_false(vals$on)

  app$set_inputs(city = "Shanghai", name = "Ada", on = TRUE)
  # el_input reports a quarter-second after the last change, as textInput()
  app$wait_for_idle(500)
  expect_equal(app$get_value(output = "echo"), "Shanghai Ada TRUE ")
  # the component shows what was set, not only the server
  expect_equal(app$get_js("document.querySelector('#name_container input').value"), "Ada")

  app$click(selector = "#go_container button")
  app$wait_for_value(input = "late")
  expect_equal(app$get_value(input = "name"), "from server")
  expect_equal(app$get_value(input = "late"), "rendered")
})
