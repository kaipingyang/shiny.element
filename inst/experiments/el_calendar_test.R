library(shiny)
library(htmltools)
library(vueR)
library(shiny.element)
library(bslib)

ui <- page_fluid(
  use_element(),
  tags$div(
    id = "cal_container",
    el$calendar(`v-model` = "value")
  ),
  vueR::vue(
    elementId = "cal_vue",
    list(
      el = "#cal_container",
      data = list(
        value = htmlwidgets::JS("new Date()")
      ),
      watch = list(
        value = htmlwidgets::JS(
          "function(val) { Shiny.setInputValue('calendar_date', val); }"
        )
      )
    )
  ),
  verbatimTextOutput("selected_date")
)

server <- function(input, output, session) {
  output$selected_date <- renderPrint({
    input$calendar_date
  })
}

shinyApp(ui, server)