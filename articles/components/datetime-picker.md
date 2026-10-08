# DateTimePicker

Select date and time in one picker.

> **Tip**
>
> DateTimePicker is derived from DatePicker and TimePicker. For a more
> detailed explanation on attributes, you can refer to DatePicker and
> TimePicker.

## Date and time

You can select date and time in one picker at the same time by setting
`type` to `datetime`. The way to use shortcuts is the same as Date
Picker.

``` r

block <- function(title, picker) {
  tags$div(class = "block", tags$span(class = "demonstration", title), picker)
}
tagList(
  tags$style(
    ".demo-datetime-picker { display: flex; width: 100%; flex-wrap: wrap; }
     .demo-datetime-picker .block { padding: 30px 0; text-align: center;
       border-right: solid 1px var(--el-border-color); flex: 1; min-width: 300px; }
     .demo-datetime-picker .block:last-child { border-right: none; }
     .demo-datetime-picker .demonstration { display: block; margin-bottom: 20px;
       color: var(--el-text-color-secondary); font-size: 14px; }"
  ),
  tags$div(
    class = "demo-datetime-picker",
    block(
      "Default",
      el_date_picker(
        "dtp1",
        type = "datetime",
        placeholder = "Select date and time"
      )
    ),
    block(
      "With shortcuts",
      el_date_picker(
        "dtp2",
        type = "datetime",
        placeholder = "Select date and time",
        shortcuts = list(
          list(text = "Today", value = JS("new Date()")),
          list(
            text = "Yesterday",
            value = JS(
              "function() { var d = new Date(); d.setDate(d.getDate() - 1); return d; }"
            )
          ),
          list(
            text = "A week ago",
            value = JS(
              "function() { var d = new Date(); d.setDate(d.getDate() - 7); return d; }"
            )
          )
        )
      )
    ),
    block(
      "With default time",
      el_date_picker(
        "dtp3",
        type = "datetime",
        placeholder = "Select date and time",
        default_time = JS("new Date(2000, 1, 1, 12, 0, 0)")
      )
    )
  )
)
```

Default

With shortcuts

With default time

## DateTime Formats

Use `format` to control displayed text’s format in the input box. Use
`value-format` to control binding value’s format.

By default, the component accepts and emits a `Date` object.

