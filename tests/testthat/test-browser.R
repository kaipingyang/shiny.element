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
    inp = "hello",
    sel = "b",
    sw = "TRUE",
    sld = "42",
    rate = "3",
    rg = "y",
    cg = "p",
    num = "7",
    dp = "2026-01-15",
    cp = "#409EFF",
    tabs = "t2",
    pg = "3",
    pg_size = "20",
    col = "i2",
    rg_num = "1",
    stp = "0",
    sw_nested = "TRUE",
    sld_nested = "88"
  )

  for (id in names(expected)) {
    expect_false(
      identical(vals[[id]], "<NULL>"),
      info = sprintf("input$%s reported no value on load", id)
    )
    expect_equal(vals[[id]], expected[[id]], info = sprintf("input$%s", id))
  }
})

test_that("an empty table selection reports NULL, as Shiny does", {
  skip_if_no_browser()
  # Shiny turns an empty JSON array into NULL; matching checkboxGroupInput.
  expect_equal(bdump()[["tbl_selection_rows"]], "<NULL>")
})

# ── choices normalisation ─────────────────────────────────────────────────────

test_that("a named numeric vector keeps its labels and stays an array", {
  skip_if_no_browser()
  expect_equal(
    bev(
      "JSON.stringify(Array.from(document.querySelectorAll('#rg_num_container .el-radio__label')).map(function(e){return e.innerText.trim()}))"
    ),
    '["First","Second"]'
  )
  # Leftover names used to serialise options as an object, which v-for cannot
  # iterate the way the component expects.
  expect_equal(
    bev(
      "(function(){var w=shinyVue.find('#rg_num'); return Array.isArray(w.instance.options)?'array':'object'})()"
    ),
    "array"
  )
  expect_equal(
    bev(
      "(function(){var w=shinyVue.find('#rg_num'); return typeof w.instance.options[0].value})()"
    ),
    "number"
  )
})

# ── table ─────────────────────────────────────────────────────────────────────

test_that("a data.frame renders as rows, not columns", {
  skip_if_no_browser()
  expect_equal(
    bev(
      "String(document.querySelectorAll('#tbl_container .el-table__body-wrapper tbody tr').length)"
    ),
    "4"
  )
  expect_equal(
    bev(
      "(function(){var w=shinyVue.find('#tbl'); return Array.isArray(w.instance.tableData)?'array':'object'})()"
    ),
    "array"
  )
})

test_that("column labels keep the original names while props are sanitised", {
  skip_if_no_browser()
  headers <- bev(
    "JSON.stringify(Array.from(document.querySelectorAll('#tbl_container .el-table__header th')).map(function(e){return e.innerText.trim()}).filter(function(x){return x!==''}))"
  )
  expect_match(headers, "Sepal.Length", fixed = TRUE)
  # prop must be underscored: el-table resolves it as a dotted path. The
  # table was given no columns, so these are the inferred ones.
  expect_equal(
    bev(
      "(function(){var w=shinyVue.find('#tbl'); return w.instance.autoColumns[0].prop})()"
    ),
    "Sepal_Length"
  )
})

test_that("columns are reactive, not baked into the markup", {
  skip_if_no_browser()
  expect_equal(
    bev(
      "(function(){var w=shinyVue.find('#tbl'); return ['columns','border','selection'].filter(function(k){return k in w.instance.$data}).join(',')})()"
    ),
    "columns,border,selection"
  )
})

# ── layout ────────────────────────────────────────────────────────────────────

test_that("grid components emit compiled Element UI classes", {
  skip_if_no_browser()
  # They used to render as literal <el-row>/<el-col> tags that nothing compiled.
  expect_equal(
    bev(
      "String(document.querySelectorAll('#grid el-row, #grid el-col').length)"
    ),
    "0"
  )
  expect_equal(
    bev("String(document.querySelectorAll('#grid .el-row').length)"),
    "1"
  )
  expect_equal(
    bev("String(document.querySelectorAll('#grid .el-col').length)"),
    "2"
  )
})

test_that("a 12/12 split renders as two equal side-by-side columns", {
  skip_if_no_browser()
  geom <- bev(
    "(function(){var c=document.querySelectorAll('#grid .el-col'); var a=c[0].getBoundingClientRect(), b=c[1].getBoundingClientRect(); return JSON.stringify({w1:Math.round(a.width), w2:Math.round(b.width), sameRow:Math.round(a.top)===Math.round(b.top), ordered:b.left>a.left})})()"
  )
  geom <- jsonlite::fromJSON(geom)
  expect_equal(geom$w1, geom$w2)
  expect_true(geom$sameRow)
  expect_true(geom$ordered)
})

test_that("gutter is applied as margins and matching padding", {
  skip_if_no_browser()
  expect_match(
    bev("getComputedStyle(document.querySelector('#grid .el-row')).marginLeft"),
    "^-10px$"
  )
  expect_match(
    bev(
      "getComputedStyle(document.querySelector('#grid .el-col')).paddingLeft"
    ),
    "^10px$"
  )
})

test_that("a flex row computes the requested alignment", {
  skip_if_no_browser()
  css <- bev(
    "(function(){var s=getComputedStyle(document.querySelector('#flexrow .el-row')); return s.display+'|'+s.justifyContent+'|'+s.alignItems})()"
  )
  expect_equal(css, "flex|center|center")
})

test_that("a container with a header lays out vertically", {
  skip_if_no_browser()
  expect_equal(
    bev(
      "getComputedStyle(document.querySelector('#layout > .el-container')).flexDirection"
    ),
    "column"
  )
  expect_equal(
    bev(
      "getComputedStyle(document.querySelector('#layout .el-container .el-container')).flexDirection"
    ),
    "row"
  )
})

test_that("header height and aside width are applied", {
  skip_if_no_browser()
  expect_equal(
    bev(
      "String(Math.round(document.querySelector('#layout .el-header').getBoundingClientRect().height))"
    ),
    "60"
  )
  expect_equal(
    bev(
      "String(Math.round(document.querySelector('#layout .el-aside').getBoundingClientRect().width))"
    ),
    "200"
  )
})

test_that("components nested in a container mount and report values", {
  skip_if_no_browser()
  # The old Vue-template container swallowed these entirely: no container, no
  # component, no error.
  expect_equal(
    bev(
      "JSON.stringify(['sw_nested','sld_nested'].map(function(id){var w=shinyVue.find('#'+id); return w&&w.instance?'ok':'missing'}))"
    ),
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
    bev(
      "String(document.querySelectorAll('#stp_container .el-step__head.is-success').length)"
    )
  }
  expect_equal(finished(), "0")

  for (i in 1:3) {
    bclick("#step_next")
  }
  # active == number of steps is what marks the last step finished.
  expect_equal(bdump()[["stp"]], "3")
  expect_equal(finished(), "3")

  bclick("#step_next")
  expect_equal(bdump()[["stp"]], "0")
  expect_equal(finished(), "0")
})

test_that("selecting rows reports 1-based row numbers with their types", {
  skip_if_no_browser()
  bev(
    "(function(){var c=document.querySelectorAll('#tbl_container .el-table__body-wrapper .el-checkbox'); c[0].click(); c[2].click();})()"
  )
  Sys.sleep(2)
  # Row objects come back simplified to character; row numbers do not.
  expect_equal(bdump()[["tbl_selection_rows"]], "1,3")
})

test_that("a table output reports its rows as an input, typed", {
  skip_if_no_browser()
  # The output element holds the id; the table inside reports its inputs
  # with no input binding of the same id, which Shiny would warn of
  expect_equal(
    bev("document.querySelector('#otbl [data-shiny-vue]').id"),
    "otbl-el"
  )
  # an update sent before the output was drawn reached the table
  expect_true(bev("!!document.querySelector('#otbl .el-table--striped')"))
  expect_equal(bdump()[["otbl_selection_rows"]], "<NULL>")
  bev(
    "(function(){var c=document.querySelectorAll('#otbl .el-table__body-wrapper .el-checkbox'); c[1].click(); c[3].click();})()"
  )
  Sys.sleep(2)
  vals <- bdump()
  expect_equal(vals[["otbl_selection_rows"]], "2,4")
  # data[rows, ]: the Date column a Date, the row names the data's
  expect_equal(vals[["otbl_picked"]], "Date Mazda RX4 Wag,Hornet 4 Drive")
})

