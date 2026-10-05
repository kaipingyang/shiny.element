# Update Element Plus Input

Server-side update for
[`el_input()`](https://kaipingyang.github.io/shiny.element/reference/el_input.md).
Sends a custom message to update named fields on the Vue instance.

## Usage

``` r
update_el_input(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  placeholder = NULL,
  disabled = NULL,
  readonly = NULL,
  type = NULL,
  size = NULL,
  clearable = NULL,
  show_password = NULL,
  label = NULL,
  error = NULL,
  show_word_limit = NULL,
  maxlength = NULL,
  rows = NULL,
  autosize = NULL,
  prefix_icon = NULL,
  suffix_icon = NULL,
  autocomplete = NULL,
  autofocus = NULL,
  name = NULL,
  form = NULL,
  minlength = NULL,
  max = NULL,
  min = NULL,
  step = NULL,
  resize = NULL,
  tabindex = NULL,
  validate_event = NULL,
  aria_label = NULL,
  clear_icon = NULL,
  count_graphemes = NULL,
  formatter = NULL,
  input_style = NULL,
  inputmode = NULL,
  parser = NULL,
  word_limit_position = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Input ID (un-namespaced).

- value:

  New value string.

- placeholder:

  New placeholder text.

- disabled:

  New disabled state.

- readonly:

  New readonly state.

- type:

  New input type.

- size:

  New input size.

- clearable:

  New clearable state.

- show_password:

  New show-password toggle state.

- label:

  New label, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html):
  text, or tags or
  [`HTML()`](https://rstudio.github.io/htmltools/reference/HTML.html)
  drawn as markup. Only a component built with a `label` has one to
  change.

- error:

  An error message to show on the component, as Element's `error` does –
  for a check only the server can make, such as whether a name is taken.
  `""` clears it.

- show_word_limit:

  Whether to show a word-count badge. Requires `maxlength` to be set.
  Default `FALSE`.

- maxlength:

  Maximum character count. `NULL` means no limit.

- rows:

  Number of rows for `type = "textarea"`. `NULL` uses the default.

- autosize:

  Whether to auto-size the textarea height. Either `TRUE`/`FALSE` or a
  named list `list(minRows = 2, maxRows = 4)`. Default `FALSE`.

- prefix_icon:

  Icon class for the prefix slot (e.g. `"el-icon-search"`). `NULL` means
  no icon.

- suffix_icon:

  Icon class for the suffix slot (e.g. `"el-icon-date"`). `NULL` means
  no icon.

- autocomplete:

  Native `autocomplete` attribute. Default `"off"`.

- autofocus:

  Whether the input takes focus on page load. Default `FALSE`.

- name:

  Native `name` attribute.

- form:

  Native `form` attribute.

- minlength:

  Minimum input length.

- max:

  Native `max` attribute, for number-like types.

- min:

  Native `min` attribute, for number-like types.

- step:

  Native `step` attribute, for number-like types.

- resize:

  Resize behaviour of a textarea: `"none"`, `"both"`, `"horizontal"` or
  `"vertical"`.

- tabindex:

  Tab index of the input.

- validate_event:

  Whether a change triggers form validation. Default `TRUE`.

- aria_label:

  Same as `aria-label` in native input. Element Plus's `aria-label`
  (string).

- clear_icon:

  Custom clear icon component. Element Plus's `clear-icon` (string /
  Component). An icon's name, such as `"Search"`.

- count_graphemes:

  Custom function to count graphemes; when set, native
  `maxlength`/`minlength` constraints are bypassed. Component uses
  `Intl.Segmenter` (Chrome 87+, Firefox 125+, Safari 14.1+) for proper
  grapheme clustering; older browsers fall back to `Array.from()` for
  code-point iteration. Element Plus's `count-graphemes` ((value:
  string) =\> number).

- formatter:

  Specifies the format of the value presented input.(only works when
  `type` is 'text'). Element Plus's `formatter` ((value: string \|
  number) =\> string).

- input_style:

  The style of the input element or textarea element. Element Plus's
  `input-style` (`string / CSSProperties | CSSProperties[] | string[]`).

- inputmode:

  Same as `inputmode` in native input. Element Plus's `inputmode`
  (string).

- parser:

  Specifies the value extracted from formatter input.(only works when
  `type` is 'text'). Element Plus's `parser` ((value: string) =\>
  string).

- word_limit_position:

  Word count position, valid when `show-word-limit` is true. Element
  Plus's `word-limit-position` ('inside' \| 'outside').

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

Every other argument of
[`el_input()`](https://kaipingyang.github.io/shiny.element/reference/el_input.md)
that can change once it is drawn is an argument here too, under the same
name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_input(session, "name", value = "Ada")
  })
}
```
