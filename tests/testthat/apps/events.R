# Fixture for test-browser-events.R: what reaches the server -- a
# component's value and defaults, the events asked for with `events`, and
# handlers of the user's own with `on`, on their own, folded into another
# component and in a module.
library(shiny)

enter <- JS("function(report, e) { report('enter', e.target.value); }")

mod_ui <- function(id) {
  ns <- NS(id)
  el_button(
    ns("b"),
    "Double-click",
    on = list(dblclick = JS("function(report) { report('twice'); }"))
  )
}

ui <- el_page(
  el_input("plain", value = "x"),
  el_input("asked", events = c("keydown", "focus")),
  el_input("own", on = list("keyup.enter" = enter)),
  el_space(el_input("folded", on = list("keyup.enter" = enter))),
  mod_ui("m"),
  el_tag(id = "tg", label = "close me", closable = TRUE),
  el_button("open", "Open"),
  el_dialog("dlg", title = "Dialog", content = "body"),
  el_tabs(
    "tb",
    addable = TRUE,
    tabs = list(
      list(name = "a", label = "A", content = "a"),
      list(name = "b", label = "B", content = "b")
    )
  )
)

server <- function(input, output, session) {
  observeEvent(input$open, update_el_dialog(session, "dlg", visible = TRUE))
}

shinyApp(ui, server)
