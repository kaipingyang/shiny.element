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

# ── form ──────────────────────────────────────────────────────────────────────

test_that("the form renders one control per declared field", {
  skip_if_no_browser()
  # A single template dispatches on f.tag via <component :is>, so a missing
  # type mapping shows up as a control that never rendered.
  expect_equal(bev("String(document.querySelectorAll('#signup_container .el-input-number').length)"), "1")
  expect_equal(bev("String(document.querySelectorAll('#signup_container .el-select').length)"), "1")
  expect_equal(bev("(function(){var e=document.querySelector('#signup_container .el-form-item__label'); return getComputedStyle(e).width})()"), "110px")
  expect_equal(bev("String(document.querySelectorAll('#signup_container .el-form-item.is-required').length)"), "2")
})

test_that("the form reports its whole model on load", {
  skip_if_no_browser()
  model <- bev("(function(){var w=HTMLWidgets.find('#signup'); return JSON.stringify(w.instance.model)})()")
  # Types survive the round-trip: a number stays a number.
  expect_equal(model, '{"fname":"","fage":18,"fcity":""}')
})

test_that("submitting an incomplete form fails validation client-side", {
  skip_if_no_browser()
  bev("(function(){document.querySelectorAll('#signup_container .el-button')[0].click()})()")
  Sys.sleep(2.5)
  expect_equal(bev("String(document.querySelectorAll('#signup_container .el-form-item.is-error').length)"), "2")
  expect_equal(
    bev("JSON.stringify(Array.from(document.querySelectorAll('#signup_container .el-form-item__error')).map(function(e){return e.innerText}))"),
    '["name required","pick a city"]'
  )
  vals <- bdump()
  expect_equal(vals[["signup_valid"]], "FALSE")
  expect_equal(vals[["signup_submit"]], "1")
})

test_that("a filled form passes and reports the model", {
  skip_if_no_browser()
  bclick("#form_prefill", wait = 2.5)
  bev("(function(){document.querySelectorAll('#signup_container .el-button')[0].click()})()")
  Sys.sleep(2.5)
  expect_equal(bev("String(document.querySelectorAll('#signup_container .el-form-item.is-error').length)"), "0")
  expect_equal(bdump()[["signup_valid"]], "TRUE")
  expect_equal(
    bev("(function(){var w=HTMLWidgets.find('#signup'); return JSON.stringify(w.instance.model)})()"),
    '{"fname":"Ada","fage":18,"fcity":"sh"}'
  )
})

test_that("resetFields restores the declared values, not empty ones", {
  skip_if_no_browser()
  bev("(function(){document.querySelectorAll('#signup_container .el-button')[1].click()})()")
  Sys.sleep(2.5)
  # fage was declared as 18, so it resets to 18 rather than 0.
  expect_equal(
    bev("(function(){var w=HTMLWidgets.find('#signup'); return JSON.stringify(w.instance.model)})()"),
    '{"fname":"","fage":18,"fcity":""}'
  )
  expect_equal(bev("String(document.querySelectorAll('#signup_container .el-form-item.is-error').length)"), "0")
})

# ── menu ──────────────────────────────────────────────────────────────────────

test_that("the menu renders its whole tree, nested and grouped", {
  skip_if_no_browser()
  expect_equal(bev("String(document.querySelectorAll('#nav_container .el-submenu').length)"), "1")
  expect_equal(bev("String(document.querySelectorAll('#nav_container .el-menu-item-group').length)"), "1")
  # home, All, Discontinued, In group -- the submenu title is not an item.
  expect_equal(bev("String(document.querySelectorAll('#nav_container .el-menu-item').length)"), "4")
  expect_equal(bev("String(document.querySelectorAll('#nav_container .el-menu-item.is-disabled').length)"), "1")
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
    bev("(function(){var e=document.querySelector('#nav_container .el-menu-item.is-active'); return e ? e.innerText.trim() : 'NONE'})()"),
    "All"
  )
})

test_that("selecting an item reports its index and path", {
  skip_if_no_browser()
  bev("(function(){var i=document.querySelectorAll('#nav_container .el-menu-item'); i[1].click()})()")
  Sys.sleep(2.5)
  vals <- bdump()
  expect_equal(vals[["nav"]], "m-all")
  # The path distinguishes a nested item from a top-level one.
  expect_equal(vals[["nav_path"]], "m-prod,m-all")
})

# ── tree ──────────────────────────────────────────────────────────────────────

test_that("the tree renders its nodes with checkboxes", {
  skip_if_no_browser()
  expect_gt(as.numeric(bev("String(document.querySelectorAll('#tree_container .el-tree-node').length)")), 2)
  # Element replaces its props map wholesale, so `disabled` has to be named in
  # it or a disabled node renders as a normal one.
  expect_equal(bev("String(document.querySelectorAll('#tree_container .el-checkbox.is-disabled').length)"), "1")
})

test_that("the tree reports its initial checked keys", {
  skip_if_no_browser()
  expect_equal(bdump()[["tree_checked"]], "t-apple")
})

test_that("clicking a node reports its key", {
  skip_if_no_browser()
  bev("(function(){var n=document.querySelectorAll('#tree_container .el-tree-node__label'); for (var i=0;i<n.length;i++) { if (n[i].innerText.trim()==='Grains') { n[i].click(); break } }})()")
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
    bev("(function(){var c=document.querySelectorAll('#tree_container .el-checkbox.is-checked'); return JSON.stringify(Array.from(c).map(function(e){return e.parentElement.innerText.trim()}))})()"),
    '["Grains"]'
  )
})

