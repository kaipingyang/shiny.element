# Task buttons (apps/task.R): loading from the click, set in the browser,
# reset once the server has handled it -- or, bound with
# bslib::bind_task_button(), once the ExtendedTask is done.

test_that("el_button(task = TRUE) works as bslib's task button", {
  skip_if_no_browser()
  skip_if_not_installed("promises")
  skip_if_not_installed("later")
  app <- testthat::test_path("apps", "task.R")
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
  b <- chromote::ChromoteSession$new(width = 1000, height = 700)
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
  loading <- function(id) {
    js(sprintf(
      "document.getElementById('%s').closest('button, .el-button') ? document.getElementById('%s').closest('.el-button').classList.contains('is-loading') : document.querySelector('#%s .el-button').classList.contains('is-loading')",
      id,
      id,
      id
    ))
  }
  button <- function(id) {
    sprintf(
      "document.querySelector('#%1$s .el-button') || document.getElementById('%1$s')",
      id
    )
  }

  # loading from the click, before the server hears of it
  expect_false(loading("sync"))
  js(paste0("(", button("sync"), ").click()"))
  Sys.sleep(0.3)
  expect_true(loading("sync"))
  Sys.sleep(1)
  expect_true(loading("sync"))
  Sys.sleep(2)
  expect_false(loading("sync"))
  # a second click counts, as an action button's
  js(paste0("(", button("sync"), ").click()"))
  Sys.sleep(3)

  # bound to an ExtendedTask: loading while it runs
  js(paste0("(", button("async"), ").click()"))
  Sys.sleep(1)
  expect_true(loading("async"))
  Sys.sleep(2.5)
  expect_false(loading("async"))

  # folded into a tooltip, it has no binding: reset all the same
  js(paste0("(", button("folded"), ").click()"))
  Sys.sleep(0.3)
  expect_true(loading("folded"))
  Sys.sleep(2)
  expect_false(loading("folded"))

  expect_equal(
    js("document.getElementById('log').textContent"),
    "sync 1,sync 2,async done,folded 1"
  )
  expect_identical(js("JSON.stringify(window.__w)"), "[]")
})
