# Switch

Switch is used for switching between two opposing states.

## Basic usage

Bind `v-model` to a `Boolean` typed variable. The `--el-switch-on-color`
and `--el-switch-off-color` CSS variables decides the background color
in two states.

``` r

tagList(
  el_switch("sw1", value = TRUE),
  el_switch("sw2", value = TRUE, active_color = "#13ce66", inactive_color = "#ff4949"))
```

## Sizes

``` r

tags$div(style = "display: flex; gap: 16px; align-items: center",
  el_switch("sw_l", value = TRUE, size = "large", active_text = "Open", inactive_text = "Close"),
  el_switch("sw_d", value = TRUE, active_text = "Open", inactive_text = "Close"),
  el_switch("sw_s", value = TRUE, size = "small", active_text = "Open", inactive_text = "Close"))
```

## Text description

You can add `active-text` and `inactive-text` attribute to show texts.
use `inline-prompt` attribute to control text is displayed inside dot.

You can add `active-text` and `inactive-text` attribute to show texts.

``` r

tags$div(style = "display: grid; gap: 12px",
  el_switch("sw_t1", value = TRUE, active_text = "Pay by month", inactive_text = "Pay by year"),
  el_switch("sw_t2", value = TRUE, inline_prompt = TRUE, active_text = "Y", inactive_text = "N"),
  el_switch("sw_t3", value = TRUE, inline_prompt = TRUE, active_text = "是", inactive_text = "否"))
```

## Display custom icons

