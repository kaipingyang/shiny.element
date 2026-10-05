# Checkbox

A group of options for multiple choices.

> **Warning**
>
> `label` act as `value` has been **deprecated**, `label` is used only
> as display text, this action **will be** removed in 3.0.0, consider
> switching to new API.

> **Tip**
>
> New API `value` has been added in 2.6.0, the examples in the document
> all use the `value`. If you are using a version **less than** 2.6.0
> and using `checkbox-group`, please refer to:

## Basic usage

Checkbox can be used alone to switch between two states.

Define `v-model`(bind variable) in `el-checkbox`. The default value is a
`Boolean` for single `checkbox`, and it becomes `true` when selected.
Content inside the `el-checkbox` tag will become the description
following the button of the checkbox.

``` r

row <- function(...) tags$div(style = "margin: 8px 0", ...)
tagList(
  row(
    el_checkbox("cb1", "Option 1", value = TRUE, size = "large"),
    el_checkbox("cb2", "Option 2", size = "large")
  ),
  row(el_checkbox("cb3", "Option 1"), el_checkbox("cb4", "Option 2")),
  row(
    el_checkbox("cb5", "Option 1", size = "small"),
    el_checkbox("cb6", "Option 2", size = "small")
  )
)
```

## Disabled State

Disabled state for checkbox.

Set the `disabled` attribute.

``` r

tagList(
  el_checkbox("cbd1", "Disabled", disabled = TRUE),
  el_checkbox("cbd2", "Not disabled", value = TRUE)
)
```

## Checkbox group

It is used for multiple checkboxes which are bound in one group, and
indicates whether one option is selected by checking if it is checked.

`checkbox-group` element can manage multiple checkboxes in one group by
using `v-model` which is bound as an `Array`. Inside the `el-checkbox`
element, `value` is the value of the checkbox. If no content is nested
in that tag, `label` will be rendered as the description following the
button of the checkbox. `value` also corresponds with the element values
in the array. It is selected if the specified value exists in the array,
and vice versa.

``` r

el_checkbox_group(
  "cbg",
  selected = c("Value selected and disabled", "Value A"),
  choices = list(
    el_option("Option A", "Value A"),
    el_option("Option B", "Value B"),
    el_option("Option C", "Value C"),
    el_option("disabled", "Value disabled", disabled = TRUE),
    el_option(
      "selected and disabled",
      "Value selected and disabled",
      disabled = TRUE
    )
  )
)
```

## Options attribute

Shortcut from basic `el-checkbox-group` usage. You can customize the
alias of the `options` through the `props` attribute.

Choices given in fields of other names, mapped with `props`.

``` r

el_checkbox_group(
  "cbo",
  selected = c("Value A"),
  props = list(label = "name", value = "id", disabled = "unable"),
  choices = list(
    el_option("Option A", "Value A"),
    el_option("Option B", "Value B"),
    el_option("Option C", "Value C")
  )
)
```

## Indeterminate

The `indeterminate` property can help you to achieve a ‘check all’
effect.

“Check all” ticks the group from the server, as Element Plus’s demo does
in its handler:
`observeEvent(input$all, update_el_checkbox_group(...))`.

``` r

tagList(
  el_checkbox("all", "Check all", indeterminate = TRUE),
  el_checkbox_group(
    "cities",
    choices = c("Shanghai", "Beijing", "Guangzhou", "Shenzhen"),
    selected = c("Shanghai", "Beijing")
  )
)
```

## Minimum / Maximum items checked

The `min` and `max` properties can help you to limit the number of
checked items.

``` r

el_checkbox_group(
  "cities_lim",
  choices = c("Shanghai", "Beijing", "Guangzhou", "Shenzhen"),
  selected = c("Shanghai", "Beijing"),
  min = 1,
  max = 2
)
```

## Button style

Checkbox with button styles.

You just need to change `el-checkbox` element into `el-checkbox-button`
element. We also provide `size` attribute.