test_that("a table output rendered again keeps the ticks of the same rows", {
  skip_if_no_browser()
  ticked <- "String(document.querySelectorAll('#otbl .el-table__body .el-checkbox.is-checked').length)"
  bclick("#otbl_again", wait = 2)
  expect_equal(bev(ticked), "2")
  expect_equal(bdump()[["otbl_selection_rows"]], "2,4")
  # other rows: Element clears the selection
  bclick("#otbl_more", wait = 2)
  expect_equal(
    bev("String(document.querySelectorAll('#otbl .el-table__body tr').length)"),
    "3"
  )
  expect_equal(bev(ticked), "0")
  expect_equal(bdump()[["otbl_selection_rows"]], "<NULL>")
})

test_that("a table output shows its mask while it recalculates", {
  skip_if_no_browser()
  mask <- "(function(){ var m = document.querySelector('#otbl .el-loading-mask'); return !!m && getComputedStyle(m).display !== 'none'; })()"
  expect_false(bev(mask))
  bclick("#otbl_slow", wait = 1)
  # the mask, and no fading of the output under it
  expect_true(bev(mask))
  expect_equal(
    bev("getComputedStyle(document.getElementById('otbl')).opacity"),
    "1"
  )
  Sys.sleep(3)
  expect_false(bev(mask))
})

test_that("a page that cannot apply a patch gets the table whole", {
  skip_if_no_browser()
  bev("document.getElementById('otbl-el').remove()")
  expect_false(bev("!!document.getElementById('otbl-el')"))
  bclick("#otbl_again", wait = 3)
  expect_true(bev(
    "!!document.querySelector('#otbl-el') && !!document.querySelector('#otbl .el-table__body tr')"
  ))
})

test_that("a cell edited in place reaches the server with its column's type", {
  skip_if_no_browser()
  cell <- function(r, c) {
    sprintf(
      "document.querySelectorAll('#etbl .el-table__body tr')[%d].querySelectorAll('td')[%d]",
      r,
      c
    )
  }
  bev(sprintf(
    "%s.querySelector('.el-table-edit-cell__value').dispatchEvent(new MouseEvent('dblclick', {bubbles: true}))",
    cell(0, 1)
  ))
  Sys.sleep(0.5)
  expect_true(bev(sprintf("!!%s.querySelector('.el-date-editor')", cell(0, 1))))
  # typed, then Enter: the date picker commits
  bev(sprintf(
    "(function(){ var i = %s.querySelector('input'); i.value = '2024-02-29'; i.dispatchEvent(new Event('input', {bubbles: true})); i.dispatchEvent(new Event('change', {bubbles: true})); i.dispatchEvent(new KeyboardEvent('keydown', {key: 'Enter', code: 'Enter', bubbles: true})); })()",
    cell(0, 1)
  ))
  Sys.sleep(2)
  vals <- bdump()
  expect_equal(vals[["etbl_edit"]], "1 made Date 2024-02-29")
  expect_equal(vals[["etbl_shown"]], "2024-02-29")
  expect_equal(bev(sprintf("%s.innerText.trim()", cell(0, 1))), "2024-02-29")
  # Escape abandons
  bev(sprintf(
    "%s.querySelector('.el-table-edit-cell__value').dispatchEvent(new MouseEvent('dblclick', {bubbles: true}))",
    cell(1, 0)
  ))
  Sys.sleep(0.5)
  bev(sprintf(
    "(function(){ var i = %s.querySelector('input'); i.value = '99'; i.dispatchEvent(new Event('input', {bubbles: true})); i.dispatchEvent(new KeyboardEvent('keyup', {key: 'Escape', bubbles: true})); })()",
    cell(1, 0)
  ))
  Sys.sleep(1)
  expect_false(bev(sprintf(
    "!!%s.querySelector('.el-input-number')",
    cell(1, 0)
  )))
  expect_equal(bev(sprintf("%s.innerText.trim()", cell(1, 0))), "21")
  expect_equal(bdump()[["etbl_edit"]], "1 made Date 2024-02-29")
})

test_that("rows edited from the server keep the other rows' ticks", {
  skip_if_no_browser()
  first <- "document.querySelector('#otbl .el-table__body tr td:nth-child(2)').innerText.trim()"
  ticked <- "String(document.querySelectorAll('#otbl .el-table__body .el-checkbox.is-checked').length)"
  bev(
    "document.querySelectorAll('#otbl .el-table__body-wrapper .el-checkbox')[1].click()"
  )
  Sys.sleep(1.5)
  expect_equal(bdump()[["otbl_selection_rows"]], "2")
  # a row before it: still ticked, renumbered
  bclick("#otbl_insert", wait = 2)
  expect_equal(bev(first), "New car")
  expect_equal(bev(ticked), "1")
  vals <- bdump()
  expect_equal(vals[["otbl_selection_rows"]], "3")
  expect_equal(
    vals[["otbl_shown"]],
    "New car,Mazda RX4,Mazda RX4 Wag,Datsun 710"
  )
  # replaced as `data[1, ] <- car` replaces: the values, not the row name
  bclick("#otbl_replace", wait = 2)
  expect_equal(bev(first), "New car")
  expect_equal(
    bev(
      "document.querySelector('#otbl .el-table__body tr td:nth-child(3)').innerText.trim()"
    ),
    "99"
  )
  expect_equal(bdump()[["otbl_selection_rows"]], "3")
  bclick("#otbl_delete", wait = 2)
  expect_equal(bev(first), "Mazda RX4")
  expect_equal(bev(ticked), "1")
  vals <- bdump()
  expect_equal(vals[["otbl_selection_rows"]], "2")
  expect_equal(vals[["otbl_shown"]], "Mazda RX4,Mazda RX4 Wag,Datsun 710")
})

test_that("a group header's child columns render their own cell and header", {
  skip_if_no_browser()
  q <- function(sel) {
    bev(sprintf(
      "String(document.querySelectorAll('#grp_tbl_container %s').length)",
      sel
    ))
  }
  # one cell per row at each level, and the headers as markup, not text
  expect_equal(q(".el-table__body-wrapper b.grp-cell"), "2")
  expect_equal(q(".el-table__body-wrapper u.grp-cell2"), "2")
  expect_equal(q(".el-table__header i.grp-head"), "1")
  expect_equal(q(".el-table__header i.grp-head2"), "1")
  expect_equal(
    bev(
      "document.querySelector('#grp_tbl_container .el-table__body-wrapper u.grp-cell2').innerText"
    ),
    "5"
  )
})

test_that("form-item markup given as tags renders as HTML", {
  skip_if_no_browser()
  expect_equal(
    bev(
      "document.querySelector('#hf-label') ? document.querySelector('#hf-label').innerText : 'none'"
    ),
    "Bold"
  )
  expect_false(grepl(
    "attribs",
    bev("document.querySelector('#htmlf_container').innerText")
  ))
  bev(
    "shinyVue.find('#htmlf').instance.$refs.form.validate().catch(function(){}); 'ok'"
  )
  Sys.sleep(1)
  expect_equal(
    bev(
      "String(document.querySelectorAll('#htmlf_container em.hf2-error').length)"
    ),
    "1"
  )
})

test_that("update_el_table swaps the data and re-infers the columns", {
  skip_if_no_browser()
  bclick("#tbl_swap", wait = 2.5)
  expect_equal(
    bev(
      "String(document.querySelectorAll('#tbl_container .el-table__body-wrapper tbody tr').length)"
    ),
    "6"
  )
  headers <- bev(
    "JSON.stringify(Array.from(document.querySelectorAll('#tbl_container .el-table__header th')).map(function(e){return e.innerText.trim()}).filter(function(x){return x!==''}))"
  )
  expect_match(headers, "mpg", fixed = TRUE)
})

test_that("the cascader's updates land", {
  skip_if_no_browser()
  # Once it had a handler script of its own, which went unloaded and every
  # update unheard. Updates now share one message, handled by the bridge.
  scripts <- bev(
    "JSON.stringify(Array.from(document.querySelectorAll('script[src]')).map(function(s){var m=s.src.match(/el-[a-z-]+-handler/); return m?m[0]:null}).filter(Boolean))"
  )
  expect_false(grepl("el-cascader-handler", scripts, fixed = TRUE))

  bclick("#casc_update", wait = 2.5)
  # With a value Element Plus shows its labels, not the placeholder; the
  # placeholder is the component's all the same
  expect_equal(bev("shinyVue.find('#casc').instance.placeholder"), "updated")
  expect_equal(
    bev(
      "(function(){var w=shinyVue.find('#casc'); return JSON.stringify(w.instance.value)})()"
    ),
    '["js","nj"]'
  )
  expect_equal(
    bev(
      "(function(){var w=shinyVue.find('#casc'); return String(w.instance.disabled)})()"
    ),
    "true"
  )
})

