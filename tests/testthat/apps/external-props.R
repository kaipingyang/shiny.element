# Fixture for test-browser-external-props.R: Element's props that need
# something outside Element to work -- Day.js's format tokens (plugins
# inside Element's build), Dates R sends as text, functions Element hands a
# Date -- each set from R. tools/external-props.csv lists them.
library(shiny)

ui <- el_page(
  loading = FALSE,
  # Date from text ($elDate): the panel opens on its month
  el_date_picker("dv", default_value = "2010-10-01"),
  # the time a picked date gets ($elDate)
  el_date_picker(
    "dt",
    type = "datetime",
    default_time = "12:34:56",
    value_format = "YYYY-MM-DD HH:mm:ss"
  ),
  # Day.js's tokens, advancedFormat (Do), weekOfYear (w), quarterOfYear (Q)
  el_date_picker(
    "fmt",
    value = "2026-10-27",
    format = "Do MMMM YYYY, [W]w, [Q]Q"
  ),
  # functions Element calls with a Date
  el_date_picker(
    "dd",
    value = "2026-10-15",
    disabled_date = JS("function(d) { return d.getDate() === 13; }"),
    cell_class_name = JS(
      "function(d) { return d.getDate() === 14 ? 'is-fourteen' : ''; }"
    ),
    shortcuts = list(
      list(
        text = "Y2K",
        value = JS("function() { return new Date(2000, 0, 1); }")
      )
    )
  ),
  verbatimTextOutput("seen")
)

server <- function(input, output, session) {
  output$seen <- renderText(paste0("dt=", input$dt, " dd=", input$dd))
}

shinyApp(ui, server)
