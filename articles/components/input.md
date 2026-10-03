# Input

Input data using mouse or keyboard.

## Basic usage

``` r

el_input("in_basic", placeholder = "Please input", width = "240px")
```

## Disabled

Disable the Input with the `disabled` attribute.

``` r

el_input("in_dis", placeholder = "Please input", disabled = TRUE, width = "240px")
```

## Clearable

Make the Input clearable with the `clearable` attribute. After version
2.13.4, the clearable feature is also available for textarea type of
Input.

``` r

el_input("in_clear", placeholder = "Please input", clearable = TRUE, width = "240px")
```

## Custom Clear Icon

You can customize the clear icon by setting the `clear-icon` attribute.

``` r

el_input("in_clear_icon", placeholder = "Please input", clearable = TRUE, clear_icon = "CloseBold",
         width = "240px")
```

## Formatter

Display value within it’s situation with `formatter`, and we usually use
`parser` at the same time.

`formatter` shows the value its way; `parser` reads it back.

``` r

el_input("in_fmt", placeholder = "Please input", width = "240px",
  formatter = JS("function(value) { return `$ ${value}`.replace(/\\B(?=(\\d{3})+(?!\\d))/g, ','); }"),
  parser = JS("function(value) { return value.replace(/\\$\\s?|(,*)/g, ''); }"))
```

## Password box

Make a toggle-able password Input with the `show-password` attribute.
Since 2.13.6, the `password-icon` slot is supported to override the
default icon.

``` r

el_input("in_pass", type = "password", placeholder = "Please input password",
         show_password = TRUE, width = "240px")
```

## Input with icon

Add an icon to indicate input type.

To add icons in Input, you can simply use `prefix-icon` and
`suffix-icon` attributes. Also, the `prefix` and `suffix` named slots
works as well.

``` r

tags$div(style = "display: flex; gap: 16px",
  el_input("in_suffix", placeholder = "Pick a date", suffix_icon = "Calendar", width = "240px"),
  el_input("in_prefix", placeholder = "Type something", prefix_icon = "Search", width = "240px"))
```

## Textarea

Resizable for entering multiple lines of text information. Add attribute
`type="textarea"` to change `input` into native `textarea`.

Control the height by setting the `rows` prop.

``` r

el_input("in_area", type = "textarea", rows = 2, placeholder = "Please input", width = "240px")
```

## Autosize Textarea

Setting the `autosize` prop for a textarea type of Input makes the
height to automatically adjust based on the content. An options object
can be provided to `autosize` to specify the minimum and maximum number
of lines the textarea can automatically adjust.

``` r

tagList(
  el_input("in_auto1", type = "textarea", autosize = TRUE, placeholder = "Please input", width = "240px"),
  tags$div(style = "margin: 20px 0"),
  el_input("in_auto2", type = "textarea", autosize = list(minRows = 2, maxRows = 4),
           placeholder = "Please input", width = "240px"))
```

## Mixed input

Prepend or append an element, generally a label or a button.

Use `slot` to distribute elements that prepend or append to Input.

``` r

tags$div(style = "display: grid; gap: 16px; max-width: 600px",
  el_input("in_pre", placeholder = "Please input", slots = list(prepend = "Http://")),
  el_input("in_app", placeholder = "Please input", slots = list(append = ".com")),
  el_input("in_both", placeholder = "Please input",
           slots = list(prepend = "Http://", append = el_button("in_search", NULL, icon = "Search"))))
```

## Sizes

Add `size` attribute to change the size of Input. In addition to the
default size, there are two other options: `large`, `small`.

``` r

tags$div(style = "display: flex; gap: 16px",
  el_input("in_l", size = "large", placeholder = "Please Input", width = "240px"),
  el_input("in_d", placeholder = "Please Input", width = "240px"),
  el_input("in_s", size = "small", placeholder = "Please Input", width = "240px"))
```

## Limit length

`maxlength` and `minlength` attributes of input, they declare a limit on
the number of characters a user can input. The “number of characters” is
measured using JavaScript string length.Setting the `maxlength` prop for
a text or textarea type of Input can limit the length of input value,
allows you to show word count by setting `show-word-limit` to `true` at
the same time. In 2.11.5, You can set `word-limit-position` to `outside`
to display the word count outside the input.

``` r

tagList(
  el_input("in_lim", maxlength = 10, show_word_limit = TRUE, placeholder = "Please input",
           width = "240px"),
  tags$div(style = "margin: 20px 0"),
  el_input("in_lim_area", type = "textarea", maxlength = 30, show_word_limit = TRUE,
           placeholder = "Please input"))
```

