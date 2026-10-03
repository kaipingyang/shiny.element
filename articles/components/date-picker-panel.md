# DatePickerPanel

`DatePickerPanel` is the core component of `DatePicker`.

## Enter Date

Basic date picker measured by ‘day’.

``` r

el_date_picker_panel("dpp", value = Sys.Date())
```

## Border

By default the date-picker-panel is bordered but in some case you don’t
want it. For example `DatePicker` don’t inherit `border`.

``` r

el_date_picker_panel("dpp_border", value = Sys.Date(), border = FALSE)
```

## Disabled

The `disabled` attribute determines if the date picker is fully
disabled.

``` r

el_date_picker_panel("dpp_dis", value = Sys.Date(), disabled = TRUE)
```

## Types

The measurement is determined by the `type` attribute.

Every type the picker has, its panel open.

``` r

tags$div(style = "display: grid; gap: 16px",
  lapply(c("date", "week", "month", "year", "daterange", "monthrange"), function(t)
    tagList(tags$div(t), el_date_picker_panel(paste0("dpp_", t), type = t))))
```

date

week

month

year

daterange

monthrange

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
| `model-value` | `value`; `input$<id>` | binding value, if it is an `range` picker, the length of the array should be 2 | [^1] / [^2] / [^3] / [^4]`number[] \\| string[] \\| Date[]` |  | ’’ |
| `border` | `border` | whether the date picker is bordered | [^5] |  | true |
| `disabled` | `disabled` | whether DatePicker is disabled | [^6] |  | false |
| `clearable` | `clearable` | whether to show clear button | [^7] |  | true |
| `editable` | `editable` | whether the input is editable | [^8] |  | true |
| `type` | `type` | type of the picker. `quarter`, `quarters`, and `quarterrange` are supported since ^(2.14.5) | [^9]`'year' \\| 'years' \\|'month' \\| 'months' \\| 'date' \\| 'dates' \\| 'datetime' \\| 'week' \\| 'quarter' \\| 'quarters' \\| 'datetimerange' \\| 'daterange' \\| 'monthrange' \\| 'yearrange' \\| 'quarterrange'` |  | date |
| `default-value` | `default_value` | optional, default date of the calendar | [^10]`Date \\| [Date, Date]` |  | — |
| `default-time` | `default_time` | optional, the time value to use when selecting date range | [^11]`Date \\| [Date, Date]` |  | — |
| `value-format` | `value_format` | optional, format of binding value. If not specified, the binding value will be a Date object | [^12] |  | — |
| `date-format` | `date_format` | optional, format of the date displayed in input’s inner panel | [^13] see [date formats](https://day.js.org/docs/en/display/format) |  | YYYY-MM-DD |
| `time-format` | `time_format` | optional, format of the time displayed in input’s inner panel | [^14] see [date formats](https://day.js.org/docs/en/display/format) |  | HH:mm:ss |
| `unlink-panels` | `unlink_panels` | unlink two date-panels in range-picker | [^15] |  | false |
| `single-panel` | `single_panel` | show only one panel in range-picker | [^16] |  | false |
| `disabled-date` | `disabled_date` | a function determining if a date is disabled with that date as its parameter. Should return a Boolean | [^17]`(data: Date) => boolean` |  | — |
| `shortcuts` | `shortcuts` | an object array to set shortcut options | [^18]`Array<{ text: string, value: Date \\| Function }>` |  | \[\] |
| `cell-class-name` | `cell_class_name` | set custom className | [^19]`(data: Date) => string` |  | — |
| `show-footer` | `show_footer` | whether to show footer where the date picker is one [^20]`'dates' \\| 'months' \\| 'years' \\| 'quarters' \\| 'datetime' \\| 'datetimerange'` | [^21] |  | false |
| `show-confirm` | `show_confirm` | whether to show the confirm button | [^22] |  | false |
| `show-week-number` | `show_week_number` | show the week number besides the week | [^23] |  | false |

### Events

| Element | In R | Description |
|----|----|----|
| `calendar-change` | `input$<id>_calendar_change` | triggers when the calendar selected date is changed. Only for `range` |
| `panel-change` | `input$<id>_panel_change` | triggers when the navigation button click. |
| `clear` | `input$<id>_clear` | triggers when a clear button is clicked |

### Slots

| Element      | In R                          | Description         |
|--------------|-------------------------------|---------------------|
| `default`    | default content               | custom cell content |
| `prev-month` | `slots = list(prev-month = )` | prev month icon     |
| `next-month` | `slots = list(next-month = )` | next month icon     |
| `prev-year`  | `slots = list(prev-year = )`  | prev year icon      |
| `next-year`  | `slots = list(next-year = )`  | next year icon      |

[^1]: number

[^2]: string

[^3]: Date

[^4]: array

[^5]: boolean

[^6]: boolean

[^7]: boolean

[^8]: boolean

[^9]: enum

[^10]: object

[^11]: object

[^12]: string

[^13]: string

[^14]: string

[^15]: boolean

[^16]: boolean

[^17]: Function

[^18]: array

[^19]: Function

[^20]: enum

[^21]: boolean

[^22]: boolean

[^23]: boolean
