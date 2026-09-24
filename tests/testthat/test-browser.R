# Browser integration tests.
#
# These cover the failures the HTML-level unit tests structurally cannot see:
# a Vue watch that never fires on mount, a handler script that is never loaded,
# a template that fails to compile, a custom tag nothing compiles. Each of the
# bugs asserted here shipped while the unit suite was fully green.
#
# One app and one browser session are shared across the file (see
# helper-browser.R). Tests that click run after the ones that read the initial
# state, because they change it.

# ── initial values ────────────────────────────────────────────────────────────

test_that("every stateful component reports its value on load", {
  skip_if_no_browser()
  vals <- bdump()

  expected <- c(
    inp = "hello", sel = "b", sw = "TRUE", sld = "42", rate = "3",
    rg = "y", cg = "p", num = "7", dp = "2026-01-15", cp = "#409EFF",
    tabs = "t2", pg_page = "3", pg_size = "20", col = "i2",
    rg_num = "1", stp = "0", sw_nested = "TRUE", sld_nested = "88"
  )

  for (id in names(expected)) {
    expect_false(identical(vals[[id]], "<NULL>"),
                 info = sprintf("input$%s reported no value on load", id))
    expect_equal(vals[[id]], expected[[id]],
                 info = sprintf("input$%s", id))
  }
})

test_that("an empty table selection reports NULL, as Shiny does", {
  skip_if_no_browser()
  # Shiny turns an empty JSON array into NULL; matching checkboxGroupInput.
  expect_equal(bdump()[["tbl_selected_rows"]], "<NULL>")
})

# ── choices normalisation ─────────────────────────────────────────────────────

test_that("a named numeric vector keeps its labels and stays an array", {
  skip_if_no_browser()
  expect_equal(
    bev("JSON.stringify(Array.from(document.querySelectorAll('#rg_num_container .el-radio__label')).map(function(e){return e.innerText.trim()}))"),
    '["First","Second"]'
  )
  # Leftover names used to serialise options as an object, which v-for cannot
  # iterate the way the component expects.
  expect_equal(
    bev("(function(){var w=HTMLWidgets.find('#rg_num'); return Array.isArray(w.instance.options)?'array':'object'})()"),
    "array"
  )
  expect_equal(
    bev("(function(){var w=HTMLWidgets.find('#rg_num'); return typeof w.instance.options[0].value})()"),
    "number"
  )
})

# ── table ─────────────────────────────────────────────────────────────────────

test_that("a data.frame renders as rows, not columns", {
  skip_if_no_browser()
  expect_equal(bev("String(document.querySelectorAll('#tbl_container .el-table__body-wrapper tbody tr').length)"), "4")
  expect_equal(
    bev("(function(){var w=HTMLWidgets.find('#tbl'); return Array.isArray(w.instance.tableData)?'array':'object'})()"),
    "array"
  )
})

test_that("column labels keep the original names while props are sanitised", {
  skip_if_no_browser()
  headers <- bev("JSON.stringify(Array.from(document.querySelectorAll('#tbl_container .el-table__header th')).map(function(e){return e.innerText.trim()}).filter(function(x){return x!==''}))")
  expect_match(headers, "Sepal.Length", fixed = TRUE)
  # prop must be underscored: el-table resolves it as a dotted path.
  expect_equal(
    bev("(function(){var w=HTMLWidgets.find('#tbl'); return w.instance.columns[0].prop})()"),
    "Sepal_Length"
  )
})

test_that("columns are reactive, not baked into the markup", {
  skip_if_no_browser()
  expect_equal(
    bev("(function(){var w=HTMLWidgets.find('#tbl'); return ['columns','border','selection'].filter(function(k){return k in w.instance.$data}).join(',')})()"),
    "columns,border,selection"
  )
})

# ── layout ────────────────────────────────────────────────────────────────────

test_that("grid components emit compiled Element UI classes", {
  skip_if_no_browser()
  # They used to render as literal <el-row>/<el-col> tags that nothing compiled.
  expect_equal(bev("String(document.querySelectorAll('#grid el-row, #grid el-col').length)"), "0")
  expect_equal(bev("String(document.querySelectorAll('#grid .el-row').length)"), "1")
  expect_equal(bev("String(document.querySelectorAll('#grid .el-col').length)"), "2")
})

test_that("a 12/12 split renders as two equal side-by-side columns", {
  skip_if_no_browser()
  geom <- bev("(function(){var c=document.querySelectorAll('#grid .el-col'); var a=c[0].getBoundingClientRect(), b=c[1].getBoundingClientRect(); return JSON.stringify({w1:Math.round(a.width), w2:Math.round(b.width), sameRow:Math.round(a.top)===Math.round(b.top), ordered:b.left>a.left})})()")
  geom <- jsonlite::fromJSON(geom)
  expect_equal(geom$w1, geom$w2)
  expect_true(geom$sameRow)
  expect_true(geom$ordered)
})