## Count graphemes

Set `count-graphemes` to calculate text length. If it’s set, native
`maxlength` and `minlength` won’t be used.

`count_graphemes` counts as a reader would: an emoji is one character.

``` r

el_input("in_graph", maxlength = 10, show_word_limit = TRUE, width = "240px",
  value = "\U0001F468‍\U0001F469‍\U0001F467",
  count_graphemes = JS("function(value) { return [...new Intl.Segmenter().segment(value)].length; }"))
```

> **Tip**
>
> **Browser Support & Fallback Strategy**
>
> When using the `count-graphemes` prop, the component employs the
> following approach:
>
> - **Primary**: Uses `Intl.Segmenter` API (Chrome 87+, Firefox 125+,
>   Safari 14.1+) for proper grapheme cluster handling. This correctly
>   handles complex emoji, combining marks, and Zero Width Joiner
>   sequences.
>
> - **Fallback**: Older browsers fall back to `Array.from()` for
>   code-point based iteration. Note that this may split multi-codepoint
>   grapheme sequences (e.g., emoji with skin tone modifiers).
>
> When implementing your own `count-graphemes` function, consider using
> `Intl.Segmenter` if you need robust support for complex unicode
> characters.

## API

Element Plus’s tables, and beside each entry where it is in R.

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `type` | `el_input(type =)` | type of input, see more in [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input#Form_%3Cinput%3E_types) | [^1]`'text' \\| 'textarea' \\| 'number' \\| 'password' \\| 'email' \\| 'search' \\| 'tel' \\| 'url'` |  | text |
| `model-value` | `value`; `input$<id>` | binding value | [^2] / [^3] |  | — |
| `model-modifiers` | `(Vue only:`v-model.trim`; trim in R)` | v-model modifiers, reference [Vue modifiers](https://vuejs.org/guide/essentials/forms.html#modifiers) | [^4]`{ lazy?: true, number?: true, trim?: true }` |  | — |
| `maxlength` | `el_input(maxlength =)` | same as `maxlength` in native input | [^5] / [^6] |  | — |
| `minlength` | `el_input(minlength =)` | same as `minlength` in native input | [^7] / [^8] |  | — |
| `show-word-limit` | `el_input(show_word_limit =)` | whether show word count, only works when `type` is ‘text’ or ‘textarea’ | [^9] |  | false |
| `word-limit-position` | `el_input(word_limit_position =)` | word count position, valid when `show-word-limit` is true | [^10]`'inside' \\| 'outside'` |  | “inside” |
| `placeholder` | `el_input(placeholder =)` | placeholder of Input | [^11] |  | — |
| `clearable` | `el_input(clearable =)` | whether to show clear button, only works when `type` is not ‘textarea’ | [^12] |  | false |
| `clear-icon` | `el_input(clear_icon =)` | custom clear icon component | [^13] / [^14]`Component` |  | CircleClose |
| `formatter` | `el_input(formatter =)` | specifies the format of the value presented input.(only works when `type` is ‘text’) | [^15]`(value: string \\| number) => string` |  | — |
| `parser` | `el_input(parser =)` | specifies the value extracted from formatter input.(only works when `type` is ‘text’) | [^16]`(value: string) => string` |  | — |
| `show-password` | `el_input(show_password =)` | whether to show toggleable password input | [^17] |  | false |
| `disabled` | `el_input(disabled =)` | whether Input is disabled | [^18] |  | false |
| `size` | `el_input(size =)` | size of Input, works when `type` is not ‘textarea’ | [^19]`'large' \\| 'default' \\| 'small'` |  | — |
| `prefix-icon` | `el_input(prefix_icon =)` | prefix icon component | [^20] / [^21] |  | — |
| `suffix-icon` | `el_input(suffix_icon =)` | suffix icon component | [^22] / [^23] |  | — |
| `rows` | `el_input(rows =)` | number of rows of textarea, only works when `type` is ‘textarea’ | [^24] |  | 2 |
| `autosize` | `el_input(autosize =)` | whether textarea has an adaptive height, only works when `type` is ‘textarea’. Can accept an object, e.g. `{ minRows: 2, maxRows: 6 }` | [^25] / [^26]`{ minRows?: number, maxRows?: number }` |  | false |
| `autocomplete` | `el_input(autocomplete =)` | same as `autocomplete` in native input | [^27] |  | off |
| `readonly` | `el_input(readonly =)` | same as `readonly` in native input | [^28] |  | false |
| `max` | `el_input(max =)` | same as `max` in native input | — |  | — |
| `min` | `el_input(min =)` | same as `min` in native input | — |  | — |
| `step` | `el_input(step =)` | same as `step` in native input | — |  | — |
| `resize` | `el_input(resize =)` | control the resizability | [^29]`'none' \\| 'both' \\| 'horizontal' \\| 'vertical'` |  | — |
| `autofocus` | `el_input(autofocus =)` | same as `autofocus` in native input | [^30] |  | false |
| `form` | `el_input(form =)` | same as `form` in native input | `string` |  | — |
| `aria-label` | `el_input(aria_label =)` | same as `aria-label` in native input | [^31] |  | — |
| `tabindex` | `el_input(tabindex =)` | input tabindex | [^32] / [^33] |  | — |
| `validate-event` | `el_input(validate_event =)` | whether to trigger form validation | [^34] |  | true |
| `input-style` | `el_input(input_style =)` | the style of the input element or textarea element | [^35] / [^36]`CSSProperties \\| CSSProperties[] \\| string[]` |  | {} |
| `label` | `el_input(label =)` | same as `aria-label` in native input | [^37] |  | — |
| `inputmode` | `el_input(inputmode =)` | same as `inputmode` in native input | [^38] |  | — |
| `count-graphemes` | `el_input(count_graphemes =)` | custom function to count graphemes; when set, native `maxlength`/`minlength` constraints are bypassed. Component uses `Intl.Segmenter` (Chrome 87+, Firefox 125+, Safari 14.1+) for proper grapheme clustering; older browsers fall back to `Array.from()` for code-point iteration | [^39]`(value: string) => number` |  | — |

### Events

| Element | In R | Description |
|----|----|----|
| `blur` | `input$<id>_blur` | triggers when Input blurs |
| `focus` | `input$<id>_focus` | triggers when Input focuses |
| `change` | `input$<id>_change` | triggers when the input box loses focus or the user presses Enter, only if the modelValue has changed |
| `input` | `input$<id>_input` | triggers when the Input value change |
| `clear` | `input$<id>_clear` | triggers when the Input is cleared by clicking the clear button |
| `keydown` | `input$<id>_keydown` | triggers when a key is pressed down |
| `mouseleave` | `input$<id>_mouseleave` | triggers when the mouse leaves the Input element |
| `mouseenter` | `input$<id>_mouseenter` | triggers when the mouse enters the Input element |
| `compositionstart` | `input$<id>_compositionstart` | triggers when the composition starts |
| `compositionupdate` | `input$<id>_compositionupdate` | triggers when the composition is updated |
| `compositionend` | `input$<id>_compositionend` | triggers when the composition ends |

### Slots

| Element | In R | Description |
|----|----|----|
| `prefix` | `slots = list(prefix = )` | content as Input prefix, only works when `type` is not ‘textarea’ |
| `suffix` | `slots = list(suffix = )` | content as Input suffix, only works when `type` is not ‘textarea’ |
| `prepend` | `slots = list(prepend = )` | content to prepend before Input, only works when `type` is not ‘textarea’ |
| `append` | `slots = list(append = )` | content to append after Input, only works when `type` is not ‘textarea’ |
| `password-icon` | `slots = list(password-icon = )` | content as Input password icon, only works when `show-password` is true. The scope variable is `{ visible: boolean }` |

### Exposes

| Element | In R | Description |
|----|----|----|
| `blur` | `el_call(session, id, "blur")` | blur the input element |
| `clear` | `el_call(session, id, "clear")` | clear input value |
| `focus` | `el_call(session, id, "focus")` | focus the input element |
| `resizeTextarea` | `el_call(session, id, "resizeTextarea")` | resize textarea |
| `select` | `el_call(session, id, "select")` | select the text in input element |

[^1]: string

[^2]: string

[^3]: number

[^4]: object

[^5]: string

[^6]: number

[^7]: string

[^8]: number

[^9]: boolean

[^10]: enum

[^11]: string

[^12]: boolean

[^13]: string

[^14]: object

[^15]: Function

[^16]: Function

[^17]: boolean

[^18]: boolean

[^19]: enum

[^20]: string

[^21]: Component

[^22]: string

[^23]: Component

[^24]: number

[^25]: boolean

[^26]: object

[^27]: string

[^28]: boolean

[^29]: enum

[^30]: boolean

[^31]: string

[^32]: string

[^33]: number

[^34]: boolean

[^35]: string

[^36]: object

[^37]: string

[^38]: string

[^39]: Function
