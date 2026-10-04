`%||%` <- function(a, b) if (is.null(a)) b else a

# The Vue layer on its own: no Element Plus on the page.

test_that("vue_app() works without Element Plus", {
  skip_if_no_browser()
  app <- testthat::test_path("apps", "pure-vue.R")
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

  # nothing of Element on the page
  expect_false(js("!!window.ElementPlus"))
  expect_false(js(
    "!!document.querySelector('link[href*=element-plus], script[src*=element-plus], script[src*=el-events]')"
  ))

  # input is input$<id>; a data.frame is rows for v-for
  expect_equal(js("Shiny.shinyapp.$inputValues.counter"), 1)
  expect_equal(
    js(
      "document.querySelector('#counter .rows').parentNode.textContent.replace(/\\s+/g, '')"
    ),
    "+1a;b;"
  )
  js("document.querySelector('#counter .inc').click()")
  Sys.sleep(0.8)
  expect_equal(js("Shiny.shinyapp.$inputValues.counter"), 2)
  # $emit('picked', row) is input$counter_picked, as Element's events are
  js("document.querySelectorAll('#counter .rows')[1].click()")
  Sys.sleep(0.8)
  expect_equal(
    js("JSON.stringify(Shiny.shinyapp.$inputValues.counter_picked)"),
    '{"name":"b"}'
  )

  # an input of two fields is one value, a named list
  expect_equal(
    js("JSON.stringify(Shiny.shinyapp.$inputValues.range)"),
    '{"from":1,"to":9}'
  )
  js(
    "var i = document.querySelector('#range .to'); i.value = '7'; i.dispatchEvent(new Event('input'));"
  )
  Sys.sleep(0.8)
  expect_equal(
    js("JSON.stringify(Shiny.shinyapp.$inputValues.range)"),
    '{"from":1,"to":7}'
  )

  # a plugin of the page's own, installed by name
  expect_equal(
    js("document.querySelector('#greet .hello').textContent"),
    "hi Ada"
  )
  # ... and with options
  expect_equal(
    js("document.querySelector('#greet2 .hello').textContent"),
    "hello Alan"
  )

  # a store: two apps share it at once, without the server; its input is
  # input$cart; the server sets a field with an update
  js(
    "document.querySelector('#sa .sa').click(); document.querySelector('#sa .sa').click();"
  )
  expect_equal(js("document.querySelector('#sb .sb').textContent"), "2|")
  Sys.sleep(0.8)
  expect_equal(js("Shiny.shinyapp.$inputValues.cart"), 2)
  js("document.querySelector('#counter .inc').click()")
  Sys.sleep(1.2)
  expect_equal(js("document.querySelector('#sb .sb').textContent"), "2|from R")

  # setup() state: reported as the input, and set by update_vue(value =)
  expect_equal(js("document.querySelector('#st .st').textContent"), "1/2")
  expect_equal(js("Shiny.shinyapp.$inputValues.st"), 1)
  js("Shiny.setInputValue('set_st', 1)")
  Sys.sleep(1)
  expect_equal(js("document.querySelector('#st .st').textContent"), "5/10")
  expect_equal(js("Shiny.shinyapp.$inputValues.st"), 5)

  # render_vue() with a component of the layer's own
  js("document.getElementById('rv_app').__mark = 1")
  expect_match(js("document.querySelector('#rv .rv').textContent"), "n is 3")
  js("document.querySelector('#counter .inc').click()")
  Sys.sleep(1.2)
  expect_match(js("document.querySelector('#rv .rv').textContent"), "n is 4")
  expect_equal(js("document.getElementById('rv_app').__mark"), 1)

  expect_equal(
    js(
      "window.__w.filter(function(w){ return /Vue warn|shiny-vue/.test(w); }).length"
    ),
    0
  )
})
