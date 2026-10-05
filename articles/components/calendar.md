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
