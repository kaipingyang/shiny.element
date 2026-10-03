## basic-usage
#' A dialog opens from the server, `update_el_dialog(visible = TRUE)`;
#' `input$<id>` is whether it is open. `before_close`, a `JS()` function,
#' may hold the close back.
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-dialog", shot_wait = 1.5
ui <- el_page(
  el_button("open", "Click to open the Dialog", plain = TRUE),
  el_dialog("tips", title = "Tips", width = "500px", content = tags$span("This is a message"),
    before_close = JS("function(done) { if (confirm('Are you sure to close this dialog?')) done(); }"),
    footer = tagList(el_button("cancel", "Cancel"), el_button("confirm", "Confirm", type = "primary"))))
server <- function(input, output, session) {
  observeEvent(input$open, update_el_dialog(id = "tips", visible = TRUE))
  observeEvent(c(input$cancel, input$confirm), update_el_dialog(id = "tips", visible = FALSE),
               ignoreInit = TRUE)
}
shinyApp(ui, server)

## customization-content
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-dialog", shot_wait = 1.5
ui <- el_page(
  el_button("open", "Open a Form nested Dialog", plain = TRUE),
  el_dialog("shipping", title = "Shipping address", width = "500px", content = tagList(
    el_input("name", label = "Promotion name", label_position = "left", label_width = "140px"),
    el_select("zone", choices = c("Zone No.1" = "shanghai", "Zone No.2" = "beijing"),
              placeholder = "Please select a zone", label = "Zones",
              label_position = "left", label_width = "140px")),
    footer = tagList(el_button("cancel", "Cancel"), el_button("confirm", "Confirm", type = "primary"))))
server <- function(input, output, session) {
  observeEvent(input$open, update_el_dialog(id = "shipping", visible = TRUE))
}
shinyApp(ui, server)

## customization-header
#' The title takes markup: a header of your own.
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-dialog", shot_wait = 1.5
ui <- el_page(
  el_button("open", "Open Dialog with customized header", plain = TRUE),
  el_dialog("custom", show_close = FALSE, width = "500px",
    title = tags$div(style = "display: flex; justify-content: space-between; align-items: center",
      tags$h4("This is a custom header!"),
      el_button("close", "Close", type = "danger", icon = "CircleCloseFilled")),
    content = "This is dialog content."))
server <- function(input, output, session) {
  observeEvent(input$open, update_el_dialog(id = "custom", visible = TRUE))
  observeEvent(input$close, update_el_dialog(id = "custom", visible = FALSE))
}
shinyApp(ui, server)

## nested-dialog
#| shot_js = "document.querySelector('#open_container button').click(); setTimeout(function(){ document.querySelector('#inner_open_container button').click(); }, 800);", shot_sel = ".el-dialog", shot_wait = 2
ui <- el_page(
  el_button("open", "Open the outer Dialog", plain = TRUE),
  el_dialog("outer", title = "Outer Dialog", width = "800px", content = tagList(
    tags$span("This is the outer Dialog"),
    el_dialog("inner", title = "Inner Dialog", width = "500px", append_to_body = TRUE,
              content = "This is the inner Dialog")),
    footer = el_button("inner_open", "Open the inner Dialog", type = "primary")))
server <- function(input, output, session) {
  observeEvent(input$open, update_el_dialog(id = "outer", visible = TRUE))
  observeEvent(input$inner_open, update_el_dialog(id = "inner", visible = TRUE))
}
shinyApp(ui, server)

## centered-content
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-dialog", shot_wait = 1.5
ui <- el_page(
  el_button("open", "Click to open the Dialog", plain = TRUE),
  el_dialog("warn", title = "Warning", width = "500px", center = TRUE,
    content = "It should be noted that the content will not be aligned in center by default",
    footer = tagList(el_button("cancel", "Cancel"), el_button("confirm", "Confirm", type = "primary"))))
server <- function(input, output, session) {
  observeEvent(input$open, update_el_dialog(id = "warn", visible = TRUE))
}
shinyApp(ui, server)

