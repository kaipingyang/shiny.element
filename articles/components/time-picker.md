# TimePicker

Use Time Picker for time input.

## Arbitrary time picker

Can pick an arbitrary time.

By default, you can scroll the mouse wheel to pick time, alternatively
you can use the control arrows when the `arrow-control` attribute is
set.

``` r

tagList(
  el_time_picker("t1", placeholder = "Arbitrary time"),
  el_time_picker("t2", arrow_control = TRUE, placeholder = "Arbitrary time")
)
```

## Limit the time range

You can also limit the time range.

Limit the time range by specifying `disabledHours` `disabledMinutes` and
`disabledSeconds`.

`disabled_hours`, `disabled_minutes` and `disabled_seconds` limit what
can be picked – here, 17:30 to 18:30.

``` r

el_time_picker(
  "lim",
  value = "18:30:00",
  placeholder = "Arbitrary time",
  disabled_hours = JS(
    "function() { var r = []; for (var h = 0; h < 24; h++) if (h < 17 || h > 18) r.push(h); return r; }"
  ),
  disabled_minutes = JS(
    "function(h) { var r = []; for (var m = 0; m < 60; m++) if ((h === 17 && m < 30) || (h === 18 && m > 30)) r.push(m); return r; }"
  )
)
```

## Arbitrary time range

Can pick an arbitrary time range.

We can pick a time range by adding an `is-range` attribute. Also,
`arrow-control` is supported in range mode.

``` r

tagList(
  el_time_picker(
    "r1",
    is_range = TRUE,
    value = c("08:40:00", "09:40:00"),
    range_separator = "To",
    start_placeholder = "Start time",
    end_placeholder = "End time"
  ),
  el_time_picker(
    "r2",
    is_range = TRUE,
    arrow_control = TRUE,
    value = c("08:40:00", "09:40:00"),
    range_separator = "To",
    start_placeholder = "Start time",
    end_placeholder = "End time"
  )
)
```

## API

