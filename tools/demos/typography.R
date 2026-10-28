## font
#' Element Plus's font stack, as the page draws it.
tags$div(
  style = "display: grid; gap: 12px",
  lapply(
    c(
      "Helvetica Neue",
      "Helvetica",
      "PingFang SC",
      "Hiragino Sans GB",
      "Microsoft YaHei",
      "Arial"
    ),
    function(f) {
      tags$div(style = sprintf("font-family: '%s'; font-size: 18px", f), f)
    }
  )
)

## convention
#' Each size is read from the theme's variable as the page has it, with
#' VueUse's `useCssVar()`, as upstream's table does: a theme that changes
#' one shows its own.
vue_app(
  "typo_sizes",
  tags$table(
    style = "border-spacing: 20px 10px",
    tags$tbody(
      tags$tr(tags$th("Level"), tags$th("Font Size"), tags$th("Demo")),
      tags$tr(
        `v-for` = "(s, i) in sizes",
        `:key` = "i",
        `:style` = "'font-size: var(--el-font-size-' + s.type + ')'",
        tags$td("{{ s.level }}"),
        tags$td("{{ s.size + ' ' + s.name }}"),
        tags$td("Build with Element")
      )
    )
  ),
  setup = JS(
    "function() {",
    "  var levels = [['Supplementary text', 'extra-small'], ['Body (small)', 'small'],",
    "    ['Body', 'base'], ['Small Title', 'medium'], ['Title', 'large'],",
    "    ['Main Title', 'extra-large']];",
    "  var sizes = levels.map(function(l) {",
    "    return {",
    "      level: l[0], type: l[1],",
    "      name: l[1].split('-').map(function(w) {",
    "        return w.charAt(0).toUpperCase() + w.slice(1); }).join(' '),",
    "      size: VueUse.useCssVar('--el-font-size-' + l[1])",
    "    };",
    "  });",
    "  return { sizes: Vue.reactive(sizes) };",
    "}"
  ),
  dependencies = vueuse_dependency()
)

## line-height
lines <- c(
  "line-height: 1" = "1",
  "line-height: 1.3" = "1.3",
  "line-height: 1.5" = "1.5",
  "line-height: 1.7" = "1.7"
)
tags$div(
  style = "display: flex; gap: 24px",
  Map(
    function(lab, lh) {
      tags$div(
        style = sprintf("line-height: %s; width: 160px", lh),
        tags$b(lab),
        tags$p("Build with Element Plus, a component library for developers.")
      )
    },
    names(lines),
    lines
  )
)
