# Fixture for test-browser-overlays.R: Element's popup manager stacking a
# custom z_index, nested dialogs with a select inside, a drawer giving focus
# back, and the keyboard on tabs and collapse.
library(shiny)

many_tabs <- lapply(1:14, function(i) {
  list(
    name = paste0("t", i),
    label = paste("Tab number", i),
    content = paste("Pane", i),
    closable = i == 2
  )
})

ui <- el_page(
  z_index = 3000,
  actionButton("open_outer", "outer"),
  actionButton("open_drawer", "drawer"),
  el_dialog(
    "outer",
    title = "Outer",
    content = tagList(
      el_select("pick", choices = c("alpha", "beta")),
      el_dialog(
        "inner",
        title = "Inner",
        append_to_body = TRUE,
        content = el_select("pick2", choices = c("one", "two"))
      )
    )
  ),
  el_drawer("drw", title = "Drawer", content = "drawer body"),
  tags$div(
    style = "width: 420px",
    el_tabs("tabs", tabs = many_tabs, selected = "t1")
  ),
  el_collapse(
    "col",
    items = list(
      list(name = "a", title = "First", content = "first body"),
      list(name = "b", title = "Second", content = "second body")
    )
  ),
  verbatimTextOutput("vals")
)

server <- function(input, output, session) {
  observeEvent(input$open_outer, {
    update_el_dialog(session, "outer", visible = TRUE)
    later::later(
      function() update_el_dialog(session, "inner", visible = TRUE),
      0.8
    )
  })
  observeEvent(
    input$open_drawer,
    update_el_drawer(session, "drw", visible = TRUE)
  )
  opened <- reactiveVal(0)
  observeEvent(input$outer_opened, opened(opened() + 1))
  output$vals <- renderPrint({
    cat("tabs =", format(input$tabs), "\n")
    cat("col =", paste(input$col, collapse = ","), "\n")
    cat("drw =", format(input$drw), "\n")
    cat("outer_opened =", opened(), "\n")
  })
}

shinyApp(ui, server)
