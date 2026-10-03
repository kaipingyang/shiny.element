# Slider

Drag the slider within a fixed range.

## Basic usage

The current value is displayed when the slider is being dragged.

Customize the initial value of the slider by setting the binding value.

``` r

tags$div(
  style = "max-width: 600px",
  tags$span("Default value"),
  el_slider("sl1", value = 0),
  tags$span("Customized initial value"),
  el_slider("sl2", value = 50),
  tags$span("Hide Tooltip"),
  el_slider("sl3", value = 36, show_tooltip = FALSE),
  tags$span("Format Tooltip"),
  el_slider(
    "sl4",
    value = 48,
    format_tooltip = JS("function(v) { return v / 100; }")
  ),
  tags$span("Disabled"),
  el_slider("sl5", value = 42, disabled = TRUE)
)
```

Default value

Customized initial value

Hide Tooltip

Format Tooltip

Disabled

## Discrete values

The options can be discrete.

Set step size with the `step` attribute. You can display breakpoints by
setting the `show-stops` attribute.

``` r

tags$div(
  style = "max-width: 600px",
  tags$span("Breakpoints not displayed"),
  el_slider("sld1", value = 0, step = 10),
  tags$span("Breakpoints displayed"),
  el_slider("sld2", value = 0, step = 10, show_stops = TRUE)
)
```

Breakpoints not displayed

Breakpoints displayed

## Slider with input box

Set value via a input box.

Set the `show-input` attribute to display an input box on the right.

``` r

el_slider("sl_input", value = 0, show_input = TRUE, width = "600px")
```

## Sizes

``` r

tags$div(
  style = "max-width: 600px",
  el_slider("sls_l", value = 0, show_input = TRUE, size = "large"),
  el_slider("sls_d", value = 0, show_input = TRUE),
  el_slider("sls_s", value = 0, show_input = TRUE, size = "small")
)
```

## Placement

You can custom tooltip placement.

``` r

tags$div(
  style = "max-width: 600px; padding-top: 40px",
  el_slider("slp1", value = 0, placement = "top"),
  el_slider("slp2", value = 0, placement = "bottom"),
  el_slider("slp3", value = 0, placement = "right"),
  el_slider("slp4", value = 0, placement = "left")
)
```

## Range selection

Selecting a range of values is supported.

Setting the `range` attribute activates range mode, where the binding
value is an array made up of two boundary values.

``` r

el_slider(
  "sl_range",
  value = c(4, 8),
  range = TRUE,
  show_stops = TRUE,
  max = 10,
  width = "600px"
)
```

## Vertical mode

Setting the `vertical` attribute to `true` enables vertical mode. In
vertical mode, the `height` attribute is required.

``` r

el_slider("sl_vert", value = 0, vertical = TRUE, height = "200px")
```

## Show marks

Setting this `marks` attribute can show mark on slider.

``` r

el_slider(
  "sl_marks",
  value = c(30, 60),
  range = TRUE,
  width = "600px",
  marks = list(
    "0" = "0°C",
    "8" = "8°C",
    "37" = "37°C",
    "50" = list(style = list(color = "#1989FA"), label = "50%")
  )
)
```

## Restrict value

Set `step="mark"` to restrict the slider value to marks.

`min` and `max` bound what can be picked.

``` r

el_slider("sl_restrict", value = 20, min = 10, max = 80, width = "600px")
```

## API

Element Plus’s tables, and beside each entry where it is in R.

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `model-value` | `value`; `input$<id>` | binding value | [^1] / [^2]`number[]` |  | 0 |
| `min` | `min` | minimum value | [^3] |  | 0 |
| `max` | `max` | maximum value | [^4] |  | 100 |
| `disabled` | `disabled` | whether Slider is disabled | [^5] |  | false |
| `step` | `step` | step size, can be a number or `'mark'` ^(2.13.6) to restrict values to marks. When set to `'mark'`, the `marks` attribute must be set | [^6] / [^7]`'mark'` |  | 1 |
| `show-input` | `show_input` | whether to display an input box, works when `range` is false and `step` is not `'mark'` | [^8] |  | false |
| `show-input-controls` | `show_input_controls` | whether to display control buttons when `show-input` is true | [^9] |  | true |
| `size` | `size` | size of the slider wrapper, will not work in vertical mode | [^10]`'' \\| 'large' \\| 'default' \\| 'small'` |  | default |
| `input-size` | `input_size` | size of the input box, when set `size`, the default is the value of `size` | [^11]`'' \\| 'large' \\| 'default' \\| 'small'` |  | default |
| `show-stops` | `show_stops` | whether to display breakpoints | [^12] |  | false |
| `show-tooltip` | `show_tooltip` | whether to display tooltip value | [^13] |  | true |
| `format-tooltip` | `format_tooltip` | format to display tooltip value | [^14]`(value: number) => number \\| string` |  | — |
| `range` | `range` | whether to select a range | [^15] |  | false |
| `vertical` | `vertical` | vertical mode | [^16] |  | false |
| `height` | `height` | slider height, required in vertical mode | [^17] |  | — |
| `aria-label` | `aria_label` | native `aria-label` attribute | [^18] |  | — |
| `range-start-label` | `range_start_label` | when `range` is true, screen reader label for the start of the range | [^19] |  | — |
| `range-end-label` | `range_end_label` | when `range` is true, screen reader label for the end of the range | [^20] |  | — |
| `format-value-text` | `format_value_text` | format to display the `aria-valuenow` attribute for screen readers | [^21]`(value: number) => string` |  | — |
| `tooltip-class` | `tooltip_class` | custom class name for the tooltip | [^22] |  | — |
| `placement` | `placement` | position of Tooltip | [^23]`'top' \\| 'top-start' \\| 'top-end' \\| 'bottom' \\| 'bottom-start' \\| 'bottom-end' \\| 'left' \\| 'left-start' \\| 'left-end' \\| 'right' \\| 'right-start' \\| 'right-end'` |  | top |
| `marks` | `marks` | marks, type of key must be `number` and must in closed interval `[min, max]`, each mark can custom style | [^24]`SliderMarks` |  | — |
| `validate-event` | `validate_event` | whether to trigger form validation | [^25] |  | true |
| `persistent` | `persistent` | when slider tooltip inactive and `persistent` is `false` , tooltip will be destroyed. `persistent` always be `false` when `show-tooltip` is `false` | [^26] |  | true |
| `label` | `label` | native `aria-label` attribute | [^27] |  | — |

### Events

| Element | In R | Description |
|----|----|----|
| `change` | `input$<id>`, the value | triggers when the value changes (if the mouse is being dragged, this event only fires when the mouse is released) |
| `input` | `input$<id>_input` | triggers when the data changes (It’ll be emitted in real time during sliding) |

[^1]: number

[^2]: array

[^3]: number

[^4]: number

[^5]: boolean

[^6]: number

[^7]: string

[^8]: boolean

[^9]: boolean

[^10]: enum

[^11]: enum

[^12]: boolean

[^13]: boolean

[^14]: Function

[^15]: boolean

[^16]: boolean

[^17]: string

[^18]: string

[^19]: string

[^20]: string

[^21]: Function

[^22]: string

[^23]: enum

[^24]: object

[^25]: boolean

[^26]: boolean

[^27]: string
