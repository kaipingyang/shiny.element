## basic
#' Notifications are sent from the server, `el_notification(session, ...)`.
#| shot_js = "document.querySelector('#show_container button').click()", shot_sel = ".el-notification", shot_wait = 1
ui <- el_page(el_button("show", "Closes automatically", plain = TRUE))
server <- function(input, output, session) {
  observeEvent(
    input$show,
    el_notification(session, title = "Title", message = "This is a reminder")
  )
}
shinyApp(ui, server)

## different-types
#| shot_js = "document.querySelectorAll('#shot button').forEach(function(b){ b.click(); })", shot_sel = ".el-notification", shot_wait = 1
types <- c("primary", "success", "warning", "info", "error")
ui <- el_page(lapply(types, function(t) {
  el_button(paste0("n_", t), tools::toTitleCase(t), plain = TRUE)
}))
server <- function(input, output, session) {
  for (t in types) {
    local({
      t <- t
      observeEvent(
        input[[paste0("n_", t)]],
        el_notification(
          session,
          title = tools::toTitleCase(t),
          type = t,
          message = paste("This is a", t, "message")
        )
      )
    })
  }
}
shinyApp(ui, server)

## positioning
#| shot_js = "document.querySelectorAll('#shot button').forEach(function(b){ b.click(); })", shot_sel = ".el-notification", shot_wait = 1
pos <- c("top-right", "bottom-right", "bottom-left", "top-left")
ui <- el_page(lapply(pos, function(p) {
  el_button(paste0("n_", gsub("-", "_", p)), p, plain = TRUE)
}))
server <- function(input, output, session) {
  for (p in pos) {
    local({
      p <- p
      observeEvent(
        input[[paste0("n_", gsub("-", "_", p))]],
        el_notification(
          session,
          title = "Custom Position",
          position = p,
          message = paste("I'm at the", p, "corner")
        )
      )
    })
  }
}
shinyApp(ui, server)

## offsetting
#| shot_js = "document.querySelector('#show_container button').click()", shot_sel = ".el-notification", shot_wait = 1
ui <- el_page(el_button("show", "Notification with offset", plain = TRUE))
server <- function(input, output, session) {
  observeEvent(
    input$show,
    el_notification(
      session,
      title = "Success",
      offset = 100,
      message = "This is a success message"
    )
  )
}
shinyApp(ui, server)

## raw-html
#| shot_js = "document.querySelector('#show_container button').click()", shot_sel = ".el-notification", shot_wait = 1
ui <- el_page(el_button("show", "Use HTML String", plain = TRUE))
server <- function(input, output, session) {
  observeEvent(
    input$show,
    el_notification(
      session,
      title = "HTML String",
      dangerously_use_html_string = TRUE,
      message = "<strong>This is <i>HTML</i> string</strong>"
    )
  )
}
shinyApp(ui, server)

## use-vnode !skip
A VNode is a Vue render function's; from R, send the message as HTML with
`dangerously_use_html_string = TRUE`.

## progress-bar
#| shot_js = "document.querySelector('#show_container button').click()", shot_sel = ".el-notification", shot_wait = 1
ui <- el_page(el_button("show", "With progress bar", plain = TRUE))
server <- function(input, output, session) {
  observeEvent(
    input$show,
    el_notification(
      session,
      title = "Progress",
      progress = TRUE,
      duration = 5000,
      message = "Closes when the bar runs out"
    )
  )
}
shinyApp(ui, server)

## no-close
#| shot_js = "document.querySelector('#show_container button').click()", shot_sel = ".el-notification", shot_wait = 1
ui <- el_page(el_button("show", "Hide close button", plain = TRUE))
server <- function(input, output, session) {
  observeEvent(
    input$show,
    el_notification(
      session,
      title = "Info",
      type = "info",
      show_close = FALSE,
      message = "This is a message without close button"
    )
  )
}
shinyApp(ui, server)