# ── form ──────────────────────────────────────────────────────────────────────

test_that("the form renders one control per declared field", {
  skip_if_no_browser()
  # A single template dispatches on f.tag via <component :is>, so a missing
  # type mapping shows up as a control that never rendered.
  expect_equal(
    bev(
      "String(document.querySelectorAll('#signup_container .el-input-number').length)"
    ),
    "1"
  )
  expect_equal(
    bev(
      "String(document.querySelectorAll('#signup_container .el-select').length)"
    ),
    "1"
  )
  expect_equal(
    bev(
      "(function(){var e=document.querySelector('#signup_container .el-form-item__label'); return getComputedStyle(e).width})()"
    ),
    "110px"
  )
  expect_equal(
    bev(
      "String(document.querySelectorAll('#signup_container .el-form-item.is-required').length)"
    ),
    "2"
  )
})

test_that("the form reports its whole model on load", {
  skip_if_no_browser()
  model <- bev(
    "(function(){var w=shinyVue.find('#signup'); return JSON.stringify(w.instance.model)})()"
  )
  # Types survive the round-trip: a number stays a number.
  expect_equal(model, '{"fname":"","fage":18,"fcity":""}')
})

test_that("submitting an incomplete form fails validation client-side", {
  skip_if_no_browser()
  bev(
    "(function(){document.querySelectorAll('#signup_container .el-button')[0].click()})()"
  )
  Sys.sleep(2.5)
  expect_equal(
    bev(
      "String(document.querySelectorAll('#signup_container .el-form-item.is-error').length)"
    ),
    "2"
  )
  expect_equal(
    bev(
      "JSON.stringify(Array.from(document.querySelectorAll('#signup_container .el-form-item__error')).map(function(e){return e.innerText}))"
    ),
    '["name required","pick a city"]'
  )
  vals <- bdump()
  expect_equal(vals[["signup_valid"]], "FALSE")
  expect_equal(vals[["signup_submit"]], "1")
})

test_that("a filled form passes and reports the model", {
  skip_if_no_browser()
  bclick("#form_prefill", wait = 2.5)
  bev(
    "(function(){document.querySelectorAll('#signup_container .el-button')[0].click()})()"
  )
  Sys.sleep(2.5)
  expect_equal(
    bev(
      "String(document.querySelectorAll('#signup_container .el-form-item.is-error').length)"
    ),
    "0"
  )
  expect_equal(bdump()[["signup_valid"]], "TRUE")
  expect_equal(
    bev(
      "(function(){var w=shinyVue.find('#signup'); return JSON.stringify(w.instance.model)})()"
    ),
    '{"fname":"Ada","fage":18,"fcity":"sh"}'
  )
})

test_that("resetFields restores the declared values, not empty ones", {
  skip_if_no_browser()
  bev(
    "(function(){document.querySelectorAll('#signup_container .el-button')[1].click()})()"
  )
  Sys.sleep(2.5)
  # fage was declared as 18, so it resets to 18 rather than 0.
  expect_equal(
    bev(
      "(function(){var w=shinyVue.find('#signup'); return JSON.stringify(w.instance.model)})()"
    ),
    '{"fname":"","fage":18,"fcity":""}'
  )
  expect_equal(
    bev(
      "String(document.querySelectorAll('#signup_container .el-form-item.is-error').length)"
    ),
    "0"
  )
})

# ── menu ──────────────────────────────────────────────────────────────────────

test_that("the menu renders its whole tree, nested and grouped", {
  skip_if_no_browser()
  expect_equal(
    bev(
      "String(document.querySelectorAll('#nav_container .el-sub-menu').length)"
    ),
    "1"
  )
  expect_equal(
    bev(
      "String(document.querySelectorAll('#nav_container .el-menu-item-group').length)"
    ),
    "1"
  )
  # home, All, Discontinued, In group -- the submenu title is not an item.
  expect_equal(
    bev(
      "String(document.querySelectorAll('#nav_container .el-menu-item').length)"
    ),
    "4"
  )
  expect_equal(
    bev(
      "String(document.querySelectorAll('#nav_container .el-menu-item.is-disabled').length)"
    ),
    "1"
  )
})

test_that("the menu reports its initial selection", {
  skip_if_no_browser()
  expect_equal(bdump()[["nav"]], "m-home")
  # No path until something is actually selected; Shiny turns [] into NULL.
  expect_equal(bdump()[["nav_path"]], "<NULL>")
})

test_that("update_el_menu moves the selection", {
  skip_if_no_browser()
  bclick("#nav_pick", wait = 2.5)
  expect_equal(
    bev(
      "(function(){var e=document.querySelector('#nav_container .el-menu-item.is-active'); return e ? e.innerText.trim() : 'NONE'})()"
    ),
    "All"
  )
})

test_that("selecting an item reports its index and path", {
  skip_if_no_browser()
  bev(
    "(function(){var i=document.querySelectorAll('#nav_container .el-menu-item'); i[1].click()})()"
  )
  Sys.sleep(2.5)
  vals <- bdump()
  expect_equal(vals[["nav"]], "m-all")
  # The path distinguishes a nested item from a top-level one.
  expect_equal(vals[["nav_path"]], "m-prod,m-all")
})

# ── tree ──────────────────────────────────────────────────────────────────────

test_that("the tree renders its nodes with checkboxes", {
  skip_if_no_browser()
  expect_gt(
    as.numeric(bev(
      "String(document.querySelectorAll('#tree_container .el-tree-node').length)"
    )),
    2
  )
  # Element replaces its props map wholesale, so `disabled` has to be named in
  # it or a disabled node renders as a normal one.
  expect_equal(
    bev(
      "String(document.querySelectorAll('#tree_container .el-checkbox.is-disabled').length)"
    ),
    "1"
  )
})

test_that("the tree reports its initial checked keys", {
  skip_if_no_browser()
  expect_equal(bdump()[["tree_checked"]], "t-apple")
})

test_that("clicking a node reports its key", {
  skip_if_no_browser()
  bev(
    "(function(){var n=document.querySelectorAll('#tree_container .el-tree-node__label'); for (var i=0;i<n.length;i++) { if (n[i].innerText.trim()==='Grains') { n[i].click(); break } }})()"
  )
  Sys.sleep(2.5)
  expect_equal(bdump()[["tree"]], "t-grain")
})

test_that("update_el_tree replaces the checked set rather than adding to it", {
  skip_if_no_browser()
  # Assigning default-checked-keys only ever adds, which left the previous
  # selection checked too; the handler calls setCheckedKeys() instead.
  bclick("#tree_check", wait = 2.5)
  expect_equal(bdump()[["tree_checked"]], "t-grain")
  expect_equal(
    bev(
      "(function(){var c=document.querySelectorAll('#tree_container .el-checkbox.is-checked'); return JSON.stringify(Array.from(c).map(function(e){return e.parentElement.innerText.trim()}))})()"
    ),
    '["Grains"]'
  )
})

# ── upload ────────────────────────────────────────────────────────────────────

test_that("the upload renders a drop zone with its tip", {
  skip_if_no_browser()
  expect_equal(
    bev("String(!!document.querySelector('#up_container .el-upload-dragger'))"),
    "true"
  )
  expect_equal(
    bev(
      "String(document.querySelectorAll('#up_container .el-upload__tip').length)"
    ),
    "1"
  )
})

test_that("Shiny's file-input binding leaves the upload's field alone", {
  skip_if_no_browser()
  # Shiny's fileInputBinding binds every input[type=file] with an id or a
  # name; the field has neither, so no input$<id>_elfile appears.
  expect_equal(
    bev(
      "(function(){var i=document.querySelector('#up_container input[type=file]'); return i ? [i.name, i.classList.contains('shiny-bound-input')].join('|') : 'NONE'})()"
    ),
    "|false"
  )
  expect_false(any(grepl(
    "_elfile",
    bev("Object.keys(Shiny.shinyapp.$inputValues).join(' ')")
  )))
})

