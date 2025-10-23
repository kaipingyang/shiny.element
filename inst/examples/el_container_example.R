library(shiny)
library(shiny.element)

ui <- fluidPage(
  tags$style(HTML("
    .el-header, .el-footer {
      background-color: #B3C0D1;
      color: #333;
      text-align: center;
      line-height: 60px;
    }
    .el-aside {
      background-color: #D3DCE6;
      color: #333;
      text-align: center;
      line-height: 200px;
    }
    .el-main {
      background-color: #E9EEF3;
      color: #333;
      text-align: center;
      line-height: 160px;
    }
    body > .el-container {
      margin-bottom: 40px;
    }
    .el-container:nth-child(5) .el-aside,
    .el-container:nth-child(6) .el-aside {
      line-height: 260px;
    }
    .el-container:nth-child(7) .el-aside {
      line-height: 320px;
    }
  ")),

  h3("Header + Main"),
  el_container(
    el_header("Header"),
    el_main("Main")
  ),

  h3("Header + Main + Footer"),
  el_container(
    el_header("Header"),
    el_main("Main"),
    el_footer("Footer")
  ),

  h3("Aside + Main"),
  el_container(
    el_aside("Aside", width = "200px"),
    el_main("Main")
  ),

  h3("Header + Aside + Main"),
  el_container(
    el_header("Header"),
    el_container(
      el_aside("Aside", width = "200px"),
      el_main("Main")
    )
  ),

  h3("Header + Aside + Main + Footer"),
  el_container(
    el_header("Header"),
    el_container(
      el_aside("Aside", width = "200px"),
      el_container(
        el_main("Main"),
        el_footer("Footer")
      )
    )
  ),

  h3("Aside + Header + Main"),
  el_container(
    el_aside("Aside", width = "200px"),
    el_container(
      el_header("Header"),
      el_main("Main")
    )
  ),

  h3("Aside + Header + Main + Footer"),
  el_container(
    id = "container7",
    el_aside("Aside", width = "200px"),
    el_container(
      id = "container7_inner",
      el_header("Header"),
      el_main("Main"),
      el_footer("Footer")
    )
  )
)

server <- function(input, output, session) {}

shinyApp(ui, server)
