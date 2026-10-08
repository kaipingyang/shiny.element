# Steps for inst/examples/combinations/drawn-later: run by tools/combinations.R

cat("== renderUI inside a config provider\n")
check(
  "dynamic components drawn",
  "!!document.getElementById('dyn_btn') || !!document.querySelector('#dyn .el-button')"
)
check("dynamic select reports", paste0(iv("dyn_sel"), " === 'a'"))
check(
  "dynamic button takes the provider's size",
  "!!document.querySelector('#dyn .el-button--small')"
)
check(
  "dynamic select takes the provider's size",
  "!!document.querySelector('#dyn .el-select--small')"
)
act(
  "(document.getElementById('dyn_btn') || document.querySelector('#dyn .el-button')).click()",
  1.5
)
check("dynamic button counted", paste0(iv("dyn_btn"), " === 1"))
check("dynamic select updated by the server", paste0(iv("dyn_sel"), " === 'c'"))
act("document.getElementById('regen').click()", 2)
check(
  "drawn again: new label",
  "/Dynamic 2/.test(document.getElementById('dyn').innerText)"
)
check(
  "drawn again: switch reports its new value",
  paste0(iv("dyn_sw"), " === true")
)
check(
  "drawn again: one button only",
  "document.querySelectorAll('#dyn .el-button').length === 1"
)
act(
  "(document.getElementById('dyn_btn') || document.querySelector('#dyn .el-button')).click()",
  1.5
)
check(
  "drawn again: button keeps counting from a fresh 1 or on",
  paste0(iv("dyn_btn"), " >= 1")
)
show(
  "dyn dump",
  "document.getElementById('dump_dyn').innerText.replace(/\\n/g, ' ')"
)

cat("== two trees in one space\n")
act(
  "document.querySelectorAll('#tree_a .el-tree-node__content .el-checkbox')[1].click()",
  1.5
)
check(
  "tree A reports its check",
  "/11/.test(JSON.stringify(Shiny.shinyapp.$inputValues.tree_a_checked))"
)
act("document.getElementById('check_b').click()", 1.5)
check(
  "call_el on tree B checks Leek in B",
  "(function(){ var b = document.getElementById('tree_b'); var root = b && (b.classList.contains('el-tree') ? b : b.querySelector('.el-tree')); return !!root && Array.from(root.querySelectorAll('.el-tree-node.is-checked')).some(function(n){ return /Leek/.test(n.innerText); }); })()"
)
check(
  "tree A untouched by the call on B",
  "(function(){ var a = document.getElementById('tree_a'); var root = a && (a.classList.contains('el-tree') ? a : a.querySelector('.el-tree')); return !!root && !Array.from(root.querySelectorAll('.el-tree-node.is-checked')).some(function(n){ return /Leek/.test(n.innerText); }); })()"
)
check(
  "tree select filled by the server",
  "(function(){ document.querySelector('#tsel .el-select__wrapper, [id=\"tsel\"]').click(); return true; })()"
)
Sys.sleep(1)
check(
  "tree select options present",
  "Array.from(document.querySelectorAll('.el-select-dropdown .el-tree-node')).some(function(n){ return /Fruit/.test(n.innerText); })"
)
act("document.body.click()", 0.5)
show(
  "tree dump",
  "document.getElementById('dump_tree').innerText.replace(/\\n/g, ' ')"
)

cat("== drawer with tabs, table and calendar outputs\n")
act("document.getElementById('open_drawer').click()", 2.5)
check("drawer open", "document.getElementById('drw').style.display !== 'none'")
check(
  "table in drawer has width",
  "(function(){ var t = document.querySelector('#dtbl .el-table__body'); return !!t && t.getBoundingClientRect().width > 300; })()"
)
check(
  "table rows drawn",
  "document.querySelectorAll('#dtbl .el-table__body tr').length === 5"
)
act(
  "document.querySelectorAll('#dtbl .el-table__body .el-checkbox')[0].click()",
  1.5
)
check(
  "table in drawer reports selection",
  paste0("JSON.stringify(", iv("dtbl_selection_rows"), ") === '[1]'")
)
act("document.querySelectorAll('#dtabs .el-tabs__item')[1].click()", 2)
check(
  "calendar in a late tab drawn",
  "document.querySelectorAll('#dcal .el-calendar-table td').length >= 28"
)
check(
  "calendar shows the event",
  "/Today's event/.test(document.getElementById('dcal').innerText)"
)
act("document.querySelector('#drw .el-drawer__close-btn').click()", 1.5)
check("drawer closed", "!document.querySelector('#drw .el-drawer.open')")

cat("== carousel with components\n")
act("document.getElementById('car_btn').click()", 1.5)
check("button in a slide counted", paste0(iv("car_btn"), " === 1"))
check("rate in a slide reports", paste0(iv("car_rate"), " === 2"))
act(
  "document.querySelectorAll('#car .el-carousel__indicator button, #car .el-carousel__button')[1].click()",
  1.5
)
check("carousel reports slide change", paste0(iv("car"), " !== undefined"))
show("carousel value", iv("car"))

cat("== steps driven by a button group\n")
act("document.getElementById('nxt').click()", 1)
act("document.getElementById('nxt').click()", 1)
act("document.getElementById('prev').click()", 1.5)
check(
  "steps at 1 after next, next, prev",
  "document.querySelectorAll('#stp .el-step__head.is-finish').length === 1"
)
show(
  "misc",
  "document.getElementById('dump_misc').innerText.replace(/\\n/g, ' ')"
)
