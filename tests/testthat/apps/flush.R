# Fixture for test-browser-flush.R: updates go with the flush, as Shiny's
# update*Input() do -- after an output the same observer re-rendered, from
# a later() callback too -- and flush_vue() sends them before a long
# computation.
library(shiny)

ui <- fluidPage(
  actionButton("go", "Re-render and update"),
  actionButton("later", "Update from later()"),
  actionButton("slow", "Slow, with flush_vue()"),
  vue_output("rv"),
  vue_app(
    "box2",
    tags$p(id = "box2_text", "{{ n }} {{ status }}"),
    data = list(n = 0, status = "idle")
  )
)

server <- function(input, output, session) {
  k <- reactiveVal(0)
  # a new template each render: the component is rebuilt
  output$rv <- render_vue(vue_app(
    "box",
    tags$p(id = "box_text", paste("render", k()), "{{ n }}"),
    data = list(n = 0)
  ))
  observeEvent(input$go, {
    k(k() + 1)
    update_vue(session, "box", n = 5)
  })
  observeEvent(input$later, {
    later::later(function() update_vue(session, "box2", n = 7), 0.3)
  })
  observeEvent(input$slow, {
    flush_vue(update_vue(session, "box2", status = "working"))
    Sys.sleep(3)
    update_vue(session, "box2", status = "done")
  })
}

shinyApp(ui, server)
