# Fixture for test-browser-bare-page.R: Element's components on Shiny's own
# page with no el_page() and no use_element() -- each carries Element Plus.
library(shiny)

ui <- fluidPage(
  el_button("btn", "Button", type = "primary"),
  el_input("txt", value = "text"),
  el_row(el_col(span = 12, "left"), el_col(span = 12, "right")),
  el_tabs(
    "tabs",
    tabs = list(el_tab_pane("A", "first"), el_tab_pane("B", "second"))
  ),
  el_table_output("tbl")
)

server <- function(input, output, session) {
  output$tbl <- render_el_table(el_table(data = head(iris, 2)))
}

shinyApp(ui, server)
