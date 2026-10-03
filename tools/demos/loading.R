## basic
#' A table's own `loading` draws Element Plus's mask over it, as `v-loading`
#' does; `update_el_table(loading =)` turns it on and off.
el_table(
  "ld_tbl",
  loading = TRUE,
  data = data.frame(
    Date = c("2016-05-02", "2016-05-04", "2016-05-01"),
    Name = c("John Smith", "John Smith", "John Smith"),
    Address = rep("No.1518,  Jinshajiang Road, Putuo District", 3)
  )
)

## customization
#' `el_loading()` covers an element of your choice, with your text, spinner
#' and background.
#| shot_js = "document.querySelector('#go_container button').click()", shot_wait = 1
ui <- el_page(
  el_button("go", "Cover the table"),
  tags$div(
    id = "covered",
    el_table("ld_tbl2", data = data.frame(Date = "2016-05-02", Name = "John"))
  )
)
server <- function(input, output, session) {
  observeEvent(
    input$go,
    el_loading(
      session,
      "covering",
      target = "#covered",
      text = "Loading...",
      background = "rgba(122, 122, 122, 0.8)"
    )
  )
}
shinyApp(ui, server)

## fullscreen
#| shot_js = "document.querySelector('#full_container button').click()", shot_wait = 1
ui <- el_page(el_button("full", "As a service", type = "primary"))
server <- function(input, output, session) {
  observeEvent(input$full, {
    el_loading(
      session,
      "page",
      text = "Loading",
      fullscreen = TRUE,
      lock = TRUE
    )
    later::later(function() el_loading_close(session, "page"), 2)
  })
}
shinyApp(ui, server)