``` r

cities <- c("Shanghai", "Beijing", "Guangzhou", "Shenzhen")
tags$div(
  style = "display: grid; gap: 16px",
  el_checkbox_group(
    "cbb1",
    choices = cities,
    selected = "Shanghai",
    button = TRUE,
    size = "large"
  ),
  el_checkbox_group(
    "cbb2",
    choices = cities,
    selected = "Shanghai",
    button = TRUE
  ),
  el_checkbox_group(
    "cbb3",
    choices = cities,
    selected = "Shanghai",
    button = TRUE,
    size = "small"
  ),
  el_checkbox_group(
    "cbb4",
    choices = cities,
    selected = "Shanghai",
    button = TRUE,
    size = "small",
    disabled = TRUE
  )
)
```

## With borders

The `border` attribute adds a border to Checkboxes.

``` r

row <- function(...) tags$div(style = "margin-top: 16px", ...)
tagList(
  row(
    el_checkbox("cbr1", "Option1", value = TRUE, size = "large", border = TRUE),
    el_checkbox("cbr2", "Option2", size = "large", border = TRUE)
  ),
  row(
    el_checkbox("cbr3", "Option1", border = TRUE),
    el_checkbox("cbr4", "Option2", value = TRUE, border = TRUE)
  )
)
```

## API

Element Plus’s tables, and beside each entry where it is in R.

### Checkbox Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `model-value` | `value`; `input$<id>` | binding value | [^1] / [^2] / [^3] |  | — |
| `value` | `el_checkbox(value =)` | value of the Checkbox when used inside a `checkbox-group` | [^4] / [^5] / [^6] / [^7] |  | — |
| `label` | `el_checkbox(label =)` | label of the Checkbox when used inside a `checkbox-group`. If there’s no value, `label` will act as `value` | [^8] / [^9] / [^10] / [^11] |  | — |
| `true-value` | `el_checkbox(true_value =)` | value of the Checkbox if it’s checked | [^12] / [^13] |  | — |
| `false-value` | `el_checkbox(false_value =)` | value of the Checkbox if it’s not checked | [^14] / [^15] |  | — |
| `disabled` | `el_checkbox(disabled =)` | whether the Checkbox is disabled | [^16] |  | false |
| `border` | `el_checkbox(border =)` | whether to add a border around Checkbox | [^17] |  | false |
| `size` | `el_checkbox(size =)` | size of the Checkbox | [^18]`'large' \\| 'default' \\| 'small'` |  | — |
| `checked` | `value`; `input$<id>` | if the Checkbox is checked | [^19] |  | false |
| `indeterminate` | `el_checkbox(indeterminate =)` | Set indeterminate state, only responsible for style control | [^20] |  | false |
| `validate-event` | `el_checkbox(validate_event =)` | whether to trigger form validation | [^21] |  | true |
| `tabindex` | `el_checkbox(tabindex =)` | input tabindex | [^22] / [^23] |  | — |
| `id` | `id`, the Shiny input’s | input id | [^24] |  | — |
| `aria-controls` | `el_checkbox(aria_controls =)` | same as [aria-controls](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Attributes/aria-controls), takes effect when `indeterminate` is `true` | [^25] |  | — |
| `aria-label` | `el_checkbox(aria_label =)` | native `aria-label` attribute | [^26] |  | — |
| `true-label` | `el_checkbox(true_label =)` | value of the Checkbox if it’s checked | [^27] / [^28] |  | — |
| `false-label` | `el_checkbox(false_label =)` | value of the Checkbox if it’s not checked | [^29] / [^30] |  | — |
| `controls` | `el_checkbox(controls =)` | same as [aria-controls](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Attributes/aria-controls), takes effect when `indeterminate` is `true` | [^31] |  | — |

### Checkbox Events

| Element  | In R                    | Description                             |
|----------|-------------------------|-----------------------------------------|
| `change` | `input$<id>`, the value | triggers when the binding value changes |

### Checkbox Slots

| Element   | In R            | Description               |
|-----------|-----------------|---------------------------|
| `default` | default content | customize default content |

