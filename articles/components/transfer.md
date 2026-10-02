# Transfer

Move items between two lists. `data` is a data frame of `key` and
`label` (and `disabled`), and `input$<id>` the keys on the right.

## Basic usage

``` r

items <- data.frame(key = 1:15, label = paste("Option", 1:15), disabled = 1:15 %% 4 == 0)
el_transfer("basic", data = items, value = c(1, 4))
```

## Filterable

``` r

states <- c("California", "Illinois", "Maryland", "Texas", "Florida", "Colorado", "Connecticut")
el_transfer("states", data = data.frame(key = seq_along(states), label = states),
            filterable = TRUE, filter_placeholder = "State abbreviations")
```

## Customizable

`titles`, `button_texts` and `format` relabel it; `render_content` draws
each item, as a
[`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
render function, or the default slot, scoped with `option`.

``` r

items <- data.frame(key = 1:8, label = paste("Option", 1:8))
el_transfer("custom", data = items, value = 1, filterable = TRUE,
            titles = c("Source", "Target"), button_texts = c("To left", "To right"),
            format = list(noChecked = "${total}", hasChecked = "${checked}/${total}"),
            slots = list(default = template(
              tags$span("{{ option.key }} - {{ option.label }}"), scope = "{ option }")))
```

## Prop aliases

Items whose fields are named otherwise: `props` says which is which.

``` r

items <- data.frame(value = 1:6, desc = paste("Option", 1:6))
el_transfer("aliases", data = items, props = list(key = "value", label = "desc"))
```

## API

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `value` | `value` | binding value | array | — | — |
| `data` | `data` | data source | array\[{ key, label, disabled }\] | — | \[ \] |
| `filterable` | `filterable` | whether Transfer is filterable | boolean | — | false |
| `filter-placeholder` | `filter_placeholder` | placeholder for the filter input | string | — | Enter keyword |
| `filter-method` | `filter_method` | custom filter method | function | — | — |
| `target-order` | `target_order` | order strategy for elements in the target list. If set to `original`, the elements will keep the same order as the data source. If set to `push`, the newly added elements will be pushed to the bottom. If set to `unshift`, the newly added elements will be inserted on the top | string | original / push / unshift | original |
| `titles` | `titles` | custom list titles | array | — | \[‘List 1’, ‘List 2’\] |
| `button-texts` | `button_texts` | custom button texts | array | — | \[ \] |
| `render-content` | `render_content` | custom render function for data items | function(h, option) | — | — |
| `format` | `format` | texts for checking status in list header | object{noChecked, hasChecked} | — | { noChecked: ‘$`{checked}/`${total}’, hasChecked: ‘$`{checked}/`${total}’ } |
| `props` | `props` | prop aliases for data source | object{key, label, disabled} | — | — |
| `left-default-checked` | `left_default_checked` | key array of initially checked data items of the left list | array | — | \[ \] |
| `right-default-checked` | `right_default_checked` | key array of initially checked data items of the right list | array | — | \[ \] |

### Slot

| Element | In R | Description |
|----|----|----|
| `left-footer` | `slots = list(left-footer = )` | content of left list footer |
| `right-footer` | `slots = list(right-footer = )` | content of right list footer |

### Methods

| Element | In R | Description |
|----|----|----|
| `clearQuery` | `el_call(session, id, "clearQuery")` | clear the filter keyword of a certain panel |

### Events

| Element | In R | Description |
|----|----|----|
| `change` | `input$<id>_change` | triggers when data items change in the right list |
| `left-check-change` | `input$<id>_left_check_change` | triggers when end user changes the checked state of any data item in the left list |
| `right-check-change` | `input$<id>_right_check_change` | triggers when end user changes the checked state of any data item in the right list |
