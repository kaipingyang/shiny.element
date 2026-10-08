# Steps for inst/examples/combinations/server-answers: run by tools/combinations.R

cat("== remote search in a folded select\n")
act(
  "var i = document.querySelector('#city, #sp .el-select input'); i = i.tagName === 'INPUT' ? i : i.querySelector('input'); i.focus(); i.value = 'be'; i.dispatchEvent(new Event('input', {bubbles: true}));",
  2.5
)
show(
  "items",
  paste0(
    vis(".el-select-dropdown__item"),
    ".map(function(o){return o.innerText.trim()}).join(',')"
  )
)
check(
  "server answered the search",
  paste0(
    vis(".el-select-dropdown__item"),
    ".map(function(o){return o.innerText.trim()}).join(',') === 'Beijing,Berlin,Bern'"
  )
)
act(paste0(vis(".el-select-dropdown__item"), "[2].click()"), 1.5)
check("city picked", paste0(iv("city"), " === 'Bern'"))

cat("== lazy tree, folded: the answer reaches it\n")
check(
  "roots loaded",
  "/Region A/.test(document.querySelector('.el-tree').innerText)"
)
act(
  "Array.from(document.querySelectorAll('.el-tree-node__content')).find(function(n){ return /Region A/.test(n.innerText); }).click()",
  2
)
check(
  "children loaded",
  "/Region A child/.test(document.querySelector('.el-tree').innerText)"
)

cat("== lazy cascader, folded\n")
act(
  "document.querySelector('.el-cascader .el-input__wrapper, .el-cascader').click()",
  2
)
check("first column loaded", paste0(vis(".el-cascader-node"), ".length >= 2"))
act(paste0(vis(".el-cascader-node"), "[0].click()"), 2)
check("second column loaded", paste0(vis(".el-cascader-menu"), ".length === 2"))
act(
  paste0(
    vis(".el-cascader-menu"),
    "[1].querySelectorAll('.el-cascader-node')[1].click()"
  ),
  1.5
)
check(
  "path reported",
  paste0("JSON.stringify(", iv("casc"), ") === '[\"l0-1\",\"l1-2\"]'")
)

cat("== form fields added while its dialog is open\n")
act("document.getElementById('open_dlg').click()", 2)
act("document.getElementById('more').click()", 1.5)
act("document.getElementById('more').click()", 1.5)
check(
  "two domains drawn",
  "document.querySelectorAll('#dlg .el-form-item').length === 4"
)
act("document.querySelector('#dlg .el-button--primary').click()", 1.5)
check(
  "new fields validated",
  paste0(
    iv("dom_valid"),
    " === false && /Domain can not be null/.test(document.getElementById('dlg').innerText)"
  )
)
act(
  "document.querySelectorAll('#dlg .el-form-item input').forEach(function(i, k){ if (k > 0) { i.value = 'x' + k; i.dispatchEvent(new Event('input', {bubbles: true})); } })",
  0.5
)
act("document.querySelector('#dlg .el-button--primary').click()", 1.5)
check("valid after filling", paste0(iv("dom_valid"), " === true"))
check(
  "model has the domains",
  paste0(
    "(function(){ var m = ",
    iv("dom"),
    "; return !!m && m.domain1 === 'x1' && m.domain2 === 'x2'; })()"
  )
)
show("dump", "document.getElementById('dump').innerText.replace(/\\n/g, ' ')")
