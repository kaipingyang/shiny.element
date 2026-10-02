# DateTimePicker

Select date and time in one picker: `el_date_picker(type = "datetime")`.
`input$<id>` is the text the picker produces, `"yyyy-MM-dd HH:mm:ss"`
unless `value_format` says otherwise.

## Date and time

``` r

el_date_picker("when", type = "datetime", value_format = "yyyy-MM-dd HH:mm:ss",
               placeholder = "Select date and time")
```

## Date and time range

``` r

el_date_picker("window", type = "datetimerange", value_format = "yyyy-MM-dd HH:mm:ss",
               range_separator = "To", start_placeholder = "Start", end_placeholder = "End")
```

## Default time for start and end

``` r

el_date_picker("shift", type = "datetimerange", value_format = "yyyy-MM-dd HH:mm:ss",
               start_placeholder = "Start", end_placeholder = "End",
               default_time = c("12:00:00", "08:00:00"))
```

## API

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `value` | `value` | binding value | date(DateTimePicker) / array(DateTimeRangePicker) | — | — |
| `readonly` | `readonly` | whether DatePicker is read only | boolean | — | false |
| `disabled` | `disabled` | whether DatePicker is disabled | boolean | — | false |
| `editable` | `editable` | whether the input is editable | boolean | — | true |
| `clearable` | `clearable` | whether to show clear button | boolean | — | true |
| `size` | `size` | size of Input | string | large/small/mini | — |
| `placeholder` | `placeholder` | placeholder in non-range mode | string | — | — |
| `start-placeholder` | `start_placeholder` | placeholder for the start date in range mode | string | — | — |
| `end-placeholder` | `end_placeholder` | placeholder for the end date in range mode | string | — | — |
| `time-arrow-control` | `time_arrow_control` | whether to pick time using arrow buttons | boolean | — | false |
| `type` | `type` | type of the picker | string | year/month/date/datetime/ week/datetimerange/daterange | date |
| `format` | `format` | format of the displayed value in the input box | string | see [date formats](#id_/en-US/component/date-picker#date-formats) | yyyy-MM-dd HH:mm:ss |
| `align` | `align` | alignment | left/center/right |  |  |
| `popper-class` | `popper_class` | custom class name for DateTimePicker’s dropdown | string | — | — |
| `picker-options` | `picker_options` | additional options, check the table below | object | — | {} |
| `range-separator` | `range_separator` | range separator | string | \- | ‘-’ |
| `default-value` | `default_value` | optional, default date of the calendar | Date | anything accepted by `new Date()` | — |
| `default-time` | `default_time` | the default time value after picking a date | non-range: string / range: string\[\] | non-range: a string like `12:00:00`, range: array of two strings, and the first item is for the start date and second for the end date. `00:00:00` will be used if not specified | — |
| `value-format` | `value_format` | optional, format of binding value. If not specified, the binding value will be a Date object | string | see [date formats](#id_/en-US/component/date-picker#date-formats) | — |
| `name` | `name` | same as `name` in native input | string | — | — |
| `unlink-panels` | `unlink_panels` | unlink two date-panels in range-picker | boolean | — | false |
| `prefix-icon` | `prefix_icon` | Custom prefix icon class | string | — | el-icon-date |
| `clear-icon` | `clear_icon` | Custom clear icon class | string | — | el-icon-circle-close |

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
