## basic
types <- c("primary", "success", "info", "warning", "danger")
tagList(lapply(types, function(t) {
  el_tag(paste0("t_", t), paste("Tag", match(t, types)), type = t)
}))

## removable
types <- c("primary", "success", "info", "warning", "danger")
tagList(lapply(types, function(t) {
  el_tag(
    paste0("r_", t),
    paste("Tag", match(t, types)),
    type = t,
    closable = TRUE
  )
}))

## editable
#' Tags the user adds and removes: the list lives on the server and is drawn
#' with `renderUI()`.
#| shot_js = "var i = document.querySelector('#newtag_container input'); i.value = 'Tag 4'; i.dispatchEvent(new Event('input')); setTimeout(function(){ document.querySelector('#add_container button').click(); }, 400);", shot_wait = 2
ui <- el_page(
  uiOutput("tags"),
  el_input("newtag", placeholder = "New tag", width = "140px"),
  el_button("add", "+ New Tag", size = "small")
)

server <- function(input, output, session) {
  tags_now <- reactiveVal(character(0))
  counter <- 0
  # Each tag gets an id of its own, and one observer for its close button
  add_tag <- function(label) {
    counter <<- counter + 1
    id <- paste0("tag", counter)
    tags_now(c(isolate(tags_now()), stats::setNames(label, id)))
    observeEvent(
      input[[paste0(id, "_close")]],
      once = TRUE,
      tags_now(tags_now()[names(tags_now()) != id])
    )
  }
  for (t in c("Tag 1", "Tag 2", "Tag 3")) {
    add_tag(t)
  }
  output$tags <- renderUI(tagList(Map(
    function(id, label) el_tag(id, label, closable = TRUE),
    names(tags_now()),
    tags_now()
  )))
  observeEvent(input$add, {
    req(nzchar(input$newtag))
    add_tag(input$newtag)
    update_el_input(id = "newtag", value = "")
  })
}

shinyApp(ui, server)

## sizes
tagList(
  el_tag("s1", "Large", size = "large"),
  el_tag("s2", "Default"),
  el_tag("s3", "Small", size = "small"),
  tags$br(),
  tags$br(),
  el_tag("s4", "Large", size = "large", closable = TRUE),
  el_tag("s5", "Default", closable = TRUE),
  el_tag("s6", "Small", size = "small", closable = TRUE)
)

## theme
#' `effect` is `"dark"`, `"light"` (the default) or `"plain"`.
types <- c("primary", "success", "info", "warning", "danger")
tagList(lapply(c("dark", "light", "plain"), function(e) {
  tags$div(
    style = "margin-bottom: 10px",
    tags$span(style = "display: inline-block; width: 50px", e),
    lapply(types, function(t) el_tag(paste0(e, t), t, type = t, effect = e))
  )
}))

## rounded
types <- c("primary", "success", "info", "warning", "danger")
tagList(lapply(c("dark", "light", "plain"), function(e) {
  tags$div(
    style = "margin-bottom: 10px",
    lapply(types, function(t) {
      el_tag(paste0("rd", e, t), t, type = t, effect = e, round = TRUE)
    })
  )
}))

## checkable
#' A tag that toggles, like a checkbox, is `el_check_tag()`; it reports
#' `input$<id>` as `TRUE` or `FALSE`.
tagList(
  el_check_tag("ct1", "Checked", value = TRUE),
  el_check_tag("ct2", "Toggle me"),
  el_check_tag("ct3", "Disabled", disabled = TRUE),
  tags$br(),
  tags$br(),
  lapply(c("primary", "success", "info", "warning", "danger"), function(t) {
    el_check_tag(paste0("ctt", t), t, type = t, value = TRUE)
  })
)
