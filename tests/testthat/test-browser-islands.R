# Shiny UI in a vue_app() template (apps/islands.R): kept out of Vue's
# compiling, moved in while Vue shows its place and back out when Vue
# removes it -- bound, drawn and holding its state again once shown.

test_that("Shiny UI in a template survives v-if: islands", {
  skip_if_no_browser()
  skip_if_not_installed("DT")
  app <- testthat::test_path("apps", "islands.R")
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
  Sys.sleep(7)
  shown <- function() {
    expect_true(js("!!document.querySelector('#va1 #txt.shiny-bound-input')"))
    expect_true(js("!!document.querySelector('#va1 #plt img')"))
    expect_equal(js("document.querySelectorAll('#va1 #dt tbody tr').length"), 3)
    expect_equal(
      js("document.querySelectorAll('#va1 #staticwidget tbody tr').length"),
      2
    )
    expect_true(js("!!document.querySelector('#va1 .el-input')"))
    expect_equal(
      js("document.querySelectorAll('#va1 .el-tabs__item').length"),
      2
    )
  }
  shown()
  js(
    "var i = document.getElementById('txt'); i.value = 'typed';
     i.dispatchEvent(new Event('change', {bubbles: true}));"
  )
  js("document.querySelectorAll('#tb .el-tabs__item')[1].click()")
  Sys.sleep(1)

  # hidden: back in the holder, the outputs suspended
  js("document.getElementById('tog').click()")
  Sys.sleep(1.5)
  expect_equal(
    js(
      "document.querySelectorAll('#va1 > [data-shiny-vue-islands] > [data-shiny-island-of]').length"
    ),
    6
  )
  expect_true(js(
    "Shiny.shinyapp.$inputValues['.clientdata_output_plt_hidden']"
  ))

  # shown again: drawn, bound, the user's input and tab kept
  js("document.getElementById('tog').click()")
  Sys.sleep(3)
  shown()
  expect_equal(js("document.getElementById('txt').value"), "typed")
  expect_equal(
    js("document.getElementById('echo').innerText"),
    "txt: typed elin: el tb: b"
  )

  expect_identical(js("JSON.stringify(window.__w)"), "[]")
})
