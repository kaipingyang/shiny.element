# TimePicker

Use Time Picker for time input. `input$<id>` is the time as text,
`"HH:mm:ss"` unless `value_format` says otherwise – two of them for a
range.

## Fixed time picker

[`el_time_select()`](https://kaipingyang.github.io/shiny.element/reference/el_time_picker.md)
offers fixed times: `start`, `end` and `step`.

``` r

el_time_select("slot", placeholder = "Select time",
               picker_options = list(start = "08:30", step = "00:15", end = "18:30"))
```

## Arbitrary time picker

`selectableRange` limits what can be picked; `arrow_control` steps with
arrows instead of the mouse wheel.

``` r

el_time_picker("t1", placeholder = "Arbitrary time",
               picker_options = list(selectableRange = "18:30:00 - 20:30:00"))
el_time_picker("t2", arrow_control = TRUE, placeholder = "Arbitrary time",
               picker_options = list(selectableRange = "18:30:00 - 20:30:00"))
```

## Fixed time range

The end’s `minTime` follows the start, from the server.

``` r

ui <- el_page(
  el_time_select("start", placeholder = "Start time",
                 picker_options = list(start = "08:30", step = "00:15", end = "18:30")),
  el_time_select("end", placeholder = "End time",
                 picker_options = list(start = "08:30", step = "00:15", end = "18:30"))
)

server <- function(input, output, session) {
  observeEvent(input$start, {
    update_el_time_select(id = "end", picker_options = list(
      start = "08:30", step = "00:15", end = "18:30", minTime = input$start))
  })
}

shinyApp(ui, server)
```

![The fixed-range example,
running](../../shots/time-picker-fixed-range.png)

## Arbitrary time range

``` r

el_time_picker("r1", is_range = TRUE, range_separator = "To",
               start_placeholder = "Start time", end_placeholder = "End time")
el_time_picker("r2", is_range = TRUE, arrow_control = TRUE, range_separator = "To",
               start_placeholder = "Start time", end_placeholder = "End time")
```

## API

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `value` | `el_time_picker(value =)` | binding value | date(TimePicker) / string(TimeSelect) | \- | \- |
| `readonly` | `el_time_picker(readonly =)` | whether TimePicker is read only | boolean | — | false |
| `disabled` | `el_time_picker(disabled =)` | whether TimePicker is disabled | boolean | — | false |
| `editable` | `el_time_picker(editable =)` | whether the input is editable | boolean | — | true |
| `clearable` | `el_time_picker(clearable =)` | whether to show clear button | boolean | — | true |
| `size` | `el_time_picker(size =)` | size of Input | string | medium / small / mini | — |
| `placeholder` | `el_time_picker(placeholder =)` | placeholder in non-range mode | string | — | — |
| `start-placeholder` | `el_time_picker(start_placeholder =)` | placeholder for the start time in range mode | string | — | — |
| `end-placeholder` | `el_time_picker(end_placeholder =)` | placeholder for the end time in range mode | string | — | — |
| `is-range` | `el_time_picker(is_range =)` | whether to pick a time range, only works with `<el-time-picker>` | boolean | — | false |
| `arrow-control` | `el_time_picker(arrow_control =)` | whether to pick time using arrow buttons, only works with `<el-time-picker>` | boolean | — | false |
| `align` | `el_time_picker(align =)` | alignment | left / center / right |  |  |
| `popper-class` | `el_time_picker(popper_class =)` | custom class name for TimePicker’s dropdown | string | — | — |
| `picker-options` | `el_time_picker(picker_options =)` | additional options, check the table below | object | — | {} |
| `range-separator` | `el_time_picker(range_separator =)` | range separator | string | \- | ‘-’ |
| `default-value` | `el_time_picker(default_value =)` | optional, default date of the calendar | Date for TimePicker, string for TimeSelect | anything accepted by `new Date()` for TimePicker, selectable value for TimeSelect | — |
| `value-format` | `el_time_picker(value_format =)` | optional, only for TimePicker, format of binding value. If not specified, the binding value will be a Date object | string | see [date formats](#id_/en-US/component/date-picker#date-formats) | — |
| `name` | `el_time_picker(name =)` | same as `name` in native input | string | — | — |
| `prefix-icon` | `el_time_picker(prefix_icon =)` | Custom prefix icon class | string | — | el-icon-time |
| `clear-icon` | `el_time_picker(clear_icon =)` | Custom clear icon class | string | — | el-icon-circle-close |

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
