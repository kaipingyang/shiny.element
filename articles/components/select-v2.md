# Virtualized Select

> **Tip**
>
> This component is still under testing, if you found any bug or issue
> please report it at
> [GitHub](https://github.com/element-plus/element-plus/issues) for us
> to fix.

## Background

In some use-cases, a single selector may end up loading tens of
thousands of rows of data. Rendering that much data into the DOM could
be a burden to the browser, which can result in performance issues. For
a better user and developer experience, we decided to add this
component.

## Basic usage

The simplest selector

``` r

el_select_v2(
  "v2_basic",
  options = paste("Option", 1:1000),
  placeholder = "Please select",
  width = "240px"
)
```

## Multi select

The basic multi-select selector with tags

``` r

opts <- paste("Option", 1:1000)
tags$div(
  style = "display: grid; gap: 16px",
  el_select_v2(
    "v2_m1",
    options = opts,
    multiple = TRUE,
    placeholder = "Please select",
    width = "240px"
  ),
  el_select_v2(
    "v2_m2",
    options = opts,
    multiple = TRUE,
    collapse_tags = TRUE,
    placeholder = "Please select",
    width = "240px"
  ),
  el_select_v2(
    "v2_m3",
    options = opts,
    multiple = TRUE,
    collapse_tags = TRUE,
    collapse_tags_tooltip = TRUE,
    placeholder = "Please select",
    width = "240px"
  )
)
```

## Sizes

Add `size` attribute to change the size of Select-V2. In addition to the
default size, there are two other options: `large`, `small`.

``` r

opts <- paste("Option", 1:1000)
tags$div(
  style = "display: grid; gap: 16px",
  el_select_v2(
    "v2_l",
    options = opts,
    size = "large",
    placeholder = "Please select",
    width = "240px"
  ),
  el_select_v2(
    "v2_d",
    options = opts,
    placeholder = "Please select",
    width = "240px"
  ),
  el_select_v2(
    "v2_s",
    options = opts,
    size = "small",
    placeholder = "Please select",
    width = "240px"
  )
)
```

## Hide extra tags when the selected items are too many

You can collapse tags to a text by using `collapse-tags` attribute. You
can check them when mouse hover collapse text by using
`collapse-tags-tooltip` attribute.

``` r

el_select_v2(
  "v2_hide",
  options = paste("Option", 1:1000),
  multiple = TRUE,
  collapse_tags = TRUE,
  max_collapse_tags = 3,
  placeholder = "Please select",
  width = "240px"
)
```

## Filterable multi-select

When the options are overwhelmingly too many, you can use `filterable`
option to enable filter feature for finding out the desired option

``` r

el_select_v2(
  "v2_filter",
  options = paste("Option", 1:1000),
  filterable = TRUE,
  multiple = TRUE,
  placeholder = "Please select",
  width = "240px"
)
```

## Disabled selector and select options

You can choose to disable selector itself or the option.

``` r

tagList(
  el_select_v2(
    "v2_dis1",
    options = list(
      list(value = "a", label = "Option a"),
      list(value = "b", label = "Option b", disabled = TRUE)
    ),
    placeholder = "Please select",
    width = "240px"
  ),
  el_select_v2(
    "v2_dis2",
    options = c("a", "b"),
    disabled = TRUE,
    placeholder = "Please select",
    width = "240px"
  )
)
```

## Option Grouping

We can group option as we wanted, as long as the data satisfies the
pattern.

``` r

el_select_v2(
  "v2_group",
  placeholder = "Please select",
  width = "240px",
  options = lapply(1:10, function(g) {
    list(
      label = paste("Group", g),
      options = lapply(1:10, function(i) {
        list(value = paste0(g, "-", i), label = paste("Option", g, i))
      })
    )
  })
)
```

## Clearable selector

We can clear all the selected options at once, also applicable for
single select.

``` r

el_select_v2(
  "v2_clear",
  options = paste("Option", 1:1000),
  multiple = TRUE,
  clearable = TRUE,
  placeholder = "Please select",
  width = "240px"
)
```

## Customized option renderer

We can define our own template for rendering the option in the popup.

``` r

el_select_v2(
  "v2_opt",
  options = paste("Option", 1:1000),
  placeholder = "Please select",
  width = "240px",
  slots = list(
    default = template(
      htmltools::HTML(
        "<div style=\"display: flex; justify-content: space-between\"><span>{{ item.label }}</span><span style=\"color: var(--el-text-color-secondary)\">{{ item.value }}</span></div>"
      ),
      scope = "{ item }"
    )
  )
)
```

## Header of the dropdown

You can customize the header of the dropdown.

Use slot to customize the content.

``` r

el_select_v2(
  "v2_head",
  options = paste("Option", 1:100),
  multiple = TRUE,
  placeholder = "Please select",
  width = "240px",
  slots = list(header = "Header content")
)
```

## Footer of the dropdown

You can customize the footer of the dropdown.

Use slot to customize the content.

``` r

el_select_v2(
  "v2_foot",
  options = paste("Option", 1:100),
  placeholder = "Please select",
  width = "240px",
  slots = list(footer = "Footer content")
)
```

## Create Option

Create and select new items that are not included in select options

By using the `allow-create` attribute, users can create new items by
typing in the input box. Note that for `allow-create` to work,
`filterable` must be `true`. This example also demonstrates
`default-first-option`. When this attribute is set to `true`, you can
select the first option in the current option list by hitting enter
without having to navigate with mouse or arrow keys.

> **Tip**
>
> It will be better to set `:reserve-keyword="false"` when use
> `allow-create`

``` r

el_select_v2(
  "v2_create",
  options = c("HTML", "CSS", "JavaScript"),
  multiple = TRUE,
  filterable = TRUE,
  allow_create = TRUE,
  default_first_option = TRUE,
  placeholder = "Please select",
  width = "240px"
)
```

## Remote search

Enter keywords and search data from server.

Set the value of `filterable` and `remote` with `true` to enable remote
search, and you should pass the `remote-method`. `remote-method` is a
`Function` that gets called when the input value changes, and its
parameter is the current input value.

A `remote_method` of your own, a
[`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
function, fetches options in the browser; for the server’s options use
`el_select(remote = TRUE)`.

``` r

el_select_v2(
  "v2_remote",
  filterable = TRUE,
  remote = TRUE,
  placeholder = "Please enter a keyword",
  width = "240px",
  remote_method = JS("function(q) {}")
)
```

## Use value-key attribute

when `options.value` is an object, you should set a unique identity key
name for value

Before 2.4.0, `value-key` was used both as the unique value of the
selected object and as an alias for the value in `options`. Now
`value-key` is only used as the unique value of the selected object, and
the alias for the value in options is `props.value`.

``` r

el_select_v2(
  "v2_vkey",
  value_key = "id",
  placeholder = "Please select",
  width = "240px",
  options = list(
    list(value = list(id = 1, name = "a"), label = "Option a"),
    list(value = list(id = 2, name = "b"), label = "Option b")
  )
)
```

## Aliases for custom options

When your `options` format is different from the default format, you can
customize the alias of the `options` through the `props` attribute

`props` names the fields each option carries.

``` r

el_select_v2(
  "v2_props",
  placeholder = "Please select",
  width = "240px",
  options = c("Option 1", "Option 2", "Option 3")
)
```

## Custom Tag

You can customize tags.

Insert customized tags into the slot of `el-select`. `collapse-tags`,
`collapse-tags-tooltip`, `max-collapse-tags` will not work.

``` r

el_select_v2(
  "v2_tag",
  options = c("Red" = "#ff0000", "Green" = "#00ff00"),
  value = c("#ff0000"),
  multiple = TRUE,
  placeholder = "Please select",
  width = "240px"
)
```

## Custom Loading

Override loading content.

``` r

el_select_v2(
  "v2_load",
  loading = TRUE,
  filterable = TRUE,
  remote = TRUE,
  placeholder = "Please enter a keyword",
  width = "240px",
  remote_method = JS("function(q) {}"),
  slots = list(loading = el_icon("Loading", class = "is-loading"))
)
```

## Empty Values

If you want to support empty string, please set `empty-values` to
`[null, undefined]`.

If you want to change the clear value to `null`, please set
`value-on-clear` to `null`.

``` r

el_select_v2(
  "v2_empty",
  options = c("Option1", "Option2"),
  clearable = TRUE,
  empty_values = list(NULL),
  value_on_clear = NULL,
  placeholder = "Please select",
  width = "240px"
)
```

## Custom Label

You can customize label.

``` r

el_select_v2(
  "v2_label",
  options = c("Option1", "Option2"),
  value = "Option1",
  width = "240px",
  slots = list(
    label = template(
      htmltools::HTML("<span>{{ label }}: </span><b>{{ value }}</b>"),
      slot = "label",
      scope = "{ label, value }"
    )
  )
)
```

## Custom Width

The width of dropdown box is calculated by default based on the value of
`label`. If you customize the dropdown box options through the
`default slot`, it is likely that the text displayed in the options is
not equal to the value of `label`, resulting in calculation errors. In
this case, you can set the `fit-input-width` attribute to a number to
fix its width.

``` r

el_select_v2(
  "v2_width",
  options = paste("A much longer option, number", 1:100),
  fit_input_width = FALSE,
  placeholder = "Please select",
  width = "240px"
)
```

## API

Element Plus’s tables, and beside each entry where it is in R.

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `model-value` | `value`; `input$<id>` | binding value | [^1] / [^2] / [^3] / [^4] / [^5] |  | — |
| `options` | `options` | data of the options, the key of `value` and `label` can be customize by `props` | [^6] |  | — |
| `props` | `props` | configuration options, see the following table | [^7] |  | — |
| `multiple` | `multiple` | is multiple | [^8] |  | false |
| `disabled` | `disabled` | is disabled | [^9] |  | false |
| `value-key` | `value_key` | unique identity key name for value, required when value is an object | [^10] |  | value |
| `size` | `size` | size of component | [^11]`'' \\| 'large' \\| 'default' \\| 'small'` |  | ’’ |
| `clearable` | `clearable` | whether select can be cleared | [^12] |  | false |
| `clear-icon` | `clear_icon` | custom clear icon | [^13] / [^14]`Component` |  | CircleClose |
| `collapse-tags` | `collapse_tags` | whether to collapse tags to a text when multiple selecting | [^15] |  | false |
| `multiple-limit` | `multiple_limit` | maximum number of options user can select when multiple is true. No limit when set to 0 | [^16] |  | 0 |
| `id` | `id`, the Shiny input’s | native input id input | [^17] |  | — |
| `effect` | `effect` | tooltip theme, built-in theme: `dark` / `light` | [^18]`'dark' \\| 'light'` / [^19] |  | light |
| `autocomplete` | `autocomplete` | autocomplete of select input | [^20] |  | off |
| `placeholder` | `placeholder` | placeholder | [^21] |  | Please select |
| `filterable` | `filterable` | whether Select is filterable | [^22] |  | false |
| `allow-create` | `allow_create` | whether creating new items is allowed. To use this, `filterable` must be true | [^23] |  | false |
| `filter-method` | `filter_method` | custom filter method, the first parameter is the current input value. To use this, `filterable` must be true method | [^24]`(query: string) => void` |  | — |
| `loading` | `loading` | whether Select is loading data from server | [^25] |  | false |
| `loading-text` | `loading_text` | displayed text while loading data from server, default is ‘Loading’ | [^26] |  | — |
| `reserve-keyword` | `reserve_keyword` | whether reserve the keyword after select filtered option. | [^27] |  | true |
| `default-first-option` | `default_first_option` | select first matching option on enter key. Use with `filterable` or `remote` | [^28] |  | false |
| `no-match-text` | `no_match_text` | displayed text when no data matches the filtering query, you can also use slot `empty`, default is ‘No matching data’ | [^29] |  | — |
| `no-data-text` | `no_data_text` | displayed text when there is no options, you can also use slot empty | [^30] |  | No Data |
| `popper-class` | `popper_class` | custom class name for Select’s dropdown and tags’ tooltip | [^31] / [^32] |  | ’’ |
| `popper-style` | `popper_style` | custom style for Select’s dropdown and tags’ tooltip | [^33] / [^34] |  | — |
| `teleported` | `teleported` | whether select dropdown is teleported, if `true` it will be teleported to where `append-to` sets | [^35] |  | true |
| `append-to` | `append_to` | which element the select dropdown appends to | [^36] / [^37] |  | — |
| `persistent` | `persistent` | when select dropdown is inactive and `persistent` is `false`, select dropdown will be destroyed | [^38] |  | true |
| `popper-options` | `popper_options` | [popper.js](https://popper.js.org/docs/v2/) parameters | [^39]refer to [popper.js](https://popper.js.org/docs/v2/) doc |  | {} |
| `automatic-dropdown` | `automatic_dropdown` | for non-filterable Select, this prop decides if the option menu pops up when the input is focused | [^40] |  | false |
| `fit-input-width` | `fit_input_width` | whether the width of the dropdown is the same as the input, if the value is `number`, then the width is fixed | [^41] / [^42] |  | true |
| `suffix-icon` | `suffix_icon` | custom suffix icon component | [^43] / [^44]`Component` |  | ArrowDown |
| `height` | `height` | The height of the dropdown panel, 34px for each item | [^45] |  | 274 |
| `item-height` | `item_height` | The height of the dropdown item | [^46] |  | 34 |
| `estimated-option-height` | `estimated_option_height` | Controls virtual-list sizing mode: if undefined, the list uses fixed item height from `item-height`; if provided, the list uses dynamic item sizing and this value as the estimated item height. | [^47] |  | — |
| `scrollbar-always-on` | `scrollbar_always_on` | Controls whether the scrollbar is always displayed | [^48] |  | false |
| `remote` | `remote` | whether search data from server | [^49] |  | false |
| `debounce` | `debounce` | debounce delay during remote search, in milliseconds | [^50] |  | 300 |
| `remote-method` | `remote_method` | function that gets called when the input value changes. Its parameter is the current input value. To use this, `filterable` must be true | [^51]`(query: string) => void` |  | — |
| `remote-show-suffix` | `remote_show_suffix` | in remote search method show suffix icon | [^52] |  | false |
| `validate-event` | `validate_event` | whether to trigger form validation | [^53] |  | true |
| `offset` | `offset` | offset of the dropdown | [^54] |  | 12 |
| `show-arrow` | `show_arrow` | whether the dropdown has an arrow | [^55] |  | true |
| `placement` | `placement` | position of dropdown | [^56]`'top' \\| 'top-start' \\| 'top-end' \\| 'bottom' \\| 'bottom-start' \\| 'bottom-end' \\| 'left' \\| 'left-start' \\| 'left-end' \\| 'right' \\| 'right-start' \\| 'right-end'` |  | bottom-start |
| `fallback-placements` | `fallback_placements` | list of possible positions for dropdown [popper.js](https://popper.js.org/docs/v2/modifiers/flip/#fallbackplacements) | [^57]`Placement[]` |  | \[‘bottom-start’, ‘top-start’, ‘right’, ‘left’\] |
| `collapse-tags-tooltip` | `collapse_tags_tooltip` | whether show all selected tags when mouse hover text of collapse-tags. To use this, `collapse-tags` must be true | [^58] |  | false |
| `tag-tooltip` | `tag_tooltip` | configuration object for the collapse-tags tooltip. To use this, `collapse-tags` and `collapse-tags-tooltip` must be true | [^59]`TagTooltipProps` |  | {} |
| `max-collapse-tags` | `max_collapse_tags` | The max tags number to be shown. To use this, `collapse-tags` must be true | [^60] |  | 1 |
| `tag-type` | `tag_type` | tag type | [^61]`'' \\| 'success' \\| 'info' \\| 'warning' \\| 'danger'` |  | info |
| `tag-effect` | `tag_effect` | tag effect | [^62]`'' \\| 'light' \\| 'dark' \\| 'plain'` |  | light |
| `aria-label` | `aria_label` | same as `aria-label` in native input | [^63] |  | — |
| `empty-values` | `empty_values` | empty values of component, [see config-provider](https://kaipingyang.github.io/shiny.element/articles/components/config-provider.html#empty-values-configurations) | [^64] |  | — |
| `value-on-clear` | `value_on_clear` | clear return value, [see config-provider](https://kaipingyang.github.io/shiny.element/articles/components/config-provider.html#empty-values-configurations) | [^65] / [^66] / [^67] / [^68] |  | — |
| `popper-append-to-body` | `popper_append_to_body` | whether to append the popper menu to body. If the positioning of the popper is wrong, you can try to set this prop to false | [^69] |  | false |
| `tabindex` | `tabindex` | tabindex for input | [^70] / [^71] |  | — |

### Events

| Element | In R | Description |
|----|----|----|
| `change` | `input$<id>`, the value | triggers when the selected value changes, the param is current selected value |
| `visible-change` | `input$<id>_visible_change` | triggers when the dropdown appears/disappears, the param will be true when it appears, and false otherwise |
| `remove-tag` | `input$<id>_remove_tag` | triggers when a tag is removed in multiple mode, the param is removed tag value |
| `clear` | `input$<id>_clear` | triggers when the clear icon is clicked in a clearable Select |
| `blur` | `input$<id>_blur` | triggers when Input blurs |
| `focus` | `input$<id>_focus` | triggers when Input focuses |
| `end-reached` | `input$<id>_end_reached` | triggers when dropdown scroll reaches an end |

### Slots

| Element | In R | Description |
|----|----|----|
| `default` | default content | Option renderer |
| `header` | `slots = list(header = )` | content at the top of the dropdown |
| `footer` | `slots = list(footer = )` | content at the bottom of the dropdown |
| `empty` | `slots = list(empty = )` | content when options is empty |
| `prefix` | `slots = list(prefix = )` | prefix content of input |
| `tag` | `slots = list(tag = )` | content as Select tag, subTags `data`, `selectDisabled` and `deleteTag` introduced in ^(2.10.3) |
| `loading` | `slots = list(loading = )` | content as Select loading |
| `label` | `slots = list(label = )` | content as Select label. `index` introduced in ^(2.11.2) |

### Exposes

| Element | In R | Description |
|----|----|----|
| `focus` | `el_call(session, id, "focus")` | focus the Input component |
| `blur` | `el_call(session, id, "blur")` | blur the Input component, and hide the dropdown |

[^1]: string

[^2]: number

[^3]: boolean

[^4]: object

[^5]: array

[^6]: array

[^7]: object

[^8]: boolean

[^9]: boolean

[^10]: string

[^11]: enum

[^12]: boolean

[^13]: string

[^14]: object

[^15]: boolean

[^16]: number

[^17]: string

[^18]: enum

[^19]: string

[^20]: string

[^21]: string

[^22]: boolean

[^23]: boolean

[^24]: Function

[^25]: boolean

[^26]: string

[^27]: boolean

[^28]: boolean

[^29]: string

[^30]: string

[^31]: string

[^32]: object

[^33]: string

[^34]: object

[^35]: boolean

[^36]: CSSSelector

[^37]: HTMLElement

[^38]: boolean

[^39]: object

[^40]: boolean

[^41]: boolean

[^42]: number

[^43]: string

[^44]: object

[^45]: number

[^46]: number

[^47]: number

[^48]: boolean

[^49]: boolean

[^50]: number

[^51]: Function

[^52]: boolean

[^53]: boolean

[^54]: number

[^55]: boolean

[^56]: enum

[^57]: array

[^58]: boolean

[^59]: object

[^60]: number

[^61]: enum

[^62]: enum

[^63]: string

[^64]: array

[^65]: string

[^66]: number

[^67]: boolean

[^68]: Function

[^69]: boolean

[^70]: string

[^71]: number
