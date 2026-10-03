# Mention

Used to mention someone or something in an input.

## Basic Usage

The most basic usage.

``` r

el_mention("mention", value = "@", width = "320px", placeholder = "Please input",
           options = c("Fuphoenixes", "kooriookami", "Jeremy", "btea"))
```

## Props

You can customize the alias of the `options` through the `props`
attribute.

``` r

el_mention("mention_props", value = "@", width = "320px", placeholder = "Please input",
           props = list(label = "name", value = "id", disabled = "unable"),
           options = list(list(name = "Fuphoenixes", id = "1"), list(name = "kooriookami", id = "2"),
                          list(name = "Jeremy", id = "3", unable = TRUE)))
```

## Textarea

The input type can be set to `textarea`.

``` r

el_mention("mention_area", type = "textarea", width = "320px", placeholder = "Please input",
           options = c("Fuphoenixes", "kooriookami", "Jeremy", "btea"))
```

## Customize label

Customize label by `label` slot.

``` r

el_mention("mention_label", width = "320px", placeholder = "Please input",
  options = c("Fuphoenixes", "kooriookami", "Jeremy", "btea"),
  slots = list(label = template(htmltools::HTML(
    "<div style=\"display: flex; align-items: center\"><el-avatar :size=\"24\" style=\"margin-right: 8px\">{{ item.label.charAt(0) }}</el-avatar><span>{{ item.label }}</span></div>"),
    slot = "label", scope = "{ item }")))
```

## Load remote options

Load options asynchronously.

`input$<id>_search` is the text after the trigger, as it is typed; the
server answers with
[`update_el_mention()`](https://kaipingyang.github.io/shiny.element/reference/update_el_mention.md)
and `loading`.

``` r

el_mention("mention_load", width = "320px", placeholder = "Please input", loading = TRUE)
```

## Customize trigger token

Customize trigger token by `prefix` props. Default to `@`,
`Array<string>` also supported.

``` r

el_mention("mention_prefix", width = "320px", placeholder = "Please input",
           prefix = c("@", "#"), options = c("Fuphoenixes", "kooriookami", "Jeremy"))
```

## Delete as a whole

Set the `whole` attribute to `true`, and when you press the backspace,
the mention will be deleted as a whole. Set the `check-is-whole`
attribute to customize the checking logic.

``` r

el_mention("mention_whole", value = "@Fuphoenixes ", whole = TRUE, width = "320px",
           options = c("Fuphoenixes", "kooriookami", "Jeremy"))
```

## Work with form

to work with `el-form`.

``` r

el_form(id = "mention_form", submit_label = "Submit", label_width = "auto", width = "480px",
  el_form_field("message", "input", label = "Message",
                rules = el_rule(required = TRUE, message = "Please input a message")))
```

Since this component is developed based on the component
[`el-input`](https://kaipingyang.github.io/shiny.element/articles/components/input.html#attributes)
, the original properties have not changed, so no repetition here, and
please go to the original component to view the documentation.

## API

Element Plus’s tables, and beside each entry where it is in R.

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `options` | `options` | mention options list | [^1]`MentionOption[]` |  | `[]` |
| `props` | `props` | configuration options | [^2]`MentionOptionProps` |  | `{value: 'value', label: 'label', disabled: 'disabled'}` |
| `prefix` | `prefix` | prefix character to trigger mentions. The string length must be exactly 1 | [^3] \\ | [^4]`string[]` |  |
| `split` | `split` | character to split mentions. The string length must be exactly 1 | [^5] |  | `' '` |
| `filter-option` | `filter_option` | customize filter option logic | [^6] \\ | [^7]`(pattern: string, option: MentionOption) => boolean` |  |
| `placement` | `placement` | set popup placement | [^8]`'bottom' \\| 'top'` |  | `'bottom'` |
| `show-arrow` | `show_arrow` | whether the dropdown panel has an arrow | [^9] |  | `false` |
| `offset` | `offset` | offset of the dropdown panel | [^10] |  | `0` |
| `whole` | `whole` | when backspace is pressed to delete, whether the mention content is deleted as a whole | [^11] |  | `false` |
| `check-is-whole` | `check_is_whole` | when backspace is pressed to delete, check if the mention is a whole | [^12]`(pattern: string, prefix: string) => boolean` |  | — |
| `loading` | `loading` | whether the dropdown panel of mentions is in a loading state | [^13] |  | `false` |
| `model-value` | `value`; `input$<id>` | input value | [^14] |  | — |
| `popper-class` | `popper_class` | custom class name for dropdown panel | [^15] / [^16] |  | ’’ |
| `popper-style` | `popper_style` | custom style for dropdown panel | [^17] / [^18] |  | — |
| `popper-options` | `popper_options` | [popper.js](https://popper.js.org/docs/v2/) parameters | [^19] refer to [popper.js doc](https://popper.js.org/docs/v2/) |  | — |

### Events

| Element | In R | Description |
|----|----|----|
| `search` | `input$<id>_search` | trigger when prefix hit |
| `select` | `input$<id>_select` | trigger when user select the option |
| `whole-remove` | `input$<id>_whole_remove` | trigger when a whole mention is removed and `whole` is `true` or `check-is-whole` is `true` |

### Slots

| Element   | In R                       | Description                           |
|-----------|----------------------------|---------------------------------------|
| `label`   | `slots = list(label = )`   | content as option label               |
| `loading` | `slots = list(loading = )` | content as option loading             |
| `header`  | `slots = list(header = )`  | content at the top of the dropdown    |
| `footer`  | `slots = list(footer = )`  | content at the bottom of the dropdown |

[^1]: array

[^2]: object

[^3]: string

[^4]: array

[^5]: string

[^6]: false

[^7]: Function

[^8]: string

[^9]: boolean

[^10]: number

[^11]: boolean

[^12]: Function

[^13]: boolean

[^14]: string

[^15]: string

[^16]: object

[^17]: string

[^18]: object

[^19]: object
