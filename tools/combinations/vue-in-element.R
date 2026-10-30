# Steps for inst/examples/combinations/vue-in-element: run by tools/combinations.R

mounted <- function(id) {
  sprintf(
    "!!(document.getElementById('%s') && document.getElementById('%s')._shinyVue)",
    id,
    id
  )
}
click <- function(id) sprintf("document.querySelector('.vc-%s').click()", id)

cat("== a vue_app() in Element's Vue apps mounts and reports\n")
for (id in c("in_scrollbar", "in_splitter", "in_card", "in_provider")) {
  check(paste(id, "mounted"), mounted(id))
  act(click(id), 0.8)
  check(paste(id, "reports"), paste0(iv(id), " === 1"))
}
cat("== in a popover's body, once shown\n")
act("document.querySelector('#pop_btn button, #pop .el-button').click()", 1)
check("in_popover mounted", mounted("in_popover"))
act(click("in_popover"), 0.8)
check("in_popover reports", paste0(iv("in_popover"), " === 1"))
act("document.body.click()", 0.5)

cat("== in the containers drawn as markup\n")
act("document.querySelector('#open button').click()", 1)
check("in_dialog mounted", mounted("in_dialog"))
act(click("in_dialog"), 0.8)
check("in_dialog reports", paste0(iv("in_dialog"), " === 1"))
act("document.querySelector('#dlg .el-dialog__headerbtn').click()", 0.8)
check(
  "the store follows the dialog closed",
  "shinyVue.useStore('ui').open === false"
)
check("in_tab_a mounted", mounted("in_tab_a"))
act("document.querySelectorAll('#tabs .el-tabs__item')[1].click()", 0.6)
check("in_tab_b mounted", mounted("in_tab_b"))
act(click("in_tab_b"), 0.8)
check("in_tab_b reports", paste0(iv("in_tab_b"), " === 1"))
check("in_collapse mounted", mounted("in_collapse"))
act(click("in_collapse"), 0.8)
check("in_collapse reports", paste0(iv("in_collapse"), " === 1"))

cat("== Element tags in a vue_app(), with v_*()\n")
act("document.querySelector('#raw .raw-btn').click()", 0.8)
check("v_on() set the field", paste0(iv("raw"), " === 'clicked'"))
check(
  "v_if() shows the tag",
  "document.querySelector('#raw .raw-tag').textContent.trim() === 'clicked'"
)
check(
  "v_model() shows it in the input",
  "document.querySelector('#raw .raw-in input').value === 'clicked'"
)
