library(shiny)
library(shiny.element)

ui <- fluidPage(
  element_ui_dependency(),
  tags$style(HTML("
    .el-row { margin-bottom: 20px; }
    .el-col { border-radius: 4px; }
    .bg-purple-dark { background: #99a9bf; }
    .bg-purple { background: #d3dce6; }
    .bg-purple-light { background: #e5e9f2; }
    .grid-content { border-radius: 4px; min-height: 36px; }
    .row-bg { padding: 10px 0; background-color: #f9fafc; }
  ")),

  h3("基础布局"),
  el_row(
    el_col(span = 24, div(class = "grid-content bg-purple-dark"))
  ),
  el_row(
    el_col(span = 12, div(class = "grid-content bg-purple")),
    el_col(span = 12, div(class = "grid-content bg-purple-light"))
  ),
  el_row(
    el_col(span = 8, div(class = "grid-content bg-purple")),
    el_col(span = 8, div(class = "grid-content bg-purple-light")),
    el_col(span = 8, div(class = "grid-content bg-purple"))
  ),
  el_row(
    el_col(span = 6, div(class = "grid-content bg-purple")),
    el_col(span = 6, div(class = "grid-content bg-purple-light")),
    el_col(span = 6, div(class = "grid-content bg-purple")),
    el_col(span = 6, div(class = "grid-content bg-purple-light"))
  ),
  el_row(
    el_col(span = 4, div(class = "grid-content bg-purple")),
    el_col(span = 4, div(class = "grid-content bg-purple-light")),
    el_col(span = 4, div(class = "grid-content bg-purple")),
    el_col(span = 4, div(class = "grid-content bg-purple-light")),
    el_col(span = 4, div(class = "grid-content bg-purple")),
    el_col(span = 4, div(class = "grid-content bg-purple-light"))
  ),

  h3("分栏间隔"),
  el_row(
    el_col(span = 6, div(class = "grid-content bg-purple")),
    el_col(span = 6, div(class = "grid-content bg-purple")),
    el_col(span = 6, div(class = "grid-content bg-purple")),
    el_col(span = 6, div(class = "grid-content bg-purple")),
    gutter = 20
  ),

  h3("混合布局"),
  el_row(
    el_col(span = 16, div(class = "grid-content bg-purple")),
    el_col(span = 8, div(class = "grid-content bg-purple")),
    gutter = 20
  ),
  el_row(
    el_col(span = 8, div(class = "grid-content bg-purple")),
    el_col(span = 8, div(class = "grid-content bg-purple")),
    el_col(span = 4, div(class = "grid-content bg-purple")),
    el_col(span = 4, div(class = "grid-content bg-purple")),
    gutter = 20
  ),
  el_row(
    el_col(span = 4, div(class = "grid-content bg-purple")),
    el_col(span = 16, div(class = "grid-content bg-purple")),
    el_col(span = 4, div(class = "grid-content bg-purple")),
    gutter = 20
  ),

  h3("分栏偏移"),
  el_row(
    el_col(span = 6, div(class = "grid-content bg-purple")),
    el_col(span = 6, offset = 6, div(class = "grid-content bg-purple")),
    gutter = 20
  ),
  el_row(
    el_col(span = 6, offset = 6, div(class = "grid-content bg-purple")),
    el_col(span = 6, offset = 6, div(class = "grid-content bg-purple")),
    gutter = 20
  ),
  el_row(
    el_col(span = 12, offset = 6, div(class = "grid-content bg-purple")),
    gutter = 20
  ),

  h3("对齐方式"),
  el_row(
    el_col(span = 6, div(class = "grid-content bg-purple")),
    el_col(span = 6, div(class = "grid-content bg-purple-light")),
    el_col(span = 6, div(class = "grid-content bg-purple")),
    type = "flex", class = "row-bg"
  ),
  el_row(
    el_col(span = 6, div(class = "grid-content bg-purple")),
    el_col(span = 6, div(class = "grid-content bg-purple-light")),
    el_col(span = 6, div(class = "grid-content bg-purple")),
    type = "flex", class = "row-bg", justify = "center"
  ),
  el_row(
    el_col(span = 6, div(class = "grid-content bg-purple")),
    el_col(span = 6, div(class = "grid-content bg-purple-light")),
    el_col(span = 6, div(class = "grid-content bg-purple")),
    type = "flex", class = "row-bg", justify = "end"
  ),
  el_row(
    el_col(span = 6, div(class = "grid-content bg-purple")),
    el_col(span = 6, div(class = "grid-content bg-purple-light")),
    el_col(span = 6, div(class = "grid-content bg-purple")),
    type = "flex", class = "row-bg", justify = "space-between"
  ),
  el_row(
    el_col(span = 6, div(class = "grid-content bg-purple")),
    el_col(span = 6, div(class = "grid-content bg-purple-light")),
    el_col(span = 6, div(class = "grid-content bg-purple")),
    type = "flex", class = "row-bg", justify = "space-around"
  ),

  h3("响应式布局"),
  el_row(
    el_col(xs = 8, sm = 6, md = 4, lg = 3, xl = 1, div(class = "grid-content bg-purple")),
    el_col(xs = 4, sm = 6, md = 8, lg = 9, xl = 11, div(class = "grid-content bg-purple-light")),
    el_col(xs = 4, sm = 6, md = 8, lg = 9, xl = 11, div(class = "grid-content bg-purple")),
    el_col(xs = 8, sm = 6, md = 4, lg = 3, xl = 1, div(class = "grid-content bg-purple-light")),
    gutter = 10
  )
)

server <- function(input, output, session) {}

shinyApp(ui, server)
