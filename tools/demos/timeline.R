## basic
el_timeline("tl", items = list(
  list(content = "Event start", timestamp = "2018-04-15"),
  list(content = "Approved", timestamp = "2018-04-13"),
  list(content = "Success", timestamp = "2018-04-11")))

## mode
#' `mode` puts the content after the line (`"start"`), before it (`"end"`),
#' or on alternate sides.
tagList(lapply(c("start", "alternate", "alternate-reverse", "end"), function(m)
  tags$div(style = "margin-bottom: 20px", tags$b(m),
    el_timeline(paste0("tl_", gsub("-", "_", m)), mode = m, items = list(
      list(content = "Event start", timestamp = "2018-04-15"),
      list(content = "Approved", timestamp = "2018-04-13"),
      list(content = "Success", timestamp = "2018-04-11"))))))

## custom-node
el_timeline("nodes", items = list(
  list(content = "Custom icon", timestamp = "2018-04-12 20:46", size = "large",
       type = "primary", icon = "MoreFilled"),
  list(content = "Custom color", timestamp = "2018-04-03 20:46", color = "#0bbd87"),
  list(content = "Custom size", timestamp = "2018-04-03 20:46", size = "large"),
  list(content = "Custom hollow", timestamp = "2018-04-03 20:46", type = "primary", hollow = TRUE),
  list(content = "Default node", timestamp = "2018-04-03 20:46")))

## custom-timestamp
el_timeline("stamps", items = list(
  list(timestamp = "2018/4/12", placement = "top",
       content = el_card(tags$h4("Update Github template"), tags$p("Tom committed 2018/4/12 20:46"))),
  list(timestamp = "2018/4/3", placement = "top",
       content = el_card(tags$h4("Update Github template"), tags$p("Tom committed 2018/4/3 20:46"))),
  list(timestamp = "2018/4/2", placement = "top",
       content = el_card(tags$h4("Update Github template"), tags$p("Tom committed 2018/4/2 20:46")))))

## center
el_timeline("centred", items = list(
  list(timestamp = "2018/4/12", placement = "top", center = TRUE,
       content = el_card(tags$h4("Update Github template"), tags$p("Tom committed 2018/4/12 20:46"))),
  list(timestamp = "2018/4/3", placement = "top",
       content = el_card(tags$h4("Update Github template"), tags$p("Tom committed 2018/4/3 20:46"))),
  list(timestamp = "2018/4/2", placement = "top", center = TRUE, content = "Event start"),
  list(timestamp = "2018/4/2", placement = "top", content = "Event end")))

## reverse
#' `reverse` shows the entries newest first; `update_el_timeline()` flips it.
ui <- el_page(
  el_radio_group("order", choices = c(Ascending = "asc", Descending = "desc"), value = "asc"),
  el_timeline("tl", items = list(
    list(content = "Event start", timestamp = "2018-04-15"),
    list(content = "Approved", timestamp = "2018-04-13"),
    list(content = "Success", timestamp = "2018-04-11"))))

server <- function(input, output, session) {
  observeEvent(input$order, update_el_timeline(id = "tl", reverse = input$order == "desc"))
}

shinyApp(ui, server)
