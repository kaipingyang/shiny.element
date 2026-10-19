# Fixture for test-browser-loading.R: a page under its loading mask, and
# an el_page() drawn later by renderUI(), whose mask is never shown.
library(shiny)
ui <- el_page(
  lapply(1:40, function(i) el_select(paste0("s", i), choices = c("a", "b"))),
  el_button("go", "Go"),
  textOutput("n"),
  uiOutput("inner")
)
server <- function(input, output, session) {
  output$n <- renderText(input$go)
  output$inner <- renderUI(el_page(el_input("late", value = "x")))
}
shinyApp(ui, server)
