## basic
#' In the browser, a click shows a message with Element's own service,
#' `$message()`, in an `on` handler -- no round trip. From the server it is
#' `el_message(session, ...)`, with the same options in snake_case: see
#' In Shiny below.
#| shot_js = "document.querySelector('#show_container button').click()", shot_sel = ".el-message", shot_wait = 1
el_button(
  "show",
  "Show message",
  plain = TRUE,
  on = list(click = "$message('This is a message.')")
)

## different-types
#| shot_js = "document.querySelectorAll('#shot button').forEach(function(b){ b.click(); })", shot_sel = ".el-message", shot_wait = 1
types <- c("primary", "success", "warning", "info", "error")
tagList(lapply(types, function(t) {
  el_button(
    paste0("m_", t),
    tools::toTitleCase(t),
    plain = TRUE,
    on = list(
      click = sprintf(
        "$message({ message: 'Congrats, this is a %s message.', type: '%s' })",
        t,
        t
      )
    )
  )
}))

## plain
#| shot_js = "document.querySelector('#show_container button').click()", shot_sel = ".el-message", shot_wait = 1
el_button(
  "show",
  "Success",
  plain = TRUE,
  on = list(
    click = "$message({ message: 'Congrats, this is a success message.', type: 'success', plain: true })"
  )
)

## closable
#| shot_js = "document.querySelector('#show_container button').click()", shot_sel = ".el-message", shot_wait = 1
el_button(
  "show",
  "Message",
  plain = TRUE,
  on = list(
    click = "$message({ message: 'This is a message.', showClose: true, duration: 0 })"
  )
)

## raw-html
#| shot_js = "document.querySelector('#show_container button').click()", shot_sel = ".el-message", shot_wait = 1
el_button(
  "show",
  "Use HTML String",
  plain = TRUE,
  on = list(
    click = "$message({ message: '<strong>This is <i>HTML</i> string</strong>', dangerouslyUseHTMLString: true })"
  )
)

## grouping
#| shot_js = "var b = document.querySelector('#show_container button'); b.click(); b.click(); b.click();", shot_sel = ".el-message", shot_wait = 1
el_button(
  "show",
  "Show grouping message",
  plain = TRUE,
  on = list(
    click = "$message({ message: 'This is a message', grouping: true, type: 'success' })"
  )
)

## placement
#| shot_js = "document.querySelector('#show_container button').click()", shot_sel = ".el-message", shot_wait = 1
el_button(
  "show",
  "Bottom",
  plain = TRUE,
  on = list(
    click = "$message({ message: 'This is a message at the bottom', placement: 'bottom' })"
  )
)

## in-shiny
#' From the server, `el_message(session, ...)` shows a message after the
#' server's work -- a save done, a check failed -- with Element's options in
#' snake_case. Given an `id`, `input$<id>_close` reports it closed and
#' `el_message_close()` closes it.
#| shot_js = "document.querySelector('#save_container button').click()", shot_sel = ".el-message", shot_wait = 1.5
ui <- el_page(el_button("save", "Save", type = "primary"))
server <- function(input, output, session) {
  observeEvent(input$save, {
    # ... the server's work ...
    el_message(session, "Saved.", type = "success", show_close = TRUE)
  })
}
shinyApp(ui, server)