### CheckboxGroup Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `model-value` | `value`; `input$<id>` | binding value | [^32]`string[] \\| number[]` |  | \[\] |
| `size` | `el_checkbox(size =)` | size of checkbox | [^33]`'large' \\| 'default' \\| 'small'` |  | — |
| `disabled` | `el_checkbox(disabled =)` | whether the nesting checkboxes are disabled | [^34] |  | false |
| `min` | `el_checkbox_group(min =)` | minimum number of checkbox checked | [^35] |  | — |
| `max` | `el_checkbox_group(max =)` | maximum number of checkbox checked | [^36] |  | — |
| `aria-label` | `el_checkbox(aria_label =)` | native `aria-label` attribute | [^37] |  | — |
| `text-color` | `el_checkbox_group(text_color =)` | font color when button is active | [^38] |  | \#ffffff |
| `fill` | `el_checkbox_group(fill =)` | border and background color when button is active | [^39] |  | \#409eff |
| `tag` | `el_checkbox_group(tag =)` | element tag of the checkbox group | [^40] |  | div |
| `validate-event` | `el_checkbox(validate_event =)` | whether to trigger form validation | [^41] |  | true |
| `label` | `el_checkbox(label =)` | native `aria-label` attribute | [^42] |  | — |
| `options` | `el_checkbox_group(options =)` | data of the options, the key of `value` and `label` and `disabled` can be customize by `props` | [^43]`Array<{[key: string]: any}>` |  | — |
| `props` | `el_checkbox_group(props =)` | configuration options | [^44]`{ value?: string, label?: string, disabled?: string}` |  | `{value: 'value', label: 'label', disabled: 'disabled'}` |
| `type` | `el_checkbox_group(type =)` | component type to render options (e.g. `'button'`) | [^45]`'checkbox' \\| 'button'` |  | ‘checkbox’ |

### CheckboxGroup Events

| Element  | In R                    | Description                             |
|----------|-------------------------|-----------------------------------------|
| `change` | `input$<id>`, the value | triggers when the binding value changes |

### CheckboxGroup Slots

| Element   | In R            | Description               |
|-----------|-----------------|---------------------------|
| `default` | default content | customize default content |

### CheckboxButton Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `value` | `el_checkbox(value =)` | value of the checkbox when used inside a `checkbox-group` | [^46] / [^47] / [^48] / [^49] |  | — |
| `label` | `el_checkbox(label =)` | label of the checkbox when used inside a `checkbox-group`. If there’s no value, `label` will act as `value` | [^50] / [^51] / [^52] / [^53] |  | — |
| `true-value` | `el_checkbox(true_value =)` | value of the checkbox if it’s checked | [^54] / [^55] |  | — |
| `false-value` | `el_checkbox(false_value =)` | value of the checkbox if it’s not checked | [^56] / [^57] |  | — |
| `disabled` | `el_checkbox(disabled =)` | whether the checkbox is disabled | [^58] |  | false |
| `checked` | `value`; `input$<id>` | if the checkbox is checked | [^59] |  | false |
| `true-label` | `el_checkbox(true_label =)` | value of the checkbox if it’s checked | [^60] / [^61] |  | — |
| `false-label` | `el_checkbox(false_label =)` | value of the checkbox if it’s not checked | [^62] / [^63] |  | — |

### CheckboxButton Slots

| Element   | In R            | Description               |
|-----------|-----------------|---------------------------|
| `default` | default content | customize default content |

[^1]: string

[^2]: number

[^3]: boolean

[^4]: string

[^5]: number

[^6]: boolean

[^7]: object

[^8]: string

[^9]: number

[^10]: boolean

[^11]: object

[^12]: string

[^13]: number

[^14]: string

[^15]: number

[^16]: boolean

[^17]: boolean

[^18]: enum

[^19]: boolean

[^20]: boolean

[^21]: boolean

[^22]: string

[^23]: number

[^24]: string

[^25]: string

[^26]: string

[^27]: string

[^28]: number

[^29]: string

[^30]: number

[^31]: string

[^32]: array

[^33]: enum

[^34]: boolean

[^35]: number

[^36]: number

[^37]: string

[^38]: string

[^39]: string

[^40]: string

[^41]: boolean

[^42]: string

[^43]: array

[^44]: object

[^45]: enum

[^46]: string

[^47]: number

[^48]: boolean

[^49]: object

[^50]: string

[^51]: number

[^52]: boolean

[^53]: object

[^54]: string

[^55]: number

[^56]: string

[^57]: number

[^58]: boolean

[^59]: boolean

[^60]: string

[^61]: number

[^62]: string

[^63]: number
