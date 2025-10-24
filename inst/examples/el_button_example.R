# el_button 综合示例
library(shiny)
library(shiny.element)

ui <- el_page(
  # 基础按钮
  el_button("btn_default", "Default", type = "default"),
  el_button("btn_primary", "Primary", type = "primary"),
  el_button("btn_success", "Success", type = "success"),
  el_button("btn_warning", "Warning", type = "warning"),
  el_button("btn_danger", "Danger", type = "danger"),
  el_button("btn_info", "Info", type = "info"),
  el_button("btn_text", "Text", type = "text"),
  
  # 带 icon 的按钮
  el_button("btn_search", "Search", icon = el_icon("search"), type = "primary"),
  el_button("btn_star", "Star", icon = shiny::icon("star"), type = "success"),
  
  # 禁用和尺寸
  el_button("btn_disabled", "Disabled", type = "primary", disabled = TRUE),
  el_button("btn_mini", "Mini", type = "success", size = "mini"),
  
  # Shiny集成
  el_button("btn1", "Click Me", type = "primary", icon = el_icon("star")),
  actionButton("update", "Update Button"),
  verbatimTextOutput("btn_default_count"),
  verbatimTextOutput("btn_primary_count"),
  verbatimTextOutput("btn_success_count"),
  verbatimTextOutput("btn_warning_count"),
  verbatimTextOutput("btn_danger_count"),
  verbatimTextOutput("btn_info_count"),
  verbatimTextOutput("btn_text_count"),
  verbatimTextOutput("btn_search_count"),
  verbatimTextOutput("btn_star_count"),
  verbatimTextOutput("btn1_count")
)

server <- function(input, output, session) {
  output$btn_default_count <- renderPrint(input$btn_default)
  output$btn_primary_count <- renderPrint(input$btn_primary)
  output$btn_success_count <- renderPrint(input$btn_success)
  output$btn_warning_count <- renderPrint(input$btn_warning)
  output$btn_danger_count <- renderPrint(input$btn_danger)
  output$btn_info_count <- renderPrint(input$btn_info)
  output$btn_text_count <- renderPrint(input$btn_text)
  output$btn_search_count <- renderPrint(input$btn_search)
  output$btn_star_count <- renderPrint(input$btn_star)
  output$btn1_count <- renderPrint(input$btn1)
  
  observeEvent(input$btn_default, {
    showNotification(paste("Default Button clicked!", "Count:", input$btn_default))
  })
  observeEvent(input$btn_primary, {
    showNotification(paste("Primary Button clicked!", "Count:", input$btn_primary))
  })
  observeEvent(input$btn_success, {
    showNotification(paste("Success Button clicked!", "Count:", input$btn_success))
  })
  observeEvent(input$btn_warning, {
    showNotification(paste("Warning Button clicked!", "Count:", input$btn_warning))
  })
  observeEvent(input$btn_danger, {
    showNotification(paste("Danger Button clicked!", "Count:", input$btn_danger))
  })
  observeEvent(input$btn_info, {
    showNotification(paste("Info Button clicked!", "Count:", input$btn_info))
  })
  observeEvent(input$btn_text, {
    showNotification(paste("Text Button clicked!", "Count:", input$btn_text))
  })
  observeEvent(input$btn_search, {
    showNotification(paste("Search Button clicked!", "Count:", input$btn_search))
  })
  observeEvent(input$btn_star, {
    showNotification(paste("Star Button clicked!", "Count:", input$btn_star))
  })
  observeEvent(input$btn1, {
    showNotification(paste("Button clicked!", "Count:", input$btn1))
  })
  observeEvent(input$update, {
    update_el_button(session, "btn1", label = "Updated!", type = "success")
  })
}

if (interactive()) shinyApp(ui, server)
