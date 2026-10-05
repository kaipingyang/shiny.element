# Radio

Single selection among multiple options.

> **Warning**
>
> `label` act as `value` has been **deprecated**, `label` is used only
> as display text, this action **will be** removed in 3.0.0, consider
> switching to new API.

> **Tip**
>
> New API `value` has been added in 2.6.0, the examples in the document
> all use the `value`. If you are using a version **less than** 2.6.0,
> please refer to:

## Basic usage

Radio should not have too many options. Otherwise, use the Select
component instead.

Creating a radio component is easy, you just need to bind a variable to
Radio’s `v-model`. It equals to the value of `value` of the chosen
radio. The type of `value` is `String`, `Number` or `Boolean`.

``` r

tags$div(
  style = "display: grid; gap: 12px",
  el_radio_group(
    "rd_l",
    choices = c("Option 1" = "1", "Option 2" = "2"),
    selected = "1",
    size = "large"
  ),
  el_radio_group(
    "rd_d",
    choices = c("Option 1" = "1", "Option 2" = "2"),
    selected = "1"
  ),
  el_radio_group(
    "rd_s",
    choices = c("Option 1" = "1", "Option 2" = "2"),
    selected = "1",
    size = "small"
  ),
  el_radio_group(
    "rd_x",
    choices = c("Option 1" = "1", "Option 2" = "2"),
    selected = "1",
    size = "small",
    disabled = TRUE
  )
)
```

## Disabled

`disabled` attribute is used to disable the radio.

You just need to add the `disabled` attribute.

``` r

el_radio_group(
  "rd_dis",
  choices = c("Option A" = "a", "Option B" = "b"),
  selected = "a",
  disabled = TRUE
)
```

## Radio Group

Suitable for choosing from some mutually exclusive options.

Combine `el-radio-group` with `el-radio` to display a radio group. Bind
a variable with `v-model` of `el-radio-group` element and set label
value in `el-radio`. It also provides `change` event with the current
value as its parameter.

``` r

el_radio_group(
  "rd_group",
  choices = c("Option A" = 3, "Option B" = 6, "Option C" = 9),
  selected = 3
)
```

## With borders

The `border` attribute adds a border to Radios.

A choice’s `border = TRUE` draws it bordered.

``` r

tags$div(
  style = "display: grid; gap: 12px",
  el_radio_group(
    "rd_b1",
    selected = "1",
    size = "large",
    choices = list(
      list(label = "Option A", value = "1", border = TRUE),
      list(label = "Option B", value = "2", border = TRUE)
    )
  ),
  el_radio_group(
    "rd_b2",
    selected = "1",
    choices = list(
      list(label = "Option A", value = "1", border = TRUE),
      list(label = "Option B", value = "2", border = TRUE)
    )
  )
)
```

## Options attribute

Shortcut from basic `el-radio-group` usage. You can customize the alias
of the `options` through the `props` attribute.

``` r

el_radio_group(
  "rd_opts",
  selected = "Value A",
  props = list(label = "name", value = "id", disabled = "unable"),
  choices = list(
    el_option("Option A", "Value A"),
    el_option("Option B", "Value B"),
    el_option("Option C", "Value C")
  )
)
```

## Radio Button

Radio with button group visual effect.

You just need to change `el-radio` element into `el-radio-button`
element. You can also set the style of the button when it is active by
using `fill` and `text-color`.

``` r

cities <- c("New York", "Washington", "Los Angeles", "Chicago")
tags$div(
  style = "display: grid; gap: 12px",
  el_radio_group(
    "rdb1",
    choices = cities,
    selected = "New York",
    button = TRUE,
    size = "large"
  ),
  el_radio_group(
    "rdb2",
    choices = cities,
    selected = "New York",
    button = TRUE
  ),
  el_radio_group(
    "rdb3",
    choices = cities,
    selected = "New York",
    button = TRUE,
    size = "small"
  )
)
```

## API

Element Plus’s tables, and beside each entry where it is in R.

### Radio Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `model-value` | `value`; `input$<id>` | binding value | [^1] / [^2] / [^3] |  | — |
| `value` | `value` | the value of Radio | [^4] / [^5] / [^6] |  | — |
| `label` | `label` | the label of Radio. If there’s no `value`, `label` will act as `value` | [^7] / [^8] / [^9] |  | — |
| `disabled` | `disabled` | whether Radio is disabled | [^10] |  | false |
| `border` | field `border` of each of `choices` | whether to add a border around Radio | [^11] |  | false |
| `size` | `size` | size of the Radio | [^12]`'large' \\| 'default' \\| 'small'` |  | — |

### Radio Events

| Element  | In R                    | Description                           |
|----------|-------------------------|---------------------------------------|
| `change` | `input$<id>`, the value | triggers when the bound value changes |

### Radio Slots

| Element   | In R            | Description               |
|-----------|-----------------|---------------------------|
| `default` | default content | customize default content |

### RadioGroup Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `model-value` | `value`; `input$<id>` | binding value | [^13] / [^14] / [^15] |  | — |
| `size` | `size` | the size of radio buttons or bordered radios | [^16] |  | default |
| `disabled` | `disabled` | whether the nesting radios are disabled | [^17] |  | false |
| `validate-event` | `validate_event` | whether to trigger form validation | [^18] |  | true |
| `text-color` | `text_color` | font color when button is active | [^19] |  | \#ffffff |
| `fill` | `fill` | border and background color when button is active | [^20] |  | \#409eff |
| `aria-label` | `aria_label` | same as `aria-label` in RadioGroup | [^21] |  | — |
| `id` | `id`, the Shiny input’s | native `id` attribute | [^22] |  | — |
| `label` | `label` | same as `aria-label` in RadioGroup | [^23] |  | — |
| `options` | `options` | data of the options, the key of `value` and `label` and `disabled` can be customize by `props` | [^24]`Array<{[key: string]: any}>` |  | — |
| `props` | `props` | configuration options | [^25]`{ value?: string, label?: string, disabled?: string}` |  | `{value: 'value', label: 'label', disabled: 'disabled'}` |
| `type` | `type` | component type to render options (e.g. `'button'`) | [^26]`'radio' \\| 'button'` |  | ‘radio’ |

### RadioGroup Events

| Element  | In R                    | Description                           |
|----------|-------------------------|---------------------------------------|
| `change` | `input$<id>`, the value | triggers when the bound value changes |

### RadioGroup Slots

| Element   | In R            | Description               |
|-----------|-----------------|---------------------------|
| `default` | default content | customize default content |

### RadioButton Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `value` | `value` | the value of Radio | [^27] / [^28] / [^29] |  | — |
| `label` | `label` | the label of Radio. If there’s no `value`, `label` will act as `value` | [^30] / [^31] / [^32] |  | — |
| `disabled` | `disabled` | whether Radio is disabled | [^33] |  | false |

### RadioButton Slots

| Element   | In R            | Description               |
|-----------|-----------------|---------------------------|
| `default` | default content | customize default content |

[^1]: string

[^2]: number

[^3]: boolean

[^4]: string

[^5]: number

[^6]: boolean

[^7]: string

[^8]: number

[^9]: boolean

[^10]: boolean

[^11]: boolean

[^12]: enum

[^13]: string

[^14]: number

[^15]: boolean

[^16]: string

[^17]: boolean

[^18]: boolean

[^19]: string

[^20]: string

[^21]: string

[^22]: string

[^23]: string

[^24]: array

[^25]: object

[^26]: enum

[^27]: string

[^28]: number

[^29]: boolean

[^30]: string

[^31]: number

[^32]: boolean

[^33]: boolean
