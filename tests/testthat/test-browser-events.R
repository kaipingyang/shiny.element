# What reaches the server (apps/events.R): a component's value and the
# events it reports unasked; the rest only when asked for with `events`;
# handlers of the user's own with `on`, under input$<id>_<name> -- alone,
# folded into another component, in a module.

test_that("only the events reported unasked or asked for reach the server", {
  skip_if_no_browser()
  app <- testthat::test_path("apps", "events.R")
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
  b <- chromote::ChromoteSession$new(width = 1100, height = 900)
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
  # every input the page sent, by name
  js(
    "window.__sent = {}; var o = Shiny.shinyapp.sendInput.bind(Shiny.shinyapp);
     Shiny.shinyapp.sendInput = function(v) { Object.keys(v).forEach(function(k) {
       window.__sent[k.split(':')[0]] = JSON.stringify(v[k]); }); return o(v); }; true"
  )
  sent <- function() jsonlite::fromJSON(js("JSON.stringify(window.__sent)"))
  focus_and_type <- function(selector, text, enter = FALSE) {
    js(sprintf("document.querySelector('%s').focus()", selector))
    for (ch in strsplit(text, "")[[1]]) {
      b$Input$dispatchKeyEvent(type = "keyDown", text = ch, key = ch)
      b$Input$dispatchKeyEvent(type = "keyUp", key = ch)
    }
    if (enter) {
      b$Input$dispatchKeyEvent(
        type = "keyDown",
        key = "Enter",
        code = "Enter",
        windowsVirtualKeyCode = 13
      )
      b$Input$dispatchKeyEvent(
        type = "keyUp",
        key = "Enter",
        code = "Enter",
        windowsVirtualKeyCode = 13
      )
    }
    Sys.sleep(1)
  }

  # unasked: the value, and no focus or keystroke
  focus_and_type("#plain_container input", "ab")
  s <- sent()
  expect_equal(s[["plain"]], "\"xab\"")
  expect_false(any(
    c("plain_focus", "plain_keydown", "plain_input") %in% names(s)
  ))

  # asked for: focus, and each key -- which key it was
  focus_and_type("#asked_container input", "z")
  s <- sent()
  expect_true("asked_focus" %in% names(s))
  expect_equal(jsonlite::fromJSON(s[["asked_keydown"]])$key, "z")
  expect_false("asked_blur" %in% names(s))

  # a handler of the user's own: Enter, reported as input$<id>_enter
  focus_and_type("#own_container input", "leek", enter = TRUE)
  expect_equal(sent()[["own_enter"]], "\"leek\"")
  # folded into a space, the same
  focus_and_type("input#folded", "pear", enter = TRUE)
  expect_equal(sent()[["folded_enter"]], "\"pear\"")

  # in a module, under the namespaced id
  js(
    "document.querySelector('#m-b button').dispatchEvent(new MouseEvent('dblclick', {bubbles: true}))"
  )
  Sys.sleep(1)
  expect_equal(sent()[["m-b_twice"]], "true")

  # the tag's close, unasked
  js("document.querySelector('#tg .el-tag__close').click()")
  Sys.sleep(1)
  expect_true("tg_close" %in% names(sent()))

  # a dialog reports closed unasked, not open, opened or close
  js("document.getElementById('open').click()")
  Sys.sleep(1.5)
  js("document.querySelector('#dlg .el-dialog__headerbtn').click()")
  Sys.sleep(1.5)
  s <- sent()
  expect_true("dlg_closed" %in% names(s))
  expect_false(any(c("dlg_open", "dlg_opened", "dlg_close") %in% names(s)))

  # tabs report an added tab unasked, not a click
  js("document.querySelectorAll('#tb .el-tabs__item')[1].click()")
  js("document.querySelector('#tb .el-tabs__new-tab').click()")
  Sys.sleep(1)
  s <- sent()
  expect_true("tb_tab_add" %in% names(s))
  expect_false(any(c("tb_tab_click", "tb_tab_change", "tb_edit") %in% names(s)))
  expect_equal(s[["tb"]], "\"b\"")

  expect_identical(js("JSON.stringify(window.__w)"), "[]")
})
