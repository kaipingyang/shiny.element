# DatePicker

Use Date Picker for date input. `input$<id>` is a `Date` – two for a
range – as [`dateInput()`](https://rdrr.io/pkg/shiny/man/dateInput.html)
gives one; another `type` or `value_format` reports the text the picker
produces.

## Enter date

`type` sets the measurement; `picker_options` carries Element’s
`shortcuts` and `disabledDate`, written with
[`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md).

``` r

el_date_picker("d1", placeholder = "Pick a day")
el_date_picker("d2", placeholder = "Pick a day", picker_options = list(
  disabledDate = JS("function(time) { return time.getTime() > Date.now(); }"),
  shortcuts = list(
    list(text = "Today", onClick = JS("function(picker) { picker.$emit('pick', new Date()); }")),
    list(text = "Yesterday", onClick = JS(
      "function(picker) { var d = new Date(); d.setTime(d.getTime() - 3600 * 1000 * 24); picker.$emit('pick', d); }")))))
```

## Other measurements

``` r

el_date_picker("week", type = "week", format = "Week WW", value_format = "yyyy-WW", placeholder = "Pick a week")
el_date_picker("month", type = "month", value_format = "yyyy-MM", placeholder = "Pick a month")
el_date_picker("year", type = "year", value_format = "yyyy", placeholder = "Pick a year")
el_date_picker("dates", type = "dates", placeholder = "Pick one or more dates")
```

## Date range

`unlink_panels` lets the two months move on their own.

``` r

el_date_picker("trip", type = "daterange", range_separator = "To", unlink_panels = TRUE,
               start_placeholder = "Start date", end_placeholder = "End date")
```

## Month range

``` r

el_date_picker("quarter", type = "monthrange", value_format = "yyyy-MM", range_separator = "To",
               start_placeholder = "Start month", end_placeholder = "End month")
```

## Default value

`default_value` is the month the panel opens on when nothing is picked.

``` r

el_date_picker("dv", placeholder = "Pick a date", default_value = "2010-10-01")
```

## Date formats

`format` is what the box shows; `value_format` what `input$<id>` gets.

``` r

el_date_picker("f1", value = "2026-03-15", format = "yyyy/MM/dd")
el_date_picker("f2", value = "2026-03-15", format = "dd MMM yyyy", value_format = "timestamp")
```

## Default time for start and end date

``` r

el_date_picker("dt", type = "daterange", value_format = "yyyy-MM-dd HH:mm:ss",
               start_placeholder = "Start", end_placeholder = "End",
               default_time = c("00:00:00", "23:59:59"))
```

## API

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `value` | `value` | binding value | date(DatePicker) / array(DateRangePicker) | — | — |
| `readonly` | `readonly` | whether DatePicker is read only | boolean | — | false |
| `disabled` | `disabled` | whether DatePicker is disabled | boolean | — | false |
| `size` | `size` | size of Input | string | large/small/mini | — |
| `editable` | `editable` | whether the input is editable | boolean | — | true |
| `clearable` | `clearable` | whether to show clear button | boolean | — | true |
| `placeholder` | `placeholder` | placeholder in non-range mode | string | — | — |
| `start-placeholder` | `start_placeholder` | placeholder for the start date in range mode | string | — | — |
| `end-placeholder` | `end_placeholder` | placeholder for the end date in range mode | string | — | — |
| `type` | `type` | type of the picker | string | year/month/date/dates/months/years/datetime/ week/datetimerange/daterange/ monthrange | date |
| `format` | `format` | format of the displayed value in the input box | string | see [date formats](#id_/en-US/component/date-picker#date-formats) | yyyy-MM-dd |
| `align` | `align` | alignment | left/center/right |  |  |
| `popper-class` | `popper_class` | custom class name for DatePicker’s dropdown | string | — | — |
| `picker-options` | `picker_options` | additional options, check the table below | object | — | {} |
| `range-separator` | `range_separator` | range separator | string | — | ‘-’ |
| `default-value` | `default_value` | optional, default date of the calendar | Date | anything accepted by `new Date()` | — |
| `default-time` | `default_time` | optional, the time value to use when selecting date range | string\[\] | Array with length 2, each item is a string like `12:00:00`. The first item for the start date and then second item for the end date | — |
| `value-format` | `value_format` | optional, format of binding value. If not specified, the binding value will be a Date object | string | see [date formats](#id_/en-US/component/date-picker#date-formats) | — |
| `name` | `name` | same as `name` in native input | string | — | — |
| `unlink-panels` | `unlink_panels` | unlink two date-panels in range-picker | boolean | — | false |
| `prefix-icon` | `prefix_icon` | Custom prefix icon class | string | — | el-icon-date |
| `clear-icon` | `clear_icon` | Custom clear icon class | string | — | el-icon-circle-close |
| `validate-event` | `validate_event` | whether to trigger form validation | boolean | \- | true |
| `append-to-body` | `append_to_body` | whether to append DatePicker itself to body | boolean | — | true |

### Events

| Element  | In R                    | Description                           |
|----------|-------------------------|---------------------------------------|
| `change` | `input$<id>`, the value | triggers when user confirms the value |
| `blur`   | `input$<id>_blur`       | triggers when Input blurs             |
| `focus`  | `input$<id>_focus`      | triggers when Input focuses           |

### Methods

| Element | In R                            | Description               |
|---------|---------------------------------|---------------------------|
| `focus` | `el_call(session, id, "focus")` | focus the Input component |

### Slots

| Element | In R | Description |
|----|----|----|
| `range-separator` | `slots = list(range-separator = )` | custom range separator content |
