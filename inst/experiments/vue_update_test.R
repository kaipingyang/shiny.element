library(shiny)
library(shiny.element)

# ---- JS handlers for Vue data updates ----
js_handlers <- "
Shiny.addCustomMessageHandler('update_vue_component', function(message) {
  var widget = HTMLWidgets.find('#' + message.id);
  if (widget && widget.instance) {
    Object.keys(message).forEach(function(key) {
      if (key !== 'id' && widget.instance.hasOwnProperty(key)) {
        widget.instance[key] = message[key];
      }
    });
  }
});
Shiny.addCustomMessageHandler('update_vue_data', function(message) {
  var widget = HTMLWidgets.find('#' + message.id);
  if (widget && widget.instance && message.data) {
    Object.assign(widget.instance.$data, message.data);
  }
});
"

# ---- UI ----
ui <- el_page(
  tags$head(tags$script(HTML(js_handlers))),
  titlePanel("Element UI Calendar Prototype Test"),
  sidebarLayout(
    sidebarPanel(
      h4("Control Panel"),
      actionButton("set_today", "Set to Today"),
      actionButton("set_tomorrow", "Set to Tomorrow"),
      actionButton("set_custom", "Set to Custom Date"),
      hr(),
      h4("Current Selected Date:"),
      verbatimTextOutput("selected_date")
    ),
    mainPanel(
      h3("Calendar Component"),
      el_calendar(
        id = "my_calendar",
        value = Sys.Date(),
        first_day_of_week = 1
      )
    )
  )
)

# ---- R-side update functions ----
update_vue_component <- function(session, id, ...) {
  message <- list(id = id, ...)
  session$sendCustomMessage("update_vue_component", message)
}

update_vue_data <- function(session, id, data) {
  session$sendCustomMessage("update_vue_data", list(id = id, data = data))
}

# ---- Server ----
server <- function(input, output, session) {
  output$selected_date <- renderPrint({
    if (is.null(input$my_calendar)) {
      "No date selected"
    } else {
      cat("Selected date:", input$my_calendar)
    }
  })

  observeEvent(input$set_today, {
    update_vue_component(session, "my_calendar", value = format(Sys.Date(), "%Y-%m-%d"))
  })

  observeEvent(input$set_tomorrow, {
    update_vue_component(session, "my_calendar", value = format(Sys.Date() + 1, "%Y-%m-%d"))
  })

  observeEvent(input$set_custom, {
    # Example: set to a fixed custom date
    update_vue_data(session, "my_calendar", list(
      value = "2025-12-31",
      first_day_of_week = 3
    ))
  })
}

shinyApp(ui, server)