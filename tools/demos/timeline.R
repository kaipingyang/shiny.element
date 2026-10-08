## basic
el_timeline(
  "tl",
  items = list(
    el_timeline_item("Event start", timestamp = "2018-04-15"),
    el_timeline_item("Approved", timestamp = "2018-04-13"),
    el_timeline_item("Success", timestamp = "2018-04-11")
  )
)

## mode
#' `mode` puts the content after the line (`"start"`), before it (`"end"`),
#' or on alternate sides; the radio buttons set it with
#' `update_el_timeline()`.
#| shot_js = "document.querySelectorAll('#tl_mode_pick .el-radio-button')[1].click()"
#| shot_expect = "document.querySelector('#tl_mode .el-timeline').classList.contains('is-alternate')"
ui <- el_page(
  el_radio_group(
    "tl_mode_pick",
    choices = c("start", "alternate", "alternate-reverse", "end"),
    selected = "start",
    button = TRUE
  ),
  tags$div(
    style = "margin-top: 16px",
    el_timeline(
      "tl_mode",
      mode = "start",
      items = list(
        el_timeline_item("Event start", timestamp = "2018-04-15"),
        el_timeline_item("Approved", timestamp = "2018-04-13"),
        el_timeline_item("Success", timestamp = "2018-04-11")
      )
    )
  )
)
server <- function(input, output, session) {
  observeEvent(input$tl_mode_pick, ignoreInit = TRUE, {
    update_el_timeline(session, "tl_mode", mode = input$tl_mode_pick)
  })
}
shinyApp(ui, server)

## custom-node
el_timeline(
  "nodes",
  items = list(
    el_timeline_item(
      "Custom icon",
      timestamp = "2018-04-12 20:46",
      size = "large",
      type = "primary",
      icon = "MoreFilled"
    ),
    el_timeline_item(
      "Custom color",
      timestamp = "2018-04-03 20:46",
      color = "#0bbd87"
    ),
    el_timeline_item(
      "Custom size",
      timestamp = "2018-04-03 20:46",
      size = "large"
    ),
    el_timeline_item(
      "Custom hollow",
      timestamp = "2018-04-03 20:46",
      type = "primary",
      hollow = TRUE
    ),
    el_timeline_item("Default node", timestamp = "2018-04-03 20:46")
  )
)

## custom-timestamp
el_timeline(
  "stamps",
  items = list(
    el_timeline_item(
      el_card(
        tags$h4("Update Github template"),
        tags$p("Tom committed 2018/4/12 20:46")
      ),
      timestamp = "2018/4/12",
      placement = "top"
    ),
    el_timeline_item(
      el_card(
        tags$h4("Update Github template"),
        tags$p("Tom committed 2018/4/3 20:46")
      ),
      timestamp = "2018/4/3",
      placement = "top"
    ),
    el_timeline_item(
      el_card(
        tags$h4("Update Github template"),
        tags$p("Tom committed 2018/4/2 20:46")
      ),
      timestamp = "2018/4/2",
      placement = "top"
    )
  )
)

## center
el_timeline(
  "centred",
  items = list(
    el_timeline_item(
      el_card(
        tags$h4("Update Github template"),
        tags$p("Tom committed 2018/4/12 20:46")
      ),
      timestamp = "2018/4/12",
      placement = "top",
      center = TRUE
    ),
    el_timeline_item(
      el_card(
        tags$h4("Update Github template"),
        tags$p("Tom committed 2018/4/3 20:46")
      ),
      timestamp = "2018/4/3",
      placement = "top"
    ),
    el_timeline_item(
      "Event start",
      timestamp = "2018/4/2",
      placement = "top",
      center = TRUE
    ),
    el_timeline_item("Event end", timestamp = "2018/4/2", placement = "top")
  )
)

## reverse
#' `reverse` shows the entries newest first; `update_el_timeline()` flips it.
ui <- el_page(
  el_radio_group(
    "order",
    choices = c(Ascending = "asc", Descending = "desc"),
    value = "asc"
  ),
  el_timeline(
    "tl",
    items = list(
      el_timeline_item("Event start", timestamp = "2018-04-15"),
      el_timeline_item("Approved", timestamp = "2018-04-13"),
      el_timeline_item("Success", timestamp = "2018-04-11")
    )
  )
)

server <- function(input, output, session) {
  observeEvent(
    input$order,
    update_el_timeline(id = "tl", reverse = input$order == "desc")
  )
}

shinyApp(ui, server)
