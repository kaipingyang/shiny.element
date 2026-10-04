# Fixture for test-browser-bookmark.R: a page bookmarked to its URL.
library(shiny)
library(shiny.element)

ui <- function(req) {
  el_page(
    el_input("name", value = "Ada"),
    el_select(
      "cities",
      choices = c("bj", "sh", "gz"),
      multiple = TRUE,
      selected = "bj"
    ),
    el_switch("on", value = TRUE),
    el_tabs(
      "tabs",
      tabs = list(
        list(name = "a", label = "A", content = "A"),
        list(name = "b", label = "B", content = "B")
      )
    ),
    el_pagination("pg", total = 100),
    # a component drawn by the server, through render_vue()
    vue_output("rv_out"),
    # an input whose field setup() defines, not data
    vue_app(
      "su",
      htmltools::tags$span("{{ k }}"),
      setup = JS("function() { return { k: Vue.ref(1) }; }"),
      input = "k"
    ),
    bookmarkButton(),
    verbatimTextOutput("vals")
  )
}

server <- function(input, output, session) {
  output$rv_out <- render_vue(
    el_select("rv", choices = c("p", "q", "r"), value = "p")
  )
  output$vals <- renderPrint({
    for (i in c("name", "cities", "on", "tabs", "pg", "rv", "su")) {
      cat(i, "=", paste(input[[i]], collapse = ","), "\n")
    }
  })
  onBookmarked(function(url) {
    session$sendCustomMessage("bookmarked", url)
  })
}

shinyApp(ui, server, enableBookmarking = "url")
