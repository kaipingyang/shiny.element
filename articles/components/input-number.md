# InputNumber

Input numerical values with a customizable range. `input$<id>` is the
number, reported a quarter-second after the last change.

## Basic usage

``` r

el_input_number("num", value = 1, min = 1, max = 10)
```

## Disabled

``` r

el_input_number("num_d", value = 1, disabled = TRUE)
```

## Steps

``` r

el_input_number("num_s", value = 5, step = 2)
```

## Step strictly

Only multiples of the step.

``` r

el_input_number("num_ss", value = 2, step = 2, step_strictly = TRUE)
```

## Precision

``` r

el_input_number("num_p", value = 1, precision = 2, step = 0.1, max = 10)
```

## Size

``` r

el_input_number("n1", value = 1)
el_input_number("n2", value = 1, size = "medium")
el_input_number("n3", value = 1, size = "small")
el_input_number("n4", value = 1, size = "mini")
```

## Controls position

``` r

el_input_number("num_r", value = 1, min = 1, max = 10, controls_position = "right")
```

## API

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `value` | `value` | binding value | number | — | 0 |
| `min` | `min` | the minimum allowed value | number | — | `-Infinity` |
| `max` | `max` | the maximum allowed value | number | — | `Infinity` |
| `step` | `step` | incremental step | number | — | 1 |
| `step-strictly` | `step_strictly` | whether input value can only be multiple of step | boolean | — | false |
| `precision` | `precision` | precision of input value | number | — | — |
| `size` | `size` | size of the component | string | large/small | — |
| `disabled` | `disabled` | whether the component is disabled | boolean | — | false |
| `controls` | `controls` | whether to enable the control buttons | boolean | — | true |
| `controls-position` | `controls_position` | position of the control buttons | string | right | \- |
| `name` | `name` | same as `name` in native input | string | — | — |
| `label` | `label` | label text | string | — | — |
| `placeholder` | `placeholder` | placeholder in input | string | \- | \- |

### Events

| Element  | In R                    | Description                     |
|----------|-------------------------|---------------------------------|
| `change` | `input$<id>`, the value | triggers when the value changes |
| `blur`   | `input$<id>_blur`       | triggers when Input blurs       |
| `focus`  | `input$<id>_focus`      | triggers when Input focuses     |

### Methods

| Element  | In R                             | Description                      |
|----------|----------------------------------|----------------------------------|
| `focus`  | `el_call(session, id, "focus")`  | focus the Input component        |
| `select` | `el_call(session, id, "select")` | select the text in input element |