Check the list
[here](https://day.js.org/docs/en/display/format#list-of-all-available-formats)
of all available formats of Day.js.

> **Warning**
>
> Pay attention to capitalization

What each picker reports is `input$<id>`: in the format `value_format`
names, `"x"` a timestamp. `format` is what the box shows.

``` r

block <- function(title, id, ...) {
  tags$div(
    class = "block",
    tags$span(class = "demonstration", title),
    tags$div(class = "demonstration", textOutput(paste0(id, "_value"))),
    el_date_picker(id, type = "datetime", placeholder = "Pick a Date", ...)
  )
}
ui <- el_page(
  tags$style(
    ".demo-datetime-picker { display: flex; width: 100%; flex-wrap: wrap; }
     .demo-datetime-picker .block { padding: 30px 0; text-align: center;
       border-right: solid 1px var(--el-border-color); flex: 1; min-width: 300px; }
     .demo-datetime-picker .block:last-child { border-right: none; }
     .demo-datetime-picker .demonstration { display: block; margin-bottom: 20px;
       color: var(--el-text-color-secondary); font-size: 14px; }"
  ),
  tags$div(
    class = "demo-datetime-picker",
    block("Default value format", "dtp_fmt1", format = "YYYY/MM/DD HH:mm:ss"),
    block(
      "Use value-format",
      "dtp_fmt2",
      format = "YYYY/MM/DD hh:mm:ss",
      value_format = "YYYY-MM-DD h:m:s a"
    ),
    block(
      "Timestamp",
      "dtp_fmt3",
      format = "YYYY/MM/DD hh:mm:ss",
      value_format = "x"
    )
  )
)
server <- function(input, output, session) {
  for (id in c("dtp_fmt1", "dtp_fmt2", "dtp_fmt3")) {
    local({
      id <- id
      output[[paste0(id, "_value")]] <- renderText({
        paste("Value:", format(input[[id]], scientific = FALSE))
      })
    })
  }
}
shinyApp(ui, server)
```

![The date-and-time-formats example,
running](../../shots/datetime-picker-date-and-time-formats.png)

## Date and time formats in dropdown panel

Use `date-format` and `time-format` to control displayed text’s format
in the dropdown panel’s input box.

``` r

tagList(
  tags$style(
    ".demo-datetime-picker { display: flex; width: 100%; flex-wrap: wrap;
       justify-content: space-around; align-items: stretch; }
     .demo-datetime-picker .block { padding: 30px 0; text-align: center;
       min-width: 300px; flex: 1; }
     .demo-datetime-picker .line { width: 1px; background-color: var(--el-border-color); }"
  ),
  tags$div(
    class = "demo-datetime-picker",
    tags$div(
      class = "block",
      el_date_picker(
        "dtp_fmt_panel",
        type = "datetime",
        placeholder = "Pick a Date",
        format = "YYYY-MM-DD HH:mm:ss",
        date_format = "MMM DD, YYYY",
        time_format = "HH:mm"
      )
    ),
    tags$div(class = "line"),
    tags$div(
      class = "block",
      el_date_picker(
        "dtp_fmt_range",
        type = "datetimerange",
        start_placeholder = "Start date",
        end_placeholder = "End date",
        format = "YYYY-MM-DD HH:mm:ss",
        date_format = "YYYY/MM/DD ddd",
        time_format = "A hh:mm:ss"
      )
    )
  )
)
```

## Date and time range

You can select date and time range by setting `type` to `datetimerange`.

``` r

block <- function(title, picker) {
  tags$div(class = "block", tags$span(class = "demonstration", title), picker)
}
range_back <- function(text, step) {
  list(
    text = text,
    value = JS(sprintf(
      "function() { var e = new Date(), s = new Date(); %s; return [s, e]; }",
      step
    ))
  )
}
tagList(
  tags$style(
    ".demo-datetime-picker { display: flex; width: 100%; flex-wrap: wrap; }
     .demo-datetime-picker .block { padding: 30px 0; text-align: center;
       border-right: solid 1px var(--el-border-color); flex: 1; min-width: 300px; }
     .demo-datetime-picker .block:last-child { border-right: none; }
     .demo-datetime-picker .demonstration { display: block; margin-bottom: 20px;
       color: var(--el-text-color-secondary); font-size: 14px; }"
  ),
  tags$div(
    class = "demo-datetime-picker",
    block(
      "Default",
      el_date_picker(
        "dtp_range",
        type = "datetimerange",
        value = c("2000-11-10 10:10:00", "2000-11-11 10:10:00"),
        range_separator = "To",
        start_placeholder = "Start date",
        end_placeholder = "End date"
      )
    ),
    block(
      "With shortcuts",
      el_date_picker(
        "dtp_range_quick",
        type = "datetimerange",
        range_separator = "To",
        start_placeholder = "Start date",
        end_placeholder = "End date",
        shortcuts = list(
          range_back("Last week", "s.setDate(s.getDate() - 7)"),
          range_back("Last month", "s.setMonth(s.getMonth() - 1)"),
          range_back("Last 3 months", "s.setMonth(s.getMonth() - 3)")
        )
      )
    )
  )
)
```

Default

With shortcuts

## Single Panel

By default date picker ranges have two panels. If you want one panel set
the `single-panel` attribute.

``` r

tags$div(
  style = "padding: 30px 0; text-align: center",
  tags$span(
    style = "display: block; margin-bottom: 20px; color: var(--el-text-color-secondary); font-size: 14px",
    "single-panel"
  ),
  el_date_picker("dtp_single", type = "datetimerange", single_panel = TRUE)
)
```

single-panel

## Default time value for start date and end date

When picking date range on the date panel with type `datetimerange`,
`00:00:00` will be used as the default time value for start and end
date. We can control it with the `default-time` attribute.
`default-time` accepts an array of up to two Date objects. The first
item controls time value of the start date and the second item controls
time value of the end date.

``` r

block <- function(title, picker) {
  tags$div(class = "block", tags$span(class = "demonstration", title), picker)
}
tagList(
  tags$style(
    ".demo-datetime-picker { display: flex; width: 100%; flex-wrap: wrap; }
     .demo-datetime-picker .block { padding: 30px 0; text-align: center;
       border-right: solid 1px var(--el-border-color); flex: 1; min-width: 300px; }
     .demo-datetime-picker .block:last-child { border-right: none; }
     .demo-datetime-picker .demonstration { display: block; margin-bottom: 20px;
       color: var(--el-text-color-secondary); font-size: 14px; }"
  ),
  tags$div(
    class = "demo-datetime-picker",
    block(
      "Start and end date time 12:00:00",
      el_date_picker(
        "dtp_dt1",
        type = "datetimerange",
        start_placeholder = "Start Date",
        end_placeholder = "End Date",
        default_time = JS("new Date(2000, 1, 1, 12, 0, 0)")
      )
    ),
    block(
      "Start date time 12:00:00, end date time 08:00:00",
      el_date_picker(
        "dtp_dt2",
        type = "datetimerange",
        start_placeholder = "Start Date",
        end_placeholder = "End Date",
        default_time = list(
          JS("new Date(2000, 1, 1, 12, 0, 0)"),
          JS("new Date(2000, 2, 1, 8, 0, 0)")
        )
      )
    )
  )
)
```

Start and end date time 12:00:00

Start date time 12:00:00, end date time 08:00:00

## Custom icon

Custom icons available with slots.

``` r

arrows <- list(
  `prev-month` = el_icon("CaretLeft"),
  `next-month` = el_icon("CaretRight"),
  `prev-year` = el_icon("Back"),
  `next-year` = el_icon("Right")
)
tagList(
  tags$style(
    ".demo-datetime-picker-icon { display: flex; width: 100%; flex-wrap: wrap;
       justify-content: space-around; align-items: stretch; }
     .demo-datetime-picker-icon .block { padding: 30px 0; text-align: center;
       min-width: 300px; flex: 1; }
     .demo-datetime-picker-icon .line { width: 1px; background-color: var(--el-border-color); }"
  ),
  tags$div(
    class = "demo-datetime-picker-icon",
    tags$div(
      class = "block",
      el_date_picker(
        "dtp_icons",
        type = "datetime",
        placeholder = "Pick a Date",
        format = "YYYY-MM-DD HH:mm:ss",
        date_format = "MMM DD, YYYY",
        time_format = "HH:mm",
        slots = arrows
      )
    ),
    tags$div(class = "line"),
    tags$div(
      class = "block",
      el_date_picker(
        "dtp_icons_range",
        type = "datetimerange",
        start_placeholder = "Start date",
        end_placeholder = "End date",
        format = "YYYY-MM-DD HH:mm:ss",
        date_format = "YYYY/MM/DD ddd",
        time_format = "A hh:mm:ss",
        unlink_panels = TRUE,
        slots = arrows
      )
    )
  )
)
```

## API

Element Plus’s tables, and beside each entry where it is in R.

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `model-value` | `value`; `input$<id>` | binding value, if it is an `range` picker, the length of the array should be 2 | [^1] / [^2] / [^3] / [^4]`number[] \\| string[] \\| Date[]` |  | ’’ |
| `readonly` | `readonly` | whether DatePicker is read only | [^5] |  | false |
| `disabled` | `disabled` | whether DatePicker is disabled | [^6] |  | false |
| `editable` | `editable` | whether the input is editable | [^7] |  | true |
| `clearable` | `clearable` | whether to show clear button | [^8] |  | true |
| `size` | `size` | size of Input | [^9]`'large' \\| 'default' \\| 'small'` |  | default |
| `placeholder` | `placeholder` | placeholder in non-range mode | [^10] |  | — |
| `start-placeholder` | `start_placeholder` | placeholder for the start date in range mode | [^11] |  | — |
| `end-placeholder` | `end_placeholder` | placeholder for the end date in range mode | [^12] |  | — |
| `arrow-control` | `arrow_control` | whether to pick time using arrow buttons | [^13] |  | false |
| `type` | `type` | type of the picker | [^14]`'year' \\| 'month' \\| 'date' \\| 'datetime' \\| 'week' \\| 'datetimerange' \\| 'daterange'` |  | date |
| `format` | `format` | format of the displayed value in the input box | [^15] see [date formats](https://kaipingyang.github.io/shiny.element/articles/components/date-picker.html#date-formats) |  | YYYY-MM-DD HH:mm:ss |
| `popper-class` | `popper_class` | custom class name for DateTimePicker’s dropdown | [^16] |  | — |
| `popper-style` | `popper_style` | custom style for DateTimePicker’s dropdown | [^17] / [^18] |  | — |
| `popper-options` | `popper_options` | Customized popper option see more at [popper.js](https://popper.js.org/docs/v2/) | [^19]`Partial<PopperOptions>` |  | {} |
| `fallback-placements` | `fallback_placements` | list of possible positions for Tooltip [popper.js](https://popper.js.org/docs/v2/modifiers/flip/#fallbackplacements) | [^20]`Placement[]` |  | \[‘bottom’, ‘top’, ‘right’, ‘left’\] |
| `placement` | `placement` | position of dropdown | `Placement` |  | bottom |
| `range-separator` | `range_separator` | range separator | [^21] |  | ‘-’ |
| `default-value` | `default_value` | optional, default date of the calendar | [^22]`Date \\| [Date, Date]` |  | — |
| `default-time` | `default_time` | the default time value after picking a date. Time `00:00:00` will be used if not specified | [^23]`Date \\| [Date, Date]` |  | — |
| `value-format` | `value_format` | optional, format of binding value. If not specified, the binding value will be a Date object | [^24] see [date formats](https://day.js.org/docs/en/display/format) |  | — |
| `date-format` | `date_format` | optional, format of the date displayed in input’s inner panel | [^25] see [date formats](https://day.js.org/docs/en/display/format) |  | YYYY-MM-DD |
| `time-format` | `time_format` | optional, format of the time displayed in input’s inner panel | [^26] see [date formats](https://day.js.org/docs/en/display/format) |  | HH:mm:ss |
| `id` | `id`, the Shiny input’s | same as `id` in native input | [^27] / [^28]`[string, string]` |  | — |
| `unlink-panels` | `unlink_panels` | unlink two date-panels in range-picker | [^29] |  | false |
| `single-panel` | `single_panel` | show only one panel in range-picker | [^30] |  | false |
| `prefix-icon` | `prefix_icon` | Custom prefix icon component | [^31] / `Component` |  | Date |
| `clear-icon` | `clear_icon` | Custom clear icon component | [^32] / `Component` |  | CircleClose |
| `shortcuts` | `shortcuts` | an object array to set shortcut options | [^33]`Array<{ text: string, value: Date \\| Function }>` |  | — |
| `disabled-date` | `disabled_date` | a function determining if a date is disabled with that date as its parameter. Should return a Boolean | [^34]`(data: Date) => boolean` |  | — |
| `disabled-hours` | `disabled_hours` | To specify the array of hours that cannot be selected | [^35]`(role: string, comparingDate?: Dayjs) => number[]` |  | — |
| `disabled-minutes` | `disabled_minutes` | To specify the array of minutes that cannot be selected | [^36]`(hour: number, role: string, comparingDate?: Dayjs) => number[]` |  | — |
| `disabled-seconds` | `disabled_seconds` | To specify the array of seconds that cannot be selected | [^37]`(hour: number, minute: number, role: string, comparingDate?: Dayjs) => number[]` |  | — |
| `cell-class-name` | `cell_class_name` | set custom className | [^38]`(data: Date) => string` |  | — |
| `teleported` | `teleported` | whether datetime-picker dropdown is teleported to the body | [^39] |  | true |
| `empty-values` | `empty_values` | empty values of component, [see config-provider](https://kaipingyang.github.io/shiny.element/articles/components/config-provider.html#empty-values-configurations) | [^40] |  | — |
| `value-on-clear` | `value_on_clear` | clear return value, [see config-provider](https://kaipingyang.github.io/shiny.element/articles/components/config-provider.html#empty-values-configurations) | [^41] / [^42] / [^43] / [^44] |  | — |
| `show-now` | `show_now` | whether to show the now button | [^45] |  | true |
| `show-footer` | `show_footer` | whether to show footer where the date picker is one [^46]`'datetime' \\| 'datetimerange'` | [^47] |  | true |
| `show-confirm` | `show_confirm` | whether to show the confirm button | [^48] |  | true |
| `show-week-number` | `show_week_number` | show the week number besides the week | [^49] |  | false |

### Events

| Element | In R | Description |
|----|----|----|
| `change` | `input$<id>`, the value | triggers when user confirms the value or click outside |
| `blur` | `input$<id>_blur` | triggers when Input blurs |
| `focus` | `input$<id>_focus` | triggers when Input focuses |
| `clear` | `input$<id>_clear` | triggers when a clear button is clicked |
| `calendar-change` | `input$<id>_calendar_change` | triggers when the calendar selected date is changed. Only for `range` |
| `panel-change` | `input$<id>_panel_change` | triggers when the navigation button click. |
| `visible-change` | `input$<id>_visible_change` | triggers when the DateTimePicker’s dropdown appears/disappears |

### Slots

| Element | In R | Description |
|----|----|----|
| `default` | default content | custom cell content |
| `range-separator` | `slots = list(range-separator = )` | custom range separator content |
| `prev-month` | `slots = list(prev-month = )` | prev month icon |
| `next-month` | `slots = list(next-month = )` | next month icon |
| `prev-year` | `slots = list(prev-year = )` | prev year icon |
| `next-year` | `slots = list(next-year = )` | next year icon |

### Exposes

| Element | In R                            | Description                    |
|---------|---------------------------------|--------------------------------|
| `focus` | `call_el(session, id, "focus")` | focus the DatePicker component |
| `blur`  | `call_el(session, id, "blur")`  | blur the DatePicker component  |

[^1]: number

[^2]: string

[^3]: Date

[^4]: array

[^5]: boolean

[^6]: boolean

[^7]: boolean

[^8]: boolean

[^9]: enum

[^10]: string

[^11]: string

[^12]: string

[^13]: boolean

[^14]: enum

[^15]: string

[^16]: string

[^17]: string

[^18]: object

[^19]: object

[^20]: array

[^21]: string

[^22]: object

[^23]: object

[^24]: string

[^25]: string

[^26]: string

[^27]: string

[^28]: array

[^29]: boolean

[^30]: boolean

[^31]: string

[^32]: string

[^33]: array

[^34]: Function

[^35]: Function

[^36]: Function

[^37]: Function

[^38]: Function

[^39]: boolean

[^40]: array

[^41]: string

[^42]: number

[^43]: boolean

[^44]: Function

[^45]: boolean

[^46]: enum

[^47]: boolean

[^48]: boolean

[^49]: boolean
