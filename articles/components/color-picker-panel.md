# ColorPickerPanel

`ColorPickerPanel` is the core component of `ColorPicker`.

## Basic usage

ColorPickerPanel requires a string typed variable to be bound to
v-model.

``` r

el_color_picker_panel("cpp", value = "#409EFF")
```

## Alpha

ColorPickerPanel supports alpha channel selecting. To activate alpha
selecting, just add the `show-alpha` attribute.

``` r

el_color_picker_panel(
  "cpp_alpha",
  value = "rgba(19, 206, 102, 0.8)",
  show_alpha = TRUE
)
```

## Predefined colors

ColorPickerPanel supports predefined color options

``` r

el_color_picker_panel(
  "cpp_pre",
  value = "#ff4500",
  predefine = c(
    "#ff4500",
    "#ff8c00",
    "#ffd700",
    "#90ee90",
    "#00ced1",
    "#1e90ff",
    "#c71585"
  )
)
```

## Border

By default the color-picker-panel is bordered but in some case you don’t
want it.

``` r

el_color_picker_panel("cpp_border", value = "#409EFF", border = FALSE)
```

## Disabled

The `disabled` attribute determines if the color picker is fully
disabled.

``` r

el_color_picker_panel("cpp_dis", value = "#409EFF", disabled = TRUE)
```

## API

Element Plus’s tables, and beside each entry where it is in R.

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `model-value` | `value`; `input$<id>` | binding value | [^1] |  | — |
| `border` | `border` | whether the color picker panel is bordered | [^2] |  | true |
| `disabled` | `disabled` | whether to disable the color picker | [^3] |  | false |
| `show-alpha` | `show_alpha` | whether to display the alpha slider | [^4] |  | false |
| `color-format` | `color_format` | color format of v-model | [^5]`'rgb' \\| 'prgb' \\| 'hex' \\| 'hex3' \\| 'hex4' \\| 'hex6' \\| 'hex8' \\| 'name' \\| 'hsl' \\| 'hsv'` |  | [^6]`'hex' (when show-alpha is false) \\| 'rgb' (when show-alpha is true)` |
| `predefine` | `predefine` | predefined color options | [^7]`string[]` |  | — |
| `validate-event` | `validate_event` | whether to trigger form validation | [^8] |  | true |
| `hue-slider-class` | `hue_slider_class` | class names will be passed to hue-slider | [^9]`string \\| string[] \\| Record<string, boolean>` |  | — |
| `hue-slider-style` | `hue_slider_style` | styles will be passed to hue-slider | [^10] / [^11]`StyleValue` |  | — |

### Slots

| Element  | In R                      | Description                       |
|----------|---------------------------|-----------------------------------|
| `footer` | `slots = list(footer = )` | content to append after the Input |

### Exposes

| Element  | In R                             | Description           |
|----------|----------------------------------|-----------------------|
| `update` | `call_el(session, id, "update")` | update sub components |

[^1]: string

[^2]: boolean

[^3]: boolean

[^4]: boolean

[^5]: enum

[^6]: enum

[^7]: array

[^8]: boolean

[^9]: object

[^10]: string

[^11]: object
