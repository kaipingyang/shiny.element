# Steps for inst/examples/combinations/awkward-values: run by tools/combinations.R

cat("== ids with dots and hyphens\n")
check("dotted input reports", paste0(iv("in.dot"), " === 'dotted'"))
check("hyphenated switch reports", paste0(iv("sw-dash"), " === true"))
check("dotted tabs report", paste0(iv("tabs.dot"), " === 'a'"))
check("module + dotted id reports", paste0(iv("m.1-pick.one"), " === 'a'"))
act("document.getElementById('m.1-go').click()")
check(
  "module update reaches the dotted id",
  paste0(iv("m.1-pick.one"), " === 'b'")
)
act("document.getElementById('add_tab').click()", 2)
check(
  "a tab inserted into dotted tabs",
  "document.querySelectorAll('[id=\"tabs.dot\"] .el-tabs__item').length === 2"
)

cat("== markup-like and non-ASCII text\n")
check(
  "button label shown as text",
  "document.getElementById('lbl').innerText.indexOf('<script>alert(1)</script>') >= 0"
)
check(
  "no script element made from a label",
  "!Array.from(document.querySelectorAll('script')).some(function(s){ return /alert\\(1\\)/.test(s.textContent) && !s.type; })"
)
check(
  "tag label not evaluated as a template",
  "document.getElementById('tag1').innerText.indexOf('{{ 7 * 6 }}') >= 0"
)
check(
  "the chosen labels are shown, not only reported",
  "['weird', 'nums', 'm.1-pick.one'].every(function(id){ var p = document.getElementById(id).closest('.el-select').querySelector('.el-select__placeholder'); return p.getBoundingClientRect().width > 0; })"
)
# folded into a space, the select's id is on its <input>, as Element puts it
act(
  "document.getElementById('weird').closest('.el-select').querySelector('.el-select__wrapper').click()",
  1
)
check(
  "option labels shown as text",
  paste0(
    vis(".el-select-dropdown__item"),
    ".map(function(o){ return o.innerText.trim(); }).join('|') === '<b>x</b>|naïve café|{{ 1 + 1 }}'"
  )
)
act("document.body.click()", 0.5)
check(
  "non-ASCII option label in the module",
  "/β & γ/.test(document.body.innerText)"
)

cat("== awkward values\n")
check("numeric choice reports a number", paste0(iv("nums"), " === 10"))
check(
  "empty checkbox group reports nothing",
  paste0(
    "(function(){ var v = ",
    iv("empty_cg"),
    "; return v === null || (Array.isArray(v) && v.length === 0); })()"
  )
)
check(
  "empty date reports nothing",
  paste0(
    "(function(){ var v = ",
    iv("date_na"),
    "; return v === null || v === '' || v === undefined; })()"
  )
)
check("negative fraction", paste0(iv("num_neg"), " === -0.5"))
check(
  "range slider reports two",
  paste0("JSON.stringify(", iv("sl_range"), ") === '[10,40]'")
)
act("document.getElementById('set_values').click()", 2)
check(
  "quoted value round-trips",
  paste0(iv("in.dot"), " === 'a \"quoted\" <tag> & é'")
)
check("numeric choice updated", paste0(iv("nums"), " === 2"))
check(
  "range updated",
  paste0("JSON.stringify(", iv("sl_range"), ") === '[0,100]'")
)
check("one of 3000 options selected", paste0(iv("many"), " === 'Option 2999'"))
