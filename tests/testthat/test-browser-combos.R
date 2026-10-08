# Components put together as an app does (apps/combos.R): each check here
# is a bug found by combining them, which no component's own test showed.

test_that("components work together: folded, provided, drawn later, hidden", {
  skip_if_no_browser()
  app <- testthat::test_path("apps", "combos.R")
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
  # an input's value, whatever type it was sent with
  input <- function(id) {
    js(sprintf(
      "(function(){ var v = Shiny.shinyapp.$inputValues; var k = Object.keys(v).filter(function(x){ return x === '%1$s' || x.indexOf('%1$s:') === 0; })[0]; return k ? JSON.stringify(v[k]) : null; })()",
      id
    ))
  }
  click <- function(id, wait = 1.5) {
    js(sprintf("document.getElementById('%s').click()", id))
    Sys.sleep(wait)
  }
  checked <- function(tree, label) {
    js(sprintf(
      "Array.from(document.querySelectorAll('#%s .el-tree-node.is-checked')).some(function(n){ return n.querySelector('.el-tree-node__label').innerText === '%s'; })",
      tree,
      label
    ))
  }

  # components folded in at different depths keep reporting, and keep
  # their ids: on the component itself, its host being gone
  expect_identical(input("sel"), '"a"')
  expect_true(js("document.getElementById('tip_btn').tagName === 'BUTTON'"))
  # a select in an input's slot, inside a provider, reports on load
  expect_identical(input("kind"), '"n"')

  # updates by their own ids reach them
  click("upd")
  expect_identical(
    js("document.getElementById('tip_btn').innerText.trim()"),
    "Updated"
  )
  expect_identical(input("sel"), '"c"')
  expect_identical(input("kind"), '"i"')

  # a component drawn later inside the provider takes its settings, and
  # follows when they change
  expect_true(js("!!document.querySelector('#dyn .el-button--small')"))
  js("document.querySelectorAll('#size_pick .el-radio-button')[2].click()")
  Sys.sleep(2)
  expect_true(js("!!document.querySelector('#dyn .el-button--large')"))
  expect_true(js("!!document.querySelector('#tip_btn.el-button--large')"))

  # two trees in one instance: each method reaches its own, and the checked
  # keys are reported after a method as after a click
  click("check_a")
  expect_true(checked("tree_a", "Pear"))
  expect_false(checked("tree_b", "Pear"))
  expect_match(input("tree_a_checked"), "12")
  click("check_b")
  expect_true(checked("tree_b", "Leek"))
  expect_false(checked("tree_a", "Leek"))

  # a provider inside another inherits what it leaves unset: the card's
  # shadow and, for a component drawn later, the size
  expect_true(js(
    "document.querySelector('#outer .el-card').classList.contains('is-never-shadow')"
  ))
  expect_true(js("!!document.querySelector('#inner_dyn .el-button--large')"))

  # a tab inserted into tabs whose id has a dot
  click("add_tab", 2)
  expect_equal(
    js("document.querySelectorAll('[id=\"tabs.dot\"] .el-tabs__item').length"),
    2
  )
  expect_equal(
    js("document.querySelectorAll('[id=\"tabs.dot\"] .el-tab-pane').length"),
    2
  )

  # tabs drawn in a closed dialog: the active bar is measured once shown
  click("open", 2)
  expect_gt(
    js(
      "document.querySelector('#dlg_tabs .el-tabs__active-bar').getBoundingClientRect().width"
    ),
    20
  )

  expect_identical(js("JSON.stringify(window.__w)"), "[]")
})