test_that("a whole selection goes through one upload job", {
  skip_if_no_browser()
  # Counted by patching makeRequest before the page loads would need a fresh
  # session; here the observable consequence is what matters: all three files
  # arrive together rather than the last one overwriting the rest.
  tmp <- file.path(tempdir(), c("ba.txt", "bb.txt", "bc.txt"))
  writeLines("aa", tmp[1])
  writeLines("bb", tmp[2])
  writeLines("cc", tmp[3])

  b <- browser_session()$b
  doc <- b$DOM$getDocument()
  node <- b$DOM$querySelector(
    nodeId = doc$root$nodeId,
    selector = "#up_container input[type=file]"
  )
  b$DOM$setFileInputFiles(files = as.list(tmp), nodeId = node$nodeId)
  Sys.sleep(5)

  expect_equal(
    bev(
      "String(document.querySelectorAll('#up_container .el-upload-list__item.is-success').length)"
    ),
    "3"
  )
  expect_equal(bdump()[["up_rows"]], "3")
  # every file under its own name
  expect_equal(bdump()[["up_files"]], "ba.txt:aa,bb.txt:bb,bc.txt:cc")
})

# A POST that fails: the file is marked failed and reported, and the rest of
# its batch is sent again as a job of its own -- a Shiny job cannot finish
# with a file missing.
upload_with_failures <- function(names, failing) {
  tmp <- file.path(tempdir(), names)
  for (i in seq_along(tmp)) {
    writeLines(sub("[.]txt$", "", names[i]), tmp[i])
  }
  bev("document.querySelector('#up_container .el-upload').__vue__ && 0")
  bev(sprintf(
    "(function(){ var bad = %s; var orig = jQuery.ajax;
    window.__restoreAjax = function(){ jQuery.ajax = orig; };
    jQuery.ajax = function(url, opts) {
      if (opts && opts.data && bad.indexOf(opts.data.name) !== -1) {
        setTimeout(function(){ opts.error({}, 'error'); }, 50);
        return { abort: function(){} };
      }
      return orig.apply(this, arguments);
    }; })()",
    jsonlite::toJSON(failing)
  ))
  b <- browser_session()$b
  doc <- b$DOM$getDocument()
  node <- b$DOM$querySelector(
    nodeId = doc$root$nodeId,
    selector = "#up_container input[type=file]"
  )
  b$DOM$setFileInputFiles(files = as.list(tmp), nodeId = node$nodeId)
  Sys.sleep(5)
  bev("window.__restoreAjax()")
  bdump()
}

test_that("a failed file in the middle of a batch leaves the rest delivered", {
  skip_if_no_browser()
  vals <- upload_with_failures(c("m1.txt", "m2.txt", "m3.txt"), "m2.txt")
  expect_equal(vals[["up_files"]], "m1.txt:m1,m3.txt:m3")
  expect_equal(vals[["up_error"]], "m2.txt")
  # the job the failure interrupted is let go of, not kept to session end
  expect_equal(vals[["up_jobs"]], "0")
})

test_that("the last file failing still delivers the others", {
  skip_if_no_browser()
  vals <- upload_with_failures(c("l1.txt", "l2.txt"), "l2.txt")
  expect_equal(vals[["up_files"]], "l1.txt:l1")
  expect_equal(vals[["up_error"]], "l2.txt")
})

test_that("a batch that fails entirely changes nothing but reports it", {
  skip_if_no_browser()
  before <- bdump()[["up_files"]]
  vals <- upload_with_failures(c("f1.txt", "f2.txt"), c("f1.txt", "f2.txt"))
  expect_equal(vals[["up_files"]], before)
  expect_match(vals[["up_error"]], "^f[12][.]txt$")
  expect_equal(vals[["up_jobs"]], "0")
  # Element drops a failed file from its list, as upstream does
  expect_false(grepl(
    "f1.txt",
    bev("document.querySelector('#up_container .el-upload-list').innerText"),
    fixed = TRUE
  ))
})

test_that("abort() stops a file, and the rest of its batch is delivered", {
  skip_if_no_browser()
  tmp <- file.path(tempdir(), c("a1.txt", "a2.txt"))
  writeLines("a1", tmp[1])
  writeLines("a2", tmp[2])
  # Hold a2's request open, then abort it through Element's own method
  bev(
    "(function(){ var orig = jQuery.ajax;
    window.__restoreAjax = function(){ jQuery.ajax = orig; };
    jQuery.ajax = function(url, opts) {
      if (opts && opts.data && opts.data.name === 'a2.txt') {
        var t = setTimeout(function(){}, 60000);
        window.__abortA2 = function(){ opts.error({}, 'abort'); };
        return { abort: function(){ clearTimeout(t); window.__abortA2(); } };
      }
      return orig.apply(this, arguments);
    }; })()"
  )
  b <- browser_session()$b
  doc <- b$DOM$getDocument()
  node <- b$DOM$querySelector(
    nodeId = doc$root$nodeId,
    selector = "#up_container input[type=file]"
  )
  b$DOM$setFileInputFiles(files = as.list(tmp), nodeId = node$nodeId)
  Sys.sleep(2)
  bev(
    "(function(){ var up = shinyVue.find('#up').instance.$refs.upload;
    var f = shinyVue.find('#up').instance.fileList.filter(function(f){ return f.name === 'a2.txt'; })[0];
    up.abort(f); })()"
  )
  Sys.sleep(3)
  bev("window.__restoreAjax()")
  vals <- bdump()
  expect_equal(vals[["up_files"]], "a1.txt:a1")
  expect_equal(vals[["up_jobs"]], "0")
})

# ── dialog holds live components ──────────────────────────────────────────────

test_that("the dialog starts closed and reports it", {
  skip_if_no_browser()
  expect_equal(bdump()[["dlg"]], "FALSE")
  expect_equal(
    bev("getComputedStyle(document.getElementById('dlg')).display"),
    "none"
  )
})

test_that("a component inside a dialog stays connected", {
  skip_if_no_browser()
  # The body stays in the document while closed, so it is mounted before the
  # dialog is ever opened.
  expect_equal(
    bev(
      "(function(){var w=shinyVue.find('#dlg_nested'); return w && w.instance ? 'mounted' : 'MISSING'})()"
    ),
    "mounted"
  )
  expect_equal(bdump()[["dlg_nested"]], "TRUE")
})

test_that("opening the dialog raises the backdrop and locks scrolling", {
  skip_if_no_browser()
  bclick("#dlg_open", wait = 2.5)
  expect_equal(bdump()[["dlg"]], "TRUE")
  expect_equal(
    bev("getComputedStyle(document.getElementById('dlg')).display"),
    "block"
  )
  expect_match(
    bev("getComputedStyle(document.getElementById('dlg')).backgroundColor"),
    "rgba"
  )
  expect_equal(
    bev("String(document.body.classList.contains('el-popup-parent--hidden'))"),
    "true"
  )
  # Above the backdrop: both from Element's popup manager
  expect_true(bev("+document.getElementById('dlg').style.zIndex >= 2000"))
})

test_that("Escape closes the dialog and clears the backdrop", {
  skip_if_no_browser()
  bev(
    "document.dispatchEvent(new KeyboardEvent('keydown', {key:'Escape', keyCode:27, bubbles:true}))"
  )
  Sys.sleep(2)
  expect_equal(bdump()[["dlg"]], "FALSE")
  expect_equal(
    bev("getComputedStyle(document.getElementById('dlg')).display"),
    "none"
  )
  expect_equal(
    bev("String(document.body.classList.contains('el-popup-parent--hidden'))"),
    "false"
  )
})

# ── tabs hold live components ─────────────────────────────────────────────────

test_that("a component inside a tab pane stays connected", {
  skip_if_no_browser()
  expect_equal(
    bev(
      "(function(){var w=shinyVue.find('#tab_nested'); return w && w.instance ? 'mounted' : 'MISSING'})()"
    ),
    "mounted"
  )
  expect_equal(bdump()[["tab_nested"]], "TRUE")
})

test_that("the active bar is positioned from the rendered label", {
  skip_if_no_browser()
  # No CSS class could express this: it depends on the label's width, which is
  # why Element sets it inline too.
  style <- bev(
    "(function(){var b=document.querySelector('#tabs .el-tabs__active-bar'); return b ? b.getAttribute('style') : 'NONE'})()"
  )
  expect_match(style, "width:", fixed = TRUE)
  expect_match(style, "translateX", fixed = TRUE)
})

