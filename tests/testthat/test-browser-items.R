# Every item constructor, drawn in its component.

test_that("item constructors draw their parts", {
  skip_if_no_browser()
  app <- testthat::test_path("apps", "items.R")
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
  b <- chromote::ChromoteSession$new(width = 1300, height = 1000)
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
  count <- function(sel) {
    js(sprintf(
      "document.querySelectorAll(%s).length",
      jsonlite::toJSON(sel, auto_unbox = TRUE)
    ))
  }
  has <- function(sel) count(sel) > 0
  Sys.sleep(6)

  # tabs: three panes, the lazy one empty until chosen, the third disabled
  expect_equal(count("#tabs .el-tabs__item"), 3)
  expect_false(has("#tabs .lazy-body"))
  expect_true(has("#tabs .el-tabs__item.is-disabled"))
  js("document.querySelectorAll('#tabs .el-tabs__item')[1].click()")
  Sys.sleep(0.8)
  expect_true(has("#tabs .lazy-body"))
  js("document.querySelector('#more button').click()")
  Sys.sleep(1.2)
  expect_equal(count("#tabs .el-tabs__item"), 4)

  expect_equal(count("#col .el-collapse-item"), 2)
  expect_true(has("#col .el-collapse-item.is-disabled"))

  # the second entry hides its timestamp
  expect_equal(count("#tl .el-timeline-item"), 2)
  expect_equal(count("#tl .el-timeline-item__timestamp"), 1)

  expect_true(has("#desc td[colspan='3']"))
  expect_equal(count("#steps .el-step"), 3)
  expect_true(has("#steps .el-step__head.is-error"))
  expect_equal(count("#bc .el-breadcrumb__item"), 2)

  expect_true(has("#menu .el-sub-menu"))
  expect_true(has("#menu .el-menu-item.is-disabled"))

  js("document.querySelector('#sel .el-select__wrapper').click()")
  Sys.sleep(0.8)
  expect_equal(count(".el-select-group__title"), 2)
  expect_true(has(".el-select-dropdown__item.is-disabled"))

  expect_true(has("#an .el-anchor__list .el-anchor__list .el-anchor__link"))

  # three header rows: Date | Info > Name, Place > City
  expect_equal(count("#tbl .el-table__header-wrapper tr"), 3)
  expect_equal(count("#tv .el-table-v2__header-cell"), 2)
  expect_true(has("#sk .el-skeleton__image"))

  expect_equal(js("window.__w.length"), 0)
})
