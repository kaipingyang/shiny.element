## basic
el_calendar("cal", value = Sys.Date())

## controller-type
#| shot_js = "document.querySelectorAll('#controller_container .el-radio-button')[1].click()"
#| shot_wait = 2
#' The radio buttons set `controller_type` from the server, with
#' `update_el_calendar()`.
ui <- el_page(
  el_radio_group(
    "controller",
    choices = c("select", "button"),
    value = "select",
    button = TRUE
  ),
  el_calendar("cal_ctl", value = Sys.Date(), controller_type = "select")
)

server <- function(input, output, session) {
  observeEvent(input$controller, {
    update_el_calendar(session, "cal_ctl", controller_type = input$controller)
  })
}

shinyApp(ui, server)

## customize
tagList(
  tags$style(".is-selected { color: #1989fa; }"),
  el_calendar(
    "cal_cell",
    slots = list(
      `date-cell` = template(
        htmltools::HTML(paste0(
          "<p :class=\"data.isSelected ? 'is-selected' : ''\">",
          "{{ data.day.split('-').slice(1).join('-') }} ",
          "{{ data.isSelected ? '\u2714\ufe0f' : '' }}</p>"
        )),
        slot = "date-cell",
        scope = "{ data }"
      )
    )
  )
)

## range
el_calendar("cal_range", range = c("2019-03-04", "2019-03-24"))

## header
#' The header's buttons move the calendar with Element Plus's `selectDate()`,
#' called on the calendar's ref, `$refs.calendar`, as upstream names it.
el_calendar(
  "cal_head",
  slots = list(
    header = template(
      htmltools::HTML(paste0(
        "<span>Custom header content</span><span>{{ date }}</span>",
        "<el-button-group>",
        "<el-button size=\"small\" @click=\"$refs.calendar.selectDate('prev-year')\">Previous Year</el-button>",
        "<el-button size=\"small\" @click=\"$refs.calendar.selectDate('prev-month')\">Previous Month</el-button>",
        "<el-button size=\"small\" @click=\"$refs.calendar.selectDate('today')\">Today</el-button>",
        "<el-button size=\"small\" @click=\"$refs.calendar.selectDate('next-month')\">Next Month</el-button>",
        "<el-button size=\"small\" @click=\"$refs.calendar.selectDate('next-year')\">Next Year</el-button>",
        "</el-button-group>"
      )),
      slot = "header",
      scope = "{ date }"
    )
  )
)
