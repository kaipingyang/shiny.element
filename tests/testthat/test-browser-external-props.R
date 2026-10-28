# Props that need something outside Element to work -- see
# tools/external-props.csv: what each needs, how the package gives it, and
# here, that it works in a browser. API coverage sees them bound and prop
# reach their values arrive; neither sees one arrive and do nothing.

test_that("props needing Day.js, Dates or Date functions work from R", {
  skip_if_no_browser()
  app <- testthat::test_path("apps", "external-props.R")
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
  b <- chromote::ChromoteSession$new(width = 1000, height = 900)
  on.exit(try(b$close(), silent = TRUE), add = TRUE)
  js <- function(x) b$Runtime$evaluate(x, returnByValue = TRUE)$result$value
  b$Page$navigate(sprintf("http://127.0.0.1:%d", port))
  Sys.sleep(5)
  js(paste0(
    "window.__w = []; ['warn', 'error'].forEach(function(k) { var o = console[k]; ",
    "console[k] = function() { __w.push(Array.from(arguments).join(' ')); o.apply(console, arguments); }; });"
  ))
  open <- function(id) {
    js("document.body.click()")
    Sys.sleep(0.3)
    js(sprintf("document.querySelector('#%s_container input').focus()", id))
    Sys.sleep(0.8)
  }
  # the picker's panel now open
  panel <- "Array.from(document.querySelectorAll('.el-picker__popper')).filter(function(p) { return p.style.display !== 'none'; }).pop()"

  # Day.js's format tokens, from plugins inside Element's build
  shown <- js("document.querySelector('#fmt_container input').value")
  expect_match(shown, "^27th October 2026, W[0-9]+, Q4$")

  # default_value: a Date made from text opens the panel on its month
  open("dv")
  expect_match(
    js(paste0(panel, ".querySelector('.el-date-picker__header').textContent")),
    "2010.*October"
  )

  # a function Element calls with a Date: disabled, a cell's class
  open("dd")
  cell <- function(day, cls) {
    js(sprintf(
      paste0(
        "Array.from(",
        panel,
        ".querySelectorAll('.el-date-table td.available, .el-date-table td.disabled'))",
        ".filter(function(td) { return td.textContent.trim() === '%d'; })",
        ".some(function(td) { return td.classList.contains('%s'); })"
      ),
      day,
      cls
    ))
  }
  expect_true(cell(13, "disabled"))
  expect_true(cell(14, "is-fourteen"))
  expect_false(cell(15, "disabled"))
  # a shortcut whose value a function makes, a Date
  js(paste0(panel, ".querySelector('.el-picker-panel__shortcut').click()"))
  Sys.sleep(1)
  expect_match(
    js("document.getElementById('seen').textContent"),
    "dd=2000-01-01"
  )

  # default_time: the time a picked date gets
  open("dt")
  js(paste0(
    "Array.from(",
    panel,
    ".querySelectorAll('.el-date-table td.available'))",
    ".filter(function(td) { return td.textContent.trim() === '15'; })[0].click()"
  ))
  Sys.sleep(0.5)
  js(paste0(
    panel,
    ".querySelector('.el-picker-panel__footer .el-button--primary, .el-picker-panel__footer button:last-child').click()"
  ))
  Sys.sleep(1)
  expect_match(
    js("document.getElementById('seen').textContent"),
    "dt=[0-9-]+ 12:34:56"
  )

  expect_equal(js("window.__w.length"), 0)
})
