library(shiny)
library(shiny.element)
library(vueR)

ui <- fluidPage(
  vueR::html_dependency_vue(),
  element_ui_dependency(),
  table_handler_dependency(),
  titlePanel("Element UI Table Example"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("rows", "显示行数:", min = 5, max = 32, value = 10),
      selectInput("dataset", "选择数据集:", choices = c("mtcars", "iris", "airquality")),
      actionButton("refresh", "刷新数据"),
      width = 3
    ),
    mainPanel(
      h3("动态表格"),
      uiOutput("dynamic_table_ui"),
      h4("调试信息:"),
      verbatimTextOutput("debug_info"),
      width = 9
    )
  )
)

server <- function(input, output, session) {
  table_config <- eventReactive(input$refresh, {
    df <- switch(input$dataset,
      "mtcars" = mtcars,
      "iris" = iris,
      "airquality" = airquality
    )
    el_table_config(df, max_rows = input$rows)
  }, ignoreNULL = FALSE)

  output$dynamic_table_ui <- renderUI({
    config <- table_config()
    el_table(
      id = "dynamic_table",
      data = config$data,
      columns = config$columns,
      selection = TRUE,
      border = TRUE
    )
  })

  output$debug_info <- renderPrint({
    config <- table_config()
    cat("数据集:", input$dataset, "\n")
    cat("数据行数:", length(config$data), "\n")
  })
}

shinyApp(ui, server)
