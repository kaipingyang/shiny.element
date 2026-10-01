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

  ARIA `label` attribute for accessibility. `NULL` omits it.

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

`input$<id>` — string value of the input, updated on `change` event
(triggered on blur or Enter key press).

## Examples

``` r
# Basic text input
el_input("name", placeholder = "Enter your name")
#> <div id="name" data-el-vue-host style="display: contents">
#>   <div id="name_container" data-el-mount style="display: contents">
#>     <el-input v-model="value" :type="type" :disabled="disabled" :readonly="readonly" :clearable="clearable" :show-password="showPassword" :show-word-limit="showWordLimit" :autosize="autosize" :prefix-icon="prefixIcon" :suffix-icon="suffixIcon" @change="handleChange" :size="size === null ? undefined : size" :maxlength="maxlength === null ? undefined : maxlength" :rows="rows === null ? undefined : rows" :placeholder="placeholder === null ? undefined : placeholder" :label="label === null ? undefined : label" :autocomplete="autocomplete === null ? undefined : autocomplete" :autofocus="autofocus === null ? undefined : autofocus" :name="name === null ? undefined : name" :form="form === null ? undefined : form" :minlength="minlength === null ? undefined : minlength" :max="max === null ? undefined : max" :min="min === null ? undefined : min" :step="step === null ? undefined : step" :resize="resize === null ? undefined : resize" :tabindex="tabindex === null ? undefined : tabindex" :validate-event="validateEvent === null ? undefined : validateEvent" @input="elEmitInput" @blur="elEmitBlur" @focus="elEmitFocus" @clear="elEmitClear"></el-input>
#>   </div>
#>   <script type="application/json" data-el-vue>{"options":{"data":{"value":"","type":"text","disabled":false,"readonly":false,"clearable":false,"showPassword":false,"showWordLimit":false,"autosize":false,"prefixIcon":null,"suffixIcon":null,"size":null,"maxlength":null,"rows":null,"placeholder":"Enter your name","label":null,"autocomplete":null,"autofocus":null,"name":null,"form":null,"minlength":null,"max":null,"min":null,"step":null,"resize":null,"tabindex":null,"validateEvent":null},"methods":{"elEmitInput":"function() { window.shinyElement.emit('name', 'input', arguments); }","elEmitBlur":"function() { window.shinyElement.emit('name', 'blur', arguments); }","elEmitFocus":"function() { window.shinyElement.emit('name', 'focus', arguments); }","elEmitClear":"function() { window.shinyElement.emit('name', 'clear', arguments); }","handleChange":"function(value) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('name', value); }"}},"input":"value","rate":null,"type":null,"evals":["options.methods.elEmitInput","options.methods.elEmitBlur","options.methods.elEmitFocus","options.methods.elEmitClear","options.methods.handleChange"]}</script>
#> </div>

# Clearable search input with icon
el_input("search", placeholder = "Search...",
         clearable = TRUE, prefix_icon = "el-icon-search")
#> <div id="search" data-el-vue-host style="display: contents">
#>   <div id="search_container" data-el-mount style="display: contents">
#>     <el-input v-model="value" :type="type" :disabled="disabled" :readonly="readonly" :clearable="clearable" :show-password="showPassword" :show-word-limit="showWordLimit" :autosize="autosize" :prefix-icon="prefixIcon" :suffix-icon="suffixIcon" @change="handleChange" :size="size === null ? undefined : size" :maxlength="maxlength === null ? undefined : maxlength" :rows="rows === null ? undefined : rows" :placeholder="placeholder === null ? undefined : placeholder" :label="label === null ? undefined : label" :autocomplete="autocomplete === null ? undefined : autocomplete" :autofocus="autofocus === null ? undefined : autofocus" :name="name === null ? undefined : name" :form="form === null ? undefined : form" :minlength="minlength === null ? undefined : minlength" :max="max === null ? undefined : max" :min="min === null ? undefined : min" :step="step === null ? undefined : step" :resize="resize === null ? undefined : resize" :tabindex="tabindex === null ? undefined : tabindex" :validate-event="validateEvent === null ? undefined : validateEvent" @input="elEmitInput" @blur="elEmitBlur" @focus="elEmitFocus" @clear="elEmitClear"></el-input>
#>   </div>
#>   <script type="application/json" data-el-vue>{"options":{"data":{"value":"","type":"text","disabled":false,"readonly":false,"clearable":true,"showPassword":false,"showWordLimit":false,"autosize":false,"prefixIcon":"el-icon-search","suffixIcon":null,"size":null,"maxlength":null,"rows":null,"placeholder":"Search...","label":null,"autocomplete":null,"autofocus":null,"name":null,"form":null,"minlength":null,"max":null,"min":null,"step":null,"resize":null,"tabindex":null,"validateEvent":null},"methods":{"elEmitInput":"function() { window.shinyElement.emit('search', 'input', arguments); }","elEmitBlur":"function() { window.shinyElement.emit('search', 'blur', arguments); }","elEmitFocus":"function() { window.shinyElement.emit('search', 'focus', arguments); }","elEmitClear":"function() { window.shinyElement.emit('search', 'clear', arguments); }","handleChange":"function(value) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('search', value); }"}},"input":"value","rate":null,"type":null,"evals":["options.methods.elEmitInput","options.methods.elEmitBlur","options.methods.elEmitFocus","options.methods.elEmitClear","options.methods.handleChange"]}</script>
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
