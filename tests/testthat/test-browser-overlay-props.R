# Dialogs and drawers: the behaviours their arguments set, each checked in a
# browser (apps/overlay-props.R).

test_that("dialogs and drawers behave as their arguments say", {
  skip_if_no_browser()
  app <- testthat::test_path("apps", "overlay-props.R")
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
  b <- chromote::ChromoteSession$new(width = 1000, height = 900)
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
  shown <- function(id) {
    js(sprintf(
      "getComputedStyle(document.getElementById('%s')).display !== 'none'",
      id
    ))
  }
  show <- function(id, visible = TRUE) {
    js(sprintf(
      "Shiny.setInputValue('show', {id: '%s', visible: %s, n: Math.random()})",
      id,
      tolower(visible)
    ))
    Sys.sleep(1)
  }
  body_overflow <- function() js("getComputedStyle(document.body).overflow")
  escape <- function() {
    js(
      "document.dispatchEvent(new KeyboardEvent('keydown', {key: 'Escape', bubbles: true}))"
    )
    Sys.sleep(0.8)
  }
  backdrop <- function(id) {
    js(sprintf(
      "(function(){ var t = document.querySelector('#%s .el-overlay-dialog') || document.getElementById('%s'); t.dispatchEvent(new MouseEvent('mousedown', {bubbles: true})); t.dispatchEvent(new MouseEvent('mouseup', {bubbles: true})); t.click(); })()",
      id,
      id
    ))
    Sys.sleep(0.8)
  }

  # scroll lock
  show("d_lock")
  expect_true(shown("d_lock"))
  expect_equal(body_overflow(), "hidden")
  show("d_lock", FALSE)
  for (id in c("d_nolock", "w_nolock")) {
    show(id)
    expect_true(shown(id), info = id)
    expect_equal(body_overflow(), "visible", info = id)
    show(id, FALSE)
  }

  # the backdrop and Escape close it, unless told not to
  for (id in c("d_nomask", "w_nomask")) {
    show(id)
    backdrop(id)
    expect_true(shown(id), info = id)
    show(id, FALSE)
  }
  show("d_lock")
  backdrop("d_lock")
  expect_false(shown("d_lock"))
  for (id in c("d_noesc", "w_noesc")) {
    show(id)
    escape()
    expect_true(shown(id), info = id)
    show(id, FALSE)
  }
  show("d_lock")
  escape()
  expect_false(shown("d_lock"))

  # open_delay and close_delay, 800 ms each
  js(
    "Shiny.setInputValue('show', {id: 'd_delay', visible: true, n: Math.random()})"
  )
  Sys.sleep(0.4)
  expect_false(shown("d_delay"))
  Sys.sleep(1.2)
  expect_true(shown("d_delay"))
  js(
    "Shiny.setInputValue('show', {id: 'd_delay', visible: false, n: Math.random()})"
  )
  Sys.sleep(0.4)
  expect_true(shown("d_delay"))
  Sys.sleep(1.2)
  expect_false(shown("d_delay"))

  # destroy_on_close: the content goes, and comes back
  inner <- "!!document.querySelector('#d_destroy #inner input')"
  show("d_destroy")
  expect_true(js(inner))
  show("d_destroy", FALSE)
  expect_false(js(inner))
  show("d_destroy")
  Sys.sleep(0.5)
  expect_true(js(inner))
  show("d_destroy", FALSE)

  # a penetrable dialog without a modal lets a click reach the page
  show("d_pen")
  js(
    "(function(){ var r = document.getElementById('under').getBoundingClientRect(); document.elementFromPoint(r.left + 5, r.top + 5).click(); })()"
  )
  Sys.sleep(1)
  expect_equal(js("document.getElementById('n_under').innerText"), "1")
  show("d_pen", FALSE)

  # before_close decides
  show("d_before")
  js("document.querySelector('#d_before .el-dialog__headerbtn').click()")
  Sys.sleep(0.8)
  expect_equal(js("window.__asked"), 1)
  expect_true(shown("d_before"))
  js(
    "window.__allow = true; document.querySelector('#d_before .el-dialog__headerbtn').click()"
  )
  Sys.sleep(0.8)
  expect_false(shown("d_before"))

  # a resizable drawer follows its dragger
  show("w_resize")
  width <- "document.querySelector('#w_resize .el-drawer').getBoundingClientRect().width"
  expect_equal(js(width), 300)
  js(
    "(function(){ var d = document.querySelector('#w_resize .el-drawer__dragger'); var r = d.getBoundingClientRect(); var x = r.left + 1, y = r.top + r.height / 2; d.dispatchEvent(new MouseEvent('mousedown', {bubbles: true, clientX: x, clientY: y})); document.dispatchEvent(new MouseEvent('mousemove', {bubbles: true, clientX: x - 100, clientY: y})); document.dispatchEvent(new MouseEvent('mouseup', {bubbles: true, clientX: x - 100, clientY: y})); })()"
  )
  Sys.sleep(0.8)
  expect_equal(js(width), 400)

  expect_equal(js("window.__w.length"), 0, info = js("window.__w.join('\\n')"))
})
