# Updates go with the flush (apps/flush.R): after the output the same
# observer re-rendered, from a later() callback as well; flush_vue() sends
# them before a long computation.

test_that("updates arrive with the flush, and flush_vue() sends them early", {
  skip_if_no_browser()
  app <- testthat::test_path("apps", "flush.R")
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
  b$Page$enable()
  b$Page$addScriptToEvaluateOnNewDocument(
    "window.__w = []; ['warn', 'error'].forEach(function(k) {
       var o = console[k];
       console[k] = function() { window.__w.push(Array.prototype.join.call(arguments, ' ')); return o.apply(console, arguments); };
     });"
  )
  b$Page$navigate(sprintf("http://127.0.0.1:%d", port))
  js <- function(x) b$Runtime$evaluate(x, awaitPromise = TRUE)$result$value
  Sys.sleep(5)
  text <- function(id) {
    js(sprintf("document.getElementById('%s').innerText", id))
  }

  # re-rendered as a new component, then updated: the update reaches the
  # new one -- sent before the render, it went to the one replaced
  expect_equal(text("box_text"), "render 0 0")
  js("document.getElementById('go').click()")
  Sys.sleep(2)
  expect_equal(text("box_text"), "render 1 5")

  # from a later() callback, outside any flush: a flush is requested
  js("document.getElementById('later').click()")
  Sys.sleep(2)
  expect_equal(text("box2_text"), "7 idle")

  # flush_vue() sends before the observer's three seconds are up
  js("document.getElementById('slow').click()")
  Sys.sleep(1.5)
  expect_equal(text("box2_text"), "7 working")
  Sys.sleep(3)
  expect_equal(text("box2_text"), "7 done")

  expect_identical(js("JSON.stringify(window.__w)"), "[]")
})
