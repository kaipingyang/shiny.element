# Fixture for test-browser-bookmark.R: a page bookmarked to its URL.
library(shiny)
library(shiny.element)

ui <- function(req) el_page(
  el_input("name", value = "Ada"),
  el_select("cities", choices = c("bj", "sh", "gz"), multiple = TRUE, selected = "bj"),
  el_switch("on", value = TRUE),
  el_tabs("tabs", tabs = list(list(name = "a", label = "A", content = "A"),
                              list(name = "b", label = "B", content = "B"))),
  el_pagination("pg", total = 100),
  bookmarkButton(),
  verbatimTextOutput("vals")
)

server <- function(input, output, session) {
  output$vals <- renderPrint({
    for (i in c("name", "cities", "on", "tabs", "pg")) {
      cat(i, "=", paste(input[[i]], collapse = ","), "\n")
    }
  })
  onBookmarked(function(url) {
    session$sendCustomMessage("bookmarked", url)
  })
}

shinyApp(ui, server, enableBookmarking = "url")
