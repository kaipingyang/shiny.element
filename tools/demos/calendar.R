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

## in-shiny
#| shot_js = "document.querySelectorAll('#snapshot .el-calendar-event')[2].click()"
#| shot_wait = 1.5
#' ### Days from the server
#'
#' In an app whose events the server reads -- from a database, from the
#' files on disk -- the calendar is an output, as toastui's is:
#' `el_calendar_output()` in the UI, `render_el_calendar()` in the server.
#' Each event is a `start` day, with optionally an `end`, a `title`, a
#' `body` shown on hover, and Element's tag `type` or a `color` of its own;
#' a title left empty draws a block of colour. A click on an event arrives
#' as `input$<id>_click`, its days as Dates; the month shown, as
#' `input$<id>_dates`. Rendered again, the calendar is patched: only the
#' events are sent, and the month the user went to stays.
archive <- data.frame(
  start = as.Date("2026-10-20") - c(16, 9, 6, 2),
  title = c("", "", "", "Validated"),
  body = c("Raw data", "Raw data", "Archive", "Validated data"),
  color = c("lightgrey", "lightgrey", "#EED5B7", "#E9C46B")
)

ui <- el_page(
  el_calendar_output("snapshot"),
  verbatimTextOutput("picked")
)

server <- function(input, output, session) {
  output$snapshot <- render_el_calendar(
    el_calendar(value = max(archive$start), events = archive)
  )
  output$picked <- renderPrint(input$snapshot_click$start)
}

shinyApp(ui, server)

## in-shiny-planner
#| shot_js = "document.querySelectorAll('#plan .el-calendar-event')[1].click()"
#| shot_wait = 1.5
#| shot_sel = ".el-calendar-dialog"
#' ### A planner
#'
#' With `editable = TRUE` the user double-clicks a day to add an event,
#' clicks one to edit or delete it in a dialog, and drags it to another day.
#' The server owns the events, as toastui's calendar has it: what the user
#' does arrives as a request and changes nothing until the server answers --
#' here by changing its data, which renders the calendar again; for a large
#' calendar, `update_el_calendar(insert =, replace =, delete =)` sends only
#' the events that changed. `el_calendar_events()` reads what the calendar
#' shows.
#'
#' | Input | Value |
#' |---|---|
#' | `input$plan` | the day picked, `"YYYY-MM-DD"` |
#' | `input$plan_dates` | the days drawn, `list(current, start, end)`, Dates |
#' | `input$plan_click` | the event clicked |
#' | `input$plan_add` | a new event asked for, without an `id` |
#' | `input$plan_update` | `list(event, changes)`: an edit, or a move |
#' | `input$plan_delete` | the event to delete |
ui <- el_page(el_calendar_output("plan"))

server <- function(input, output, session) {
  events <- reactiveVal(data.frame(
    id = 1:3,
    start = as.Date("2026-10-05") + c(0, 2, 9),
    end = as.Date(c(NA, "2026-10-09", NA)),
    title = c("Standup", "Conference", "Review"),
    type = c("primary", "success", "warning")
  ))
  output$plan <- render_el_calendar(
    el_calendar(value = "2026-10-07", events = events(), editable = TRUE)
  )
  observeEvent(input$plan_add, {
    new <- input$plan_add
    events(rbind(
      events(),
      data.frame(
        id = max(events()$id) + 1L,
        start = new$start,
        end = if (is.null(new$end)) as.Date(NA) else new$end,
        title = new$title,
        type = new$type
      )
    ))
  })
  observeEvent(input$plan_update, {
    d <- events()
    i <- d$id == input$plan_update$event$id
    for (k in intersect(names(input$plan_update$changes), names(d))) {
      value <- input$plan_update$changes[[k]]
      d[[k]][i] <- if (is.null(value)) NA else value
    }
    events(d)
  })
  observeEvent(input$plan_delete, {
    events(events()[events()$id != input$plan_delete$id, ])
  })
}

shinyApp(ui, server)
