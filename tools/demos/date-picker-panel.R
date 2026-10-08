## basic
el_date_picker_panel("dpp", value = Sys.Date())

## border
#' `border = FALSE`: the panel on its own, and inside a card.
tags$div(
  tags$div(style = "text-align: center", "No border:"),
  el_divider(),
  tags$div(
    style = "display: flex; flex-wrap: wrap; gap: 16px; justify-content: center",
    tags$div(
      style = "padding: 20px",
      el_date_picker_panel("dpp_border", border = FALSE)
    ),
    el_divider(direction = "vertical", style = "height: auto"),
    el_card(el_date_picker_panel("dpp_border_card", border = FALSE))
  )
)

## disabled
#' The switch disables the panel with `update_el_date_picker_panel(disabled
#' =)`.
#| shot_js = "document.querySelector('#dpp_switch .el-switch').click()"
#| shot_expect = c("!document.querySelector('#dpp_dis .el-picker-panel.is-disabled')", "document.querySelector('#dpp_dis .el-date-table td.available')")
ui <- el_page(
  tags$div(
    style = "display: flex; flex-direction: column; align-items: center",
    el_switch(
      "dpp_switch",
      value = TRUE,
      active_text = "Disabled",
      inactive_text = "Enabled"
    ),
    el_date_picker_panel("dpp_dis", disabled = TRUE)
  )
)
server <- function(input, output, session) {
  observeEvent(input$dpp_switch, {
    update_el_date_picker_panel(session, "dpp_dis", disabled = input$dpp_switch)
  })
}
shinyApp(ui, server)

## all-types
#' The select changes the panel's `type`, and clears its value as it does
#' (`value = NA`).
#| shot_js = c("document.querySelector('#dpp_all .el-date-table td.available').click()", "window.picked = Shiny.shinyapp.$inputValues.dpp_all", "document.querySelector('#dpp_type .el-select__wrapper').click()", "Array.from(document.querySelectorAll('.el-select-dropdown__item')).find(function(o){ return o.innerText.trim() === 'daterange'; }).click()")
#| shot_expect = c("window.picked", "document.querySelector('#dpp_all .el-date-range-picker')", "Shiny.shinyapp.$inputValues.dpp_all === null")
types <- c(
  "year",
  "years",
  "month",
  "months",
  "date",
  "dates",
  "week",
  "quarter",
  "quarters",
  "quarterrange",
  "datetime",
  "datetimerange",
  "daterange",
  "monthrange",
  "yearrange"
)
ui <- el_page(
  tags$div(
    style = "display: flex; gap: 16px",
    tags$div(
      style = "display: flex; flex-direction: column; flex-basis: 150px; gap: 4px",
      tags$span("Type:"),
      el_select("dpp_type", choices = types, selected = "date")
    )
  ),
  el_divider(),
  tags$div(
    style = "display: flex; justify-content: center",
    el_date_picker_panel("dpp_all", type = "date")
  )
)
server <- function(input, output, session) {
  observeEvent(input$dpp_type, ignoreInit = TRUE, {
    update_el_date_picker_panel(
      session,
      "dpp_all",
      type = input$dpp_type,
      value = NA
    )
  })
}
shinyApp(ui, server)
