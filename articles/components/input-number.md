# Input

Input numerical values with a customizable range.

## Basic usage

Bind a variable to `v-model` in `<el-input-number>` element and you are
set.

``` r

el_input_number("num", value = 1, min = 1, max = 10)
```

> **Tip**
>
> When inputting invalid string to the input box, input value will emit
> `NaN` to the upper layer as result of error

## Disabled

The `disabled` attribute accepts a `boolean`, and if the value is
`true`, the component is disabled. If you just need to control the value
within a range, you can add `min` attribute to set the minimum value and
`max` to set the maximum value. By default, the minimum value is
`Number.MIN_SAFE_INTEGER`.

``` r

el_input_number("num_dis", value = 1, disabled = TRUE)
```

## Steps

Allows you to define incremental steps.

Add `step` attribute to set the step.

``` r

el_input_number("num_step", value = 5, step = 2)
```

## Step strictly

The `step-strictly` attribute accepts a `boolean`. if this attribute is
`true`, input value can only be multiple of step.

``` r

el_input_number("num_strict", value = 2, step = 2, step_strictly = TRUE)
```

## Precision

Add `precision` attribute to set the precision of input value.

``` r

el_input_number("num_prec", value = 1, precision = 2, step = 0.1, max = 10)
```

> **Tip**
>
> The value of `precision` must be a non negative integer and should not
> be less than the decimal places of `step`.

## Size

Use attribute `size` to set additional sizes with `large` or `small`.

``` r

tags$div(
  style = "display: flex; gap: 16px",
  el_input_number("num_l", value = 1, size = "large"),
  el_input_number("num_d", value = 2),
  el_input_number("num_s", value = 3, size = "small")
)
```

## Controls Position

Set `controls-position` to decide the position of control buttons.

``` r

tags$div(
  style = "display: flex; gap: 16px",
  el_input_number(
    "num_ctl",
    value = 1,
    min = 1,
    max = 10,
    controls_position = "right",
    size = "large"
  ),
  el_input_number(
    "num_ctl2",
    value = 1,
    min = 1,
    max = 10,
    controls_position = "right"
  )
)
```

## Custom Icon

Use `decrease-icon` and `increase-icon` to set custom icons.

``` r

el_input_number(
  "num_custom",
  value = 1,
  min = 1,
  max = 10,
  slots = list(
    `decrease-icon` = el_icon("ArrowDown"),
    `increase-icon` = el_icon("ArrowUp")
  )
)
```

## With prefix and suffix

Use the prefix and suffix named slots.

``` r

tags$div(
  style = "display: grid; gap: 16px",
  el_input_number(
    "num_pre",
    value = 18,
    min = 1,
    max = 100,
    slots = list(prefix = "￥")
  ),
  el_input_number(
    "num_suf",
    value = 100,
    min = 1,
    max = 100,
    slots = list(suffix = "RMB")
  )
)
```

> **Tip**
>
> For precision purposes, the input number is limited from
> [Number.MIN_SAFE_INTEGER](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/MIN_SAFE_INTEGER)
> to
> [Number.MAX_SAFE_INTEGER](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/MAX_SAFE_INTEGER).

## Formatter

Display the value with `formatter`, and typically use `parser` alongside
it.

When `formatter` is set, the inner input `type` changes to `text`, which
allows non-numeric characters to be entered. Internally, the component
processes input with `Number.parseFloat`: when parsing succeeds, the
parsed number is written to `model-value`; when parsing returns `NaN`,
`model-value` is set to `null`.

``` r

el_input_number(
  "num_fmt",
  value = 1234.5,
  formatter = JS(
    "function(value) { return `$ ${value}`.replace(/\\B(?=(\\d{3})+(?!\\d))/g, ','); }"
  ),
  parser = JS("function(value) { return value.replace(/\\$\\s?|(,*)/g, ''); }")
)
```

## API

Element Plus’s tables, and beside each entry where it is in R.

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `model-value` | `value`; `input$<id>` | binding value | [^1] / [^2] |  | — |
| `min` | `min` | the minimum allowed value | [^3] |  | Number.MIN_SAFE_INTEGER |
| `max` | `max` | the maximum allowed value | [^4] |  | Number.MAX_SAFE_INTEGER |
| `step` | `step` | incremental step | [^5] |  | 1 |
| `step-strictly` | `step_strictly` | whether input value can only be multiple of step | [^6] |  | false |
| `precision` | `precision` | precision of input value | [^7] |  | — |
| `size` | `size` | size of the component | [^8]`'large' \\| 'default' \\| 'small'` |  | default |
| `readonly` | `readonly` | same as `readonly` in native input | [^9] |  | false |
| `disabled` | `disabled` | whether the component is disabled | [^10] |  | false |
| `controls` | `controls` | whether to enable the control buttons | [^11] |  | true |
| `controls-position` | `controls_position` | position of the control buttons | [^12]`'' \\| 'right'` |  | — |
| `aria-label` | `aria_label` | same as `aria-label` in native input | [^13] |  | — |
| `placeholder` | `placeholder` | same as `placeholder` in native input | [^14] |  | — |
| `id` | `id`, the Shiny input’s | same as `id` in native input | [^15] |  | — |
| `value-on-clear` | `value_on_clear` | value should be set when input box is cleared | [^16] / [^17] / [^18]`'min' \\| 'max'` |  | — |
| `validate-event` | `validate_event` | whether to trigger form validation | [^19] |  | true |
| `label` | `label` | same as `aria-label` in native input | [^20] |  | — |
| `inputmode` | `inputmode` | same as `inputmode` in native input | [^21] |  | — |
| `align` | `align` | alignment for the inner input text | [^22]`'left' \\| 'center' \\| 'right'` |  | ‘center’ |
| `disabled-scientific` | `disabled_scientific` | disables input of scientific notation (e.g. ‘e’) | [^23] |  | false |
| `tabindex` | `tabindex` | same as `tabindex` in native input | [^24] / [^25] |  | 0 |
| `formatter` | `formatter` | specifies the format of the value presented in the input | [^26]`(value: string) => string` |  | — |
| `parser` | `parser` | specifies the value extracted from the formatted input | [^27]`(value: string) => string` |  | — |

### Slots

| Element | In R | Description |
|----|----|----|
| `decrease-icon` | `slots = list(decrease-icon = )` | custom input box button decrease icon |
| `increase-icon` | `slots = list(increase-icon = )` | custom input box button increase icon |
| `prefix` | `slots = list(prefix = )` | content as Input prefix |
| `suffix` | `slots = list(suffix = )` | content as Input suffix |

### Events

| Element  | In R                    | Description                     |
|----------|-------------------------|---------------------------------|
| `change` | `input$<id>`, the value | triggers when the value changes |
| `blur`   | `input$<id>_blur`       | triggers when Input blurs       |
| `focus`  | `input$<id>_focus`      | triggers when Input focuses     |

### Exposes

| Element | In R                            | Description                      |
|---------|---------------------------------|----------------------------------|
| `focus` | `call_el(session, id, "focus")` | get focus the input component    |
| `blur`  | `call_el(session, id, "blur")`  | remove focus the input component |

[^1]: number

[^2]: null

[^3]: number

[^4]: number

[^5]: number

[^6]: boolean

[^7]: number

[^8]: enum

[^9]: boolean

[^10]: boolean

[^11]: boolean

[^12]: enum

[^13]: string

[^14]: string

[^15]: string

[^16]: number

[^17]: null

[^18]: enum

[^19]: boolean

[^20]: string

[^21]: string

[^22]: enum

[^23]: boolean

[^24]: string

[^25]: number

[^26]: Function

[^27]: Function
