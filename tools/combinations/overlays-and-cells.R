# Steps for inst/examples/combinations/overlays-and-cells: run by tools/combinations.R

cat("== config provider updated: static and dynamic follow\n")
check(
  "both small at first",
  "!!document.querySelector('#static_btn.el-button--small') && !!document.querySelector('#dyn .el-button--small')"
)
act("document.querySelectorAll('#size_pick .el-radio-button')[2].click()", 2)
check(
  "static button large",
  "!!document.querySelector('#static_btn.el-button--large')"
)
check(
  "dynamic button large",
  "!!document.querySelector('#dyn .el-button--large')"
)

cat("== call_el on the first of two trees\n")
act("document.getElementById('check_a').click()", 1.5)
check(
  "Pear checked in tree A",
  "Array.from(document.querySelectorAll('#tree_a .el-tree-node.is-checked')).some(function(n){ return /Pear/.test(n.innerText); })"
)
check(
  "tree B untouched",
  "!Array.from(document.querySelectorAll('#tree_b .el-tree-node.is-checked')).some(function(n){ return /Pear/.test(n.innerText); })"
)
check(
  "tree A reports",
  paste0("/12/.test(JSON.stringify(", iv("tree_a_checked"), "))")
)

cat("== a select in an input's slot\n")
check("kind reports", paste0(iv("kind"), " === 'n'"))
act("document.getElementById('set_kind').click()", 1.5)
check("kind updated by its id", paste0(iv("kind"), " === 'i'"))
check(
  "kind shows Id",
  "/Id/.test(document.querySelector('.el-input-group__prepend').innerText)"
)

cat("== dialog with tabs, nested dialog, message box\n")
act("document.getElementById('open_dlg').click()", 2)
check(
  "tab bar under the first tab has a width",
  "(function(){ var b = document.querySelector('#dlg_tabs .el-tabs__active-bar'); return !!b && b.getBoundingClientRect().width > 20; })()"
)
act("document.querySelectorAll('#dlg_tabs .el-tabs__item')[1].click()", 1.5)
show(
  "bar vs tab",
  "(function(){ var b = document.querySelector('#dlg_tabs .el-tabs__active-bar'); var t = document.querySelectorAll('#dlg_tabs .el-tabs__item')[1]; var cs = getComputedStyle(t); return [b.getBoundingClientRect().width, t.getBoundingClientRect().width, cs.paddingLeft, cs.paddingRight, b.style.transform].join(' '); })()"
)
check(
  "tab bar follows the long tab",
  "(function(){ var b = document.querySelector('#dlg_tabs .el-tabs__active-bar'); var t = document.querySelectorAll('#dlg_tabs .el-tabs__item')[1]; var cs = getComputedStyle(t); return Math.abs(b.getBoundingClientRect().width - (t.getBoundingClientRect().width - parseFloat(cs.paddingLeft) - parseFloat(cs.paddingRight))) < 2; })()"
)
check(
  "table in the dialog's tab has width",
  "(function(){ var t = document.querySelector('#dlg .el-table__body'); return !!t && t.getBoundingClientRect().width > 200; })()"
)
act("document.getElementById('open_inner').click()", 2)
check("inner dialog above the outer", paste0(z("#inner"), " > ", z("#dlg")))
act("document.querySelector('#inner .el-dialog__headerbtn').click()", 1.5)
check(
  "outer still open after closing inner",
  "document.getElementById('dlg').style.display !== 'none'"
)
check(
  "body still locked while outer open",
  "document.body.classList.contains('el-popup-parent--hidden')"
)
act("document.getElementById('ask').click()", 2)
check(
  "message box above the dialog",
  paste0(
    "(function(){ var m = document.querySelector('.el-message-box'); var o = m && m.closest('.el-overlay'); return !!o && parseInt(getComputedStyle(o).zIndex) > ",
    z("#dlg"),
    "; })()"
  )
)
act(
  "document.querySelector('.el-message-box .el-button--primary').click()",
  1.5
)
check("message box answered", paste0(iv("q1"), " === 'confirm'"))
check(
  "dialog still open after the message box",
  "document.getElementById('dlg').style.display !== 'none'"
)
act("document.querySelector('#dlg .el-dialog__headerbtn').click()", 1.5)
check(
  "page unlocked after all closed",
  "!document.body.classList.contains('el-popup-parent--hidden')"
)

cat("== table cell buttons: popconfirm and edit\n")
act(
  "document.querySelectorAll('#acts .el-table__body .el-button--primary')[1].click()",
  1.5
)
check(
  "edit reports row 2",
  paste0("(", iv("acts_edit"), " || {}).row_index === 2")
)
act(
  "document.querySelectorAll('#acts .el-table__body .el-button--danger')[0].click()",
  1
)
act(
  "Array.from(document.querySelectorAll('.el-popconfirm')).filter(function(p){return p.offsetParent})[0].querySelector('.el-button--primary').click()",
  1.5
)
check(
  "popconfirm in a cell confirms row 1",
  paste0("(", iv("acts_del"), " || {}).row_index === 1")
)

cat("== insertUI and removeUI\n")
act("document.getElementById('add').click()", 2)
check("inserted switch reports", paste0(iv("ins_sw1"), " === true"))
act("document.querySelector('#w1 .el-switch').click()", 1.5)
check("inserted switch changes", paste0(iv("ins_sw1"), " === false"))
act("document.getElementById('remove').click()", 1.5)
check("removed", "!document.getElementById('w1')")
act("document.getElementById('add').click()", 2)
check("second insert reports", paste0(iv("ins_sw2"), " === true"))
show("dump", "document.getElementById('dump').innerText.replace(/\\n/g, ' ')")
