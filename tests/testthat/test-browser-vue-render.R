`%||%` <- function(a, b) if (is.null(a)) b else a

# render_vue(): the component stays, with what the user did to it, when a
# render changes only its data; it is replaced when the shape changes.

test_that("render_vue() keeps the component and the user's state", {
  skip_if_no_browser()
  app <- testthat::test_path("apps", "vue-render.R")
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
  for (i in 1:60) {
    Sys.sleep(0.5)
    if (isTRUE(js("!!document.querySelector('#tbl .el-table__row')"))) break
  }
  Sys.sleep(1)
  # mark the hosts: a kept component keeps its mark
  js(
    "['tbl', 'mod-pick', 'shape_sel'].forEach(function(id){ document.getElementById(id).__mark = 1; });
      document.querySelector('#alert_out [data-shiny-vue]').__mark = 1;"
  )

  # ── a table: sort by score, tick a row, then the server filters the data
  js(
    "document.querySelectorAll('#tbl th')[2].querySelector('.caret-wrapper .ascending').click()"
  )
  Sys.sleep(0.4)
  js(
    "document.querySelectorAll('#tbl .el-table__body .el-checkbox')[0].click()"
  )
  Sys.sleep(0.6)
  expect_equal(
    js(
      "Array.from(document.querySelectorAll('#tbl .el-table__body tr td:nth-child(2)')).map(function(c){ return c.textContent.trim(); }).join(',')"
    ),
    "Linus,Alan,Grace,Ada"
  )
  js("Shiny.setInputValue('min_score', 70)")
  Sys.sleep(1.5)
  expect_equal(js("document.getElementById('tbl').__mark"), 1)
  # the new rows, still in the user's order
  expect_equal(
    js(
      "Array.from(document.querySelectorAll('#tbl .el-table__body tr td:nth-child(2)')).map(function(c){ return c.textContent.trim(); }).join(',')"
    ),
    "Alan,Grace,Ada"
  )
  expect_true(js(
    "document.querySelectorAll('#tbl th')[2].classList.contains('ascending')"
  ))

  # ── no id given: a new random id each render is still the same component
  expect_equal(
    js("document.querySelector('#alert_out [data-shiny-vue]').__mark"),
    1
  )
  expect_match(
    js("document.querySelector('#alert_out').textContent"),
    "at least 70"
  )

  # ── in a module: the user's pick survives a render that changes the hint
  js("Shiny.setInputValue('mod-pick', 'b')") # as a pick would
  js("var h = document.getElementById('mod-pick'); h._shinyVue.value = 'b';")
  Sys.sleep(0.5)
  js("Shiny.setInputValue('hint', 1)")
  Sys.sleep(1.5)
  expect_equal(js("document.getElementById('mod-pick').__mark"), 1)
  expect_equal(js("document.getElementById('mod-pick')._shinyVue.value"), "b")
  expect_equal(
    js("document.getElementById('mod-pick')._shinyVue.placeholder"),
    "hint 1"
  )
  expect_match(
    js("document.getElementById('mod-seen').textContent"),
    "pick = b"
  )

  # ── another shape: replaced, as renderUI() would
  js("Shiny.setInputValue('as_input', true)")
  Sys.sleep(1.5)
  expect_true(js("!!document.querySelector('#shape_out #shape_in .el-input')"))
  expect_false(js("!!document.getElementById('shape_sel')"))
  js("Shiny.setInputValue('as_input', false)")
  Sys.sleep(1.5)
  expect_true(js("!!document.querySelector('#shape_out #shape_sel')"))
  expect_true(is.null(js("document.getElementById('shape_sel').__mark")))

  # ── several components and markup in one output
  js("Shiny.setInputValue('min_score', 0)")
  Sys.sleep(1.5)
  js(
    "['mix_sel', 'mix_tbl', 'tab_in'].forEach(function(id){ document.getElementById(id).__mark = 1; });
     document.getElementById('mix_sel')._shinyVue.value = 'y';"
  )
  js("document.getElementById('tb-tab-two').click()")
  Sys.sleep(0.8)
  js("document.getElementById('tab_in')._shinyVue.value = 'typed';")
  js("Shiny.setInputValue('min_score', 80)")
  Sys.sleep(1.5)
  # the heading's text, set by the server
  expect_equal(
    js("document.querySelector('#mixed_out .count').textContent"),
    "2 rows"
  )
  # both components kept, each patched
  expect_equal(js("document.getElementById('mix_sel').__mark"), 1)
  expect_equal(js("document.getElementById('mix_tbl').__mark"), 1)
  expect_equal(js("document.getElementById('mix_sel')._shinyVue.value"), "y")
  expect_equal(
    js("document.getElementById('mix_sel')._shinyVue.placeholder"),
    "min 80"
  )
  expect_equal(
    js("document.querySelectorAll('#mix_tbl .el-table__body tr').length"),
    2
  )
  # the formatter is the new one
  expect_match(
    js("document.querySelector('#mix_tbl .el-table__body').textContent"),
    "90 / 80"
  )
  # a markup container: the user's tab stays open, the input in it is patched
  expect_equal(
    js("document.querySelector('#tb .el-tabs__item.is-active').id"),
    "tb-tab-two"
  )
  expect_equal(js("document.getElementById('tab_in').__mark"), 1)
  expect_equal(js("document.getElementById('tab_in')._shinyVue.value"), "typed")
  expect_equal(
    js("document.getElementById('tab_in')._shinyVue.placeholder"),
    "min 80"
  )

  # ── an id the author gave is the component's identity: a new id renders
  # a new component, whatever the shape
  expect_true(js("!!document.getElementById('old_id')"))
  js("Shiny.setInputValue('ident', 'new_id')")
  Sys.sleep(1.2)
  expect_false(js("!!document.getElementById('old_id')"))
  expect_true(js("!!document.querySelector('#new_id .ident')"))
  expect_equal(js("Shiny.shinyapp.$inputValues.new_id"), 1)

  # ── removeUI() takes the output and its component away cleanly
  js("document.getElementById('drop').click()")
  Sys.sleep(1)
  expect_false(js("!!document.getElementById('tbl')"))

  expect_equal(
    js(
      "window.__w.filter(function(w){ return /Vue warn|shiny-vue/.test(w); }).length"
    ),
    0
  )
})
