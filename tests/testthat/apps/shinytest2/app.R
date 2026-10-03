# Fixture for test-shinytest2.R: a page shinytest2's AppDriver drives.
pkgload::load_all(
  Sys.getenv("SHINY_ELEMENT_PKG"),
  quiet = TRUE,
  helpers = FALSE,
  attach_testthat = FALSE
)
library(shiny)

ui <- el_page(
  el_select("city", choices = c("Beijing", "Shanghai")),
  el_input("name"),
  el_switch("on"),
  el_button("go", "Go"),
  uiOutput("later"),
  textOutput("echo")
)

server <- function(input, output, session) {
  output$echo <- renderText(paste(input$city, input$name, input$on, input$late))
  observeEvent(input$go, {
    update_el_input(id = "name", value = "from server")
    output$later <- renderUI(el_input("late", value = "rendered"))
  })
}

shinyApp(ui, server)