## align-center
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-dialog", shot_wait = 1.5
ui <- el_page(
  el_button("open", "Click to open the Dialog", plain = TRUE),
  el_dialog("warn", title = "Warning", width = "500px", align_center = TRUE,
    content = "Open the dialog from the center from the screen",
    footer = tagList(el_button("cancel", "Cancel"), el_button("confirm", "Confirm", type = "primary"))))
server <- function(input, output, session) {
  observeEvent(input$open, update_el_dialog(id = "warn", visible = TRUE))
}
shinyApp(ui, server)

## destroy-on-close
#' Its content made again each time it opens: inputs inside start fresh.
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-dialog", shot_wait = 1.5
ui <- el_page(
  el_button("open", "Click to open Dialog", plain = TRUE),
  el_dialog("notice", title = "Notice", width = "500px", destroy_on_close = TRUE, center = TRUE,
    content = tagList(tags$p("Notice: before dialog gets opened for the first time this node and the one below will not be rendered"),
                      el_input("note", placeholder = "starts empty each time"))))
server <- function(input, output, session) {
  observeEvent(input$open, update_el_dialog(id = "notice", visible = TRUE))
}
shinyApp(ui, server)

## draggable-dialog
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-dialog", shot_wait = 1.5
ui <- el_page(
  el_button("open", "Click to open Dialog", plain = TRUE),
  el_dialog("drag", title = "Tips", width = "500px", draggable = TRUE,
            content = "It's a draggable Dialog"))
server <- function(input, output, session) {
  observeEvent(input$open, update_el_dialog(id = "drag", visible = TRUE))
}
shinyApp(ui, server)

## fullscreen
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-dialog", shot_wait = 1.5
ui <- el_page(
  el_button("open", "Open the fullscreen Dialog", plain = TRUE),
  el_dialog("full", title = "Tips", fullscreen = TRUE, content = "It's a fullscreen Dialog"))
server <- function(input, output, session) {
  observeEvent(input$open, update_el_dialog(id = "full", visible = TRUE))
}
shinyApp(ui, server)

## modal
#' Without a backdrop the page beneath stays in view, and with
#' `modal_penetrable` it can be used too.
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-dialog", shot_wait = 1.5
ui <- el_page(
  el_button("open", "Open the modal-less Dialog", plain = TRUE),
  el_dialog("nomodal", title = "Tips", width = "500px", modal = FALSE, modal_penetrable = TRUE,
            content = "It's a modal-less Dialog"))
server <- function(input, output, session) {
  observeEvent(input$open, update_el_dialog(id = "nomodal", visible = TRUE))
}
shinyApp(ui, server)

## custom-animation
#' `transition` names a CSS animation of your own, as Element Plus's does.
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-dialog", shot_wait = 1.5
ui <- el_page(
  tags$style(".dialog-bounce-enter-active { animation: dialog-fade-in .5s; }"),
  el_button("open", "Open the Dialog", plain = TRUE),
  el_dialog("anim", title = "Custom animation", width = "500px", transition = "dialog-bounce",
            content = "This dialog plays an animation of its own."))
server <- function(input, output, session) {
  observeEvent(input$open, update_el_dialog(id = "anim", visible = TRUE))
}
shinyApp(ui, server)

## events
#' Every event is an input: `input$<id>_open`, `_opened`, `_close`,
#' `_closed`, `_open_auto_focus` and `_close_auto_focus`.
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-dialog", shot_wait = 1.5
ui <- el_page(
  el_button("open", "Open the Dialog", plain = TRUE),
  el_dialog("ev", title = "Events", width = "500px", content = verbatimTextOutput("log")))
server <- function(input, output, session) {
  seen <- reactiveVal(character())
  for (e in c("open", "opened", "close", "closed")) local({
    e <- e
    observeEvent(input[[paste0("ev_", e)]], seen(c(seen(), e)))
  })
  output$log <- renderText(paste(seen(), collapse = "\n"))
  observeEvent(input$open, update_el_dialog(id = "ev", visible = TRUE))
}
shinyApp(ui, server)