test_that("update_el_tabs switches the pane and reports back", {
  skip_if_no_browser()
  bclick("#tabs_go", wait = 2.5)
  expect_equal(bdump()[["tabs"]], "t1")
  expect_equal(
    bev(
      "(function(){var p=document.querySelector('#tabs .el-tab-pane[data-el-name=\"t1\"]'); return p ? getComputedStyle(p).display : 'NONE'})()"
    ),
    "block"
  )
})

# ── collapse holds live components ────────────────────────────────────────────

test_that("a component inside a collapse panel stays connected", {
  skip_if_no_browser()
  # This is the whole point of rendering the collapse as markup rather than
  # mounting a Vue instance over it: a Vue instance rebuilds the DOM inside
  # the panels and detaches whatever is in them.
  expect_equal(
    bev(
      "(function(){var w=shinyVue.find('#col_nested'); return w && w.instance ? 'mounted' : 'MISSING'})()"
    ),
    "mounted"
  )
  expect_equal(bdump()[["col_nested"]], "TRUE")
})

test_that("the collapse reports its open panels", {
  skip_if_no_browser()
  expect_equal(bdump()[["col"]], "i2")
})

test_that("clicking a header opens a panel and reports it", {
  skip_if_no_browser()
  bev(
    "(function(){var h=document.querySelectorAll('#col .el-collapse-item__header'); h[0].click()})()"
  )
  Sys.sleep(2)
  expect_equal(bdump()[["col"]], "i1,i2")
})

test_that("update_el_collapse replaces the open set and reports back", {
  skip_if_no_browser()
  # receiveMessage has no callback of its own; the binding raises an event so
  # the value does not go stale while the panels move.
  bclick("#col_open", wait = 2.5)
  expect_equal(bdump()[["col"]], "i1")
  expect_equal(
    bev(
      "String(document.querySelectorAll('#col .el-collapse-item.is-active').length)"
    ),
    "1"
  )
})

# ── carousel and timeline ─────────────────────────────────────────────────────

test_that("the carousel reports the showing slide by index and name", {
  skip_if_no_browser()
  vals <- bdump()
  expect_equal(vals[["car"]], "0")
  expect_equal(vals[["car_name"]], "s1")
})

test_that("update_el_carousel moves slides through setActiveItem", {
  skip_if_no_browser()
  # initial-index is read once at mount and has no watcher, so assigning it
  # would move nothing.
  bclick("#car_go", wait = 3)
  expect_equal(bdump()[["car"]], "2")
  expect_equal(
    bev(
      "(function(){var a=document.querySelector('#car_container .el-carousel__item.is-active'); return a ? a.innerText.trim() : 'NONE'})()"
    ),
    "slide three"
  )
})

test_that("a timeline entry without a timestamp renders none", {
  skip_if_no_browser()
  expect_equal(
    bev(
      "String(document.querySelectorAll('#tl_container .el-timeline-item').length)"
    ),
    "2"
  )
  # Filling the gap with null rather than leaving it out matched neither
  # placement branch, so every timestamp vanished.
  expect_equal(
    bev(
      "String(document.querySelectorAll('#tl_container .el-timeline-item__timestamp').length)"
    ),
    "1"
  )
})

test_that("update_el_timeline replaces the entries", {
  skip_if_no_browser()
  bclick("#tl_add", wait = 2.5)
  expect_equal(
    bev(
      "String(document.querySelectorAll('#tl_container .el-timeline-item').length)"
    ),
    "3"
  )
  expect_match(
    bev(
      "(function(){var i=document.querySelectorAll('#tl_container .el-timeline-item'); return i.length ? i[i.length-1].innerText : ''})()"
    ),
    "Appended"
  )
})

# ── unsupplied props fall back to Element's defaults ──────────────────────────

test_that("a select with no placeholder shows Element's own", {
  skip_if_no_browser()
  # Bound to a bare null it rendered an empty placeholder instead. The text
  # comes from Element's locale, so this also proves the prop reached its
  # default rather than being overwritten.
  ph <- bev(
    "(function(){var e=document.querySelector('#sel_container .el-select__placeholder'); return e ? e.innerText : 'NONE'})()"
  )
  expect_true(nzchar(ph))
  expect_false(identical(ph, "NONE"))
})

test_that("an input with no size keeps the default height", {
  skip_if_no_browser()
  h <- as.numeric(bev(
    "(function(){var e=document.querySelector('#inp_container .el-input__wrapper'); return e ? String(Math.round(e.getBoundingClientRect().height)) : '0'})()"
  ))
  # Element Plus's default control height is 32px; large is 40, small 24
  expect_equal(h, 32)
})

# ── components do not each claim their own line ───────────────────────────────

test_that("two buttons sit side by side", {
  skip_if_no_browser()
  # Vue mounts onto each component's container div but leaves it in the
  # document. While it was block-level, no two components could share a line.
  geom <- bev(
    "(function(){var b=document.querySelectorAll('#inline_probe .el-button'); if(b.length<2) return 'null'; var a=b[0].getBoundingClientRect(), c=b[1].getBoundingClientRect(); return JSON.stringify({sameRow: Math.round(a.top)===Math.round(c.top), ordered: c.left>a.left})})()"
  )
  geom <- jsonlite::fromJSON(geom)
  expect_true(geom$sameRow)
  expect_true(geom$ordered)
})

test_that("the mount point generates no layout box of its own", {
  skip_if_no_browser()
  expect_equal(
    bev(
      "getComputedStyle(document.getElementById('probe_b1_container')).display"
    ),
    "contents"
  )
})

test_that("a block component still fills its parent", {
  skip_if_no_browser()
  # display:contents must not stop an alert or a table from taking the full
  # width of whatever contains it.
  ratio <- bev(
    "(function(){var t=document.querySelector('#tbl_container .el-table'); if(!t) return '0'; var p=t.parentElement.getBoundingClientRect(); return String(t.getBoundingClientRect().width / p.width)})()"
  )
  expect_gt(as.numeric(ratio), 0.9)
})

# ── layout is not distorted by the bundled stylesheet ─────────────────────────

test_that("container components keep a normal line height", {
  skip_if_no_browser()
  # el-layout.css used to force line-height: 160px on .el-main and 200px on
  # .el-aside, stretching every line of text in the app.
  for (sel in c(".el-main", ".el-aside", ".el-header")) {
    lh <- bev(sprintf(
      "(function(){var e=document.querySelector('%s'); if(!e) return '0'; return getComputedStyle(e).lineHeight})()",
      sel
    ))
    px <- suppressWarnings(as.numeric(sub("px$", "", lh)))
    expect_true(is.na(px) || px < 60, info = paste(sel, "line-height", lh))
  }
})

test_that("the page is not stretched to several times its content height", {
  skip_if_no_browser()
  # The demo stylesheet once made the fixture page three times its natural
  # height. Measured against the same page with the package's layout
  # stylesheet switched off, rather than against a fixed number of pixels,
  # which every new fixture would push past.
  h <- jsonlite::fromJSON(bev(
    "(function(){
    var sheet = Array.from(document.styleSheets).filter(function(s) {
      return s.href && s.href.indexOf('el-layout.css') >= 0; })[0];
    var withIt = document.documentElement.scrollHeight;
    if (sheet) sheet.disabled = true;
    var without = document.documentElement.scrollHeight;
    if (sheet) sheet.disabled = false;
    return JSON.stringify({with: withIt, without: without, found: !!sheet});
  })()"
  ))
  expect_true(h$found)
  expect_lt(h$with, 1.1 * h$without)
})

# ── offline assets ────────────────────────────────────────────────────────────

test_that("the page loads no third-party assets at runtime", {
  skip_if_no_browser()
  # A CDN dependency leaves the app blank on an intranet or when unpkg is down.
  hosts <- bev(
    "JSON.stringify(Array.from(new Set(Array.from(document.querySelectorAll('script[src],link[href]')).map(function(e){try{return new URL(e.src||e.href).hostname}catch(x){return null}}).filter(Boolean))))"
  )
  expect_false(grepl("unpkg", hosts, fixed = TRUE))
  expect_false(grepl("cdn", hosts, fixed = TRUE))
})

