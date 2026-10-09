# Fixture for test-browser-task.R: task buttons, as bslib's
# input_task_button() -- loading from the click, in the browser, until the
# observer is done; bound to an ExtendedTask, until the task is; folded
# into a tooltip, too.
library(shiny)

ui <- el_page(
  el_button("sync", "Sync", task = TRUE),
  el_button("async", "Async", task = TRUE, type = "primary"),
  el_tooltip(
    "tip",
    el_button("folded", "Folded", task = TRUE),
    content = "in a tooltip"
  ),
  verbatimTextOutput("log")
)

server <- function(input, output, session) {
  log <- reactiveVal(character())
  observeEvent(input$sync, {
    Sys.sleep(2)
    log(c(log(), paste("sync", input$sync)))
  })
  task <- ExtendedTask$new(function() {
    promises::promise(function(resolve, reject) {
      later::later(function() resolve("done"), 2)
    })
  })
  bslib::bind_task_button(task, "async")
  observeEvent(input$async, task$invoke())
  observeEvent(task$result(), log(c(log(), paste("async", task$result()))))
  observeEvent(input$folded, {
    Sys.sleep(1)
    log(c(log(), paste("folded", input$folded)))
  })
  output$log <- renderText(paste(log(), collapse = ","))
}

shinyApp(ui, server)
