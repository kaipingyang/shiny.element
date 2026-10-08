# Steps for inst/examples/combinations/wrapped-and-nested: run by tools/combinations.R

cat("== load\n")
check("tabs report the first tab", "Shiny.shinyapp.$inputValues.tabs === 'one'")
check("wrapped switch reports TRUE", "Shiny.shinyapp.$inputValues.sw1 === true")
check(
  "wrapped input reports its value",
  "Shiny.shinyapp.$inputValues.in1 === 'hello'"
)
check(
  "slider in a closed collapse reports",
  "Shiny.shinyapp.$inputValues.sl_hidden === 30"
)
check("module select reports", "Shiny.shinyapp.$inputValues['m1-pick'] === 'x'")
check(
  "config provider size reaches a wrapped button",
  "!!document.querySelector('#space1 .el-button--small')"
)
check(
  "config provider size reaches the module's select",
  "!!document.querySelector('.el-select--small')"
)
check(
  "no stray el-id inputs",
  "Object.keys(Shiny.shinyapp.$inputValues).filter(function(k){return k.indexOf('el-id')===0}).length === 0"
)

cat("== update wrapped components by their ids\n")
act("document.getElementById('upd_wrapped').click()", 2)
check(
  "second button relabelled",
  "Array.from(document.querySelectorAll('#space1 .el-button')).map(function(b){return b.innerText.trim()}).join('|') === 'First|Second (updated)'"
)
check(
  "second button now danger",
  "!!document.querySelector('#space1 .el-button--danger')"
)
check(
  "first button untouched",
  "!document.querySelectorAll('#space1 .el-button')[0].classList.contains('el-button--danger')"
)
check(
  "wrapped input updated and reported",
  "document.getElementById('in1').value === 'changed' && Shiny.shinyapp.$inputValues.in1 === 'changed'"
)
check(
  "wrapped switch updated and reported",
  "Shiny.shinyapp.$inputValues.sw1 === false"
)
check(
  "hidden slider updated and reported",
  "Shiny.shinyapp.$inputValues.sl_hidden === 77"
)

cat("== open the closed collapse panel: slider drawn at its value\n")
act(
  "document.querySelectorAll('#coll .el-collapse-item__header')[1].click()",
  1.5
)
check(
  "slider handle sits at 77%",
  "(function(){ var b = document.getElementById('sl_hidden'); return b && Math.round(parseFloat(b.style.left)) === 77; })()"
)

cat("== module: click the wrapped button\n")
act("document.getElementById('m1-btn').click()", 2)
check(
  "module button counted",
  "Shiny.shinyapp.$inputValues['m1-btn:shiny.action'] === 1"
)
check(
  "module button relabelled through its session",
  "Array.from(document.querySelectorAll('.el-button')).some(function(b){return b.innerText.trim()==='Clicked 1'})"
)
check("module select updated", "Shiny.shinyapp.$inputValues['m1-pick'] === 'z'")
show("module text", "document.getElementById('m1-said').innerText")

cat("== dialog with a form, destroy-on-close\n")
act("document.querySelectorAll('#tabs .el-tabs__item')[1].click()", 1.5)
check("tab two reported", "Shiny.shinyapp.$inputValues.tabs === 'two'")
act("document.getElementById('open_dlg').click()", 2)
check(
  "dialog open",
  "document.querySelector('#dlg').style.display !== 'none' && !!document.querySelector('#dlg .el-form')"
)
check(
  "form field group has two inner items",
  "document.querySelectorAll('#dlg .el-form-item .el-form-item').length === 2"
)
act("document.querySelector('#dlg .el-button--primary').click()", 1.5)
check("empty submit invalid", "Shiny.shinyapp.$inputValues.frm_valid === false")
check(
  "the select's error shows",
  "/Pick someone/.test(document.querySelector('#dlg').innerText)"
)
act("document.querySelector('#dlg .el-select__wrapper').click()", 1)
act(
  "Array.from(document.querySelectorAll('.el-select-dropdown__item')).filter(function(o){return o.offsetParent})[1].click()",
  1
)
act("document.querySelector('#dlg .el-button--primary').click()", 1.5)
check("valid after picking", "Shiny.shinyapp.$inputValues.frm_valid === true")
check(
  "model carries who",
  "Shiny.shinyapp.$inputValues.frm && Shiny.shinyapp.$inputValues.frm.who === 'Grace'"
)
act("document.querySelector('#dlg .el-dialog__headerbtn').click()", 1.5)
act("document.getElementById('open_dlg').click()", 2)
check("reopened: form drawn again", "!!document.querySelector('#dlg .el-form')")
show("dialog inputs", "JSON.stringify({dlg: Shiny.shinyapp.$inputValues.dlg})")
act("document.querySelector('#dlg .el-dialog__headerbtn').click()", 1)

cat("== popover filtering a table output\n")
act("document.querySelectorAll('#tabs .el-tabs__item')[2].click()", 2)
check(
  "table drawn in a tab shown late",
  "document.querySelectorAll('#tbl .el-table__body tr').length === 2"
)
act("document.getElementById('pop_btn').click()", 1)
check(
  "popover open",
  "Array.from(document.querySelectorAll('.el-popover')).some(function(p){return p.offsetParent})"
)
show(
  "input keys",
  "Object.keys(Shiny.shinyapp.$inputValues).filter(function(k){return /tbl/.test(k)}).join(',')"
)
act(
  "Array.from(document.querySelectorAll('.el-popover')).filter(function(p){return p.offsetParent})[0].querySelector('.el-select__wrapper').click()",
  1
)
act(
  "Array.from(document.querySelectorAll('.el-select-dropdown__item')).filter(function(o){return o.offsetParent && o.innerText.trim()==='core'})[0].click()",
  2
)
check(
  "picking in the select inside the popover keeps the popover open",
  "Array.from(document.querySelectorAll('.el-popover')).some(function(p){return p.offsetParent})"
)
check("team reported", "Shiny.shinyapp.$inputValues.team === 'core'")
check(
  "table filtered to core",
  "document.querySelectorAll('#tbl .el-table__body tr').length === 2 && /Ada/.test(document.querySelector('#tbl').innerText) && /Linus/.test(document.querySelector('#tbl').innerText)"
)
check(
  "pagination total follows",
  "document.querySelectorAll('#pg .el-pager li').length === 1"
)
act(
  "document.querySelectorAll('#tbl .el-table__body .el-checkbox')[1].click()",
  1.5
)
check(
  "selection reported",
  "JSON.stringify(Shiny.shinyapp.$inputValues['tbl_selection_rows:shiny.element.rows']) === '[2]'"
)
show("dump3", "document.getElementById('dump3').innerText.replace(/\\n/g, ' ')")
