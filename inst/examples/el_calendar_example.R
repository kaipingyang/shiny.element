library(shiny)
library(shiny.element)

ui <- el_page(
  titlePanel("Element UI Calendar 单选测试"),
  sidebarLayout(
    sidebarPanel(
      h4("控制面板"),
      actionButton("set_today", "设置为今天"),
      actionButton("set_tomorrow", "设置为明天"),
      hr(),
      h4("当前选中日期:"),
      verbatimTextOutput("selected_date")
    ),
    mainPanel(
      h3("日历组件"),
      el_calendar(
        id = "my_calendar",
        value = Sys.Date(),
        first_day_of_week = 1
      )
    )
  )
)

server <- function(input, output, session) {
  output$selected_date <- renderPrint({
    if (is.null(input$my_calendar)) {
      "未选择日期"
    } else {
      cat("选中日期:", input$my_calendar)
    }
  })

  observeEvent(input$set_today, {
    update_el_calendar(
      session = session,
      id = "my_calendar",
      value = Sys.Date()
    )
  })

  observeEvent(input$set_tomorrow, {
    update_el_calendar(
      session = session,
      id = "my_calendar",
      value = Sys.Date() + 1
    )
  })
}

shinyApp(ui, server)