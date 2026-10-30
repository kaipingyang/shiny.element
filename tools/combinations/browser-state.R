# Steps for inst/examples/combinations/browser-state: run by tools/combinations.R

badge <- "document.querySelector('#bdg .el-badge__content').textContent.trim()"
on <- function(id) {
  sprintf(
    "document.querySelector('#%s .el-switch').classList.contains('is-checked')",
    id
  )
}

cat("== Vue's ref, computed and watch\n")
act("document.querySelector('#bdg button').click()", 0.3)
act("document.querySelector('#bdg button').click()", 1)
check(
  "a folded component's binding follows the computed",
  paste0(badge, " === '4'")
)
check("the ref reports", paste0(iv("count"), " === 2"))
check("the computed reports", paste0(iv("twice"), " === 4"))
check("the watch set the store", "shinyVue.useStore('app').label === 'count 2'")

cat("== a binding in an overlay, and one outside it, on one store\n")
act("document.querySelector('#open button').click()", 1)
act("document.querySelector('#dlg_sw .el-switch').click()", 1)
check("the switch outside follows the one inside", on("main_sw"))
check(
  "the server hears both",
  paste0(iv("main_sw"), " === true && ", iv("dlg_sw"), " === true")
)
act("document.querySelector('#dlg .el-dialog__headerbtn').click()", 0.8)
check(
  "closing the dialog sets the store",
  "shinyVue.useStore('app').open === false"
)
check(
  "a cell's template reads the store",
  "document.querySelectorAll('#tbl .cell-on').length === 2"
)

cat("== drawn later, and redrawn\n")
check(
  "a component drawn later follows the store",
  "document.querySelector('#later_tag .el-tag').classList.contains('el-tag--success')"
)
check(
  "a store drawn after its reader",
  "document.querySelector('#late_read .late').textContent === 'late store'"
)
act("document.getElementById('redraw').click()", 1.5)
check(
  "redrawn, still bound",
  "document.querySelector('#later_tag .el-tag').classList.contains('el-tag--success')"
)
check(
  "redrawn store, read again",
  "document.querySelector('#late_read .late').textContent === 'late store'"
)

cat("== the route\n")
act("location.hash = '#/orders'", 1)
check(
  "a binding follows the route",
  "document.querySelector('#routed .route').textContent === '/orders'"
)

cat("== two instances of a module\n")
act("document.querySelector('#m1-add button').click()", 0.3)
act("document.querySelector('#m1-add button').click()", 0.8)
check(
  "each its own store",
  "document.querySelector('#m1-badge .el-badge__content').textContent.trim() === '2' && document.querySelector('#m2-badge .el-badge__content').textContent.trim() === '0'"
)

cat("== $find()\n")
act("document.querySelector('#flt button').click()", 0.8)
check(
  "a component's method from another's handler",
  "Array.from(document.querySelectorAll('#tr .el-tree-node')).filter(function(n){ return n.style.display !== 'none'; }).length === 1"
)

cat("== the server sets bound fields\n")
act("document.getElementById('srv').click()", 1.5)
check(
  "an update of a bound switch sets the store",
  "shinyVue.useStore('app').on === false"
)
check("the other switch follows", paste0("!", on("dlg_sw")))
check(
  "an update of a ref",
  paste0(iv("count"), " === 10 && ", badge, " === '20'")
)
