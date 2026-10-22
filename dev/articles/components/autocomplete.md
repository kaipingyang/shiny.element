# Autocomplete

Get some recommended tips based on the current input.

## Basic Usage

Autocomplete component provides input suggestions.

The `fetch-suggestions` attribute is a method that return suggested
inputs. In this example, `querySearch(queryString, cb)` return
suggestions to Autocomplete via `cb(data)` when suggestions are ready.

``` r

restaurants <- c(
  "vue",
  "element",
  "cooking",
  "mint-ui",
  "vuex",
  "vue-router",
  "babel"
)
tags$div(
  style = "display: flex; gap: 40px",
  tags$div(
    tags$div(class = "demo-title", "list suggestions when activated"),
    el_autocomplete(
      "ac1",
      suggestions = restaurants,
      clearable = TRUE,
      placeholder = "Please Input",
      width = "240px"
    )
  ),
  tags$div(
    tags$div(class = "demo-title", "list suggestions on input"),
    el_autocomplete(
      "ac2",
      suggestions = restaurants,
      trigger_on_focus = FALSE,
      clearable = TRUE,
      placeholder = "Please Input",
      width = "240px"
    )
  )
)
```

list suggestions when activated

list suggestions on input

## Custom template

Customize how suggestions are displayed.

Use `scoped slot` to customize suggestion items. In the scope, you can
access the suggestion object via the `item` key.

Each suggestion drawn with a template of its own: the scoped default
slot.

``` r

el_autocomplete(
  "ac_tpl",
  placeholder = "Please input",
  popper_class = "my-autocomplete",
  suggestions = list(
    list(value = "vue", link = "https://github.com/vuejs/vue"),
    list(value = "element", link = "https://github.com/ElemeFE/element")
  ),
  slots = list(
    suffix = el_icon("Edit", class = "el-input__icon"),
    default = template(
      htmltools::HTML(
        '<div class="value">{{ item.value }}</div><span class="link">{{ item.link }}</span>'
      ),
      scope = "{ item }"
    )
  )
)
```

## Remote search

Search data from server-side.

`remote = TRUE` asks the server: `input$<id>_query` is the text typed,
and `update_el_autocomplete(suggestions =)` answers it.

``` r

el_autocomplete("ac_remote", remote = TRUE, placeholder = "Please input")
```

## Custom Loading

Override loading content.

``` r

el_autocomplete(
  "ac_loading",
  remote = TRUE,
  placeholder = "Please input",
  slots = list(loading = el_icon("Loading", class = "is-loading"))
)
```

## Custom Header & Footer

You can customize both the header and footer of the dropdown using slots

Use slot to customize the content.

``` r

tags$div(
  style = "display: flex; gap: 40px",
  el_autocomplete(
    "ac_header",
    suggestions = c("vue", "element", "cooking"),
    placeholder = "Please input",
    slots = list(header = "header content")
  ),
  el_autocomplete(
    "ac_footer",
    suggestions = c("vue", "element", "cooking"),
    placeholder = "Please input",
    slots = list(footer = "footer content")
  )
)
```

## API

