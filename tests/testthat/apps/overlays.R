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
    events = c("opened", "closed"),
    content = tagList(
      el_select("pick", choices = c("alpha", "beta")),
      tags$button(id = "outer_btn", "in outer"),
      el_dialog(
        "inner",
        title = "Inner",
        append_to_body = TRUE,
        content = el_select("pick2", choices = c("one", "two"))
      )
    )
  ),
  el_drawer("drw", title = "Drawer", content = "drawer body"),
  # focus trap: two controls inside, one outside
  actionButton("outside_btn", "outside"),
  el_dialog(
    "trap",
    title = "Trap",
    content = tagList(
      tags$input(id = "trap_a"),
      tags$button(id = "trap_b", "b")
    )
  ),
  el_dialog(
    "race",
    title = "Race",
    content = "race",
    events = c("open", "opened", "close", "closed")
  ),
  el_tabs(
    "tabs2",
    addable = TRUE,
    closable = TRUE,
    tabs = list(
      list(name = "a", label = "A", content = "a"),
      list(name = "b", label = "B", content = "b", disabled = TRUE),
      list(name = "c", label = "C", content = "c")
    ),
    selected = "a"
  ),
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
    cat("tabs2 =", format(input$tabs2), "\n")
    cat("tabs2_add =", format(input$tabs2_tab_add), "\n")
  })
}

shinyApp(ui, server)
