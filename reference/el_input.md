# Element Plus Input with Vue Instance

Creates an Element Plus input component (`<el-input>`) with a Vue
instance, supporting text, textarea, and password modes, plus clearable,
prefix/suffix icons, word-limit display, and autosize textarea.

## Usage

``` r
el_input(
  id = NULL,
  value = "",
  placeholder = NULL,
  type = "text",
  size = NULL,
  disabled = FALSE,
  readonly = FALSE,
  clearable = FALSE,
  show_password = FALSE,
  show_word_limit = FALSE,
  maxlength = NULL,
  rows = NULL,
  autosize = FALSE,
  prefix_icon = NULL,
  suffix_icon = NULL,
  label = NULL,
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
  label_position = c("top", "left", "right"),
  label_width = NULL,
  label_suffix = NULL,
  required = FALSE,
  error = NULL,
  show_message = TRUE,
  inline_message = FALSE,
  aria_label = NULL,
  clear_icon = NULL,
  count_graphemes = NULL,
  formatter = NULL,
  input_style = NULL,
  inputmode = NULL,
  parser = NULL,
  word_limit_position = NULL,
  width = NULL,
  slots = NULL,
  events = NULL,
  on = NULL,
  session = NULL
)

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

- id:

  Input ID. Auto-generated UUID if `NULL`.

- value:

  Initial input value. Default `""`.

- placeholder:

  Placeholder text. `NULL` means no placeholder attribute.

- type:

  Input type: `"text"` (default), `"textarea"`, `"password"`.

- size:

  Size: `"large"`, `"default"` or `"small"`; `NULL` follows the form or
  the page.

- disabled:

  Whether the input is disabled. Default `FALSE`.

- readonly:

  Whether the input is read-only. Default `FALSE`.

- clearable:

  Whether to show a clear button. Default `FALSE`.

- show_password:

  Whether to show the password toggle icon. Only meaningful when
  `type = "password"`. Default `FALSE`.

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

- label:

  A label shown with the component, as Shiny's inputs have: text or a
  tag. `NULL`, the default, shows none. It is the component's accessible
  name too – tied to it with `for` where the component has a native
  input that takes the id `<id>-input`, else with `aria-labelledby`.

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

- label_position:

  Where the label sits, as
  [`el_form()`](https://kaipingyang.github.io/shiny.element/reference/el_form.md)'s
  `label_position`: `"top"` (the default, as Shiny's labels sit), or
  beside the component, its text aligned `"left"` or `"right"` – which
  shows once `label_width` gives the labels a common width.

- label_width:

  Width of a label beside the component, as a CSS unit, so that several
  line up. Element's `label-width`.

- label_suffix:

  Text after the label, such as `":"`. Element's `label-suffix`.

- required:

  Draw Element's red asterisk before the label. It marks the field; it
  does not check it – shinyvalidate or
  [`el_form()`](https://kaipingyang.github.io/shiny.element/reference/el_form.md)
  does that.

- error:

  An error message shown under the component in Element's style, the
  field framed in red. Element's `error`.

- show_message, inline_message:

  Whether `error`'s message is shown, and whether beside the component
  rather than under it. Element's `show-message` and `inline-message`.

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

- width:

  Component width, as a CSS unit – `"200px"`, `"50%"`, or a number taken
  as pixels. Element's own markup carries it, so it behaves like the
  `width` argument of a Shiny input.

- slots:

  Named list of Element slot contents, such as
  `list(title = shiny::tags$b("Bold"))`. A shiny.element component given
  here is absorbed rather than nested. For a scoped slot, write the
  template with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).

- events:

  Element's events to report besides those reported unasked, by name:
  `events = "node_drop"` reports `input$<id>_node_drop`. The component's
  are listed under "Shiny inputs", and by
  [`el_events()`](https://kaipingyang.github.io/shiny.element/reference/el_events.md);
  a name it does not have is an error.

- on:

  Handlers of your own, for an event not reported or to send something
  else: a named list of
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  functions, one per event – Element's, or a DOM event with Vue's
  modifiers (`"keyup.enter"`). Each is called with `report` and the
  event's arguments; `report(name, value)` sets `input$<id>_<name>`. See
  [`el_widget()`](https://kaipingyang.github.io/shiny.element/reference/el_widget.md).

- session:

  In `el_input()`, deprecated: inside a module, wrap `id` in `ns()`, as
  for any Shiny input; a session given here namespaces `id` once more,
  with a warning. In `update_el_input()`, the Shiny session, the current
  one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

## Value

An `htmltools` tagList with a Vue-managed input component.

## Element methods

Callable with
[`call_el()`](https://kaipingyang.github.io/shiny.element/reference/call_el.md):

- `blur()` – Blur the input element

- `focus()` – Focus the input element

- `select()` – Select the text in input element

## Shiny inputs

|  |  |  |
|----|----|----|
| Input | Reported | Value |
| `input$<id>` | unasked | the text, as it is typed (debounced by 250 ms) |
| `input$<id>_input` | `events = "input"` | triggers when the Input value change |
| `input$<id>_blur` | `events = "blur"` | triggers when Input blurs |
| `input$<id>_focus` | `events = "focus"` | triggers when Input focuses |
| `input$<id>_clear` | `events = "clear"` | triggers when the Input is cleared by clicking the clear button |
| `input$<id>_compositionend` | `events = "compositionend"` | triggers when the composition ends |
| `input$<id>_compositionstart` | `events = "compositionstart"` | triggers when the composition starts |
| `input$<id>_compositionupdate` | `events = "compositionupdate"` | triggers when the composition is updated |
| `input$<id>_keydown` | `events = "keydown"` | the key: `list(key, code, ctrl, shift, alt, meta)` |
| `input$<id>_mouseenter` | `events = "mouseenter"` | triggers when the mouse enters the Input element |
| `input$<id>_mouseleave` | `events = "mouseleave"` | triggers when the mouse leaves the Input element |

The same list as `el_events("el_input")`, which says how an event's
arguments travel.

The text is debounced by 250 ms, as
[`shiny::textInput()`](https://rdrr.io/pkg/shiny/man/textInput.html)'s
is, and reported after an `update_el_input()` too.

## Updating from the server

Server-side update for `el_input()`. Sends a custom message to update
named fields on the Vue instance.

Every other argument of `el_input()` that can change once it is drawn is
an argument here too, under the same name. One left `NULL` stays as it
is; `NA` returns it to Element's default.

`update_el_input()` is called for its side effect and returns `NULL`
invisibly.

## Examples

``` r
# Basic text input
el_input("name", placeholder = "Enter your name")
#> <div id="name" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="name_container" style="display: contents">
#>   <el-input v-model="value" :type="type" :disabled="disabled" :readonly="readonly" :clearable="clearable" :show-password="showPassword" :show-word-limit="showWordLimit" :autosize="autosize" :prefix-icon="prefixIcon" :suffix-icon="suffixIcon" @change="handleChange" :size="size === null ? undefined : size" :maxlength="maxlength === null ? undefined : maxlength" :rows="rows === null ? undefined : rows" :placeholder="placeholder === null ? undefined : placeholder" :label="label === null ? undefined : label" :autocomplete="autocomplete === null ? undefined : autocomplete" :autofocus="autofocus === null ? undefined : autofocus" :name="name === null ? undefined : name" :form="form === null ? undefined : form" :minlength="minlength === null ? undefined : minlength" :max="max === null ? undefined : max" :min="min === null ? undefined : min" :step="step === null ? undefined : step" :resize="resize === null ? undefined : resize" :tabindex="tabindex === null ? undefined : tabindex" :validate-event="validateEvent === null ? undefined : validateEvent" :aria-label="ariaLabel === null ? undefined : ariaLabel" :clear-icon="clearIcon === null ? undefined : clearIcon" :count-graphemes="countGraphemes === null ? undefined : countGraphemes" :formatter="formatter === null ? undefined : formatter" :input-style="inputStyle === null ? undefined : inputStyle" :inputmode="inputmode === null ? undefined : inputmode" :parser="parser === null ? undefined : parser" :word-limit-position="wordLimitPosition === null ? undefined : wordLimitPosition"></el-input>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"","type":"text","disabled":false,"readonly":false,"clearable":false,"showPassword":false,"showWordLimit":false,"autosize":false,"prefixIcon":null,"suffixIcon":null,"size":null,"maxlength":null,"rows":null,"placeholder":"Enter your name","label":null,"autocomplete":null,"autofocus":null,"name":null,"form":null,"minlength":null,"max":null,"min":null,"step":null,"resize":null,"tabindex":null,"validateEvent":null,"ariaLabel":null,"clearIcon":null,"countGraphemes":null,"formatter":null,"inputStyle":null,"inputmode":null,"parser":null,"wordLimitPosition":null},"methods":{"handleChange":"function(value) { }"}},"input":"value","rate":{"policy":"debounce","delay":250},"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.handleChange"]}</script>
#> </div>