test_that("Element Plus's icons are drawn as SVG, inside components and out", {
  skip_if_no_browser()
  # el_icon() outside any component, filled in by the page
  expect_true(bev(
    "[].every.call(document.querySelectorAll('i[data-el-icon]'), function(e){ return !!e.querySelector('svg'); })"
  ))
  expect_gt(bev("document.querySelectorAll('i[data-el-icon] svg').length"), 0)
  # an icon prop inside a component -- Element UI's class name included
  expect_gt(
    bev("document.querySelectorAll('#nav_container .el-icon svg').length"),
    0
  )
})

# ── no silent failures ────────────────────────────────────────────────────────

test_that("the page raises no JS exceptions throughout", {
  skip_if_no_browser()
  expect_equal(bjs_errors(), character(0))
})

test_that("Vue raises no warnings", {
  skip_if_no_browser()
  # The fixture app loads Vue's development build on purpose. With the
  # production build a failed template compile, a missing prop or a render
  # error is stripped entirely -- which is how a container that rendered
  # nothing at all went unnoticed.
  expect_equal(bconsole(), character(0))
})

test_that("the fixture runs Vue's development build, which does warn", {
  skip_if_no_browser()
  # Guards the test above: with the production build bconsole() is empty
  # whatever happens. Mount a template naming a missing property, catching
  # console.warn for the moment so the page's own log stays clean.
  got <- bev(
    "(function(){
       var seen = [], warn = console.warn;
       console.warn = function(m){ seen.push(String(m)); };
       var box = document.createElement('div');
       document.body.appendChild(box);
       var app = Vue.createApp({ template: '<span>{{ notDefined }}</span>' });
       app.mount(box); app.unmount(); box.remove();
       console.warn = warn;
       return seen.join(' | ');
     })()"
  )
  expect_match(got, "[Vue warn]", fixed = TRUE)
  expect_match(got, "notDefined", fixed = TRUE)
})

# ── forwarded Element events ──────────────────────────────────────────────────

test_that("a forwarded Element event reaches the server", {
  skip_if_no_browser()

  # The fixture latches these with observeEvent, which records that the event
  # happened at all -- including an event carrying no value, reported as TRUE.
  expect_false(grepl("tbl_row_click", bdump()[["events_seen"]], fixed = TRUE))

  bclick("#tbl_container .el-table__row td", wait = 3)
  expect_match(bdump()[["events_seen"]], "tbl_row_click")
})

test_that("an event carrying no serialisable argument still reports", {
  skip_if_no_browser()
  # focus hands over a native FocusEvent and nothing else. Dropping it leaves
  # no value, so the input is set to TRUE -- the event did happen.
  bev("document.querySelector('#inp_container input').focus()")
  Sys.sleep(2)
  expect_match(bdump()[["events_seen"]], "inp_focus")
})

test_that("forwarding an event raises no Vue warning", {
  skip_if_no_browser()
  # el_tree's events carry TreeNode objects, which point back at their parent
  # and at their children -- serialising one without a cycle guard overflowed
  # the stack the first time these were forwarded.
  bclick("#tree_container .el-tree-node__expand-icon", wait = 2)
  expect_equal(bconsole(), character(0))
})

# ── call_el(): reaching the component's own methods ───────────────────────────

test_that("call_el runs a method that returns nothing", {
  skip_if_no_browser()
  bclick("#call_clear_container button", wait = 3)
  # clearSelection() returns undefined, which is reported as TRUE so an
  # observeEvent can still tell that it ran
  expect_match(bdump()[["events_seen"]], "called_clear")
})

test_that("call_el reports a method's return value", {
  skip_if_no_browser()
  bclick("#call_keys_container button", wait = 3)
  # getCheckedKeys() answers with whatever is checked at the time; earlier
  # tests drive the tree, so assert that an answer came back rather than
  # which keys it names.
  keys <- unname(bdump()[["called_keys"]])
  expect_false(is.na(keys))
  expect_true(nzchar(keys))
})

test_that("call_el awaits a method that returns a promise", {
  skip_if_no_browser()
  # el-form's validate() returns a promise when called without a callback; it
  # rejects when the form is invalid, which arrives as FALSE rather than as an
  # unhandled rejection.
  bclick("#call_validate_container button", wait = 3)
  expect_equal(unname(bdump()[["called_validate"]]), "FALSE")
})

test_that("call_el on a method that does not exist warns rather than failing", {
  skip_if_no_browser()
  bclick("#call_missing_container button", wait = 3)
  expect_match(paste(bconsole(), collapse = " "), "not a method")
})

# ── wrapping a component rather than plain markup ─────────────────────────────

test_that("a component used as a tooltip trigger keeps working", {
  skip_if_no_browser()
  # Nesting one Vue instance inside another loses the inner one: Element's
  # tooltip keeps only its first child node, and the inner host goes
  # with the rest. .el_absorb() folds the two into a single instance instead.
  expect_true(bev("!!document.querySelector('#wrap_container button')"))
  expect_equal(
    bev("document.querySelector('#wrap_container button').innerText"),
    "Nested"
  )

  # the tooltip still behaves as a tooltip
  bev(
    "(function(){var e=document.querySelector('#wrap_container button');
       ['mouseenter','mouseover'].forEach(function(t){
         e.dispatchEvent(new MouseEvent(t,{bubbles:true}));});})()"
  )
  Sys.sleep(1)
  expect_true(bev(
    "[].some.call(document.querySelectorAll('.el-popper'), function(e){ return getComputedStyle(e).display !== 'none' && /works/.test(e.innerText); })"
  ))
})

test_that("an absorbed component still reports its inputs", {
  skip_if_no_browser()
  # an action button's count, sent typed as actionButton()'s is
  bclick("#wrap_container button", wait = 2)
  expect_gt(
    bev("Shiny.shinyapp.$inputValues['nested_btn:shiny.action'] || 0"),
    0
  )
})

test_that("absorbing a component raises no Vue warning", {
  skip_if_no_browser()
  # An empty methods list serialises to [], and Vue rejects an array where it
  # wants an options object -- which is what the first merged instance did.
  # An earlier test deliberately logs one of the package's own warnings, so
  # look only at what Vue said.
  expect_equal(
    grep("[Vue warn]", bconsole(), fixed = TRUE, value = TRUE),
    character(0)
  )
})

test_that("two components in one wrapper both work", {
  skip_if_no_browser()
  # el_button and el_tag both declare label, type, size and handleClick, so
  # the second one's fields are renamed on the way in -- markup, methods and
  # interpolation together. Renaming only the data would leave the template
  # referring to fields that no longer exist, which Vue reports at render
  # time and which the first attempt did.
  expect_equal(
    bev("document.querySelector('#twoup_container button').innerText"),
    "Open"
  )

  bclick("#twoup_container button", wait = 2)
  expect_gt(bev("Shiny.shinyapp.$inputValues['pop_btn:shiny.action'] || 0"), 0)

  # the popover opened, and the tag inside it rendered its own label
  expect_true(bev("!!document.querySelector('.el-popover')"))
  expect_equal(
    bev("document.querySelector('.el-popover .el-tag').innerText"),
    "inside"
  )
  expect_equal(
    grep("[Vue warn]", bconsole(), fixed = TRUE, value = TRUE),
    character(0)
  )
})

test_that("confirming an el_popconfirm reaches the server", {
  skip_if_no_browser()
  # Element renamed this event between 2.13 and 2.15 (onConfirm -> confirm).
  # Bound under the old name the prompt still opened and closed, and the
  # answer never arrived -- nothing short of clicking it would show that.
  bclick("#pc_container button", wait = 1)
  bev(
    "(function(){var b=document.querySelectorAll('.el-popconfirm .el-button');
       b[b.length-1].click();})()"
  )
  Sys.sleep(2)
  expect_match(bdump()[["events_seen"]], "pc_confirm")
})

test_that("a row event arrives as a named list with a usable row_index", {
  skip_if_no_browser()
  # Sent as Element's raw arguments, [row, column] reached R as one flat
  # character vector -- row fields and column internals run together, every
  # number a string. Shaped, it is a list whose row_index indexes the data.
  bev(
    "document.querySelectorAll('#tbl_container .el-table__body tr')[1].querySelector('td').click()"
  )
  Sys.sleep(2)
  expect_equal(unname(bdump()[["row_index"]]), "2")
})

