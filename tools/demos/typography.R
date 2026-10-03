## font
#' Element Plus's font stack, as the page draws it.
tags$div(style = "display: grid; gap: 12px",
  lapply(c("Helvetica Neue", "Helvetica", "PingFang SC", "Hiragino Sans GB", "Microsoft YaHei", "Arial"),
         function(f) tags$div(style = sprintf("font-family: '%s'; font-size: 18px", f), f)))

## convention
row <- function(level, size, var) tags$tr(tags$td(level), tags$td(size),
  tags$td(style = sprintf("font-size: var(%s)", var), "Build with Element"))
tags$table(style = "border-spacing: 20px 10px",
  tags$tr(tags$th("Level"), tags$th("Font Size"), tags$th("Demo")),
  row("Supplementary text", "12px Extra Small", "--el-font-size-extra-small"),
  row("Body (small)", "13px Small", "--el-font-size-small"),
  row("Body", "14px Base", "--el-font-size-base"),
  row("Small Title", "16px Medium", "--el-font-size-medium"),
  row("Title", "18px Large", "--el-font-size-large"),
  row("Main Title", "20px Extra Large", "--el-font-size-extra-large"))

## line-height
lines <- c("line-height: 1" = "1", "line-height: 1.3" = "1.3", "line-height: 1.5" = "1.5",
           "line-height: 1.7" = "1.7")
tags$div(style = "display: flex; gap: 24px",
  Map(function(lab, lh) tags$div(style = sprintf("line-height: %s; width: 160px", lh),
    tags$b(lab), tags$p("Build with Element Plus, a component library for developers.")),
    names(lines), lines))
