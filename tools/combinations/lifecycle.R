# Steps for inst/examples/combinations/lifecycle: run by tools/combinations.R

count <- function(sel) sprintf("document.querySelectorAll('%s').length", sel)

cat("== many components at once\n")
check(
  "every switch reports",
  "Object.keys(Shiny.shinyapp.$inputValues).filter(function(k){ return /^many_sw/.test(k); }).length === 120"
)
check("every select reports", paste0(iv("many_sel60"), " === 'y'"))
show("hosts on the page", count("[data-shiny-vue]"))
show("poppers on the page at start", count(".el-popper"))
poppers <- ev(count(".el-popper"))
hosts <- ev(count("[data-shiny-vue]"))

cat("== insert and remove a block, twenty times\n")
for (i in 1:20) {
  act("document.getElementById('add').click()", 0.6)
  # open its dropdown, so a teleported popper is made
  act(
    "var s = document.querySelector('#slot .el-select__wrapper'); if (s) s.click();",
    0.3
  )
  act("document.body.click(); document.getElementById('remove').click()", 0.6)
}
check(
  "no block left",
  "document.querySelectorAll('#slot .el-card').length === 0"
)
show("poppers after", count(".el-popper"))
check(
  "dropdowns and tooltips in <body> leave with their component",
  paste0(count(".el-popper"), " <= ", poppers + 3)
)
check(
  "hosts back to where they were",
  paste0(count("[data-shiny-vue]"), " === ", hosts)
)

cat("== redraw an output twenty times\n")
for (i in 1:20) {
  act("document.getElementById('redraw').click()", 0.5)
}
Sys.sleep(1)
check(
  "one block in the output",
  "document.querySelectorAll('#out .el-card').length === 1"
)
check("the latest block's select reports", paste0(iv("sr20"), " === 'a'"))
show("poppers after redraws", count(".el-popper"))
check(
  "redraws leave no poppers behind",
  paste0(count(".el-popper"), " <= ", poppers + 6)
)

cat("== reconnect\n")
act("Shiny.shinyapp.$socket.close()", 6)
check("reconnected", "Shiny.shinyapp.isConnected()")
act("document.getElementById('add').click()")
check(
  "the server answers after reconnecting",
  "document.querySelectorAll('#slot .el-card').length === 1"
)
act("document.querySelectorAll('#many .el-switch')[0].click()")
check(
  "an input still reports after reconnecting",
  "/sw1 TRUE/.test(document.getElementById('dump').innerText)"
)