test_that("a value set from the server is reported back, as update*Input() does", {
  skip_if_no_browser()
  # Element raises `change` only for the user's own edits. The new value
  # showed on screen while input$<id> kept the old one, so the server went on
  # acting on a value the page no longer held.
  bclick("#set_values", wait = 2.5)
  vals <- bdump()
  expect_equal(vals[["inp"]], "from server")
  expect_equal(vals[["sel"]], "a")
  expect_equal(vals[["sw"]], "FALSE")
  expect_equal(vals[["sld"]], "7")
  expect_equal(vals[["num"]], "9")
})

# ── Shiny modules ─────────────────────────────────────────────────────────────

test_that("components in a module report under the module's namespace", {
  skip_if_no_browser()
  vals <- bdump("mod-dump")
  expect_equal(vals[["text"]], "in module")
  expect_equal(vals[["pick"]], "a")
  expect_equal(vals[["tabs"]], "one")
  # Built by renderUI() in the module server: once namespaced, not twice
  expect_equal(vals[["flag"]], "TRUE")
  expect_true(bev("!!document.getElementById('mod-flag')"))
  expect_false(bev("!!document.getElementById('mod-mod-flag')"))
})

test_that("updates, row actions and inserted tabs work inside a module", {
  skip_if_no_browser()
  bclick("#mod-set", wait = 2)
  bclick("#mod-add_tab", wait = 2.5)
  bev(
    "document.querySelector('#mod-rows_container .el-table__body .el-button').click()"
  )
  Sys.sleep(2)
  vals <- bdump("mod-dump")
  expect_equal(vals[["text"]], "set from module")
  expect_equal(vals[["pick"]], "b")
  expect_equal(vals[["tabs"]], "two")
  expect_equal(vals[["stars"]], "2")
  expect_equal(vals[["went"]], "1")
})

# ── components that first appear through renderUI() ─────────────────────────

test_that("a component only ever rendered by renderUI() hears its updates", {
  skip_if_no_browser()
  # Its handler script loads after shiny:connected; handlers used to register
  # only on that event, so every update_el_*() and call_el() went nowhere.
  expect_equal(bdump("late_dump")[["late_tp"]], "09:00:00")
  bclick("#late_set", wait = 2)
  expect_equal(bdump("late_dump")[["late_tp"]], "10:30:00")
  bclick("#late_call", wait = 2)
  expect_equal(bdump("late_dump")[["late_focus"]], "TRUE")
})

# ── the rest of the ecosystem addresses a component by its id ────────────────

test_that("every component with a value is a Shiny input binding", {
  skip_if_no_browser()
  # Under vueR the id sat on a hidden 0x0 htmlwidget beside the component,
  # and Shiny did not know there was an input at all.
  expect_true(bev("!!$('#inp').data('shiny-input-binding')"))
  expect_true(bev("!!$('#sel').data('shiny-input-binding')"))
  # A component with no value of its own is mounted but not an input
  expect_true(bev("!!document.querySelector('#av_container .el-avatar')"))
  expect_false(bev("!!$('#av').data('shiny-input-binding')"))
})

test_that("shinyjs::hide(), shinyjs::disable() and removeUI() reach the component", {
  skip_if_no_browser()
  skip_if_not_installed("shinyjs")
  bclick("#js_go", wait = 2)
  # hidden: the host takes display: none, and its contents with it
  expect_equal(
    bev(
      "String(document.querySelector('#js_hide_container .el-input').getBoundingClientRect().height)"
    ),
    "0"
  )
  # disabled the way Element draws it, not just a native attribute underneath
  expect_true(bev(
    "!!document.querySelector('#js_off_container .el-input.is-disabled')"
  ))
  # removed, and its Vue instance with it
  expect_false(bev("!!document.getElementById('js_gone')"))
  expect_false(bev("!!document.querySelector('#js_gone_container')"))
})

# ── typed values ──────────────────────────────────────────────────────────────

test_that("a date picker reports Date, as dateInput() does", {
  skip_if_no_browser()
  vals <- bdump()
  expect_equal(vals[["dp_class"]], "Date")
  expect_equal(vals[["dr_class"]], "Date")
  # A format of the caller's own is text in that format
  expect_equal(vals[["dmonth_class"]], "character")
})

test_that("shinyvalidate's message is drawn as Element draws a failed rule", {
  skip_if_no_browser()
  skip_if_not_installed("shinyvalidate")
  # shinyvalidate asks the input's binding first; without setInvalid() it
  # looks for a Bootstrap .form-group, which a component here does not have
  bclick("#val_go", wait = 2)
  expect_equal(
    bev(
      "(document.querySelector('#val_email > .el-form-item__error') || {}).textContent || ''"
    ),
    "An email, please"
  )
  expect_true(bev(
    "document.getElementById('val_email').classList.contains('is-error')"
  ))
  # framed in Element's danger colour
  expect_match(
    bev(
      "getComputedStyle(document.querySelector('#val_email .el-input__wrapper')).boxShadow"
    ),
    "rgb(245, 108, 108)",
    fixed = TRUE
  )
  # A labelled component is a form item already: the message goes under the
  # control, in its content, and replaces the one the page opened with
  expect_equal(
    bev(
      "Array.from(document.querySelectorAll('#val_name_container > .el-form-item__content > .el-form-item__error')).map(function(e){ return e.textContent; }).join('|')"
    ),
    "A name, please"
  )
  expect_true(bev(
    "document.getElementById('val_name_container').classList.contains('is-error')"
  ))
  expect_false(bev(
    "document.getElementById('val_name').classList.contains('el-form-item')"
  ))
})

test_that("el_button is an action button, as actionButton() is", {
  skip_if_no_browser()
  vals <- bdump("act_dump")
  # 0 on load, classed, so observeEvent() does not run for it
  expect_equal(vals[["act_class"]], "shinyActionButtonValue/integer")
  expect_equal(vals[["act_fired"]], "0")
  bclick("#act_btn_container button", wait = 2)
  expect_equal(bdump("act_dump")[["act_fired"]], "1")
})

test_that("an input absorbed into a wrapper still reports its changes", {
  skip_if_no_browser()
  expect_equal(bdump("act_dump")[["abs_sw"]], "FALSE")
  bclick("#abs_tip_container .el-switch", wait = 2)
  expect_equal(bdump("act_dump")[["abs_sw"]], "TRUE")
})

# ── components added in the upstream pass ────────────────────────────────────

test_that("el_checkbox is one box, reporting TRUE or FALSE", {
  skip_if_no_browser()
  expect_equal(bdump("new_dump")[["cb1"]], "FALSE")
  bclick("#cb1_container .el-checkbox", wait = 2)
  expect_equal(bdump("new_dump")[["cb1"]], "TRUE")
  bclick("#cb1_container .el-checkbox", wait = 2)
  bclick("#cb_set", wait = 2)
  expect_equal(bdump("new_dump")[["cb1"]], "TRUE")
  expect_equal(
    bev(
      "document.querySelector('#cb1_container .el-checkbox__label').textContent.trim()"
    ),
    "Agreed"
  )
})

test_that("a button group joins its buttons, each still reporting", {
  skip_if_no_browser()
  # Element's group styles direct children: the buttons are inside it, not
  # behind hosts of their own
  expect_equal(
    bev(
      "document.querySelectorAll('#grp_container .el-button-group > .el-button').length"
    ),
    2
  )
  bclick("#grp_container .el-button-group > .el-button", wait = 2)
  expect_equal(bdump("new_dump")[["grp_a"]], "1")
})

test_that("a badge with an id is updated from the server", {
  skip_if_no_browser()
  expect_equal(
    bev(
      "document.querySelector('#bdg_container .el-badge__content').textContent.trim()"
    ),
    "3"
  )
  bclick("#bdg_set", wait = 2)
  expect_equal(
    bev(
      "document.querySelector('#bdg_container .el-badge__content').textContent.trim()"
    ),
    "42"
  )
})

test_that("a link with an id is an action link", {
  skip_if_no_browser()
  expect_equal(bdump("new_dump")[["lnk"]], "0")
  bclick("#lnk_container .el-link", wait = 2)
  expect_equal(bdump("new_dump")[["lnk"]], "1")
})

test_that("a remote autocomplete shows what the server suggests", {
  skip_if_no_browser()
  bev(
    "(function(){var i=document.querySelector('#ac_remote_container input'); i.focus(); i.value='zz'; i.dispatchEvent(new Event('input'));})()"
  )
  Sys.sleep(2.5)
  expect_match(
    bev(
      "Array.from(document.querySelectorAll('.el-autocomplete-suggestion li')).map(function(e){return e.textContent.trim()}).join('|')"
    ),
    "zz-x|zz-y",
    fixed = TRUE
  )
  bev("document.body.click()")
})