Element Plus’s tables, and beside each entry where it is in R.

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `model-value` | `value`; `input$<id>` | binding value, if it is an array, the length should be 2 | [^1] / [^2] / [^3]`Date \\| [Date, Date] \\| [number, number] \\| [string, string]` |  | ’’ |
| `readonly` | `readonly` | whether TimePicker is read only | [^4] |  | false |
| `disabled` | `disabled` | whether TimePicker is disabled | [^5] |  | false |
| `editable` | `editable` | whether the input is editable | [^6] |  | true |
| `clearable` | `clearable` | whether to show clear button | [^7] |  | true |
| `size` | `size` | size of Input | [^8]`'large' \\| 'default' \\| 'small'` |  | — |
| `placeholder` | `placeholder` | placeholder in non-range mode | [^9] |  | ’’ |
| `start-placeholder` | `start_placeholder` | placeholder for the start time in range mode | [^10] |  | — |
| `end-placeholder` | `end_placeholder` | placeholder for the end time in range mode | [^11] |  | — |
| `is-range` | `is_range` | whether to pick a time range | [^12] |  | false |
| `arrow-control` | `arrow_control` | whether to pick time using arrow buttons | [^13] |  | false |
| `popper-class` | `popper_class` | custom class name for TimePicker’s dropdown | [^14] |  | ’’ |
| `popper-style` | `popper_style` | custom style for TimePicker’s dropdown | [^15] / [^16] |  | — |
| `popper-options` | `popper_options` | Customized popper option see more at [popper.js](https://popper.js.org/docs/v2/) | [^17]`Partial<PopperOptions>` |  | {} |
| `fallback-placements` | `fallback_placements` | list of possible positions for Tooltip [popper.js](https://popper.js.org/docs/v2/modifiers/flip/#fallbackplacements) | [^18]`Placement[]` |  | \[‘bottom’, ‘top’, ‘right’, ‘left’\] |
| `placement` | `placement` | position of dropdown | `Placement` |  | bottom |
| `range-separator` | `range_separator` | range separator | [^19] |  | ‘-’ |
| `format` | `format` | format of the displayed value in the input box | [^20] see [date formats](https://kaipingyang.github.io/shiny.element/articles/components/date-picker.html#date-formats) |  | — |
| `default-value` | `default_value` | optional, default date of the calendar | [^21] / [^22]`[Date, Date]` |  | — |
| `value-format` | `value_format` | optional, format of binding value. If not specified, the binding value will be a Date object | [^23] see [date formats](https://kaipingyang.github.io/shiny.element/articles/components/date-picker.html#date-formats) |  | — |
| `id` | `id`, the Shiny input’s | same as `id` in native input | [^24] / [^25]`[string, string]` |  | — |
| `aria-label` | `aria_label` | same as `aria-label` in native input | [^26] |  | — |
| `prefix-icon` | `prefix_icon` | Custom prefix icon component | [^27] / [^28] |  | Clock |
| `clear-icon` | `clear_icon` | Custom clear icon component | [^29] / [^30] |  | CircleClose |
| `disabled-hours` | `disabled_hours` | To specify the array of hours that cannot be selected | [^31]`(role: string, comparingDate?: Dayjs) => number[]` |  | — |
| `disabled-minutes` | `disabled_minutes` | To specify the array of minutes that cannot be selected | [^32]`(hour: number, role: string, comparingDate?: Dayjs) => number[]` |  | — |
| `disabled-seconds` | `disabled_seconds` | To specify the array of seconds that cannot be selected | [^33]`(hour: number, minute: number, role: string, comparingDate?: Dayjs) => number[]` |  | — |
| `teleported` | `teleported` | whether time-picker dropdown is teleported to the body | [^34] |  | true |
| `tabindex` | `tabindex` | input tabindex | [^35] / [^36] |  | 0 |
| `empty-values` | `empty_values` | empty values of component, [see config-provider](https://kaipingyang.github.io/shiny.element/articles/components/config-provider.html#empty-values-configurations) | [^37] |  | — |
| `value-on-clear` | `value_on_clear` | clear return value, [see config-provider](https://kaipingyang.github.io/shiny.element/articles/components/config-provider.html#empty-values-configurations) | [^38] / [^39] / [^40] / [^41] |  | — |
| `save-on-blur` | `save_on_blur` | Whether to auto-fill the input with the current time on focus when no value is selected | [^42] |  | true |
| `label` | `label` | same as `aria-label` in native input | [^43] |  | — |

### Events

| Element | In R | Description |
|----|----|----|
| `change` | `input$<id>`, the value | triggers when user confirms the value |
| `blur` | `input$<id>_blur` | triggers when Input blurs |
| `focus` | `input$<id>_focus` | triggers when Input focuses |
| `clear` | `input$<id>_clear` | triggers when the clear icon is clicked in a clearable TimePicker |
| `visible-change` | `input$<id>_visible_change` | triggers when the TimePicker’s dropdown appears/disappears |

### Exposes

| Element | In R | Description |
|----|----|----|
| `focus` | `call_el(session, id, "focus")` | focus the TimePicker component |
| `blur` | `call_el(session, id, "blur")` | blur the TimePicker component |
| `handleOpen` | `call_el(session, id, "handleOpen")` | open the TimePicker popper |
| `handleClose` | `call_el(session, id, "handleClose")` | close the TimePicker popper |

[^1]: number

[^2]: string

[^3]: object

[^4]: boolean

[^5]: boolean

[^6]: boolean

[^7]: boolean

[^8]: enum

[^9]: string

[^10]: string

[^11]: string

[^12]: boolean

[^13]: boolean

[^14]: string

[^15]: string

[^16]: object

[^17]: object

[^18]: array

[^19]: string

[^20]: string

[^21]: Date

[^22]: array

[^23]: string

[^24]: string

[^25]: array

[^26]: string

[^27]: string

[^28]: Component

[^29]: string

[^30]: Component

[^31]: Function

[^32]: Function

[^33]: Function

[^34]: boolean

[^35]: string

[^36]: number

[^37]: array

[^38]: string

[^39]: number

[^40]: boolean

[^41]: Function

[^42]: boolean

[^43]: string
