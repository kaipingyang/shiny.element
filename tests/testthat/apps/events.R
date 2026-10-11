# Fixture for test-browser-events.R: what reaches the server -- a
# component's value and defaults, the events asked for with `events`, and
# handlers of the user's own with `on`, on their own, folded into another
# component and in a module.
library(shiny)

enter <- JS("function(report, e) { report('enter', e.target.value); }")

paths <- df_to_cascader_options(
  data.frame(compound = c("c1", "c1", "c2"), study = c("s1", "s2", "s3")),
  c("compound", "study")
)

mod_ui <- function(id) {
  ns <- NS(id)
  tagList(
    el_button(
      ns("b"),
      "Double-click",
      on = list(dblclick = JS("function(report) { report('twice'); }"))
    ),
    el_cascader(
      ns("csa"),
      options = paths,
      value = c("c2", "s3"),
      level_inputs = ns(c("compound", "study"))
    )
  )
}

ui <- el_page(
  el_input("plain", value = "x"),
  el_input("asked", events = c("keydown", "focus")),
  el_input("own", on = list("keyup.enter" = enter)),
  el_space(el_input("folded", on = list("keyup.enter" = enter))),
  mod_ui("m"),
  # `on` on an event the component handles itself; each level of the path
  # as an input of its own
  el_cascader(
    "csa",
    options = paths,
    value = c("c1", "s1"),
    level_inputs = c("compound", "study"),
    on = list(change = JS("function(report, v) { report('changed', v); }"))
  ),
  el_button("set_csa", "Set path"),
  textOutput("compound_runs"),
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
  observeEvent(
    input$set_csa,
    update_el_cascader(session, "csa", value = c("c2", "s3"))
  )
  # how often an observer of the first level runs
  runs <- reactiveVal(0)
  observeEvent(input$compound, runs(isolate(runs()) + 1))
  output$compound_runs <- renderText(runs())
}

shinyApp(ui, server)
