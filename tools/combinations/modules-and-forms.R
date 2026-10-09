# Steps for inst/examples/combinations/modules-and-forms: run by tools/combinations.R

cat("== nested modules, wrapped\n")
check("inner number reports under o-in-n", paste0(iv("o-in-n"), " === 1"))
act("document.getElementById('o-in-go').click()", 1.5)
check("inner update through the inner session", paste0(iv("o-in-n"), " === 5"))
act("document.getElementById('o-hello').click()", 1.5)
check(
  "outer button updated with the inner value",
  "/n is 5/.test(document.getElementById('o-hello').innerText)"
)
act(
  "document.querySelector('[id=\"o-in-tag\"] .el-tag__close, #o-in-tag .el-tag__close, .el-tag .el-tag__close').click()",
  1.5
)
check("inner tag closed reports", paste0(iv("o-in-tag_close"), " === 1"))

cat("== a form in a closed collapse, inside a watermark\n")
check(
  "reported field reports on load though hidden",
  paste0(iv("frm_size"), " === 'default'")
)
act("document.querySelector('#coll .el-collapse-item__header').click()", 1.5)
check(
  "segmented drawn with its selection",
  "(function(){ var s = document.querySelector('#frm .el-segmented__item-selected'); return !!s && s.getBoundingClientRect().width > 20; })()"
)
act(
  "Array.from(document.querySelectorAll('#frm .el-segmented__item')).find(function(i){ return i.innerText.trim() === 'large'; }).click()",
  2
)
check("segmented reports at once", paste0(iv("frm_size"), " === 'large'"))
show(
  "form classes",
  "(document.querySelector('#frm.el-form, #frm .el-form, .el-collapse .el-form') || {}).className"
)
check(
  "form resized by the server",
  "!!document.querySelector('.el-collapse .el-form--large')"
)
act(
  "var i = document.querySelector('#frm .el-input-tag input'); i.focus(); i.value = 'red'; i.dispatchEvent(new Event('input', {bubbles: true})); i.dispatchEvent(new KeyboardEvent('keydown', {key: 'Enter', code: 'Enter', bubbles: true}));",
  1
)
act("document.querySelector('#frm .el-button--primary').click()", 1.5)
check("form invalid without a name", paste0(iv("frm_valid"), " === false"))
act(
  "var i = document.querySelector('#frm .el-form-item:nth-child(2) input'); i.value = 'Ada'; i.dispatchEvent(new Event('input', {bubbles: true}));",
  0.5
)
act("document.querySelector('#frm .el-button--primary').click()", 1.5)
check("form valid", paste0(iv("frm_valid"), " === true"))
check(
  "model carries the tag and the size",
  paste0(
    "(function(){ var m = ",
    iv("frm"),
    "; return m && m.name === 'Ada' && JSON.stringify(m.tags) === '[\"red\"]' && m.size === 'large'; })()"
  )
)
check(
  "watermark still drawn over the form",
  "(function(){ var w = document.querySelector('#coll [style*=\"background-image\"]'); return !!w; })()"
)

cat("== an editable table in a dialog\n")
act("document.getElementById('open_edit').click()", 2)
check(
  "table drawn in the dialog",
  "document.querySelectorAll('#etbl .el-table__body tr').length === 2"
)
act(
  "document.querySelectorAll('#etbl .el-table__body tr')[1].querySelectorAll('td')[1].querySelector('.el-table-edit-cell__value').dispatchEvent(new MouseEvent('dblclick', {bubbles: true}))",
  1
)
act(
  "var i = document.querySelectorAll('#etbl .el-table__body tr')[1].querySelectorAll('td')[1].querySelector('input'); i.value = '7'; i.dispatchEvent(new Event('input', {bubbles: true})); i.dispatchEvent(new Event('change', {bubbles: true})); i.dispatchEvent(new KeyboardEvent('keyup', {key: 'Enter', code: 'Enter', bubbles: true}));",
  2
)
check(
  "edit reaches the server as a number",
  "document.getElementById('edit_type').innerText === 'The edit is numeric' && /edit: 2, qty, 7, 2/.test(document.getElementById('dump').innerText)"
)
show("edit", paste0("JSON.stringify(", iv("etbl_cell_edit"), ")"))
act("document.querySelector('#edit_dlg .el-dialog__headerbtn').click()", 1)

cat("== calendar output: event popup\n")
act("document.querySelector('#cal .el-calendar-event').click()", 1.5)
check(
  "event opens its editor, filled",
  "Array.from(document.querySelectorAll('.el-calendar-dialog input')).some(function(i){ return i.value === 'Review'; })"
)
show(
  "visible popups",
  "Array.from(document.querySelectorAll('.el-popper, .el-popover, .el-dialog')).filter(function(p){return p.offsetParent}).map(function(p){return p.className.split(' ').slice(0,2).join('.')}).join(' ')"
)

cat("== a transfer in a drawer\n")
act("document.getElementById('open_drw').click()", 2)
act(
  "document.querySelectorAll('#tr .el-transfer-panel')[0].querySelectorAll('.el-checkbox')[2].click()",
  0.5
)
act(
  "document.querySelectorAll('#tr .el-transfer__buttons .el-button')[1].click()",
  1.5
)
check(
  "transfer moved item 2",
  paste0("JSON.stringify(", iv("tr"), ") === '[2]'")
)
act(
  "var i = document.querySelectorAll('#tr .el-transfer-panel__filter input')[0]; i.value = '5'; i.dispatchEvent(new Event('input', {bubbles: true}));",
  1
)
check(
  "transfer filter in a drawer",
  "document.querySelectorAll('#tr .el-transfer-panel')[0].querySelectorAll('.el-transfer-panel__item').length === 1"
)
show("dump", "document.getElementById('dump').innerText.replace(/\\n/g, ' ')")
