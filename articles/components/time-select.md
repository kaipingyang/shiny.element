# TimeSelect

Use Time Select for time input.

The available time range is 00:00 to 23:59

## Fixed time picker

Provide a list of fixed time for users to choose.

Use `el-time-select` label, then assign start time, end time and time
step with `start`, `end` and `step`.

``` r

el_time_select(
  "slot",
  start = "08:30",
  step = "00:15",
  end = "18:30",
  placeholder = "Select time",
  width = "240px"
)
```

## Time Formats

Use `format` to control format of time(hours and minutes).

Check the list
[here](https://day.js.org/docs/en/display/format#list-of-all-available-formats)
of all available formats of Day.js.

> **Warning**
>
> Pay attention to capitalization

``` r

el_time_select(
  "fmt",
  start = "00:00",
  step = "00:30",
  end = "23:59",
  placeholder = "Select time",
  format = "hh:mm A",
  width = "240px"
)
```

## Fixed time range

If start( end ) time is picked at first, then the status of end( start )
time’s options will change accordingly.

The end’s earliest time follows the start: the server redraws it.

``` r

ui <- el_page(
  el_time_select(
    "start",
    start = "08:30",
    step = "00:15",
    end = "18:30",
    placeholder = "Start time",
    width = "240px"
  ),
  uiOutput("end_ui")
)

server <- function(input, output, session) {
  output$end_ui <- renderUI(el_time_select(
    "end",
    start = "08:30",
    step = "00:15",
    end = "18:30",
    min_time = if (isTruthy(input$start)) input$start,
    value = isolate(input$end),
    placeholder = "End time",
    width = "240px"
  ))
}

shinyApp(ui, server)
```

![The time-range example,
running](../../shots/time-select-time-range.png)

## API

Element Plus’s tables, and beside each entry where it is in R.

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `model-value` | `value`; `input$<id>` | binding value | [^1] |  | — |
| `disabled` | `disabled` | whether TimeSelect is disabled | [^2] |  | false |
| `editable` | `editable` | whether the input is editable | [^3] |  | true |
| `clearable` | `clearable` | whether to show clear button | [^4] |  | true |
| `include-end-time` | `include_end_time` | whether `end` is included in options | [^5] |  | false |
| `size` | `size` | size of Input | [^6]`'large' \\| 'default' \\| 'small'` |  | default |
| `placeholder` | `placeholder` | placeholder in non-range mode | [^7] |  | — |
| `effect` | `effect` | Tooltip theme, built-in theme: `dark` / `light` | [^8] / [^9]`'dark' \\| 'light'` |  | light |
| `prefix-icon` | `prefix_icon` | custom prefix icon component | [^10] / [^11] |  | Clock |
| `clear-icon` | `clear_icon` | custom clear icon component | [^12] / [^13] |  | CircleClose |
| `start` | `start` | start time | [^14] |  | 09:00 |
| `end` | `end` | end time | [^15] |  | 18:00 |
| `step` | `step` | time step | [^16] |  | 00:30 |
| `min-time` | `min_time` | minimum time, any time before this time will be disabled | [^17] |  | — |
| `max-time` | `max_time` | maximum time, any time after this time will be disabled | [^18] |  | — |
| `format` | `format` | set format of time | [^19] see [formats](https://day.js.org/docs/en/display/format#list-of-all-available-formats) |  | HH:mm |
| `empty-values` | `empty_values` | empty values of component, [see config-provider](https://kaipingyang.github.io/shiny.element/articles/components/config-provider.html#empty-values-configurations) | [^20] |  | — |
| `value-on-clear` | `value_on_clear` | clear return value, [see config-provider](https://kaipingyang.github.io/shiny.element/articles/components/config-provider.html#empty-values-configurations) | [^21] / [^22] / [^23] / [^24] |  | — |
| `popper-class` | `popper_class` | custom class name for TimeSelect’s dropdown | [^25] |  | ’’ |
| `popper-style` | `popper_style` | custom style for TimeSelect’s dropdown | [^26] / [^27] |  | — |

### Events

| Element | In R | Description |
|----|----|----|
| `change` | `input$<id>`, the value | triggers when user confirms the value |
| `blur` | `input$<id>_blur`, with `events = "blur"` | triggers when Input blurs |
| `focus` | `input$<id>_focus`, with `events = "focus"` | triggers when Input focuses |
| `clear` | `input$<id>_clear`, with `events = "clear"` | triggers when the clear icon is clicked in a clearable TimeSelect |

### Exposes

| Element | In R                            | Description               |
|---------|---------------------------------|---------------------------|
| `focus` | `call_el(session, id, "focus")` | focus the Input component |
| `blur`  | `call_el(session, id, "blur")`  | blur the Input component  |

[^1]: string

[^2]: boolean

[^3]: boolean

[^4]: boolean

[^5]: boolean

[^6]: enum

[^7]: string

[^8]: string

[^9]: enum

[^10]: string

[^11]: Component

[^12]: string

[^13]: Component

[^14]: string

[^15]: string

[^16]: string

[^17]: string

[^18]: string

[^19]: string

[^20]: array

[^21]: string

[^22]: number

[^23]: boolean

[^24]: Function

[^25]: string

[^26]: string

[^27]: object
