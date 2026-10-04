# Overlays through Element's popup manager, and the keyboard on the
# components reimplemented as markup: what a mouse never exercises.

test_that("overlays stack with Element's popups, focus returns, keys work", {
  skip_if_no_browser()
  app <- testthat::test_path("apps", "overlays.R")
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
  b <- chromote::ChromoteSession$new(width = 1000, height = 800)
  on.exit(try(b$close(), silent = TRUE), add = TRUE)
  js <- function(x) b$Runtime$evaluate(x, awaitPromise = TRUE)$result$value
  loaded <- b$Page$loadEventFired(wait_ = FALSE)
  b$Page$navigate(sprintf("http://127.0.0.1:%d/", port), wait_ = FALSE)
  b$wait_for(loaded)
  Sys.sleep(3)
  vals <- function() {
    txt <- strsplit(js("document.getElementById('vals').innerText"), "\n")[[1]]
    stats::setNames(
      trimws(sub("^[^=]*=", "", txt)),
      trimws(sub("=.*", "", txt))
    )
  }
  key <- function(type, code, k) {
    b$Input$dispatchKeyEvent(
      type = type,
      windowsVirtualKeyCode = code,
      key = k,
      code = k
    )
  }

  # ── z-index: from el_page(z_index =), shared with every Element popup
  js("document.getElementById('open_outer').click()")
  Sys.sleep(2.5)
  z_outer <- as.numeric(js("document.getElementById('outer').style.zIndex"))
  z_inner <- as.numeric(js("document.getElementById('inner').style.zIndex"))
  expect_gte(z_outer, 3000)
  expect_gt(z_inner, z_outer)
  # opened follows the transition, once
  expect_equal(vals()[["outer_opened"]], "1")
  # the inner dialog, on top, keeps the focus: the outer one is under its mask
  js("document.getElementById('outer_btn').focus()")
  Sys.sleep(0.2)
  expect_true(js(
    "document.querySelector('#inner .el-dialog').contains(document.activeElement)"
  ))
  # a select inside the inner dialog opens above it
  js("document.querySelector('#pick2_container .el-select__wrapper').click()")
  Sys.sleep(1)
  # Element Plus's dropdown is a popper, z-indexed from the same counter
  expect_true(js(
    "(function(){
    var dd = Array.from(document.querySelectorAll('.el-select__popper'))
      .filter(function(e){ return getComputedStyle(e).display !== 'none'; })[0];
    var r = dd.getBoundingClientRect();
    var top = document.elementFromPoint(r.left + 10, r.top + 12);
    return !!(top && top.closest('.el-select__popper')) &&
      +getComputedStyle(dd).zIndex > +document.getElementById('inner').style.zIndex; })()"
  ))
  # Escape closes the topmost only: the dropdown -- whose input stops the
  # key going further, as in Element -- then, from elsewhere, the inner dialog
  key("keyDown", 27, "Escape")
  key("keyUp", 27, "Escape")
  Sys.sleep(0.5)
  expect_true(js(
    "Array.from(document.querySelectorAll('.el-select__popper')).every(function(e){ return getComputedStyle(e).display === 'none'; })"
  ))
  js("document.activeElement.blur()")
  key("keyDown", 27, "Escape")
  key("keyUp", 27, "Escape")
  Sys.sleep(1)
  expect_equal(js("document.getElementById('inner').style.display"), "none")
  expect_equal(js("document.getElementById('outer').style.display"), "")
  key("keyDown", 27, "Escape")
  key("keyUp", 27, "Escape")
  Sys.sleep(1)
  expect_equal(js("document.getElementById('outer').style.display"), "none")
  expect_false(js(
    "document.body.classList.contains('el-popup-parent--hidden')"
  ))

  # ── a drawer gives focus back to what had it
  js(
    "document.getElementById('open_drawer').focus(); document.getElementById('open_drawer').click()"
  )
  Sys.sleep(2)
  expect_equal(vals()[["drw"]], "TRUE")
  expect_true(js("document.activeElement.classList.contains('el-drawer')"))
  js("document.querySelector('#drw .el-drawer__close-btn').click()")
  Sys.sleep(1.5)
  expect_equal(js("document.activeElement.id"), "open_drawer")

  # ── focus trap: Tab and Shift+Tab stay inside the open dialog
  js(
    "(function(){ var w = document.getElementById('trap');
      $(w).data('shiny-input-binding').setValue(w, true); })()"
  )
  Sys.sleep(1.5)
  tab <- function(shift = FALSE) {
    b$Input$dispatchKeyEvent(
      type = "keyDown",
      windowsVirtualKeyCode = 9,
      key = "Tab",
      code = "Tab",
      modifiers = if (shift) 8 else 0
    )
    Sys.sleep(0.2)
    js(
      "(function(){ var a = document.activeElement;
        return document.querySelector('#trap .el-dialog').contains(a) ? 'in' : (a.id || a.tagName); })()"
    )
  }
  where <- vapply(1:6, function(i) tab(), "")
  expect_equal(unique(where), "in")
  where <- vapply(1:4, function(i) tab(TRUE), "")
  expect_equal(unique(where), "in")
  # focus that lands under the mask is brought back
  js("document.getElementById('outside_btn').focus()")
  Sys.sleep(0.2)
  expect_true(js(
    "document.querySelector('#trap .el-dialog').contains(document.activeElement)"
  ))
  # a drawer opened over the dialog takes the focus from it
  js(
    "(function(){ var w = document.getElementById('drw');
      $(w).data('shiny-input-binding').setValue(w, true); })()"
  )
  Sys.sleep(1.5)
  js("document.getElementById('trap_a').focus()")
  Sys.sleep(0.2)
  expect_true(js(
    "document.querySelector('#drw .el-drawer').contains(document.activeElement)"
  ))
  js(
    "(function(){ ['drw', 'trap'].forEach(function(id){ var w = document.getElementById(id);
      $(w).data('shiny-input-binding').setValue(w, false); }); })()"
  )
  Sys.sleep(1)

  # ── closed straight after opening: no late "opened"
  order <- js(
    "(async function(){
      var seen = [], orig = Shiny.setInputValue;
      Shiny.setInputValue = function(n){ if (/^race_/.test(n) && !/auto_focus/.test(n)) seen.push(n.slice(5)); return orig.apply(this, arguments); };
      var w = document.getElementById('race'), bd = $(w).data('shiny-input-binding');
      bd.setValue(w, true);
      await new Promise(function(r){ setTimeout(r, 50); });
      bd.setValue(w, false);
      await new Promise(function(r){ setTimeout(r, 1200); });
      Shiny.setInputValue = orig;
      return seen.join(' > ');
    })()"
  )
  expect_equal(order, "open > close > closed")

  # ── tabs: disabled tabs are passed over, cannot be closed; Enter adds
  js("document.getElementById('tabs2-tab-a').focus()")
  key("keyDown", 39, "ArrowRight")
  Sys.sleep(0.8)
  expect_equal(vals()[["tabs2"]], "c")
  expect_false(js(
    "document.getElementById('tabs2-tab-b').classList.contains('is-closable')"
  ))
  expect_false(js("!!document.querySelector('#tabs2-tab-b .is-icon-close')"))
  js("document.querySelector('#tabs2 .el-tabs__new-tab').focus()")
  key("keyDown", 13, "Enter")
  Sys.sleep(0.8)
  expect_equal(vals()[["tabs2_add"]], "TRUE")

  # ── tabs: arrows move and select, Delete closes, overflow scrolls
  expect_true(js(
    "document.querySelector('#tabs .el-tabs__nav-wrap').classList.contains('is-scrollable')"
  ))
  expect_true(js("!!document.querySelector('#tabs .el-tabs__nav-next')"))
  expect_equal(
    js("document.getElementById('tabs-tab-t1').getAttribute('aria-controls')"),
    "tabs-pane-t1"
  )
  js("document.getElementById('tabs-tab-t1').focus()")
  key("keyDown", 39, "ArrowRight")
  Sys.sleep(1)
  expect_equal(vals()[["tabs"]], "t2")
  expect_true(js(
    "document.getElementById('tabs-tab-t2').classList.contains('is-focus')"
  ))
  key("keyDown", 46, "Delete")
  Sys.sleep(1)
  expect_false(js("!!document.getElementById('tabs-tab-t2')"))
  # the last tab, out of view, scrolls in when selected
  js("document.getElementById('tabs-tab-t1').focus()")
  key("keyDown", 37, "ArrowLeft")
  Sys.sleep(1)
  expect_equal(vals()[["tabs"]], "t14")
  expect_true(js(
    "(function(){ var a = document.getElementById('tabs-tab-t14').getBoundingClientRect();
    var s = document.querySelector('#tabs .el-tabs__nav-scroll').getBoundingClientRect();
    return a.right <= s.right + 1 && a.left >= s.left - 1; })()"
  ))

  # ── collapse: Enter on a focused header opens it, with ARIA to match
  js("document.getElementById('col-head-b').focus()")
  key("keyUp", 13, "Enter")
  Sys.sleep(1)
  expect_equal(vals()[["col"]], "b")
  expect_equal(
    js("document.querySelector('#col-head-b').getAttribute('aria-expanded')"),
    "true"
  )
  expect_equal(
    js("document.getElementById('col-content-b').getAttribute('aria-hidden')"),
    "false"
  )
  key("keyUp", 32, " ")
  Sys.sleep(1)
  expect_equal(
    js("document.getElementById('col-content-b').style.display"),
    "none"
  )
})
