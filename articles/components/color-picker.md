# ColorPicker

ColorPicker is a color selector supporting multiple color formats;
`input$<id>` is the colour as text.

## Basic usage

``` r

el_color_picker("c1", value = "#409EFF")
el_color_picker("c2")
```

## Alpha

``` r

el_color_picker("ca", value = "rgba(19, 206, 102, 0.8)", show_alpha = TRUE)
```

## Predefined colors

``` r

el_color_picker("cp", value = "rgba(255, 69, 0, 0.68)", show_alpha = TRUE, predefine = c(
  "#ff4500", "#ff8c00", "#ffd700", "#90ee90", "#00ced1", "#1e90ff", "#c71585",
  "rgba(255, 69, 0, 0.68)", "rgb(255, 120, 0)", "hsv(51, 100, 98)"))
```

## Sizes

``` r

el_color_picker("s1", value = "#409EFF")
el_color_picker("s2", value = "#409EFF", size = "medium")
el_color_picker("s3", value = "#409EFF", size = "small")
el_color_picker("s4", value = "#409EFF", size = "mini")
```

## API

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `value` | `value` | binding value | string | — | — |
| `disabled` | `disabled` | whether to disable the ColorPicker | boolean | — | false |
| `size` | `size` | size of ColorPicker | string | — | medium / small / mini |
| `show-alpha` | `show_alpha` | whether to display the alpha slider | boolean | — | false |
| `color-format` | `color_format` | color format of v-model | string | hsl / hsv / hex / rgb | hex (when show-alpha is false)/ rgb (when show-alpha is true) |
| `popper-class` | `popper_class` | custom class name for ColorPicker’s dropdown | string | — | — |
| `predefine` | `predefine` | predefined color options | array | — | — |

### Events

| Element | In R | Description |
|----|----|----|
| `change` | `input$<id>`, the value | triggers when input value changes |
| `active-change` | `input$<id>_active_change` | triggers when the current active color changes |
