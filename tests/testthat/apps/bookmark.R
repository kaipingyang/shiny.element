# Fixture for test-browser-bookmark.R: a page bookmarked to its URL.
library(shiny)
library(shiny.element)

mod_ui <- function(id) {
  ns <- NS(id)
  el_space(el_select(ns("pick"), choices = c("u", "v"), selected = "u"))
}

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
    # folded into a space, a module's space and an input's slot
    el_space(
      el_select("sp_sel", choices = c("x", "y", "z"), selected = "x"),
      el_input_number("sp_num", value = 1)
    ),
    mod_ui("m"),
    el_input(
      "q",
      slots = list(
        prepend = el_select("kind", choices = c("n", "i"), selected = "n")
      )
    ),
    bookmarkButton(),
    verbatimTextOutput("vals")
  )
}

server <- function(input, output, session) {
  output$rv_out <- render_vue(
    el_select("rv", choices = c("p", "q", "r"), value = "p")
  )
  # the trigger is not bookmarked, or restoring would set the values again
  # and prove nothing
  setBookmarkExclude("set_folded")
  observeEvent(input$set_folded, {
    update_el_select(session, "sp_sel", selected = "z")
    update_el_input_number(session, "sp_num", value = 5)
    update_el_select(session, "m-pick", selected = "v")
    update_el_select(session, "kind", selected = "i")
  })
  output$vals <- renderPrint({
    folded <- c("sp_sel", "sp_num", "m-pick", "kind")
    for (i in c("name", "cities", "on", "tabs", "pg", "rv", "su", folded)) {
      cat(i, "=", paste(input[[i]], collapse = ","), "\n")
    }
  })
  onBookmarked(function(url) {
    session$sendCustomMessage("bookmarked", url)
  })
}

shinyApp(ui, server, enableBookmarking = "url")