# Clearable search input with icon
el_input(
  "search",
  placeholder = "Search...",
  clearable = TRUE,
  prefix_icon = "el-icon-search"
)
#> <div id="search" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="search_container" style="display: contents">
#>   <el-input v-model="value" :type="type" :disabled="disabled" :readonly="readonly" :clearable="clearable" :show-password="showPassword" :show-word-limit="showWordLimit" :autosize="autosize" :prefix-icon="prefixIcon" :suffix-icon="suffixIcon" @change="handleChange" :size="size === null ? undefined : size" :maxlength="maxlength === null ? undefined : maxlength" :rows="rows === null ? undefined : rows" :placeholder="placeholder === null ? undefined : placeholder" :label="label === null ? undefined : label" :autocomplete="autocomplete === null ? undefined : autocomplete" :autofocus="autofocus === null ? undefined : autofocus" :name="name === null ? undefined : name" :form="form === null ? undefined : form" :minlength="minlength === null ? undefined : minlength" :max="max === null ? undefined : max" :min="min === null ? undefined : min" :step="step === null ? undefined : step" :resize="resize === null ? undefined : resize" :tabindex="tabindex === null ? undefined : tabindex" :validate-event="validateEvent === null ? undefined : validateEvent" :aria-label="ariaLabel === null ? undefined : ariaLabel" :clear-icon="clearIcon === null ? undefined : clearIcon" :count-graphemes="countGraphemes === null ? undefined : countGraphemes" :formatter="formatter === null ? undefined : formatter" :input-style="inputStyle === null ? undefined : inputStyle" :inputmode="inputmode === null ? undefined : inputmode" :parser="parser === null ? undefined : parser" :word-limit-position="wordLimitPosition === null ? undefined : wordLimitPosition"></el-input>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"","type":"text","disabled":false,"readonly":false,"clearable":true,"showPassword":false,"showWordLimit":false,"autosize":false,"prefixIcon":"el-icon-search","suffixIcon":null,"size":null,"maxlength":null,"rows":null,"placeholder":"Search...","label":null,"autocomplete":null,"autofocus":null,"name":null,"form":null,"minlength":null,"max":null,"min":null,"step":null,"resize":null,"tabindex":null,"validateEvent":null,"ariaLabel":null,"clearIcon":null,"countGraphemes":null,"formatter":null,"inputStyle":null,"inputmode":null,"parser":null,"wordLimitPosition":null},"methods":{"handleChange":"function(value) { }"}},"input":"value","rate":{"policy":"debounce","delay":250},"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.handleChange"]}</script>
#> </div>

# Shiny app example
if (interactive()) {
  library(shiny)
  library(shiny.element)
  ui <- el_page(
    el_input("txt", placeholder = "Type something"),
    verbatimTextOutput("val")
  )
  server <- function(input, output, session) {
    output$val <- renderPrint(input$txt)
  }
  shinyApp(ui, server)
}
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_input(session, "name", value = "Ada")
  })
}
```
