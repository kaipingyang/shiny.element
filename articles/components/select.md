# Select

When there are plenty of options, use a drop-down menu to display and
select desired ones.

> **Tip**
>
> After version 2.5.0, the default width of `el-select` changed to
> `100%`. When used in a inline form, the width will collapse. In order
> to display the width properly, you need to give `el-select` a specific
> width (eg:
> [Example](https://github.com/element-plus/element-plus/issues/15834#issuecomment-1936919229))
> .

## Basic usage

`v-model` is the value of `el-option` that is currently selected.

``` r

opts <- c("Option1", "Option2", "Option3", "Option4", "Option5")
tags$div(
  style = "display: flex; gap: 16px",
  el_select(
    "sel_l",
    choices = opts,
    placeholder = "Select",
    size = "large",
    width = "240px"
  ),
  el_select("sel_d", choices = opts, placeholder = "Select", width = "240px"),
  el_select(
    "sel_s",
    choices = opts,
    placeholder = "Select",
    size = "small",
    width = "240px"
  )
)
```

## Options attribute

Shortcut from basic `el-option` usage. You can customize the alias of
the `options` through the `props` attribute.

``` r

el_select(
  "sel_opts",
  placeholder = "Select",
  width = "240px",
  choices = list(
    list(value = "Option1", label = "Option 1"),
    list(value = "Option2", label = "Option 2"),
    list(value = "Option3", label = "Option 3", disabled = TRUE)
  )
)
```

## Disabled option

Set the value of `disabled` in `el-option` to `true` to disable this
option.

``` r

el_select(
  "sel_dis_opt",
  placeholder = "Select",
  width = "240px",
  choices = list(
    list(value = "Option1", label = "Option1"),
    list(value = "Option2", label = "Option2", disabled = TRUE),
    list(value = "Option3", label = "Option3")
  )
)
```

## Disabled select

Disable the whole component.

Set `disabled` of `el-select` to make it disabled.

``` r

el_select(
  "sel_dis",
  choices = c("Option1", "Option2"),
  placeholder = "Select",
  disabled = TRUE,
  width = "240px"
)
```

## Clearable

You can clear Select using a clear icon.

Set `clearable` attribute for `el-select` and a clear icon will appear.

``` r

el_select(
  "sel_clear",
  choices = c("Option1", "Option2", "Option3"),
  selected = "Option1",
  clearable = TRUE,
  width = "240px"
)
```

## Sizes

Add `size` attribute to change the size of Select. In addition to the
default size, there are two other options: `large`, `small`.

``` r

opts <- c("Option1", "Option2", "Option3")
tags$div(
  style = "display: grid; gap: 16px",
  el_select("sel_sz_l", choices = opts, size = "large", width = "240px"),
  el_select("sel_sz_d", choices = opts, width = "240px"),
  el_select("sel_sz_s", choices = opts, size = "small", width = "240px")
)
```

## Basic multiple select

Multiple select uses tags to display selected options.

Set `multiple` attribute for `el-select` to enable multiple mode. In
this case, the value of `v-model` will be an array of selected options.
By default the selected options will be displayed as Tags. You can
collapse them to a text by using `collapse-tags` attribute. You can
check them when mouse hover collapse text by using
`collapse-tags-tooltip` attribute.

``` r

opts <- c("Option1", "Option2", "Option3", "Option4", "Option5")
tags$div(
  style = "display: grid; gap: 16px",
  el_select(
    "sel_m1",
    choices = opts,
    multiple = TRUE,
    placeholder = "Select",
    width = "240px"
  ),
  el_select(
    "sel_m2",
    choices = opts,
    multiple = TRUE,
    collapse_tags = TRUE,
    placeholder = "Select",
    width = "240px"
  ),
  el_select(
    "sel_m3",
    choices = opts,
    multiple = TRUE,
    collapse_tags = TRUE,
    collapse_tags_tooltip = TRUE,
    placeholder = "Select",
    width = "240px"
  ),
  el_select(
    "sel_m4",
    choices = opts,
    multiple = TRUE,
    collapse_tags = TRUE,
    collapse_tags_tooltip = TRUE,
    max_collapse_tags = 3,
    placeholder = "Select",
    width = "240px"
  )
)
```

## Custom template

You can customize HTML templates for options.

Insert customized HTML templates into the slot of `el-option`.

``` r

el_select(
  "sel_tpl",
  placeholder = "Select",
  width = "240px",
  choices = list(
    list(value = "Beijing", label = "Beijing", code = "BJ"),
    list(value = "Shanghai", label = "Shanghai", code = "SH"),
    list(value = "Nanjing", label = "Nanjing", code = "NJ")
  ),
  option_template = tagList(
    tags$span(style = "float: left", "{{ opt.label }}"),
    tags$span(
      style = "float: right; color: var(--el-text-color-secondary); font-size: 13px",
      "{{ opt.code }}"
    )
  )
)
```

## Header of the dropdown

You can customize the header of the dropdown.

Use slot to customize the content.

``` r

el_select(
  "sel_head",
  choices = c("Option1", "Option2", "Option3"),
  multiple = TRUE,
  clearable = TRUE,
  collapse_tags = TRUE,
  placeholder = "Select",
  width = "240px",
  slots = list(header = el_checkbox("sel_all", "All"))
)
```

## Footer of the dropdown

You can customize the footer of the dropdown.

Use slot to customize the content.

``` r

el_select(
  "sel_foot",
  choices = c("Option1", "Option2", "Option3"),
  placeholder = "Select",
  width = "240px",
  slots = list(
    footer = el_button("sel_add", "Add an option", text = TRUE, size = "small")
  )
)
```

## Grouping

Display options in groups.

Use `el-option-group` to group the options, and its `label` attribute
stands for the name of the group.

``` r

el_select(
  "sel_group",
  placeholder = "Select",
  width = "240px",
  choices = list(
    "Popular cities" = c(Shanghai = "Shanghai", Beijing = "Beijing"),
    "City name" = c(
      Chengdu = "Chengdu",
      Shenzhen = "Shenzhen",
      Guangzhou = "Guangzhou",
      Dalian = "Dalian"
    )
  )
)
```

## Option filtering

You can filter options for your desired ones.

Adding `filterable` to `el-select` enables filtering. By default, Select
will find all the options whose `label` attribute contains the input
value. If you prefer other filtering strategies, you can pass the
`filter-method`. `filter-method` is a `Function` that gets called when
the input value changes, and its parameter is the current input value.

``` r

el_select(
  "sel_filter",
  choices = c("Option1", "Option2", "Option3", "Option4"),
  filterable = TRUE,
  placeholder = "Select",
  width = "240px"
)
```

## Remote Search

Enter keywords and search data from server.

Set the value of `filterable` and `remote` with `true` to enable remote
search, and you should pass the `remote-method`. `remote-method` is a
`Function` that gets called when the input value changes, and its
parameter is the current input value. Note that if `el-option` is
rendered with the `v-for` directive, you should add the `key` attribute
for `el-option`. Its value needs to be unique, such as `item.value` in
the following example.

The server does the search: `input$<id>_query` is the text typed, and
`update_el_select(choices =)` answers it.

``` r

el_select(
  "sel_remote",
  multiple = TRUE,
  filterable = TRUE,
  remote = TRUE,
  reserve_keyword = FALSE,
  placeholder = "Please enter a keyword",
  width = "240px"
)
```

## Create new items

Create and select new items that are not included in select options

By using the `allow-create` attribute, users can create new items by
typing in the input box. Note that for `allow-create` to work,
`filterable` must be `true`. This example also demonstrates
`default-first-option`. When this attribute is set to `true`, you can
select the first option in the current option list by hitting enter
without having to navigate with mouse or arrow keys.

``` r

el_select(
  "sel_create",
  choices = c("HTML", "CSS", "JavaScript"),
  multiple = TRUE,
  filterable = TRUE,
  allow_create = TRUE,
  default_first_option = TRUE,
  reserve_keyword = FALSE,
  placeholder = "Choose tags for your article",
  width = "240px"
)
```

## Use value-key attribute

If the binding value of Select is an object, make sure to assign
`value-key` as its unique identity key name.

By using the `value-key` attribute, data with duplicate labels can be
properly handled. The value of the `label` property is duplicated, but
the option can be identified through the `id`.

Values that are objects need `value_key`, the field that tells them
apart.

``` r

el_select(
  "sel_vkey",
  value_key = "id",
  placeholder = "Select",
  width = "240px",
  choices = list(
    list(value = list(id = 1, name = "Option A"), label = "Option A"),
    list(value = list(id = 2, name = "Option B"), label = "Option B")
  )
)
```

## Custom Tag

You can customize tags.

Insert customized tags into the slot of `el-select`. `collapse-tags`,
`collapse-tags-tooltip`, `max-collapse-tags` will not work.

``` r

el_select(
  "sel_tag",
  choices = c("Red" = "#ff0000", "Green" = "#00ff00", "Blue" = "#0000ff"),
  selected = c("#ff0000", "#00ff00"),
  multiple = TRUE,
  placeholder = "Select",
  width = "240px",
  slots = list(
    tag = template(
      htmltools::HTML(
        "<el-tag v-for=\"color in value\" :key=\"color\" :color=\"color\" closable :style=\"{ color: '#fff' }\">{{ color }}</el-tag>"
      ),
      slot = "tag",
      scope = "{ value }"
    )
  )
)
```

## Custom Loading

Override loading content.

``` r

el_select(
  "sel_load",
  remote = TRUE,
  filterable = TRUE,
  loading = TRUE,
  placeholder = "Please enter a keyword",
  width = "240px",
  slots = list(loading = el_icon("Loading", class = "is-loading"))
)
```

## Empty Values

If you want to support empty string, please set `empty-values` to
`[null, undefined]`.

If you want to change the clear value to `null`, please set
`value-on-clear` to `null`.

``` r

el_select(
  "sel_empty",
  choices = c("Option1", "Option2"),
  clearable = TRUE,
  empty_values = list(NULL),
  value_on_clear = NULL,
  placeholder = "Select",
  width = "240px"
)
```

## Custom Label

You can customize label.

``` r

el_select(
  "sel_label",
  choices = c("Option1", "Option2", "Option3"),
  selected = "Option1",
  width = "240px",
  slots = list(
    label = template(
      htmltools::HTML(
        "<span>{{ label }}: </span><span style=\"font-weight: bold\">{{ value }}</span>"
      ),
      slot = "label",
      scope = "{ label, value }"
    )
  )
)
```

## API

Element Plus’s tables, and beside each entry where it is in R.

### Select Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `model-value` | `value`; `input$<id>` | binding value | [^1] / [^2] / [^3] / [^4] / [^5] |  | — |
| `multiple` | `multiple` | whether multiple-select is activated | [^6] |  | false |
| `options` | `options` | data of the options, the key of `value` and `label` and `disabled` can be customize by `props` | [^7]`Array<{[key: string]: any}>` |  | — |
| `disabled` | `disabled` | whether Select is disabled | [^8] |  | false |
| `value-key` | `value_key` | unique identity key name for value, required when value is an object | [^9] |  | value |
| `size` | `size` | size of Input | [^10]`'' \\| 'large' \\| 'default' \\| 'small'` |  | — |
| `clearable` | `clearable` | whether select can be cleared | [^11] |  | false |
| `collapse-tags` | `collapse_tags` | whether to collapse tags to a text when multiple selecting | [^12] |  | false |
| `collapse-tags-tooltip` | `collapse_tags_tooltip` | whether show all selected tags when mouse hover text of collapse-tags. To use this, `collapse-tags` must be true | [^13] |  | false |
| `multiple-limit` | `multiple_limit` | maximum number of options user can select when `multiple` is `true`. No limit when set to 0 | [^14] |  | 0 |
| `id` | `id`, the Shiny input’s | native input id input | [^15] |  | — |
| `effect` | `effect` | tooltip theme, built-in theme: `dark` / `light` | [^16]`'dark' \\| 'light'` / [^17] |  | light |
| `autocomplete` | `autocomplete` | the autocomplete attribute of select input | [^18] |  | off |
| `placeholder` | `placeholder` | placeholder, default is ‘Select’ | [^19] |  | — |
| `filterable` | `filterable` | whether Select is filterable | [^20] |  | false |
| `allow-create` | `allow_create` | whether creating new items is allowed. To use this, `filterable` must be true | [^21] |  | false |
| `filter-method` | `filter_method` | custom filter method, the first parameter is the current input value. To use this, `filterable` must be true | [^22]`(query: string) => void` |  | — |
| `remote` | `remote` | whether options are loaded from server | [^23] |  | false |
| `debounce` | `debounce` | debounce delay during remote search, in milliseconds | [^24] |  | 300 |
| `remote-method` | `remote_method` | function that gets called when the input value changes. Its parameter is the current input value. To use this, `filterable` must be true | [^25]`(query: string) => void` |  | — |
| `remote-show-suffix` | `remote_show_suffix` | in remote search method show suffix icon | [^26] |  | false |
| `loading` | `loading` | whether Select is loading data from server | [^27] |  | false |
| `loading-text` | `loading_text` | displayed text while loading data from server, default is ‘Loading’ | [^28] |  | — |
| `no-match-text` | `no_match_text` | displayed text when no data matches the filtering query, you can also use slot `empty`, default is ‘No matching data’ | [^29] |  | — |
| `no-data-text` | `no_data_text` | displayed text when there is no options, you can also use slot `empty`, default is ‘No data’ | [^30] |  | — |
| `popper-class` | `popper_class` | custom class name for Select’s dropdown and tags’ tooltip | [^31] |  | ’’ |
| `popper-style` | `popper_style` | custom style for Select’s dropdown and tags’ tooltip | [^32] / [^33] |  | — |
| `reserve-keyword` | `reserve_keyword` | when `multiple` and `filterable` is true, whether to reserve current keyword after selecting an option | [^34] |  | true |
| `default-first-option` | `default_first_option` | select first matching option on enter key. Use with `filterable` or `remote` | [^35] |  | false |
| `teleported` | `teleported` | whether select dropdown is teleported, if `true` it will be teleported to where `append-to` sets | [^36] |  | true |
| `append-to` | `append_to` | which element the select dropdown appends to | [^37] / [^38] |  | — |
| `persistent` | `persistent` | when select dropdown is inactive and `persistent` is `false`, select dropdown will be destroyed | [^39] |  | true |
| `automatic-dropdown` | `automatic_dropdown` | for non-filterable Select, this prop decides if the option menu pops up when the input is focused | [^40] |  | false |
| `clear-icon` | `clear_icon` | custom clear icon component | [^41] / [^42]`Component` |  | CircleClose |
| `fit-input-width` | `fit_input_width` | whether the width of the dropdown is the same as the input | [^43] |  | false |
| `suffix-icon` | `suffix_icon` | custom suffix icon component | [^44] / [^45]`Component` |  | ArrowDown |
| `tag-type` | `tag_type` | tag type | [^46]`'' \\| 'success' \\| 'info' \\| 'warning' \\| 'danger'` |  | info |
| `tag-effect` | `tag_effect` | tag effect | [^47]`'' \\| 'light' \\| 'dark' \\| 'plain'` |  | light |
| `validate-event` | `validate_event` | whether to trigger form validation | [^48] |  | true |
| `offset` | `offset` | offset of the dropdown | [^49] |  | 12 |
| `show-arrow` | `show_arrow` | whether the dropdown has an arrow | [^50] |  | true |
| `placement` | `placement` | position of dropdown | [^51]`'top' \\| 'top-start' \\| 'top-end' \\| 'bottom' \\| 'bottom-start' \\| 'bottom-end' \\| 'left' \\| 'left-start' \\| 'left-end' \\| 'right' \\| 'right-start' \\| 'right-end'` |  | bottom-start |
| `fallback-placements` | `fallback_placements` | list of possible positions for dropdown [popper.js](https://popper.js.org/docs/v2/modifiers/flip/#fallbackplacements) | [^52]`Placement[]` |  | \[‘bottom-start’, ‘top-start’, ‘right’, ‘left’\] |
| `max-collapse-tags` | `max_collapse_tags` | the max tags number to be shown. To use this, `collapse-tags` must be true | [^53] |  | 1 |
| `popper-options` | `popper_options` | [popper.js](https://popper.js.org/docs/v2/) parameters | [^54]refer to [popper.js](https://popper.js.org/docs/v2/) doc |  | {} |
| `aria-label` | `aria_label` | same as `aria-label` in native input | [^55] |  | — |
| `empty-values` | `empty_values` | empty values of component, [see config-provider](https://kaipingyang.github.io/shiny.element/articles/components/config-provider.html#empty-values-configurations) | [^56] |  | — |
| `value-on-clear` | `value_on_clear` | clear return value, [see config-provider](https://kaipingyang.github.io/shiny.element/articles/components/config-provider.html#empty-values-configurations) | [^57] / [^58] / [^59] / [^60] |  | — |
| `suffix-transition` | `suffix_transition` | animation when dropdown appears/disappears icon | [^61] |  | true |
| `tabindex` | `tabindex` | tabindex for input | [^62] / [^63] |  | — |

### Select Events

| Element | In R | Description |
|----|----|----|
| `change` | `input$<id>`, the value | triggers when the selected value changes |
| `visible-change` | `input$<id>_visible_change` | triggers when the dropdown appears/disappears |
| `remove-tag` | `input$<id>_remove_tag` | triggers when a tag is removed in multiple mode |
| `clear` | `input$<id>_clear` | triggers when the clear icon is clicked in a clearable Select |
| `blur` | `input$<id>_blur` | triggers when Input blurs |
| `focus` | `input$<id>_focus` | triggers when Input focuses |
| `popup-scroll` | `input$<id>_popup_scroll` | triggers when dropdown scrolls |
| `end-reached` | `input$<id>_end_reached` | triggers when dropdown scroll reaches an end |

### Select Slots

| Element | In R | Description |
|----|----|----|
| `default` | default content | option component list |
| `header` | `slots = list(header = )` | content at the top of the dropdown |
| `footer` | `slots = list(footer = )` | content at the bottom of the dropdown |
| `prefix` | `slots = list(prefix = )` | content as Select prefix |
| `empty` | `slots = list(empty = )` | content when there is no options |
| `tag` | `slots = list(tag = )` | content as Select tag, subTags `data`, `selectDisabled` and `deleteTag` introduced in ^(2.10.3) |
| `loading` | `slots = list(loading = )` | content as Select loading |
| `label` | `slots = list(label = )` | content as Select label. `index` introduced in ^(2.11.2) |

### Select Exposes

| Element | In R | Description |
|----|----|----|
| `focus` | `el_call(session, id, "focus")` | focus the Input component |
| `blur` | `el_call(session, id, "blur")` | blur the Input component, and hide the dropdown |

### Option Group Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `label` | `label` | name of the group | [^64] |  | — |
| `disabled` | `disabled` | whether to disable all options in this group | [^65] |  | false |

### Option Group Slots

| Element   | In R            | Description               |
|-----------|-----------------|---------------------------|
| `default` | default content | customize default content |

### Option Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `value` | `value` | value of option | [^66] / [^67] / [^68] / [^69] |  | — |
| `label` | `label` | label of option, same as `value` if omitted | [^70] / [^71] |  | — |
| `disabled` | `disabled` | whether option is disabled | [^72] |  | false |

### Option Slots

| Element   | In R            | Description               |
|-----------|-----------------|---------------------------|
| `default` | default content | customize default content |

[^1]: string

[^2]: number

[^3]: boolean

[^4]: object

[^5]: array

[^6]: boolean

[^7]: array

[^8]: boolean

[^9]: string

[^10]: enum

[^11]: boolean

[^12]: boolean

[^13]: boolean

[^14]: number

[^15]: string

[^16]: enum

[^17]: string

[^18]: string

[^19]: string

[^20]: boolean

[^21]: boolean

[^22]: Function

[^23]: boolean

[^24]: number

[^25]: Function

[^26]: boolean

[^27]: boolean

[^28]: string

[^29]: string

[^30]: string

[^31]: string

[^32]: string

[^33]: object

[^34]: boolean

[^35]: boolean

[^36]: boolean

[^37]: CSSSelector

[^38]: HTMLElement

[^39]: boolean

[^40]: boolean

[^41]: string

[^42]: object

[^43]: boolean

[^44]: string

[^45]: object

[^46]: enum

[^47]: enum

[^48]: boolean

[^49]: number

[^50]: boolean

[^51]: enum

[^52]: array

[^53]: number

[^54]: object

[^55]: string

[^56]: array

[^57]: string

[^58]: number

[^59]: boolean

[^60]: Function

[^61]: boolean

[^62]: string

[^63]: number

[^64]: string

[^65]: boolean

[^66]: string

[^67]: number

[^68]: boolean

[^69]: object

[^70]: string

[^71]: number

[^72]: boolean
