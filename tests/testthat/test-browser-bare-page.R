# Element's components on a page that loads nothing of Element itself: each
# component carries Vue and Element Plus, as Shiny's inputs carry selectize.

test_that("components work on a page without el_page() or use_element()", {
  skip_if_no_browser()
  app <- testthat::test_path("apps", "bare-page.R")
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
      options(shiny.element.dev = TRUE)
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
  b <- chromote::ChromoteSession$new(width = 1000, height = 800)
  on.exit(try(b$close(), silent = TRUE), add = TRUE)
  b$Page$enable()
  b$Page$addScriptToEvaluateOnNewDocument(
    "window.__w = []; ['warn', 'error'].forEach(function(k) {
       var o = console[k];
       console[k] = function() { window.__w.push(Array.prototype.join.call(arguments, ' ')); return o.apply(console, arguments); };
     });"
  )
  b$Page$navigate(sprintf("http://127.0.0.1:%d", port))
  js <- function(x) b$Runtime$evaluate(x, awaitPromise = TRUE)$result$value
  Sys.sleep(6)

  expect_true(js("!!window.ElementPlus"))
  # one copy of Element, though every component brings it
  expect_equal(
    js("document.querySelectorAll('script[src*=\"index.full\"]').length"),
    1
  )
  # mounted: Element's markup, no raw tags left
  expect_equal(
    js("document.querySelectorAll('#btn .el-button--primary').length"),
    1
  )
  expect_equal(js("document.querySelectorAll('#txt .el-input').length"), 1)
  expect_equal(js("document.querySelectorAll('#tbl .el-table__row').length"), 2)
  expect_equal(
    js("document.querySelectorAll('el-button, el-input, el-table').length"),
    0
  )
  expect_equal(js("Shiny.shinyapp.$inputValues.txt"), "text")
  # the containers are styled by Element's stylesheet
  expect_equal(
    js("getComputedStyle(document.querySelector('.el-row')).display"),
    "flex"
  )
  expect_equal(
    js(
      "Math.round(document.querySelector('.el-col-12').getBoundingClientRect().width * 2 / document.querySelector('.el-row').getBoundingClientRect().width * 100)"
    ),
    100
  )
  expect_equal(
    js(
      "getComputedStyle(document.querySelector('#tabs .el-tabs__item.is-active')).color"
    ),
    "rgb(64, 158, 255)"
  )
  expect_equal(js("window.__w.length"), 0, info = js("window.__w.join('\\n')"))
})
