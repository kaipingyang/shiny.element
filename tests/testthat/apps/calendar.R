# Fixture for test-browser-calendar.R: the calendar's events layer -- times,
# groups, "+N more", the detail popover, dragging across days, read-only
# events, the week's first day, the workweek and slots of Element's
# components of one's own.
library(shiny)

events <- data.frame(
  id = 1:7,
  date = c(
    "2026-10-05",
    "2026-10-05 09:30",
    "2026-10-05 14:00",
    "2026-10-05",
    "2026-10-07",
    "2026-10-13 10:00",
    "2026-10-21"
  ),
  end = c(NA, NA, "2026-10-05 15:00", NA, "2026-10-09", NA, NA),
  title = c(
    "Standup",
    "Design",
    "Review",
    "Lunch",
    "Conference",
    "Locked",
    "Holiday"
  ),
  calendarId = c("work", "work", "work", "home", "work", "work", "home"),
  isReadOnly = c(FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, FALSE),
  body = c("Daily", "", "Sprint review", "", "Annual", "Read only", "")
)
calendars <- data.frame(
  id = c("work", "home"),
  name = c("Work", "Home"),
  type = c("primary", "success")
)

ui <- el_page(
  el_calendar_output("xplan"),
  el_calendar_output("xro"),
  el_calendar("xsun", value = "2026-10-07"),
  el_calendar(
    "xslot",
    value = "2026-10-07",
    events = data.frame(
      id = 1:2,
      date = c("2026-10-06", "2026-10-08"),
      title = c("Visit", "Audit"),
      location = c("Lab 2", "HQ"),
      isReadOnly = c(FALSE, TRUE)
    ),
    editable = TRUE,
    use_detail_popup = TRUE,
    slots = list(
      event = template(
        "<b class='xs-title'>{{ event.title }}</b>",
        slot = "event",
        scope = "{ event }"
      ),
      eventForm = htmltools::tagList(
        el$form_item(label = "Title", el$input(`v-model` = "form.title")),
        el$form_item(
          label = "Where",
          el$input(class = "xs-where", `v-model` = "form.location")
        )
      ),
      eventDetail = htmltools::tags$div(
        class = "xs-detail",
        "{{ event.title }} @ {{ event.location }}"
      )
    )
  ),
  actionButton("hide_home", "hide home"),
  verbatimTextOutput("dump")
)

server <- function(input, output, session) {
  output$xplan <- render_el_calendar(el_calendar(
    value = "2026-10-07",
    events = events,
    calendars = calendars,
    editable = TRUE,
    visible_event_count = 2,
    first_day_of_week = 1
  ))
  output$xro <- render_el_calendar(el_calendar(
    value = "2026-10-07",
    events = events,
    calendars = calendars,
    use_detail_popup = TRUE,
    first_day_of_week = 1,
    workweek = TRUE
  ))
  # the server answers an add with the event, given an id
  observeEvent(input$xplan_add, {
    new <- input$xplan_add
    update_el_calendar(
      session,
      "xplan",
      insert = data.frame(
        id = 100L,
        date = new$date,
        end = new$end %||% NA,
        title = new$title,
        calendarId = new$calendarId
      )
    )
  })
  observeEvent(input$hide_home, {
    update_el_calendar(
      session,
      "xro",
      calendars = transform(calendars, isVisible = id != "home")
    )
  })
  output$dump <- renderPrint({
    a <- input$xplan_add
    u <- input$xslot_update
    cat(
      "xplan_add",
      "=",
      if (!is.null(a)) {
        paste(
          class(a$date)[1],
          format(a$date, "%Y-%m-%d %H:%M"),
          format(a$end, "%Y-%m-%d %H:%M"),
          a$title,
          a$calendarId
        )
      },
      "\n"
    )
    cat(
      "xslot_update",
      "=",
      if (!is.null(u)) paste(u$event$title, u$changes$location),
      "\n"
    )
  })
}

shinyApp(ui, server)