test_that("a form's fields change from the server, and its errors and validators work", {
  skip_if_no_browser()
  # Element's custom validator, a JS() function: 1 is not even
  bclick("#dyn_check", wait = 2)
  expect_equal(bdump("new_dump")[["dyn_valid"]], "FALSE")
  expect_match(
    bev("document.querySelector('#dyn_container').innerText"),
    "An even number"
  )
  bclick("#dyn_add", wait = 2)
  vals <- bdump("new_dump")
  expect_equal(vals[["dyn_fields"]], "email,phone,even")
  expect_equal(vals[["dyn_phone"]], "555")
  bclick("#dyn_err", wait = 2)
  expect_match(
    bev("document.querySelector('#dyn_container').innerText"),
    "Taken"
  )
})

# ── the server answering ──────────────────────────────────────────────────────

test_that("update_el_*(label, error) redraw the form item, as update*Input() does", {
  skip_if_no_browser()
  bclick("#upd_go", wait = 2)
  expect_equal(
    bev("document.getElementById('upd_lab-label').textContent"),
    "New:"
  )
  expect_equal(
    bev(
      "(document.querySelector('#upd_lab_container .el-form-item__error') || {}).textContent || ''"
    ),
    "Taken"
  )
  bclick("#upd_clear", wait = 2)
  expect_false(bev(
    "!!document.querySelector('#upd_lab_container .el-form-item__error')"
  ))
  expect_false(bev(
    "document.getElementById('upd_lab_container').classList.contains('is-error')"
  ))
  bclick("#upd_tag", wait = 2)
  expect_equal(
    bev("(document.getElementById('upd-b') || {}).textContent || 'none'"),
    "Bold"
  )
  expect_equal(
    bev("document.getElementById('upd_lab-label').textContent"),
    "Bold:"
  )
})

test_that("a lazy tree loads its nodes from the server", {
  skip_if_no_browser()
  # the top level, asked for on mount
  expect_match(
    bev("document.querySelector('#lz_tree_container .el-tree').innerText"),
    "Root"
  )
  bclick("#lz_tree_container .el-tree-node__content", wait = 2)
  expect_match(
    bev("document.querySelector('#lz_tree_container .el-tree').innerText"),
    "Child"
  )
})

test_that("a lazy cascader loads each column from the server", {
  skip_if_no_browser()
  bclick("#lz_casc_container .el-input__inner", wait = 2)
  expect_match(
    bev(
      "Array.from(document.querySelectorAll('.el-cascader-node__label')).map(function(e){return e.textContent}).join('|')"
    ),
    "Asia"
  )
  bev(
    "Array.from(document.querySelectorAll('.el-cascader-node')).filter(function(e){return /Asia/.test(e.textContent)})[0].click()"
  )
  Sys.sleep(2)
  expect_match(
    bev(
      "Array.from(document.querySelectorAll('.el-cascader-node__label')).map(function(e){return e.textContent}).join('|')"
    ),
    "China"
  )
  bev("document.body.click()")
})

test_that("a remote select searches on the server", {
  skip_if_no_browser()
  # Opened first, as a user would: a closed select does not search
  bclick("#rm_sel_container input", wait = 1)
  bev(
    "(function(){var i=document.querySelector('#rm_sel_container input'); i.value='be'; i.dispatchEvent(new Event('input', {bubbles: true}));})()"
  )
  Sys.sleep(2.5)
  expect_match(
    bev(
      "Array.from(document.querySelectorAll('.el-select-dropdown__item')).map(function(e){return e.textContent.trim()}).join('|')"
    ),
    "be-1|be-2"
  )
  expect_false(bev("shinyVue.find('#rm_sel').instance.loading"))
  bev("document.body.click()")
})

test_that("a lazy tree table loads a row's children from the server", {
  skip_if_no_browser()
  bclick("#lz_tbl_container .el-table__expand-icon", wait = 2)
  expect_match(
    bev(
      "document.querySelector('#lz_tbl_container .el-table__body').innerText"
    ),
    "a-child"
  )
})

test_that("a question the server never answers settles, and so does a removed one's", {
  skip_if_no_browser()
  bev(
    "window.__asked = 'waiting'; var t = shinyVue.askTimeout; shinyVue.askTimeout = 500;
       shinyVue.ask('nobody_answers', {}).then(function(v){ window.__asked = String(v); });
       shinyVue.askTimeout = t;"
  )
  Sys.sleep(1.5)
  expect_equal(bev("window.__asked"), "null")
  # A component removed while it waits: its question settles at once, and
  # its Vue instance is destroyed though it never had a binding
  bev(
    "window.__asked2 = 'waiting'; var h = document.getElementById('lz_tbl');
       var vm = h._shinyVue; window.__vm = vm;
       shinyVue.ask('lz_tbl_load', {probe: true}, vm).then(function(v){ window.__asked2 = String(v); });
       h.parentNode.removeChild(h);"
  )
  Sys.sleep(1)
  expect_equal(bev("window.__asked2"), "null")
  expect_true(bev("window.__vm.$.isUnmounted"))
})

test_that("a remote search the server never answers stops waiting", {
  skip_if_no_browser()
  bev(
    "var t = shinyVue.askTimeout; shinyVue.askTimeout = 500;
       shinyVue.find('#rm_none').instance.elRemoteQuery('q');
       window.__ac = 'waiting';
       shinyVue.find('#ac_none').instance.fetchSuggestions('q', function(v){ window.__ac = JSON.stringify(v); });
       shinyVue.askTimeout = t;"
  )
  expect_true(bev("shinyVue.find('#rm_none').instance.loading"))
  Sys.sleep(1.5)
  expect_false(bev("shinyVue.find('#rm_none').instance.loading"))
  expect_equal(bev("window.__ac"), "[]")
})

test_that("an autocomplete typed into faster than the server shows the last answer", {
  skip_if_no_browser()
  # Two queries out, answered in order: the second callback, the one Element
  # still listens to, ends with the second answer
  bev(
    "var vm = shinyVue.find('#ac_none').instance; window.__got = [];
       vm.fetchSuggestions('a', function(v){ window.__got.push('cb1:' + v[0].value); });
       vm.fetchSuggestions('ab', function(v){ window.__got.push('cb2:' + v[0].value); });
       vm.suggestions = [{value: 'A'}];
       vm.$nextTick(function(){ vm.suggestions = [{value: 'AB'}]; });"
  )
  Sys.sleep(0.5)
  expect_equal(bev("window.__got.join(',')"), "cb2:A,cb2:AB")
})

test_that("a tree filters by label without a filter method of its own", {
  skip_if_no_browser()
  # Element throws "filterNodeMethod is required" without one
  bclick("#tree_filter", wait = 2)
  shown <- bev("document.querySelector('#tree_container .el-tree').innerText")
  expect_match(shown, "Apple")
  expect_false(grepl("Grains", shown))
})

test_that("a table method taking a row gets the table's own row", {
  skip_if_no_browser()
  bclick("#tbl_pick", wait = 2)
  expect_equal(bdump()[["tbl_selection_rows"]], "2")
})

test_that("more of Element's methods run through call_el()", {
  skip_if_no_browser()
  # A button named car_next would collide with call_el()'s own report,
  # input$car_next, and run twice
  before <- as.integer(bdump()[["car"]])
  bclick("#carousel_forward", wait = 2)
  expect_equal(as.integer(bdump()[["car"]]), (before + 1) %% 3)
  bclick("#menu_open_btn", wait = 1.5)
  expect_true(bev(
    "Array.from(document.querySelectorAll('#nav_container .el-sub-menu')).some(function(e){ return e.classList.contains('is-opened'); })"
  ))
})

test_that("a label names its component for assistive technology", {
  skip_if_no_browser()
  # A select's id reaches its native input, so <label for> works
  expect_equal(
    bev("document.getElementById('lab_city-input').labels[0].textContent"),
    "City"
  )
  # A switch has no single native input: aria-labelledby on its root
  expect_equal(
    bev(
      "document.querySelector('#lab_on .el-switch').getAttribute('aria-labelledby')"
    ),
    "lab_on-label"
  )
  # hiding the component by its id hides its label too
  expect_true(bev(
    "document.getElementById('lab_city').contains(document.getElementById('lab_city-label'))"
  ))
})
