`%||%` <- function(a, b) if (is.null(a)) b else a

# Element Plus prototype: the bridge on Vue 3 -- one app per component --
# with the components and behaviours the migration has to keep.

test_that("the Vue 3 / Element Plus bridge keeps the Shiny contract", {
  skip_if_no_browser()
  app <- testthat::test_path("apps", "ep-prototype.R")
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
  errors <- character()
  b$Runtime$enable()
  b$Runtime$exceptionThrown(
    callback = function(e) {
      errors <<- c(errors, e$exceptionDetails$exception$description)
    },
    wait_ = FALSE
  )
  b$Runtime$consoleAPICalled(
    callback = function(e) {
      if (e$type %in% c("error", "warning")) {
        errors <<- c(
          errors,
          paste(
            vapply(
              e$args,
              function(a) as.character(a$value %||% a$description %||% ""),
              ""
            ),
            collapse = " "
          )
        )
      }
    },
    wait_ = FALSE
  )
  js <- function(x) b$Runtime$evaluate(x, returnByValue = TRUE)$result$value
  loaded <- b$Page$loadEventFired(wait_ = FALSE)
  b$Page$navigate(sprintf("http://127.0.0.1:%d/", port), wait_ = FALSE)
  b$wait_for(loaded)
  Sys.sleep(4)
  vals <- function() {
    txt <- strsplit(js("document.getElementById('dump').innerText"), "\n")[[1]]
    stats::setNames(
      trimws(sub("^[^=]*=", "", txt)),
      trimws(sub("=.*", "", txt))
    )
  }
  count <- function(sel) {
    js(sprintf("document.querySelectorAll('%s').length", sel))
  }

  # ── mounting: every component an app of its own, reporting on load
  v <- vals()
  expect_equal(v[["inp"]], "hello")
  expect_equal(v[["sel"]], "b")
  expect_equal(v[["dyn_inp"]], "dynamic") # renderUI
  expect_equal(v[["dlg_inp"]], "inside") # inside a closed dialog
  expect_equal(count("#btn .el-button"), 1)
  expect_equal(count("#tbl .el-table__body tr"), 3)
  expect_match(
    js("document.querySelector('#tbl .el-table__body tr').innerText"),
    "setosa"
  )

  # ── tables: group headers, cell and header templates at every level
  expect_equal(count("#grp b.grp-cell"), 2)
  expect_equal(count("#grp u.grp-cell2"), 2)
  expect_equal(count("#grp i.grp-head"), 1)

  # ── form: one item per field, a rule's message, submit
  expect_equal(count("#frm .el-form-item__label"), 2)
  js("document.querySelector('#frm .el-button--primary').click()")
  Sys.sleep(1.5)
  expect_match(js("document.getElementById('frm').innerText"), "name required")

  # ── events in, updates and method calls out
  js("document.querySelector('#btn .el-button').click()")
  js(
    "(function(){var i=document.querySelector('#inp input'); i.value='typed'; i.dispatchEvent(new Event('input'));})()"
  )
  Sys.sleep(1.5)
  v <- vals()
  expect_equal(v[["btn"]], "1")
  expect_equal(v[["inp"]], "typed")
  js("document.getElementById('upd').click()")
  Sys.sleep(1.5)
  v <- vals()
  expect_equal(v[["inp"]], "updated")
  expect_equal(v[["sel"]], "c")
  expect_equal(
    js("document.getElementById('inp-label').textContent"),
    "New name"
  )
  expect_equal(count("#tbl .el-table__body tr"), 5)
  js("document.getElementById('call').click()")
  Sys.sleep(1.5)
  expect_equal(vals()[["tbl"]], "2")

  # ── insertUI / removeUI: mounted, then unmounted with its app
  js("document.getElementById('add').click()")
  Sys.sleep(1.5)
  expect_equal(vals()[["ins_sw"]], "TRUE")
  js("window.__vm = document.getElementById('ins_sw')._shinyVue; 0")
  js("document.getElementById('rm').click()")
  Sys.sleep(1.5)
  expect_false(js("!!document.getElementById('ins_sw')"))
  expect_true(js("window.__vm.$.isUnmounted"))

  # ── dialog: Element Plus's markup, its z-index counter, scroll lock, Escape
  js("document.querySelector('#open_dlg .el-button').click()")
  Sys.sleep(1.5)
  expect_equal(vals()[["dlg"]], "TRUE")
  expect_equal(
    js("getComputedStyle(document.getElementById('dlg')).display"),
    "block"
  )
  expect_true(js("document.body.classList.contains('el-popup-parent--hidden')"))
  z_dlg <- as.numeric(js("document.getElementById('dlg').style.zIndex"))
  # a select inside opens above it, from the same counter
  js("document.querySelector('#dlg_sel .el-select__wrapper').click()")
  Sys.sleep(1)
  z_pop <- as.numeric(js(
    "(function(){var p=[].filter.call(document.querySelectorAll('.el-select__popper'), function(e){return getComputedStyle(e).display!=='none'})[0]; return p ? getComputedStyle(p).zIndex : 0;})()"
  ))
  expect_gt(z_pop, z_dlg)
  # the select keeps Escape to itself while it has focus, as upstream's does
  js(
    "document.body.click(); document.activeElement && document.activeElement.blur(); 0"
  )
  Sys.sleep(0.5)
  b$Input$dispatchKeyEvent(
    type = "keyDown",
    windowsVirtualKeyCode = 27,
    key = "Escape",
    code = "Escape"
  )
  b$Input$dispatchKeyEvent(
    type = "keyUp",
    windowsVirtualKeyCode = 27,
    key = "Escape",
    code = "Escape"
  )
  Sys.sleep(1.5)
  expect_equal(vals()[["dlg"]], "FALSE")
  expect_false(js(
    "document.body.classList.contains('el-popup-parent--hidden')"
  ))

  # ── drawer: opens over the page, a click on the mask closes it
  js("document.querySelector('#open_drw .el-button').click()")
  Sys.sleep(1.5)
  expect_equal(vals()[["drw"]], "TRUE")
  expect_gt(
    js(
      "document.querySelector('#drw .el-drawer').getBoundingClientRect().width"
    ),
    100
  )
  js(
    "(function(){var w=document.getElementById('drw'); w.dispatchEvent(new MouseEvent('mousedown',{bubbles:true})); w.dispatchEvent(new MouseEvent('click',{bubbles:true}));})()"
  )
  Sys.sleep(1.5)
  expect_equal(vals()[["drw"]], "FALSE")

  # ── theme: CSS variables, tints included; dark mode is Element's own
  expect_equal(
    trimws(js(
      "getComputedStyle(document.documentElement).getPropertyValue('--el-color-primary')"
    )),
    "#7c3aed"
  )
  expect_equal(
    trimws(js(
      "getComputedStyle(document.querySelector('#btn .el-button')).backgroundColor"
    )),
    "rgb(124, 58, 237)"
  )
  light_bg <- js(
    "getComputedStyle(document.documentElement).getPropertyValue('--el-bg-color')"
  )
  js("document.documentElement.classList.add('dark')")
  expect_false(identical(
    js(
      "getComputedStyle(document.documentElement).getPropertyValue('--el-bg-color')"
    ),
    light_bg
  ))

  # ── components Element Plus added: mounted, reporting, interactive
  v <- vals()
  expect_equal(v[["seg"]], "w")
  expect_equal(v[["itag"]], "a,b")
  expect_equal(v[["sv2"]], "Option 5")
  expect_equal(v[["tsel"]], "web")
  expect_equal(v[["ctag"]], "TRUE")
  js(
    "[].filter.call(document.querySelectorAll('#seg .el-segmented__item'), function(e){ return /Day/.test(e.innerText); })[0].click()"
  )
  js("document.querySelector('#ctag .el-check-tag').click()")
  Sys.sleep(1.5)
  v <- vals()
  expect_equal(v[["seg"]], "d")
  expect_equal(v[["ctag"]], "FALSE")
  # a virtualized table draws a few of its 5000 rows, not all
  rows <- count("#tv2 .el-table-v2__row")
  expect_gt(rows, 0)
  expect_lt(rows, 100)
  # a container folds its buttons in, and they still report
  js(
    "document.querySelector('#sp2 .el-button, [id^=el_space] .el-button:nth-of-type(2)') && 0"
  )
  expect_equal(count(".el-space .el-button"), 2)

  expect_length(errors, 0)
})
