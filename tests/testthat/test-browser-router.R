# The page's router: Element's menu and breadcrumb navigate it, a Vue app
# reads it, the server moves it, the route is an input.

test_that("vue_router(): components navigate, the server too, input$<id> follows", {
  skip_if_no_browser()
  app <- testthat::test_path("apps", "router.R")
  pkg <- normalizePath(testthat::test_path("..", ".."))
  port <- httpuv::randomPort()
  log <- tempfile(fileext = ".log")
  proc <- callr::r_bg(
    function(app, pkg, port, libs) {
      .libPaths(libs)
      pkgload::load_all(
        pkg,
        quiet = TRUE,
        helpers = FALSE,
        attach_testthat = FALSE
      )
      options(shiny.vue.dev = TRUE)
      shiny::runApp(
        app,
        host = "127.0.0.1",
        port = port,
        launch.browser = FALSE
      )
    },
    args = list(app = app, pkg = pkg, port = port, libs = .libPaths()),
    stdout = log,
    stderr = "2>&1"
  )
  on.exit(proc$kill(), add = TRUE)
  for (i in seq_len(120)) {
    Sys.sleep(0.5)
    if (any(grepl("Listening on", readLines(log, warn = FALSE)))) break
  }
  use_browser_args()
  b <- chromote::ChromoteSession$new(width = 1000, height = 700)
  on.exit(try(b$close(), silent = TRUE), add = TRUE)
  js <- function(x) b$Runtime$evaluate(x, returnByValue = TRUE)$result$value
  b$Page$navigate(sprintf("http://127.0.0.1:%d", port))
  Sys.sleep(5)
  js(paste0(
    "window.__w = []; ['warn', 'error'].forEach(function(k) { var o = console[k]; ",
    "console[k] = function() { __w.push(Array.from(arguments).join(' ')); o.apply(console, arguments); }; });"
  ))
  seen <- function() js("document.getElementById('seen').textContent")
  active <- function() {
    js(
      "(document.querySelector('#menu_container .el-menu-item.is-active') || {textContent: ''}).textContent.trim()"
    )
  }
  # on load: the route reported, the menu on it
  expect_equal(seen(), "route=/ menu=/")
  expect_equal(active(), "Home")

  # Element's menu, router = TRUE, navigates
  js("document.querySelectorAll('#menu_container .el-menu-item')[1].click()")
  Sys.sleep(1.5)
  expect_equal(js("location.hash"), "#/orders")
  expect_equal(seen(), "route=/orders menu=/orders")
  expect_equal(active(), "Orders")
  expect_equal(
    js("document.querySelector('#own .path').textContent"),
    "/orders"
  )

  # a breadcrumb step's `to`
  js(
    "document.querySelectorAll('#crumb_container .el-breadcrumb__inner')[0].click()"
  )
  Sys.sleep(1.5)
  expect_equal(js("location.hash"), "#/")
  expect_equal(active(), "Home")

  # Vue's <router-link>, in an app of the user's; the menu follows
  js("document.querySelector('#own .to-admin').click()")
  Sys.sleep(1.5)
  expect_equal(seen(), "route=/admin menu=/admin")
  expect_equal(active(), "Admin")

  # the server
  js("document.getElementById('go_orders').click()")
  Sys.sleep(1.5)
  expect_equal(js("location.hash"), "#/orders")
  expect_equal(active(), "Orders")

  # the browser's back
  js("history.back()")
  Sys.sleep(1.5)
  expect_equal(seen(), "route=/admin menu=/admin")
  expect_equal(active(), "Admin")

  expect_equal(js("window.__w.length"), 0)

  # a page opened on a route starts there
  b$Page$navigate(sprintf("http://127.0.0.1:%d/#/orders", port))
  Sys.sleep(5)
  expect_equal(seen(), "route=/orders menu=/orders")
  expect_equal(active(), "Orders")
})
