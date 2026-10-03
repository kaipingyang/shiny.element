# Segmented

Display multiple options and allow users to select a single option.

## Basic Usage

Set `v-model` to the option value is selected.

``` r

days <- c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")
tags$div(style = "display: grid; gap: 16px; justify-items: start",
  el_segmented("seg_l", options = days, value = "Mon", size = "large"),
  el_segmented("seg_d", options = days, value = "Mon"),
  el_segmented("seg_s", options = days, value = "Mon", size = "small"))
```

## Direction Usage

Set `vertical` to change direction.

``` r

el_segmented("seg_v", direction = "vertical", value = "Apple",
             options = c("Apple", "Cherry", "Grape", "Orange", "Pear"))
```

## Disabled

Set `disabled` of segmented or option to `true` to disable it.

``` r

opts <- list(list(label = "Mon", value = "Mon"), list(label = "Tue", value = "Tue", disabled = TRUE),
             list(label = "Wed", value = "Wed"))
tags$div(style = "display: grid; gap: 16px; justify-items: start",
  el_segmented("seg_dis1", options = opts, value = "Mon", disabled = TRUE),
  el_segmented("seg_dis2", options = opts, value = "Mon"))
```

## Aliases for custom options

When your `options` format is different from the default format, you can
customize the alias of the `options` through the `props` attribute

Element Plus’s `props` names the fields an option carries.

``` r

el_segmented("seg_props", value = "Mon", options = c("Mon", "Tue", "Wed", "Thu", "Fri"))
```

## Block

Set `block` to `true` to fit the width of parent element.

``` r

el_segmented("seg_block", block = TRUE, value = "Mon",
             options = c("Mon", "Tue", "Wednesday", "Thu", "Fri", "Saturday", "Sun"))
```

## Custom Content

Set default slot to render custom content.

``` r

el_segmented("seg_icons", value = "Apple", options = list(
  list(label = "Apple", value = "Apple", icon = "Apple"), list(label = "Cherry", value = "Cherry", icon = "Cherry"),
  list(label = "Grape", value = "Grape", icon = "Grape")),
  slots = list(default = template(htmltools::HTML(paste0(
    "<div style=\"display: flex; flex-direction: column; align-items: center; gap: 8px; padding: 8px\">",
    "<el-icon size=\"20\"><component :is=\"scope.item.icon\" /></el-icon><div>{{ scope.item.label }}</div></div>")),
    scope = "scope")))
```

## Custom Style

Set custom styles using CSS variables.

``` r

tags$div(style = paste(
  "--el-segmented-item-selected-color: var(--el-text-color-primary);",
  "--el-segmented-item-selected-bg-color: #ffd100; --el-border-radius-base: 16px"),
  el_segmented("seg_style", value = "Mon", options = c("Mon", "Tue", "Wed", "Thu", "Fri")))
```

## API

Element Plus’s tables, and beside each entry where it is in R.

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `model-value` | `value`; `input$<id>` | binding value | [^1] / [^2] / [^3] |  | — |
| `options` | `options` | data of the options | [^4]`Option[]` |  | \[\] |
| `size` | `size` | size of component | [^5]`'' \\| 'large' \\| 'default' \\| 'small'` |  | ’’ |
| `block` | `block` | fit width of parent content | [^6] |  | false |
| `disabled` | `disabled` | whether segmented is disabled | [^7] |  | false |
| `validate-event` | `validate_event` | whether to trigger form validation | [^8] |  | true |
| `id` | `id`, the Shiny input’s | native `id` attribute | [^9] |  | — |
| `aria-label` | `aria_label` | native `aria-label` attribute | [^10] |  | — |
| `direction` | `direction` | display direction | [^11]`'horizontal' \\| 'vertical'` |  | horizontal |

### Events

| Element | In R | Description |
|----|----|----|
| `change` | `input$<id>`, the value | triggers when the selected value changes, the param is current selected value |

### Slots

| Element   | In R            | Description     |
|-----------|-----------------|-----------------|
| `default` | default content | option renderer |

[^1]: string

[^2]: number

[^3]: boolean

[^4]: array

[^5]: enum

[^6]: boolean

[^7]: boolean

[^8]: boolean

[^9]: string

[^10]: string

[^11]: enum