# ── upload ────────────────────────────────────────────────────────────────────

test_that("the upload renders a drop zone with its tip", {
  skip_if_no_browser()
  expect_equal(bev("String(!!document.querySelector('#up_container .el-upload-dragger'))"), "true")
  expect_equal(bev("String(document.querySelectorAll('#up_container .el-upload__tip').length)"), "1")
})

test_that("the file field is named uniquely so Shiny sees no duplicate id", {
  skip_if_no_browser()
  # Shiny's fileInputBinding claims every input[type=file] and keys it by
  # name; Element's default "file" collides as soon as there are two uploads.
  expect_equal(
    bev("(function(){var i=document.querySelector('#up_container input[type=file]'); return i ? i.name : 'NONE'})()"),
    "up_elfile"
  )
})

test_that("a whole selection goes through one upload job", {
  skip_if_no_browser()
  # Counted by patching makeRequest before the page loads would need a fresh
  # session; here the observable consequence is what matters: all three files
  # arrive together rather than the last one overwriting the rest.
  tmp <- file.path(tempdir(), c("ba.txt", "bb.txt", "bc.txt"))
  writeLines("aa", tmp[1]); writeLines("bb", tmp[2]); writeLines("cc", tmp[3])

  b   <- browser_session()$b
  doc <- b$DOM$getDocument()
  node <- b$DOM$querySelector(nodeId = doc$root$nodeId,
                              selector = "#up_container input[type=file]")
  b$DOM$setFileInputFiles(files = as.list(tmp), nodeId = node$nodeId)
  Sys.sleep(5)

  expect_equal(bev("String(document.querySelectorAll('#up_container .el-upload-list__item.is-success').length)"), "3")
  expect_equal(bdump()[["up_rows"]], "3")
})

# ── unsupplied props fall back to Element's defaults ──────────────────────────

test_that("a select with no placeholder shows Element's own", {
  skip_if_no_browser()
  # Bound to a bare null it rendered an empty placeholder instead. The text
  # comes from Element's locale, so this also proves the prop reached its
  # default rather than being overwritten.
  ph <- bev("(function(){var e=document.querySelector('#sel_container input'); return e ? e.placeholder : 'NONE'})()")
  expect_true(nzchar(ph))
  expect_false(identical(ph, "NONE"))
})

test_that("an input with no size keeps the default height", {
  skip_if_no_browser()
  h <- as.numeric(bev("(function(){var e=document.querySelector('#inp_container .el-input__inner'); return e ? String(Math.round(e.getBoundingClientRect().height)) : '0'})()"))
  # Element's default control height is 40px; the small sizes are 36/32/28.
  expect_equal(h, 40)
})

# ── components do not each claim their own line ───────────────────────────────

test_that("two buttons sit side by side", {
  skip_if_no_browser()
  # Vue mounts onto each component's container div but leaves it in the
  # document. While it was block-level, no two components could share a line.
  geom <- bev("(function(){var b=document.querySelectorAll('#inline_probe .el-button'); if(b.length<2) return 'null'; var a=b[0].getBoundingClientRect(), c=b[1].getBoundingClientRect(); return JSON.stringify({sameRow: Math.round(a.top)===Math.round(c.top), ordered: c.left>a.left})})()")
  geom <- jsonlite::fromJSON(geom)
  expect_true(geom$sameRow)
  expect_true(geom$ordered)
})

test_that("the mount point generates no layout box of its own", {
  skip_if_no_browser()
  expect_equal(
    bev("getComputedStyle(document.getElementById('probe_b1_container')).display"),
    "contents"
  )
})

test_that("a block component still fills its parent", {
  skip_if_no_browser()
  # display:contents must not stop an alert or a table from taking the full
  # width of whatever contains it.
  ratio <- bev("(function(){var t=document.querySelector('#tbl_container .el-table'); if(!t) return '0'; var p=t.parentElement.getBoundingClientRect(); return String(t.getBoundingClientRect().width / p.width)})()")
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
  # The fixture app renders every component once. With the demo stylesheet
  # loaded it measured over 4000px; without it, well under.
  h <- as.numeric(bev("String(document.documentElement.scrollHeight)"))
  expect_lt(h, 4000)
})

# ── offline assets ────────────────────────────────────────────────────────────

test_that("the page loads no third-party assets at runtime", {
  skip_if_no_browser()
  # A CDN dependency leaves the app blank on an intranet or when unpkg is down.
  hosts <- bev("JSON.stringify(Array.from(new Set(Array.from(document.querySelectorAll('script[src],link[href]')).map(function(e){try{return new URL(e.src||e.href).hostname}catch(x){return null}}).filter(Boolean))))")
  expect_false(grepl("unpkg", hosts, fixed = TRUE))
  expect_false(grepl("cdn", hosts, fixed = TRUE))
})

test_that("the bundled icon font is served and loaded", {
  skip_if_no_browser()
  expect_equal(
    bev("(function(){return String(Array.from(document.fonts).some(function(f){return f.family.indexOf('element-icons')>-1 && f.status==='loaded'}))})()"),
    "true"
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
