# Components inside bslib's and Shiny's containers, bslib's dark mode, and
# shinyjs.

test_that("components work inside bslib and Shiny containers", {
  skip_if_no_browser()
  skip_if_not_installed("shinyjs")
  app <- testthat::test_path("apps", "bslib.R")
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
  b <- chromote::ChromoteSession$new(width = 1300, height = 1000)
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
  value <- function(id) {
    js(sprintf("JSON.stringify(Shiny.shinyapp.$inputValues['%s'])", id))
  }
  size <- function(sel) {
    js(sprintf(
      "(function() { var e = document.querySelector('%s'); if (!e) return 'missing';
         var r = e.getBoundingClientRect(); return Math.round(r.width) + 'x' + Math.round(r.height); })()",
      sel
    ))
  }
  click_tab <- function(text) {
    js(sprintf(
      "Array.from(document.querySelectorAll('.nav-link')).filter(function(a) { return a.textContent.trim() === '%s'; })[0].click()",
      text
    ))
    Sys.sleep(1)
  }
  Sys.sleep(6)

  # every host mounted, in a sidebar and in cards
  expect_equal(
    js("document.querySelectorAll('[data-shiny-vue-root]').length"),
    js("document.querySelectorAll('[data-shiny-vue]').length")
  )
  expect_equal(value("sb_sel"), '"a"')
  expect_equal(
    js("document.querySelectorAll('#tbl .el-table__body tr').length"),
    3
  )

  # hidden containers: the value is there before they open, the layout after
  expect_equal(value("acc_in"), '"in accordion"')
  js("document.querySelector('.accordion-button').click()")
  Sys.sleep(1)
  expect_false(size("#acc_in .el-input") %in% c("0x0", "missing"))

  expect_equal(value("nav_sl"), "30")
  click_tab("two")
  expect_equal(size("#nav_sl .el-slider__button"), "20x20")
  expect_false(size("#nav_tabs .el-tabs__active-bar") %in% c("0x2", "missing"))

  click_tab("B")
  expect_equal(value("tsp_rate"), "2")
  expect_false(size("#tsp_rate .el-rate") %in% c("0x0", "missing"))

  expect_equal(value("cp_sw"), "true")
  js("document.getElementById('show_cp').click()")
  Sys.sleep(1)
  expect_false(size("#cp_sw .el-switch") %in% c("0x0", "missing"))

  # a modal: the component binds, and its dropdown opens above the modal
  js("document.getElementById('modal').click()")
  Sys.sleep(1.5)
  expect_equal(value("md_sel"), '"x"')
  js("document.querySelector('.modal .el-select__wrapper').click()")
  Sys.sleep(0.8)
  expect_true(js(
    "(function() {
       var d = Array.from(document.querySelectorAll('.el-select__popper'))
         .filter(function(e) { return getComputedStyle(e).display !== 'none'; })[0];
       return !!d && +getComputedStyle(d).zIndex >
         +getComputedStyle(document.querySelector('.modal')).zIndex;
     })()"
  ))
  js(
    "document.body.dispatchEvent(new KeyboardEvent('keydown', { key: 'Escape' }))"
  )
  js("$('.modal').modal('hide')")
  Sys.sleep(1)

  # shinyjs
  step <- function(input) {
    js(sprintf("Shiny.setInputValue('%s', Math.random())", input))
    Sys.sleep(0.8)
  }
  step("do_hide")
  expect_equal(size("#js_in .el-input"), "0x0")
  step("do_show")
  expect_false(size("#js_in .el-input") == "0x0")
  step("do_toggle")
  expect_equal(size("#js_in .el-input"), "0x0")
  step("do_toggle")
  expect_false(size("#js_in .el-input") == "0x0")
  step("do_disable")
  expect_true(js(
    "document.querySelector('#js_in .el-input').classList.contains('is-disabled')"
  ))
  step("do_enable")
  expect_false(js(
    "document.querySelector('#js_in .el-input').classList.contains('is-disabled')"
  ))

  # shinyjs::reset(): the components go back as the page had them, beside
  # Shiny's own input
  sel_before <- value("rs_sel")
  step("do_change")
  expect_equal(value("rs_in"), '"changed"')
  expect_equal(value("rs_sel"), '["b","c"]')
  expect_equal(value("rs_txt"), '"changed"')
  step("do_reset")
  Sys.sleep(0.5)
  expect_equal(value("rs_in"), '"start"')
  expect_equal(value("rs_sel"), sel_before)
  expect_equal(value("rs_txt"), '"orig"')

  # shinyjs::hidden() and disabled() wrap a component in the UI; click()
  # reaches the button inside it
  expect_equal(size("#sj_hid .el-input"), "0x0")
  step("do_show_hid")
  expect_false(size("#sj_hid .el-input") == "0x0")
  expect_true(js(
    "document.querySelector('#sj_dis .el-input').classList.contains('is-disabled')"
  ))
  clicks <- "(function() { var v = Shiny.shinyapp.$inputValues;
    var k = Object.keys(v).filter(function(k) { return k.split(':')[0] === 'sj_btn'; })[0];
    return String(v[k]); })()"
  expect_equal(js(clicks), "0")
  step("do_click")
  expect_equal(js(clicks), "1")

  # session$setCurrentTheme(): Element's colours follow the new theme
  primary <- "getComputedStyle(document.documentElement).getPropertyValue('--el-color-primary').trim().toLowerCase()"
  expect_equal(js(primary), "#409eff")
  step("do_theme")
  Sys.sleep(4)
  expect_equal(js(primary), "#198754")

  # bslib's tooltip and popover: the host is their trigger, and has a box
  hover <- function(sel) {
    r <- jsonlite::fromJSON(js(sprintf(
      "(function() { var e = document.querySelector('%s'); e.scrollIntoView({block: 'center'});
         var r = e.getBoundingClientRect(); return JSON.stringify([r.x + r.width / 2, r.y + r.height / 2]); })()",
      sel
    )))
    b$Input$dispatchMouseEvent(type = "mouseMoved", x = 1, y = 1)
    Sys.sleep(0.2)
    b$Input$dispatchMouseEvent(type = "mouseMoved", x = r[1], y = r[2])
    Sys.sleep(1)
    r
  }
  box <- function(id) {
    js(sprintf(
      "(function() { var h = document.getElementById('%s'), c = h.querySelector('button, .el-input');
         var a = h.getBoundingClientRect(), b = c.getBoundingClientRect();
         return Math.round(a.width) + '/' + Math.round(b.width); })()",
      id
    ))
  }
  # the box is the component's size: a button's, an input's whole line
  w <- strsplit(box("tip_btn"), "/")[[1]]
  expect_equal(w[1], w[2])
  expect_lt(as.numeric(w[1]), 200)
  w <- strsplit(box("pop_in"), "/")[[1]]
  expect_equal(w[1], w[2])
  at <- hover("#tip_btn button")
  tip <- jsonlite::fromJSON(js(
    "(function() { var t = document.querySelector('.tooltip.show'); if (!t) return 'null';
       var r = t.getBoundingClientRect(); return JSON.stringify([r.x, r.y, r.width, r.height]); })()"
  ))
  expect_length(tip, 4)
  # beside the button, not in the corner of the page
  expect_lt(
    abs(tip[1] + tip[3] / 2 - at[1]) + abs(tip[2] + tip[4] / 2 - at[2]),
    120
  )
  b$Input$dispatchMouseEvent(type = "mouseMoved", x = 1, y = 1)
  js("document.querySelector('#pop_in input').click()")
  Sys.sleep(1)
  expect_true(js("!!document.querySelector('.popover.show')"))
  js("document.body.click()")
  Sys.sleep(0.5)

  # bslib's dark mode switch turns Element Plus's dark mode with it
  dark <- function() {
    js("document.documentElement.classList.contains('dark')")
  }
  background <- function() {
    js(
      "getComputedStyle(document.querySelector('#js_in .el-input__wrapper')).backgroundColor"
    )
  }
  light_bg <- background()
  expect_false(dark())
  toggle_dark <- function() {
    js(
      "(function() { var t = document.querySelector('bslib-input-dark-mode');
         (t.shadowRoot ? t.shadowRoot.querySelector('button') : t).click(); })()"
    )
    Sys.sleep(1)
  }
  toggle_dark()
  expect_equal(
    js("document.documentElement.getAttribute('data-bs-theme')"),
    "dark"
  )
  expect_true(dark())
  expect_false(identical(background(), light_bg))
  toggle_dark()
  expect_false(dark())
  expect_equal(background(), light_bg)

  expect_equal(js("window.__w.length"), 0)
})
