# Fixture for test-browser-vue-render.R: render_vue() keeps a component
# across renders of the same shape, and replaces it otherwise.
library(shiny)

rows <- data.frame(
  name = c("Ada", "Alan", "Grace", "Linus"),
  score = c(90, 75, 88, 60)
)

picker_ui <- function(id) {
  ns <- NS(id)
  tagList(vue_output(ns("out")), verbatimTextOutput(ns("seen")))
}
picker_server <- function(id, hint) {
  moduleServer(id, function(input, output, session) {
    output$out <- render_vue(
      el_select(
        session$ns("pick"),
        choices = c("a", "b", "c"),
        value = "a",
        placeholder = hint()
      )
    )
    output$seen <- renderText(paste("pick =", input$pick))
  })
}

ui <- el_page(
  dev = TRUE,
  vue_output("table_out"),
  vue_output("alert_out"),
  vue_output("shape_out"),
  picker_ui("mod"),
  verbatimTextOutput("vals")
)

server <- function(input, output, session) {
  # the test drives these with Shiny.setInputValue()
  min_score <- reactive(input$min_score %||% 0)
  output$table_out <- render_vue(
    el_table(
      "tbl",
      data = rows[rows$score >= min_score(), ],
      selection = TRUE,
      columns = list(
        list(prop = "name", label = "Name", sortable = TRUE),
        list(prop = "score", label = "Score", sortable = TRUE)
      )
    )
  )
  # no id: a fresh random one each render
  output$alert_out <- render_vue(
    el_alert(title = paste("at least", min_score()), type = "info")
  )
  output$shape_out <- render_vue(
    if (isTRUE(input$as_input)) {
      el_input("shape_in")
    } else {
      el_select("shape_sel", choices = "x")
    }
  )
  hint <- reactive(paste("hint", input$hint %||% 0))
  picker_server("mod", hint)
  output$vals <- renderText(paste(
    "selected =",
    paste(input$tbl_selected_rows, collapse = ",")
  ))
}

shinyApp(ui, server)
