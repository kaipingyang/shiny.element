## basic
#' Messages are sent from the server, `el_message(session, ...)`.
#| shot_js = "document.querySelector('#show_container button').click()", shot_sel = ".el-message", shot_wait = 1
ui <- el_page(el_button("show", "Show message", plain = TRUE))
server <- function(input, output, session) {
  observeEvent(input$show, el_message(session, "This is a message."))
}
shinyApp(ui, server)

## different-types
#| shot_js = "document.querySelectorAll('#shot button').forEach(function(b){ b.click(); })", shot_sel = ".el-message", shot_wait = 1
types <- c("primary", "success", "warning", "info", "error")
ui <- el_page(lapply(types, function(t) el_button(paste0("m_", t), tools::toTitleCase(t), plain = TRUE)))
server <- function(input, output, session) {
  for (t in types) local({
    t <- t
    observeEvent(input[[paste0("m_", t)]],
                 el_message(session, paste("Congrats, this is a", t, "message."), type = t))
  })
}
shinyApp(ui, server)

## plain
#| shot_js = "document.querySelector('#show_container button').click()", shot_sel = ".el-message", shot_wait = 1
ui <- el_page(el_button("show", "Success", plain = TRUE))
server <- function(input, output, session) {
  observeEvent(input$show, el_message(session, "Congrats, this is a success message.",
                                      type = "success", plain = TRUE))
}
shinyApp(ui, server)

## closable
#| shot_js = "document.querySelector('#show_container button').click()", shot_sel = ".el-message", shot_wait = 1
ui <- el_page(el_button("show", "Message", plain = TRUE))
server <- function(input, output, session) {
  observeEvent(input$show, el_message(session, "This is a message.", show_close = TRUE, duration = 0))
}
shinyApp(ui, server)

## raw-html
#| shot_js = "document.querySelector('#show_container button').click()", shot_sel = ".el-message", shot_wait = 1
ui <- el_page(el_button("show", "Use HTML String", plain = TRUE))
server <- function(input, output, session) {
  observeEvent(input$show, el_message(session, "<strong>This is <i>HTML</i> string</strong>",
                                      dangerously_use_html_string = TRUE))
}
shinyApp(ui, server)

## grouping
#| shot_js = "var b = document.querySelector('#show_container button'); b.click(); b.click(); b.click();", shot_sel = ".el-message", shot_wait = 1
ui <- el_page(el_button("show", "Show grouping message", plain = TRUE))
server <- function(input, output, session) {
  observeEvent(input$show, el_message(session, "This is a message", grouping = TRUE,
                                      type = "success"))
}
shinyApp(ui, server)

## placement
#| shot_js = "document.querySelector('#show_container button').click()", shot_sel = ".el-message", shot_wait = 1
ui <- el_page(el_button("show", "Bottom", plain = TRUE))
server <- function(input, output, session) {
  observeEvent(input$show, el_message(session, "This is a message at the bottom", placement = "bottom"))
}
shinyApp(ui, server)
