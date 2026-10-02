# Slider

Drag the slider within a fixed range. `input$<id>` is the value – or two
values with `range = TRUE`.

## Basic usage

``` r

el_slider("v1", value = 0, width = "300px")
el_slider("v2", value = 50, width = "300px")
el_slider("v3", value = 36, show_tooltip = FALSE, width = "300px")
el_slider("v4", value = 48, format_tooltip = JS("function(v) { return v / 100; }"), width = "300px")
el_slider("v5", value = 42, disabled = TRUE, width = "300px")
```

## Discrete values

``` r

el_slider("d1", value = 0, step = 10, width = "300px")
el_slider("d2", value = 0, step = 10, show_stops = TRUE, width = "300px")
```

## Slider with input box

``` r

el_slider("withinput", value = 0, show_input = TRUE, width = "500px")
```

## Range selection

``` r

el_slider("rng", value = c(4, 8), range = TRUE, show_stops = TRUE, max = 10, width = "300px")
```

## Vertical mode

``` r

el_slider("vert", value = 0, vertical = TRUE, height = "200px")
```

## Show marks

``` r

el_slider("mk", value = c(30, 60), range = TRUE, width = "400px", marks = list(
  "0" = "0°C", "8" = "8°C", "37" = "37°C",
  "50" = list(style = list(color = "#1989FA"), label = "50%")))
```

## API

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `value` | `value` | binding value | number | — | 0 |
| `min` | `min` | minimum value | number | — | 0 |
| `max` | `max` | maximum value | number | — | 100 |
| `disabled` | `disabled` | whether Slider is disabled | boolean | — | false |
| `step` | `step` | step size | number | — | 1 |
| `show-input` | `show_input` | whether to display an input box, works when `range` is false | boolean | — | false |
| `show-input-controls` | `show_input_controls` | whether to display control buttons when `show-input` is true | boolean | — | true |
| `input-size` | `input_size` | size of the input box | string | large / medium / small / mini | small |
| `show-stops` | `show_stops` | whether to display breakpoints | boolean | — | false |
| `show-tooltip` | `show_tooltip` | whether to display tooltip value | boolean | — | true |
| `format-tooltip` | `format_tooltip` | format to display tooltip value | function(value) | — | — |
| `range` | `range` | whether to select a range | boolean | — | false |
| `vertical` | `vertical` | vertical mode | boolean | — | false |
| `height` | `height` | Slider height, required in vertical mode | string | — | — |
| `label` | `label` | label for screen reader | string | — | — |
| `debounce` | `debounce` | debounce delay when typing, in milliseconds, works when `show-input` is true | number | — | 300 |
| `tooltip-class` | `tooltip_class` | custom class name for the tooltip | string | — | — |
| `marks` | `marks` | marks， type of key must be `number` and must in closed interval `[min, max]`, each mark can custom style | object | — | — |

### Events

| Element | In R | Description |
|----|----|----|
| `change` | `input$<id>`, the value | triggers when the value changes (if the mouse is being dragged, this event only fires when the mouse is released) |
| `input` | `input$<id>_input` | triggers when the data changes (It’ll be emitted in real time during sliding) |
