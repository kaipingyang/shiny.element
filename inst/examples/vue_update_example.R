
# use el_calendar component ----------------------------------

library(shiny)
library(shiny.element)

ui <- el_page(
  titlePanel("Element UI Calendar 单选测试"),
  sidebarLayout(
    sidebarPanel(
      h4("控制面板"),
      actionButton("set_today", "设置为今天"),
      actionButton("set_tomorrow", "设置为明天"),
      actionButton("set_custom", "设置为自定义日期"),
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
    update_vue_component(session, "my_calendar", value = format(Sys.Date(), "%Y-%m-%d"))
  })

  observeEvent(input$set_tomorrow, {
    update_vue_component(session, "my_calendar", value = format(Sys.Date() + 1, "%Y-%m-%d"))
  })

  observeEvent(input$set_custom, {
    update_vue_data(session, "my_calendar", list(
      value = "2025-12-31",
      first_day_of_week = 3
    ))
  })
}

shinyApp(ui, server)


# use el$calendar ----------------------------------------------------

library(shiny)
library(shiny.element)
library(vueR)

ui <- el_page(
  titlePanel("Element UI Calendar 单选测试"),
  sidebarLayout(
    sidebarPanel(
      h4("控制面板"),
      actionButton("set_today", "设置为今天"),
      actionButton("set_tomorrow", "设置为明天"),
      actionButton("set_custom", "设置为自定义日期"),
      hr(),
      h4("当前选中日期:"),
      verbatimTextOutput("selected_date")
    ),
    mainPanel(
      h3("日历组件"),
      tags$div(
        id = "calendar_container",
        el$calendar(
          `v-model` = "value",
          `:first-day-of-week` = "firstDayOfWeek",
          template(
            tags$p(
              `:class` = "data.isSelected ? 'is-selected' : ''",
              "{{ data.day.split('-').slice(1).join('-') }}",
              tags$span("✔️", `v-if` = "data.isSelected")
            ),
            slot = "dateCell",
            scope = "{date, data}"
          )
        )
      ),
      vueR::vue(
        elementId = "calendar_vue",
        list(
          el = "#calendar_container",
          data = list(
            value = format(Sys.Date(), "%Y-%m-%d"),
            firstDayOfWeek = 1
          ),
          watch = list(
            value = htmlwidgets::JS(
              "function(val) { Shiny.setInputValue('my_calendar', val); }"
            )
          )
        )
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
    session$sendCustomMessage("update_vue_component", list(
      id = "calendar_vue",
      value = format(Sys.Date(), "%Y-%m-%d")
    ))
  })

  observeEvent(input$set_tomorrow, {
    session$sendCustomMessage("update_vue_component", list(
      id = "calendar_vue",
      value = format(Sys.Date() + 1, "%Y-%m-%d")
    ))
  })

  observeEvent(input$set_custom, {
    session$sendCustomMessage("update_vue_data", list(
      id = "calendar_vue",
      data = list(
        value = "2025-12-31",
        firstDayOfWeek = 3
      )
    ))
  })
}

shinyApp(ui, server)