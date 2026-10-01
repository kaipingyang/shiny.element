# Element UI Input with Vue Instance

Creates an Element UI input component (`<el-input>`) with a Vue
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
  width = NULL,
  slots = NULL,
  session = NULL
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

  Input size: `NULL`, `"medium"`, `"small"`, `"mini"`.

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

- session:

  Deprecated. Inside a module, wrap `id` in `ns()`, as for any Shiny
  input; a session given here namespaces `id` once more, with a warning.

## Value

An `htmltools` tagList with a Vue-managed input component.

## Element methods

Callable with
[`el_call()`](https://kaipingyang.github.io/shiny.element/reference/el_call.md):

- `blur()` – Blur the input element

- `focus()` – Focus the input element

- `select()` – Select the text in input element

## Shiny input

`input$<id>` – the text, reported as it is typed, debounced by 250 ms as
[`shiny::textInput()`](https://rdrr.io/pkg/shiny/man/textInput.html)
does, and after an
[`update_el_input()`](https://kaipingyang.github.io/shiny.element/reference/update_el_input.md).
(triggered on blur or Enter key press).

## Examples

``` r
# Basic text input
el_input("name", placeholder = "Enter your name")
#> <div id="name" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="name_container" style="display: contents">
#>   <el-input v-model="value" :type="type" :disabled="disabled" :readonly="readonly" :clearable="clearable" :show-password="showPassword" :show-word-limit="showWordLimit" :autosize="autosize" :prefix-icon="prefixIcon" :suffix-icon="suffixIcon" @change="handleChange" :size="size === null ? undefined : size" :maxlength="maxlength === null ? undefined : maxlength" :rows="rows === null ? undefined : rows" :placeholder="placeholder === null ? undefined : placeholder" :label="label === null ? undefined : label" :autocomplete="autocomplete === null ? undefined : autocomplete" :autofocus="autofocus === null ? undefined : autofocus" :name="name === null ? undefined : name" :form="form === null ? undefined : form" :minlength="minlength === null ? undefined : minlength" :max="max === null ? undefined : max" :min="min === null ? undefined : min" :step="step === null ? undefined : step" :resize="resize === null ? undefined : resize" :tabindex="tabindex === null ? undefined : tabindex" :validate-event="validateEvent === null ? undefined : validateEvent" @input="elEmitInput" @blur="elEmitBlur" @focus="elEmitFocus" @clear="elEmitClear"></el-input>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"","type":"text","disabled":false,"readonly":false,"clearable":false,"showPassword":false,"showWordLimit":false,"autosize":false,"prefixIcon":null,"suffixIcon":null,"size":null,"maxlength":null,"rows":null,"placeholder":"Enter your name","label":null,"autocomplete":null,"autofocus":null,"name":null,"form":null,"minlength":null,"max":null,"min":null,"step":null,"resize":null,"tabindex":null,"validateEvent":null},"methods":{"elEmitInput":"function() { window.shinyElement.emit('name', 'input', arguments); }","elEmitBlur":"function() { window.shinyElement.emit('name', 'blur', arguments); }","elEmitFocus":"function() { window.shinyElement.emit('name', 'focus', arguments); }","elEmitClear":"function() { window.shinyElement.emit('name', 'clear', arguments); }","handleChange":"function(value) { }"}},"input":"value","rate":{"policy":"debounce","delay":250},"type":null,"evals":["options.methods.elEmitInput","options.methods.elEmitBlur","options.methods.elEmitFocus","options.methods.elEmitClear","options.methods.handleChange"]}</script>
#> </div>

# Clearable search input with icon
el_input("search", placeholder = "Search...",
         clearable = TRUE, prefix_icon = "el-icon-search")
#> <div id="search" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="search_container" style="display: contents">
#>   <el-input v-model="value" :type="type" :disabled="disabled" :readonly="readonly" :clearable="clearable" :show-password="showPassword" :show-word-limit="showWordLimit" :autosize="autosize" :prefix-icon="prefixIcon" :suffix-icon="suffixIcon" @change="handleChange" :size="size === null ? undefined : size" :maxlength="maxlength === null ? undefined : maxlength" :rows="rows === null ? undefined : rows" :placeholder="placeholder === null ? undefined : placeholder" :label="label === null ? undefined : label" :autocomplete="autocomplete === null ? undefined : autocomplete" :autofocus="autofocus === null ? undefined : autofocus" :name="name === null ? undefined : name" :form="form === null ? undefined : form" :minlength="minlength === null ? undefined : minlength" :max="max === null ? undefined : max" :min="min === null ? undefined : min" :step="step === null ? undefined : step" :resize="resize === null ? undefined : resize" :tabindex="tabindex === null ? undefined : tabindex" :validate-event="validateEvent === null ? undefined : validateEvent" @input="elEmitInput" @blur="elEmitBlur" @focus="elEmitFocus" @clear="elEmitClear"></el-input>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"","type":"text","disabled":false,"readonly":false,"clearable":true,"showPassword":false,"showWordLimit":false,"autosize":false,"prefixIcon":"el-icon-search","suffixIcon":null,"size":null,"maxlength":null,"rows":null,"placeholder":"Search...","label":null,"autocomplete":null,"autofocus":null,"name":null,"form":null,"minlength":null,"max":null,"min":null,"step":null,"resize":null,"tabindex":null,"validateEvent":null},"methods":{"elEmitInput":"function() { window.shinyElement.emit('search', 'input', arguments); }","elEmitBlur":"function() { window.shinyElement.emit('search', 'blur', arguments); }","elEmitFocus":"function() { window.shinyElement.emit('search', 'focus', arguments); }","elEmitClear":"function() { window.shinyElement.emit('search', 'clear', arguments); }","handleChange":"function(value) { }"}},"input":"value","rate":{"policy":"debounce","delay":250},"type":null,"evals":["options.methods.elEmitInput","options.methods.elEmitBlur","options.methods.elEmitFocus","options.methods.elEmitClear","options.methods.handleChange"]}</script>
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
```
