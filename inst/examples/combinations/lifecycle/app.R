# What a long-running app does to its components: 180 of them on one page;
# a block of a card, a select, a date picker and a tooltip inserted with
# insertUI() and removed with removeUI() again and again; an output redrawn
# again and again -- each leaving no dropdown or tooltip behind in <body>;
# and the connection lost and found again.
#
#   shiny::runApp(system.file("examples/combinations/lifecycle", package = "shiny.element"))
#
# tools/combinations.R drives it in a browser and checks each step
# (tools/combinations/lifecycle.R).

library(shiny)
library(shiny.element)

block <- function(i) {
  el_card(
    header = paste("Block", i),
    el_space(
      el_select(
        paste0("s", i),
        choices = c("a", "b"),
        selected = "a",
        width = "100px"
      ),
      el_date_picker(paste0("d", i)),
      el_tooltip(
        paste0("tt", i),
        el_button(paste0("b", i), "Hover"),
        content = "tip"
      )
    )
  )
}

ui <- el_page(
  el_space(
    el_button("add", "Insert a block"),
    el_button("remove", "Remove it"),
    el_button("redraw", "Redraw the output")
  ),
  tags$div(id = "slot"),
  uiOutput("out"),
  h4("Many at once"),
  tags$div(
    id = "many",
    lapply(1:120, function(i) {
      el_switch(paste0("many_sw", i), value = i %% 2 == 0)
    }),
    lapply(1:60, function(i) {
      el_select(
        paste0("many_sel", i),
        choices = c("x", "y"),
        selected = "y",
        width = "80px"
      )
    })
  ),
  verbatimTextOutput("dump")
)

server <- function(input, output, session) {
  # reconnect after the connection drops, even when run locally (Shiny
  # reconnects only on a server configured for it otherwise)
  session$allowReconnect("force")
  n <- 0
  observeEvent(input$add, {
    n <<- n + 1
    insertUI("#slot", ui = tags$div(id = paste0("blk", n), block(n)))
  })
  observeEvent(input$remove, removeUI(paste0("#blk", n)))
  k <- reactiveVal(0)
  observeEvent(input$redraw, k(k() + 1))
  output$out <- renderUI(block(paste0("r", k())))
  output$dump <- renderText(paste(
    "sw1",
    input$many_sw1,
    "sw2",
    input$many_sw2,
    "sel60",
    input$many_sel60
  ))
}

shinyApp(ui, server)
