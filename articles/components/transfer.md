# Transfer

## Basic usage

Data is passed to Transfer via the `data` attribute. The data needs to
be an object array, and each object should have these attributes: `key`
being the identification of the data item, `label` being the displayed
text, and `disabled` indicating if the data item is disabled. Items
inside the target list are in sync with the variable binding to
`v-model`, and the value of that variable is an array of target item
keys. So, if you don’t want the target list be initially empty, you can
initialize the `v-model` with an array.

`data` is a data frame of `key` and `label` (and `disabled`), and
`input$<id>` the keys on the right.

``` r

items <- data.frame(key = 1:15, label = paste("Option", 1:15), disabled = 1:15 %% 4 == 0)
el_transfer("basic", data = items, value = c(1, 4))
```

## Filterable

You can search and filter data items.

Set the `filterable` attribute to `true` to enable filter mode. By
default, if the data item `label` contains the search keyword, it will
be included in the search result. Also, you can implement you own filter
method with the `filter-method` attribute. It takes a method and passes
search keyword and each data item to it whenever the keyword changes.
For a certain data item, if the method returns true, it will be included
in the result list.

``` r

states <- c("California", "Illinois", "Maryland", "Texas", "Florida", "Colorado", "Connecticut")
el_transfer("states", data = data.frame(key = seq_along(states), label = states),
            filterable = TRUE, filter_placeholder = "State Abbreviations")
```

## Customizable

You can customize list titles, button texts, render function for data
items, checking status texts in list footer and list footer contents.

Use `titles`, `button-texts`, `render-content` and `format` to
respectively customize list titles, button texts, render function for
data items, checking status texts in list header. Plus, you can also use
scoped slot to customize data items. For list footer contents, two named
slots are provided: `left-footer` and `right-footer`. Plus, if you want
some items initially checked, you can use `left-default-checked` and
`right-default-checked`. Finally, this example demonstrate the `change`
event. Note that this demo can’t run in JSFiddle because it doesn’t
support JSX syntax. In a real project, `render-content` will work if
relevant dependencies are correctly configured.

`titles`, `button_texts` and `format` relabel it; the default slot,
scoped with `option`, draws each item.

``` r

items <- data.frame(key = 1:15, label = paste("Option", 1:15))
el_transfer("custom", data = items, value = 1, filterable = TRUE,
            titles = c("Source", "Target"), button_texts = c("To left", "To right"),
            format = list(noChecked = "${total}", hasChecked = "${checked}/${total}"),
            slots = list(default = template(
              tags$span("{{ option.key }} - {{ option.label }}"), scope = "{ option }")))
```

## Custom empty content

You can customize the content when the list is empty or when no
filtering results are found.

Use `left-empty` and `right-empty` slots to customize the empty content
for each panel.

``` r

items <- data.frame(key = integer(0), label = character(0))
el_transfer("empty", data = items, slots = list(
  leftEmpty = el_empty(image_size = 60, description = "No data"),
  rightEmpty = el_empty(image_size = 60, description = "No data")))
```

## Prop aliases

By default, Transfer looks for `key`, `label` and `disabled` in a data
item. If your data items have different key names, you can use the
`props` attribute to define aliases.

The data items in this example do not have `key`s or `label`s, instead
they have `value`s and `desc`s. So you need to set aliases for `key` and
`label`.

Items whose fields are named otherwise: `props` says which is which.

``` r

items <- data.frame(value = 1:15, desc = paste("Option", 1:15))
el_transfer("aliases", data = items, props = list(key = "value", label = "desc"))
```

## Virtual Scroll

When dealing with large amounts of data, you can enable virtual
scrolling to improve performance.

Set `virtual-scroll` to `true` to enable virtual scrolling. You can also
customize the item height with `item-size`. Default item size is 30px.

`virtual_scroll` draws only the rows in view, for long lists.

``` r

items <- data.frame(key = 1:10000, label = paste("Option", 1:10000))
el_transfer("virtual", data = items, virtual_scroll = TRUE, item_size = 34, filterable = TRUE)
```

## API

Element Plus’s tables, and beside each entry where it is in R.

### Transfer Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `model-value` | `value`; `input$<id>` | binding value | [^1]`Array<string \\| number>` |  | \[\] |
| `data` | `data` | data source | [^2]`Record<string, any>[]` |  | \[\] |
| `filterable` | `filterable` | whether Transfer is filterable | [^3] |  | false |
| `filter-placeholder` | `filter_placeholder` | placeholder for the filter input | [^4] |  | — |
| `filter-method` | `filter_method` | custom filter method | [^5]`(query: string, item: Record<string, any>) => boolean` |  | — |
| `target-order` | `target_order` | order strategy for elements in the target list. If set to `original`, the elements will keep the same order as the data source. If set to `push`, the newly added elements will be pushed to the bottom. If set to `unshift`, the newly added elements will be inserted on the top | [^6]`'original' \\| 'push' \\| 'unshift'` |  | original |
| `titles` | `titles` | custom list titles | [^7]`[string, string]` |  | \[\] |
| `button-texts` | `button_texts` | custom button texts | [^8]`[string, string]` |  | \[\] |
| `render-content` | `render_content` | custom render function for data items | [^9]`renderContent` |  | — |
| `format` | `format` | texts for checking status in list header | [^10]`TransferFormat` |  | {} |
| `left-default-checked` | `left_default_checked` | key array of initially checked data items of the left list | [^11]`Array<string \\| number>` |  | \[\] |
| `right-default-checked` | `right_default_checked` | key array of initially checked data items of the right list | [^12]`Array<string \\| number>` |  | \[\] |
| `validate-event` | `validate_event` | whether to trigger form validation | [^13] |  | true |
| `virtual-scroll` | `virtual_scroll` | whether to enable virtual scrolling | [^14] |  | false |
| `item-size` | `item_size` | item height for virtual scrolling | [^15] |  | 30 |

### Transfer Events

| Element | In R | Description |
|----|----|----|
| `change` | `input$<id>_change` | triggers when data items change in the right list |
| `left-check-change` | `input$<id>_left_check_change` | triggers when end user changes the checked state of any data item in the left list |
| `right-check-change` | `input$<id>_right_check_change` | triggers when end user changes the checked state of any data item in the right list |

### Transfer Slots

| Element | In R | Description |
|----|----|----|
| `default` | default content | Custom content for data items. |
| `left-footer` | `slots = list(left-footer = )` | content of left list footer |
| `right-footer` | `slots = list(right-footer = )` | content of right list footer |
| `left-empty` | `slots = list(left-empty = )` | content when left panel is empty or when no data matches the filter |
| `right-empty` | `slots = list(right-empty = )` | content when right panel is empty or when no data matches the filter |

### Transfer Exposes

| Element | In R | Description |
|----|----|----|
| `clearQuery` | `el_call(session, id, "clearQuery")` | clear the filter keyword of a certain panel |

[^1]: array

[^2]: array

[^3]: boolean

[^4]: string

[^5]: Function

[^6]: enum

[^7]: array

[^8]: array

[^9]: object

[^10]: object

[^11]: array

[^12]: array

[^13]: boolean

[^14]: boolean

[^15]: number
