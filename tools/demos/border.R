## border
row <- function(name, width, style) tags$tr(tags$td(name), tags$td(width),
  tags$td(tags$div(style = sprintf("width: 200px; height: 0; border-top: %s %s var(--el-border-color)",
                                   width, style))))
tags$table(class = "demo-border", style = "border-spacing: 30px 10px",
  tags$tr(tags$td("Name"), tags$td("Thickness"), tags$td("Demo")),
  row("Solid", "1px", "solid"), row("Dashed", "2px", "dashed"))

## radius
box <- function(name, radius) el_col(span = 6,
  tags$div(name), tags$code(sprintf("border-radius: %s", radius)),
  tags$div(style = sprintf(paste("height: 40px; margin-top: 10px; border: 1px solid",
                                 "var(--el-border-color); border-radius: %s"), radius)))
el_row(gutter = 12,
  box("No Radius", "0px"), box("Small Radius", "var(--el-border-radius-small)"),
  box("Large Radius", "var(--el-border-radius-base)"),
  box("Round Radius", "var(--el-border-radius-round)"))

## shadow
shadow <- function(name, var) tags$div(style = "text-align: center; margin: 0 20px",
  tags$div(style = sprintf("width: 120px; height: 120px; box-shadow: var(%s)", var)),
  tags$p(name), tags$code(var))
tags$div(style = "display: flex; flex-wrap: wrap",
  shadow("Basic Shadow", "--el-box-shadow"), shadow("Light Shadow", "--el-box-shadow-light"),
  shadow("Lighter Shadow", "--el-box-shadow-lighter"), shadow("Dark Shadow", "--el-box-shadow-dark"))