Element Plus’s tables, and beside each entry where it is in R.

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `model-value` | `value`; `input$<id>` | binding value | [^1] |  | — |
| `placeholder` | `placeholder` | the placeholder of Autocomplete | [^2] |  | — |
| `clearable` | `clearable` | whether to show clear button | [^3] |  | false |
| `disabled` | `disabled` | whether Autocomplete is disabled | [^4] |  | false |
| `value-key` | `value_key` | key name of the input suggestion object for display | [^5] |  | value |
| `debounce` | `debounce` | debounce delay when typing, in milliseconds | [^6] |  | 300 |
| `placement` | `placement` | placement of the popup menu | [^7]`'top' \\| 'top-start' \\| 'top-end' \\| 'bottom' \\| 'bottom-start' \\| 'bottom-end'` |  | bottom-start |
| `fetch-suggestions` | `fetch_suggestions` | a method to fetch input suggestions. When suggestions are ready, invoke `callback(data:[])` to return them to Autocomplete | [^8] / [^9]`(queryString: string, callback: callbackfn) => void` |  | — |
| `trigger-on-focus` | `trigger_on_focus` | whether show suggestions when input focus | [^10] |  | true |
| `select-when-unmatched` | `select_when_unmatched` | whether to emit a `select` event on enter when there is no autocomplete match | [^11] |  | false |
| `aria-label` | `aria_label` | native `aria-label` attribute | [^12] |  | — |
| `hide-loading` | `hide_loading` | whether to hide the loading icon in remote search | [^13] |  | false |
| `popper-class` | `popper_class` | custom class name for autocomplete’s dropdown | [^14] / [^15] |  | ’’ |
| `popper-style` | `popper_style` | custom style for autocomplete’s dropdown | [^16] / [^17] |  | — |
| `popper-options` | `popper_options` | [popper.js](https://popper.js.org/docs/v2/) parameters | [^18]refer to [popper.js](https://popper.js.org/docs/v2/) doc |  | {} |
| `show-arrow` | `show_arrow` | whether the dropdown has an arrow | [^19] |  | true |
| `teleported` | `teleported` | whether select dropdown is teleported to the body | [^20] |  | true |
| `append-to` | `append_to` | which select dropdown appends to | [^21] / [^22] |  | — |
| `highlight-first-item` | `highlight_first_item` | whether to highlight first item in remote search suggestions by default | [^23] |  | false |
| `fit-input-width` | `fit_input_width` | whether the width of the dropdown is the same as the input | [^24] |  | false |
| `popper-append-to-body` | `(deprecated upstream;`teleported`)` | whether to append the dropdown to body. If the positioning of the dropdown is wrong, you can try to set this prop to false | [^25] |  | false |
| `loop-navigation` | `loop_navigation` | whether keyboard navigation loops from end to start | [^26] |  | true |

### Events

| Element | In R | Description |
|----|----|----|
| `blur` | `input$<id>_blur`, with `events = "blur"` | triggers when Input blurs |
| `focus` | `input$<id>_focus`, with `events = "focus"` | triggers when Input focuses |
| `input` | `input$<id>_input`, with `events = "input"` | triggers when the Input value change |
| `clear` | `input$<id>_clear`, with `events = "clear"` | triggers when the Input is cleared by clicking the clear button |
| `select` | `input$<id>_select` | triggers when a suggestion is clicked |
| `change` | `input$<id>_change`, with `events = "change"` | triggers when the icon inside Input value change |

### Slots

| Element   | In R                       | Description                           |
|-----------|----------------------------|---------------------------------------|
| `default` | default content            | custom content for input suggestions  |
| `header`  | `slots = list(header = )`  | content at the top of the dropdown    |
| `footer`  | `slots = list(footer = )`  | content at the bottom of the dropdown |
| `prefix`  | `slots = list(prefix = )`  | content as Input prefix               |
| `suffix`  | `slots = list(suffix = )`  | content as Input suffix               |
| `prepend` | `slots = list(prepend = )` | content to prepend before Input       |
| `append`  | `slots = list(append = )`  | content to append after Input         |
| `loading` | `slots = list(loading = )` | override loading content              |

### Exposes

| Element | In R | Description |
|----|----|----|
| `blur` | `call_el(session, id, "blur")` | blur the input element |
| `close` | `call_el(session, id, "close")` | collapse suggestion list |
| `focus` | `call_el(session, id, "focus")` | focus the input element |
| `handleSelect` | `call_el(session, id, "handleSelect")` | triggers when a suggestion is clicked |
| `handleKeyEnter` | `call_el(session, id, "handleKeyEnter")` | handle keyboard enter event |
| `highlight` | `call_el(session, id, "highlight")` | highlight an item in a suggestion |
| `getData` | `call_el(session, id, "getData")` | loading suggestion list |

[^1]: string

[^2]: string

[^3]: boolean

[^4]: boolean

[^5]: string

[^6]: number

[^7]: enum

[^8]: array

[^9]: Function

[^10]: boolean

[^11]: boolean

[^12]: string

[^13]: boolean

[^14]: string

[^15]: object

[^16]: string

[^17]: object

[^18]: object

[^19]: boolean

[^20]: boolean

[^21]: CSSSelector

[^22]: HTMLElement

[^23]: boolean

[^24]: boolean

[^25]: boolean

[^26]: boolean
