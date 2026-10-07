# Calendar

Display date.

## Basic

Set `value` to specify the currently displayed month. If `value` is not
specified, current month is displayed. `value` supports two-way binding.

``` r

el_calendar("cal", value = Sys.Date())
```

## Controller Type

You can set the type of the controller for Calendar header. When setting
`select`, you can use `formatter` to customize `label`.

The radio buttons set `controller_type` from the server, with
[`update_el_calendar()`](https://kaipingyang.github.io/shiny.element/reference/el_calendar.md).

``` r

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
```

![The controller-type example,
running](../../shots/calendar-controller-type.png)

## Custom Content

Customize what is displayed in the calendar cell by setting
`scoped-slot` named `date-cell`. In `scoped-slot` you can get the date
(the date of the current cell), data (including the type, isSelected,
day attribute). For details, please refer to the API documentation
below.

``` r

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
```

## Range

Set the `range` attribute to specify the display range of the calendar.
Start time must be Monday, end time must be Sunday, and the time span
cannot exceed two months.

``` r

el_calendar("cal_range", range = c("2019-03-04", "2019-03-24"))
```

## Customize header

The header’s buttons move the calendar with Element Plus’s
`selectDate()`, called on the calendar’s ref, `$refs.calendar`, as
upstream names it.

``` r

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
```

## Localization

The default locale of is English, if you need to use other languages,
please check
[Internationalization](https://element-plus.org/en-US/guide/i18n)

Note, date time locale (month name, first day of the week …) are also
configured in localization.

## In Shiny

### Days from the server

In an app whose events the server reads – from a database, from the
files on disk – the calendar is an output, as toastui’s is:
[`el_calendar_output()`](https://kaipingyang.github.io/shiny.element/reference/el_calendar_output.md)
in the UI,
[`render_el_calendar()`](https://kaipingyang.github.io/shiny.element/reference/el_calendar_output.md)
in the server. Each event has a `date`, and optionally an `end`, a
`title`, a `body` shown on hover, and Element’s tag `type` or a `color`
of its own; a title left empty draws a block of colour. A click on an
event arrives as `input$<id>_click`, its days as Dates; the month shown,
as `input$<id>_dates`. Rendered again, the calendar is patched: only the
events are sent, and the month the user went to stays.

``` r

#'
archive <- data.frame(
  date = as.Date("2026-10-20") - c(16, 9, 6, 2),
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
    el_calendar(value = max(archive$date), events = archive)
  )
  output$picked <- renderPrint(input$snapshot_click$date)
}

shinyApp(ui, server)
```

![The shiny-output example,
running](../../shots/calendar-shiny-output.png)

### A planner

With `editable = TRUE` the user double-clicks a day to add an event,
clicks one to edit or delete it in a dialog, and drags it to another
day. The server owns the events, as toastui’s calendar has it: what the
user does arrives as a request and changes nothing until the server
answers – here by changing its data, which renders the calendar again;
for a large calendar,
`update_el_calendar(insert =, replace =, delete =)` sends only the
events that changed.
[`el_calendar_events()`](https://kaipingyang.github.io/shiny.element/reference/el_calendar_events.md)
reads what the calendar shows. \| Input \| Value \| \|—\|—\| \|
`input$plan` \| the day picked, `"YYYY-MM-DD"` \| \| `input$plan_dates`
\| the days drawn, `list(current, start, end)`, Dates \| \|
`input$plan_click` \| the event clicked \| \| `input$plan_add` \| a new
event asked for, without an `id` \| \| `input$plan_update` \|
`list(event, changes)`: an edit, or a move \| \| `input$plan_delete` \|
the event to delete \|

``` r

#'
#'
ui <- el_page(el_calendar_output("plan"))

server <- function(input, output, session) {
  events <- reactiveVal(data.frame(
    id = 1:3,
    date = as.Date("2026-10-05") + c(0, 2, 9),
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
        date = new$date,
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
```

![The shiny-planner example,
running](../../shots/calendar-shiny-planner.png)

## API

Element Plus’s tables, and beside each entry where it is in R.

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `model-value` | `value`; `input$<id>` | binding value | [^1] |  | — |
| `range` | `range` | time range, including start time and end time. Start time must be start day of week, end time must be end day of week, the time span cannot exceed two months. | [^2]`[Date, Date]` |  | — |
| `controller-type` | `controller_type` | type of the controller for Calendar header | [^3]`'button' \\| 'select'` |  | button |
| `formatter` | `formatter` | format label when `controller-type` is ‘select’ | [^4]`(value: number, type: 'year' \\| 'month') => string \\| number` |  | — |

### Slots

| Element | In R | Description |
|----|----|----|
| `date-cell` | `slots = list(date-cell = )` | `type` indicates which month the date belongs, optional values are prev-month, current-month, next-month; `isSelected` indicates whether the date is selected; `day` is the formatted date in the format `YYYY-MM-DD`; `date` is date the cell represents |
| `header` | `slots = list(header = )` | content of the Calendar header |

### Exposes

| Element | In R | Description |
|----|----|----|
| `pickDay` | `call_el(session, id, "pickDay")` | select a specific date |
| `selectDate` | `call_el(session, id, "selectDate")` | select date |
| `calculateValidatedDateRange` | `call_el(session, id, "calculateValidatedDateRange")` | Calculate the validate date range according to the start and end dates |

[^1]: Date

[^2]: array

[^3]: enum

[^4]: Function
