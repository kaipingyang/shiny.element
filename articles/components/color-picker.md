# ColorPicker

ColorPicker is a color selector supporting multiple color formats.

## Basic usage

ColorPicker requires a string typed variable to be bound to v-model.

``` r

tagList(
  tags$div(
    tags$span("With default value"),
    el_color_picker("cp1", value = "#409EFF")
  ),
  tags$div(tags$span("With no default value"), el_color_picker("cp2"))
)
```

With default value

With no default value

## Alpha

ColorPicker supports alpha channel selecting. To activate alpha
selecting, just add the `show-alpha` attribute.

``` r

el_color_picker(
  "cp_alpha",
  value = "rgba(19, 206, 102, 0.8)",
  show_alpha = TRUE
)
```

## Predefined colors

ColorPicker supports predefined color options

``` r

el_color_picker(
  "cp_pre",
  value = "rgba(255, 69, 0, 0.68)",
  show_alpha = TRUE,
  predefine = c(
    "#ff4500",
    "#ff8c00",
    "#ffd700",
    "#90ee90",
    "#00ced1",
    "#1e90ff",
    "#c71585",
    "rgba(255, 69, 0, 0.68)",
    "rgb(255, 120, 0)",
    "hsv(51, 100, 98)"
  )
)
```

## Sizes

``` r

tagList(
  el_color_picker("cp_l", value = "#409EFF", size = "large"),
  el_color_picker("cp_d", value = "#409EFF"),
  el_color_picker("cp_s", value = "#409EFF", size = "small")
)
```

## API

Element Plus’s tables, and beside each entry where it is in R.

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `model-value` | `value`; `input$<id>` | binding value | [^1] |  | — |
| `disabled` | `disabled` | whether to disable the ColorPicker | [^2] |  | false |
| `clearable` | `clearable` | whether to show clear button | [^3] |  | true |
| `size` | `size` | size of ColorPicker | [^4]`'large' \\| 'default' \\| 'small'` |  | — |
| `show-alpha` | `show_alpha` | whether to display the alpha slider | [^5] |  | false |
| `color-format` | `color_format` | color format of v-model | [^6]`'rgb' \\| 'prgb' \\| 'hex' \\| 'hex3' \\| 'hex4' \\| 'hex6' \\| 'hex8' \\| 'name' \\| 'hsl' \\| 'hsv'` |  | [^7]`'hex' (when show-alpha is false) \\| 'rgb' (when show-alpha is true)` |
| `popper-class` | `popper_class` | custom class name for ColorPicker’s dropdown | [^8] / [^9] |  | ’’ |
| `popper-style` | `popper_style` | custom style for ColorPicker’s dropdown | [^10] / [^11] |  | — |
| `predefine` | `predefine` | predefined color options | [^12]`string[]` |  | — |
| `validate-event` | `validate_event` | whether to trigger form validation | [^13] |  | true |
| `tabindex` | `tabindex` | ColorPicker tabindex | [^14] / [^15] |  | 0 |
| `aria-label` | `aria_label` | ColorPicker aria-label | [^16] |  | — |
| `empty-values` | `empty_values` | empty values of component, [see config-provider](https://kaipingyang.github.io/shiny.element/articles/components/config-provider.html#empty-values-configurations) | [^17] |  | — |
| `value-on-clear` | `value_on_clear` | clear return value, [see config-provider](https://kaipingyang.github.io/shiny.element/articles/components/config-provider.html#empty-values-configurations) | [^18] / [^19] / [^20] / [^21] |  | — |
| `id` | `id`, the Shiny input’s | ColorPicker id | [^22] |  | — |
| `teleported` | `teleported` | whether color-picker popper is teleported to the body | [^23] |  | true |
| `label` | `label` | ColorPicker aria-label | [^24] |  | — |
| `persistent` | `persistent` | when color-picker inactive and persistent is false, the color panel will be destroyed | [^25] |  | true |
| `append-to` | `append_to` | which element the color-picker panel appends to | [^26] / [^27] |  | \- |

### Events

| Element | In R | Description |
|----|----|----|
| `change` | `input$<id>`, the value | triggers when input value changes |
| `active-change` | `input$<id>_active_change` | triggers when the current active color changes |
| `focus` | `input$<id>_focus` | triggers when Component focuses |
| `blur` | `input$<id>_blur` | triggers when Component blurs |
| `clear` | `input$<id>_clear` | triggers when the clear button is clicked |

### Exposes

| Element | In R                            | Description               |
|---------|---------------------------------|---------------------------|
| `show`  | `el_call(session, id, "show")`  | manually show ColorPicker |
| `hide`  | `el_call(session, id, "hide")`  | manually hide ColorPicker |
| `focus` | `el_call(session, id, "focus")` | focus the picker element  |
| `blur`  | `el_call(session, id, "blur")`  | blur the picker element   |

[^1]: string

[^2]: boolean

[^3]: boolean

[^4]: enum

[^5]: boolean

[^6]: enum

[^7]: enum

[^8]: string

[^9]: object

[^10]: string

[^11]: object

[^12]: array

[^13]: boolean

[^14]: string

[^15]: number

[^16]: string

[^17]: array

[^18]: string

[^19]: number

[^20]: boolean

[^21]: Function

[^22]: string

[^23]: boolean

[^24]: string

[^25]: boolean

[^26]: CSSSelector

[^27]: HTMLElement
