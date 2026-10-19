# el_page(loading = TRUE): Element's mask over the page until every
# component has mounted and Shiny is connected; none from a page renderUI()
# draws later.

test_that("the loading mask goes once the components are drawn", {
  skip_if_no_browser()
  app <- testthat::test_path("apps", "loading.R")
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
     });
     window.__seen = {};
     document.addEventListener('DOMContentLoaded', function() {
       var m = document.querySelector('.el-page-loading');
       window.__seen.shown = !!m && getComputedStyle(m).position === 'fixed';
       var iv = setInterval(function() {
         if (document.querySelector('body > .container-fluid > .el-page-loading')) return;
         clearInterval(iv);
         window.__seen.mounted = document.querySelectorAll('[data-shiny-vue-root]').length;
         window.__seen.hosts = document.querySelectorAll('[data-shiny-vue]').length;
       }, 20);
     });"
  )
  b$Page$navigate(sprintf("http://127.0.0.1:%d", port))
  js <- function(x) b$Runtime$evaluate(x, returnByValue = TRUE)$result$value
  Sys.sleep(7)

  # over the page from the start, gone once every component had mounted
  expect_true(js("window.__seen.shown"))
  expect_gte(js("window.__seen.mounted"), 41)
  expect_gte(js("window.__seen.mounted"), js("window.__seen.hosts"))
  expect_equal(js("document.querySelectorAll('.el-page-loading').length"), 0)
  # the page drawn by renderUI() brought none
  expect_equal(js("JSON.stringify(Shiny.shinyapp.$inputValues.late)"), '"x"')

  # nothing left in the way of a real click
  js("document.querySelector('#go button').scrollIntoView()")
  Sys.sleep(0.3)
  at <- js(
    "(function() { var r = document.querySelector('#go button').getBoundingClientRect();
       return [r.x + 5, r.y + 5]; })()"
  )
  for (type in c("mousePressed", "mouseReleased")) {
    b$Input$dispatchMouseEvent(
      type = type,
      x = at[[1]],
      y = at[[2]],
      button = "left",
      clickCount = 1
    )
  }
  Sys.sleep(1)
  expect_equal(js("document.getElementById('n').textContent"), "1")
  expect_identical(js("JSON.stringify(window.__w)"), "[]")
})
