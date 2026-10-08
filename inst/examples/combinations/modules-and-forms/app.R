# Modules inside modules, wrapped; a form in a closed collapse, inside a
# watermark, one of its fields reporting as it changes; an editable table in
# a dialog; a calendar's events; a transfer in a drawer.
#
#   shiny::runApp(system.file("examples/combinations/modules-and-forms", package = "shiny.element"))
#
# tools/combinations.R drives it in a browser and checks each step
# (tools/combinations/modules-and-forms.R).

library(shiny)
library(shiny.element)

# what the server holds, one input per line
inputs_text <- function(x) {
  paste(
    sprintf(
      "%s: %s",
      names(x),
      vapply(
        x,
        function(v) {
          if (is.null(v)) "NULL" else paste(format(unclass(v)), collapse = ", ")
        },
        character(1)
      )
    ),
    collapse = "\n"
  )
}

inner_ui <- function(id) {
  ns <- NS(id)
  el_space(
    el_button(ns("go"), "Inner go"),
    el_input_number(ns("n"), value = 1),
    el_tag(id = ns("tag"), label = "inner tag", closable = TRUE)
  )
}
inner_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    observeEvent(input$go, update_el_input_number(session, "n", value = 5))
    reactive(input$n)
  })
}
outer_ui <- function(id) {
  ns <- NS(id)
  el_card(
    header = "outer",
    el_tooltip(ns("tip"), el_button(ns("hello"), "Outer"), content = "hi"),
    inner_ui(ns("in"))
  )
}
outer_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    n <- inner_server("in")
    observeEvent(
      input$hello,
      update_el_button(session, "hello", label = paste("n is", n()))
    )
  })
}

ui <- el_page(
  outer_ui("o"),
  el_collapse(
    "coll",
    value = character(),
    items = list(list(
      name = "f",
      title = "A form in a closed panel",
      content = el_watermark(
        content = "DRAFT",
        el_form(
          id = "frm",
          el_form_field(
            "size",
            "segmented",
            label = "Size",
            choices = c("small", "default", "large"),
            value = "default",
            report = TRUE
          ),
          el_form_field(
            "name",
            "input",
            label = "Name",
            rules = el_rule(required = TRUE, message = "Name, please")
          ),
          el_form_field("tags", "input-tag", label = "Tags")
        )
      )
    ))
  ),
  el_button("open_edit", "Edit table"),
  el_dialog(
    "edit_dlg",
    title = "Edit",
    content = el_table_output("etbl")
  ),
  el_calendar_output("cal"),
  el_button("open_drw", "Transfer"),
  el_drawer(
    "drw",
    title = "Pick",
    content = el_transfer(
      "tr",
      data = data.frame(key = 1:5, label = paste("Item", 1:5)),
      filterable = TRUE
    )
  ),
  # an edit arrives in its column's type
  textOutput("edit_type"),
  verbatimTextOutput("dump")
)

server <- function(input, output, session) {
  outer_server("o")
  observeEvent(
    input$frm_size,
    update_el_form(session, "frm", size = input$frm_size),
    ignoreInit = TRUE
  )
  observeEvent(
    input$open_edit,
    update_el_dialog(session, "edit_dlg", visible = TRUE)
  )
  output$etbl <- render_el_table(el_table(
    data = data.frame(item = c("a", "b"), qty = c(1, 2)),
    columns = list(
      el_table_column("item", "Item"),
      el_table_column("qty", "Qty", editable = TRUE)
    )
  ))
  output$cal <- render_el_calendar(el_calendar(
    value = as.Date("2026-10-15"),
    events = data.frame(id = 1, date = as.Date("2026-10-15"), title = "Review"),
    editable = TRUE
  ))
  observeEvent(input$open_drw, update_el_drawer(session, "drw", visible = TRUE))
  output$edit_type <- renderText({
    req(input$etbl_cell_edit)
    paste("The edit is", class(input$etbl_cell_edit$value))
  })
  output$dump <- renderText(inputs_text(list(
    n = input[["o-in-n"]],
    tag_close = input[["o-in-tag_close"]],
    frm_size = input$frm_size,
    frm = input$frm,
    valid = input$frm_valid,
    edit = input$etbl_cell_edit,
    tr = input$tr,
    cal_add = input$cal_add,
    cal_update = input$cal_update
  )))
}

shinyApp(ui, server)
