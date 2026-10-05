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
  vue_output("mixed_out"),
  vue_output("tabs_out"),
  vue_output("ident_out"),
  vue_output("ident_uuid_out"),
  actionButton("drop", "remove the table"),
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
  # several components and plain markup in one output; a formatter given
  # as JS() that changes with the data
  output$mixed_out <- render_vue(tagList(
    tags$h4(
      class = "count",
      paste(nrow(rows[rows$score >= min_score(), ]), "rows")
    ),
    el_select(
      "mix_sel",
      choices = c("x", "y"),
      value = "x",
      placeholder = paste("min", min_score())
    ),
    el_table(
      "mix_tbl",
      data = rows[rows$score >= min_score(), ],
      columns = list(
        list(prop = "name", label = "Name"),
        list(
          prop = "score",
          label = "Score",
          formatter = JS(sprintf(
            "function(r, c, v) { return v + ' / %d'; }",
            as.integer(min_score())
          ))
        )
      )
    )
  ))
  # a markup container: the tab the user opened stays open
  # the same shape under another id the author gave: another component
  output$ident_out <- render_vue(
    vue_app(
      input$ident %||% "old_id",
      tags$b(class = "ident", "{{ n }}"),
      data = list(n = 1),
      input = "n"
    )
  )
  # an id of the author's that looks generated is still the author's
  output$ident_uuid_out <- render_vue(
    el_alert(
      input$ident_uuid %||% "box_00000000-0000-4000-8000-000000000001",
      title = "uuid-looking id"
    )
  )
  output$tabs_out <- render_vue(el_tabs(
    "tb",
    selected = "one",
    tabs = list(
      list(name = "one", label = "One", content = tags$p("first")),
      list(
        name = "two",
        label = "Two",
        content = el_input("tab_in", placeholder = paste("min", min_score()))
      )
    )
  ))
  observeEvent(input$drop, removeUI("#table_out"))
  hint <- reactive(paste("hint", input$hint %||% 0))
  picker_server("mod", hint)
  output$vals <- renderText(paste(
    "selected =",
    paste(input$tbl_selected_rows, collapse = ",")
  ))
}

shinyApp(ui, server)
