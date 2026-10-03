## basic
el_time_select("slot", start = "08:30", step = "00:15", end = "18:30",
               placeholder = "Select time", width = "240px")

## time-formats
el_time_select("fmt", start = "00:00", step = "00:30", end = "23:59",
               placeholder = "Select time", format = "hh:mm A", width = "240px")

## time-range
#' The end's earliest time follows the start: the server redraws it.
ui <- el_page(
  el_time_select("start", start = "08:30", step = "00:15", end = "18:30",
                 placeholder = "Start time", width = "240px"),
  uiOutput("end_ui"))

server <- function(input, output, session) {
  output$end_ui <- renderUI(el_time_select("end", start = "08:30", step = "00:15", end = "18:30",
    min_time = if (isTruthy(input$start)) input$start, value = isolate(input$end),
    placeholder = "End time", width = "240px"))
}

shinyApp(ui, server)
