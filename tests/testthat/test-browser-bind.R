# vue_bind(): components following one another in the browser -- with no
# Shiny on the page, and with a server that reads and changes what they do.

bind_page_js <- function(b) {
  function(x) b$Runtime$evaluate(x, returnByValue = TRUE)$result$value
}

catch_warnings <- function(js) {
  js(paste0(
    "window.__w = []; ['warn', 'error'].forEach(function(k) { var o = console[k]; ",
    "console[k] = function() { __w.push(Array.from(arguments).join(' ')); o.apply(console, arguments); }; });"
  ))
}

gap <- "getComputedStyle(document.querySelector('#sp .el-space')).columnGap"
checked <- function(id) {
  sprintf(
    "document.querySelector('#%s .el-switch').classList.contains('is-checked')",
    id
  )
}
dialog_open <- "document.getElementById('dlg').style.display !== 'none'"
active_tab <- "document.querySelector('#tabs .el-tabs__item.is-active').textContent.trim()"
state <- "document.querySelector('#state [data-shiny-vue-root]').textContent.trim()"

test_that("bound components follow each other on a page with no Shiny", {
  skip_if_no_browser()
  source(testthat::test_path("apps", "bind.R"), local = TRUE)
  dir <- withr::local_tempdir()
  htmltools::save_html(
    htmltools::tagList(use_element(dev = TRUE), bind_ui()),
    file.path(dir, "page.html"),
    libdir = "lib"
  )
  use_browser_args()
  b <- chromote::ChromoteSession$new(width = 1000, height = 700)
  on.exit(try(b$close(), silent = TRUE), add = TRUE)
  js <- bind_page_js(b)
  b$Page$navigate(paste0("file://", file.path(dir, "page.html")))
  Sys.sleep(3)
  catch_warnings(js)
  expect_equal(js("typeof Shiny"), "undefined")
  # $inputs filled with no Shiny: the space follows the radio group
  expect_equal(js(gap), "12px")
  js("document.querySelectorAll('#sz .el-radio')[0].click()")
  Sys.sleep(0.3)
  expect_equal(js(gap), "16px")
  # a store both ways: one switch turned off, the other follows
  expect_true(js(checked("sw2")))
  js("document.querySelector('#sw .el-switch').click()")
  Sys.sleep(0.3)
  expect_false(js(checked("sw2")))
  expect_match(js(state), "on=false")
  # a container: opened by an `on` handler setting the store, closed by
  # its user, the store following
  js("document.querySelector('#open button').click()")
  Sys.sleep(0.6)
  expect_true(js(dialog_open))
  expect_match(js(state), "open=true")
  js("document.querySelector('#dlg .el-dialog__headerbtn').click()")
  Sys.sleep(0.6)
  expect_false(js(dialog_open))
  expect_match(js(state), "open=false")
  # tabs: clicked, the store follows; the store set, the tab follows
  js("document.querySelectorAll('#tabs .el-tabs__item')[1].click()")
  Sys.sleep(0.3)
  expect_match(js(state), "tab=b")
  js("shinyVue.useStore('ui').tab = 'a'")
  Sys.sleep(0.3)
  expect_equal(js(active_tab), "A")
  # a drawer's edge following a radio group, its visibility a store
  js("document.querySelectorAll('#edge .el-radio')[1].click()")
  js("shinyVue.useStore('ui').drawer = true")
  Sys.sleep(0.6)
  expect_true(js("!!document.querySelector('#drw .el-drawer.btt')"))
  expect_true(js("document.getElementById('drw').style.display !== 'none'"))
  js("document.querySelector('#drw .el-drawer__close-btn').click()")
  Sys.sleep(0.6)
  expect_false(js("shinyVue.useStore('ui').drawer"))
  # Element's message service from an `on` handler
  js("document.querySelector('#msg button').click()")
  Sys.sleep(0.4)
  expect_equal(
    js("(document.querySelector('.el-message') || {}).textContent"),
    "Hi from the page"
  )
  expect_equal(js("__w.length"), 0)
})

test_that("with a server: it reads what the page did and changes it", {
  skip_if_no_browser()
  app <- testthat::test_path("apps", "bind.R")
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
  js <- bind_page_js(b)
  b$Page$navigate(sprintf("http://127.0.0.1:%d", port))
  Sys.sleep(5)
  catch_warnings(js)
  seen <- function() js("document.getElementById('seen').textContent")
  expect_equal(seen(), "sz=default sw=TRUE sw2=TRUE dlg=FALSE tabs=a")
  # the page changes without the server, and the server hears of it
  js("document.querySelectorAll('#sz .el-radio')[0].click()")
  js("document.querySelector('#sw .el-switch').click()")
  Sys.sleep(0.1)
  expect_equal(js(gap), "16px")
  expect_false(js(checked("sw2")))
  Sys.sleep(1)
  expect_equal(seen(), "sz=large sw=FALSE sw2=FALSE dlg=FALSE tabs=a")
  js("document.querySelector('#open button').click()")
  Sys.sleep(1)
  expect_equal(seen(), "sz=large sw=FALSE sw2=FALSE dlg=TRUE tabs=a")
  js("document.querySelector('#dlg .el-dialog__headerbtn').click()")
  Sys.sleep(1)
  expect_match(seen(), "dlg=FALSE")
  # an update of a bound field sets the store, and the other switch follows
  js("document.querySelector('#srv_on button').click()")
  Sys.sleep(1.5)
  expect_true(js(checked("sw2")))
  expect_match(js(state), "on=true")
  expect_match(seen(), "sw=TRUE sw2=TRUE")
  # a container's update too
  js("document.querySelector('#srv_tab button').click()")
  Sys.sleep(1.5)
  expect_match(js(state), "tab=b")
  expect_match(seen(), "tabs=b")
  expect_equal(js("__w.length"), 0)
})