> **Tip**
>
> Use the `active-icon` and `inactive-icon` attribute to add icon. You
> can pass either string for the component name (registered in advance)
> or the component itself which is a SVG Vue component. Element Plus has
> provided a set of icon that you can find at
> [icon](https://kaipingyang.github.io/shiny.element/articles/components/icon.md)

You can add `active-icon` and `inactive-icon` attribute to show icons.
use `inline-prompt` attribute to control icon is displayed inside dot.

``` r

tags$div(style = "display: flex; gap: 16px",
  el_switch("sw_i1", value = TRUE, active_icon = "Check", inactive_icon = "Close"),
  el_switch("sw_i2", value = TRUE, inline_prompt = TRUE, active_icon = "Check", inactive_icon = "Close"))
```

## Extended value types

You can set `active-value` and `inactive-value` attributes. They both
receive a `Boolean`, `String` or `Number` typed value.

``` r

el_switch("sw_ext", value = "100", active_value = "100", inactive_value = "0",
          active_color = "#13ce66", inactive_color = "#ff4949")
```

## Disabled

Adding the `disabled` attribute disables Switch.

``` r

tagList(el_switch("sw_dis1", value = TRUE, disabled = TRUE), el_switch("sw_dis2", disabled = TRUE))
```

## Loading

Setting the `loading` attribute to `true` indicates a loading state on
the Switch.

``` r

tagList(el_switch("sw_ld1", value = TRUE, loading = TRUE), el_switch("sw_ld2", loading = TRUE))
```

## Prevent switching

set the `before-change` property, If `false` is returned or a `Promise`
is returned and then is rejected, will stop switching.

`before_change`, a
[`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
function, may hold the switch – return `false`, or a promise.

``` r

el_switch("sw_guard", before_change = JS("function() { return new Promise(function(r) { setTimeout(function() { r(true); }, 1000); }); }"))
```

## Custom action icon

You can add `active-action-icon` and `inactive-action-icon` attribute to
show icons.

``` r

tags$div(style = "display: flex; gap: 16px",
  el_switch("sw_ai1", value = TRUE, active_action_icon = "View", inactive_action_icon = "Hide"))
```

## Custom action slot

You can use `active-action` and `inactive-action` slot to customize
action.

``` r

el_switch("sw_slot", value = TRUE, slots = list(
  `active-action` = tags$span(class = "custom-active-action", "T"),
  `inactive-action` = tags$span(class = "custom-inactive-action", "F")))
```

## API

Element Plus’s tables, and beside each entry where it is in R.

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `model-value` | `value`; `input$<id>` | binding value, it should be equivalent to either `active-value` or `inactive-value`, by default it’s `boolean` type | [^1] / [^2] / [^3] |  | false |
| `disabled` | `disabled` | whether Switch is disabled | [^4] |  | false |
| `loading` | `loading` | whether Switch is in loading state | [^5] |  | false |
| `size` | `size` | size of Switch | [^6]`'' \\| 'large' \\| 'default' \\| 'small'` |  | ’’ |
| `width` | `width` | width of Switch | [^7] / [^8] |  | ’’ |
| `inline-prompt` | `inline_prompt` | whether icon or text is displayed inside dot, only the first character will be rendered for text | [^9] |  | false |
| `active-icon` | `active_icon` | component of the icon displayed when in `on` state, overrides `active-text` | [^10] / [^11] |  | — |
| `inactive-icon` | `inactive_icon` | component of the icon displayed when in `off` state, overrides `inactive-text` | [^12] / [^13] |  | — |
| `active-action-icon` | `active_action_icon` | component of the icon displayed in action when in `on` state | [^14] / [^15] |  | — |
| `inactive-action-icon` | `inactive_action_icon` | component of the icon displayed in action when in `off` state | [^16] / [^17] |  | — |
| `active-text` | `active_text` | text displayed when in `on` state | [^18] |  | ’’ |
| `inactive-text` | `inactive_text` | text displayed when in `off` state | [^19] |  | ’’ |
| `active-value` | `active_value` | switch value when in `on` state | [^20] / [^21] / [^22] |  | true |
| `inactive-value` | `inactive_value` | switch value when in `off` state | [^23] / [^24] / [^25] |  | false |
| `validate-event` | `validate_event` | whether to trigger form validation | [^26] |  | true |
| `before-change` | `before_change` | before-change hook before the switch state changes. If `false` is returned or a `Promise` is returned and then is rejected, will stop switching | [^27]`() => Promise<boolean> \\| boolean` |  | — |
| `id` | `id`, the Shiny input’s | id for input | [^28] |  | — |
| `tabindex` | `tabindex` | tabindex for input | [^29] / [^30] |  | — |
| `aria-label` | `aria_label` | same as `aria-label` in native input | [^31] |  | — |
| `active-color` | `active_color` | background color when in `on` state ( use CSS var `--el-switch-on-color` instead ) | [^32] |  | ’’ |
| `inactive-color` | `inactive_color` | background color when in `off` state ( use CSS var `--el-switch-off-color` instead ) | [^33] |  | ’’ |
| `border-color` | `border_color` | border color of the switch ( use CSS var `--el-switch-border-color` instead ) | [^34] |  | ’’ |
| `label` | `label` | same as `aria-label` in native input | [^35] |  | — |

### Events

| Element  | In R                    | Description                 |
|----------|-------------------------|-----------------------------|
| `change` | `input$<id>`, the value | triggers when value changes |

### Switch Slots

| Element | In R | Description |
|----|----|----|
| `active-action` | `slots = list(active-action = )` | customize active action |
| `inactive-action` | `slots = list(inactive-action = )` | customize inactive action |
| `active` | `slots = list(active = )` | customize active content |
| `inactive` | `slots = list(inactive = )` | customize inactive content |

### Exposes

| Element | In R | Description |
|----|----|----|
| `focus` | `el_call(session, id, "focus")` | manual focus to the switch component |

[^1]: boolean

[^2]: string

[^3]: number

[^4]: boolean

[^5]: boolean

[^6]: enum

[^7]: number

[^8]: string

[^9]: boolean

[^10]: string

[^11]: Component

[^12]: string

[^13]: Component

[^14]: string

[^15]: Component

[^16]: string

[^17]: Component

[^18]: string

[^19]: string

[^20]: boolean

[^21]: string

[^22]: number

[^23]: boolean

[^24]: string

[^25]: number

[^26]: boolean

[^27]: Function

[^28]: string

[^29]: string

[^30]: number

[^31]: string

[^32]: string

[^33]: string

[^34]: string

[^35]: string
