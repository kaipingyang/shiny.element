# Fixture for test-browser-overlay-props.R: one dialog or drawer per
# behaviour -- scroll lock, the backdrop, Escape, delays, destroy on close,
# a penetrable modal, before_close, a resizable drawer.
library(shiny)
ui <- el_page(
  tags$div(
    style = "height: 2000px",
    actionButton("under", "under"),
    textOutput("n_under")
  ),
  el_dialog("d_lock", "x", title = "lock"),
  el_dialog("d_nolock", "x", title = "nolock", lock_scroll = FALSE),
  el_dialog("d_nomask", "x", title = "nomask", close_on_click_modal = FALSE),
  el_dialog("d_noesc", "x", title = "noesc", close_on_press_escape = FALSE),
  el_dialog(
    "d_delay",
    "x",
    title = "delay",
    open_delay = 800,
    close_delay = 800
  ),
  el_dialog(
    "d_destroy",
    el_input("inner", value = "a"),
    title = "destroy",
    destroy_on_close = TRUE
  ),
  el_dialog(
    "d_pen",
    "x",
    title = "pen",
    modal = FALSE,
    modal_penetrable = TRUE,
    top = "40vh"
  ),
  el_dialog(
    "d_before",
    "x",
    title = "before",
    before_close = JS(
      "function(done) { window.__asked = (window.__asked || 0) + 1; if (window.__allow) done(); }"
    )
  ),
  el_drawer(
    "w_resize",
    "x",
    title = "resize",
    resizable = TRUE,
    size = "300px"
  ),
  el_drawer("w_nomask", "x", title = "nomask", close_on_click_modal = FALSE),
  el_drawer("w_noesc", "x", title = "noesc", close_on_press_escape = FALSE),
  el_drawer("w_nolock", "x", title = "nolock", lock_scroll = FALSE)
)
server <- function(input, output, session) {
  n <- reactiveVal(0)
  observeEvent(input$under, n(n() + 1))
  output$n_under <- renderText(n())
  # opened and closed from the server, as an app does
  observeEvent(input$show, {
    id <- input$show$id
    if (startsWith(id, "w_")) {
      update_el_drawer(session, id, visible = input$show$visible)
    } else {
      update_el_dialog(session, id, visible = input$show$visible)
    }
  })
}
shinyApp(ui, server)