test_that("gutter is applied as margins and matching padding", {
  skip_if_no_browser()
  expect_match(bev("getComputedStyle(document.querySelector('#grid .el-row')).marginLeft"), "^-10px$")
  expect_match(bev("getComputedStyle(document.querySelector('#grid .el-col')).paddingLeft"), "^10px$")
})

test_that("a flex row computes the requested alignment", {
  skip_if_no_browser()
  css <- bev("(function(){var s=getComputedStyle(document.querySelector('#flexrow .el-row')); return s.display+'|'+s.justifyContent+'|'+s.alignItems})()")
  expect_equal(css, "flex|center|center")
})

test_that("a container with a header lays out vertically", {
  skip_if_no_browser()
  expect_equal(
    bev("getComputedStyle(document.querySelector('#layout > .el-container')).flexDirection"),
    "column"
  )
  expect_equal(
    bev("getComputedStyle(document.querySelector('#layout .el-container .el-container')).flexDirection"),
    "row"
  )
})

test_that("header height and aside width are applied", {
  skip_if_no_browser()
  expect_equal(bev("String(Math.round(document.querySelector('#layout .el-header').getBoundingClientRect().height))"), "60")
  expect_equal(bev("String(Math.round(document.querySelector('#layout .el-aside').getBoundingClientRect().width))"), "200")
})

test_that("widgets nested in a container mount and report values", {
  skip_if_no_browser()
  # The old Vue-template container swallowed these entirely: no container, no
  # widget, no error.
  expect_equal(
    bev("JSON.stringify(['sw_nested','sld_nested'].map(function(id){var w=HTMLWidgets.find('#'+id); return w&&w.instance?'ok':'missing'}))"),
    '["ok","ok"]'
  )
  vals <- bdump()
  expect_equal(vals[["sw_nested"]], "TRUE")
  expect_equal(vals[["sld_nested"]], "88")
})

# ── interactions (these mutate state; keep them last) ─────────────────────────

test_that("stepping through every step reaches all-finished", {
  skip_if_no_browser()
  finished <- function() {
    bev("String(document.querySelectorAll('#stp_container .el-step__icon-inner.is-status.el-icon-check').length)")
  }
  expect_equal(finished(), "0")

  for (i in 1:3) bclick("#step_next")
  # active == number of steps is what marks the last step finished.
  expect_equal(bdump()[["stp"]], "3")
  expect_equal(finished(), "3")

  bclick("#step_next")
  expect_equal(bdump()[["stp"]], "0")
  expect_equal(finished(), "0")
})

test_that("selecting rows reports 1-based row numbers with their types", {
  skip_if_no_browser()
  bev("(function(){var c=document.querySelectorAll('#tbl_container .el-table__body-wrapper .el-checkbox'); c[0].click(); c[2].click();})()")
  Sys.sleep(2)
  # Row objects come back simplified to character; row numbers do not.
  expect_equal(bdump()[["tbl_selected_rows"]], "1,3")
})

test_that("update_el_table swaps the data and re-infers the columns", {
  skip_if_no_browser()
  bclick("#tbl_swap", wait = 2.5)
  expect_equal(bev("String(document.querySelectorAll('#tbl_container .el-table__body-wrapper tbody tr').length)"), "6")
  headers <- bev("JSON.stringify(Array.from(document.querySelectorAll('#tbl_container .el-table__header th')).map(function(e){return e.innerText.trim()}).filter(function(x){return x!==''}))")
  expect_match(headers, "mpg", fixed = TRUE)
})

test_that("the cascader's own handler is loaded and its updates land", {
  skip_if_no_browser()
  scripts <- bev("JSON.stringify(Array.from(document.querySelectorAll('script[src]')).map(function(s){var m=s.src.match(/el-[a-z-]+-handler/); return m?m[0]:null}).filter(Boolean))")
  expect_match(scripts, "el-cascader-handler", fixed = TRUE)

  bclick("#casc_update", wait = 2.5)
  expect_equal(bev("document.querySelector('#casc_container input').placeholder"), "updated")
  expect_equal(bev("(function(){var w=HTMLWidgets.find('#casc'); return JSON.stringify(w.instance.value)})()"), '["js","nj"]')
  expect_equal(bev("(function(){var w=HTMLWidgets.find('#casc'); return String(w.instance.disabled)})()"), "true")
})

# ── no silent failures ────────────────────────────────────────────────────────

test_that("the page raises no JS exceptions throughout", {
  skip_if_no_browser()
  # vue.min.js is a production build with warnings stripped, so a template that
  # fails to compile is silent -- exceptions are what is left to catch.
  expect_equal(bjs_errors(), character(0))
})
