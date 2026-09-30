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
  session = shiny::getDefaultReactiveDomain()
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

- session:

  Shiny session for module support.

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
#> <div id="name_container" style="display: contents">
#>   <el-input v-model="value" :type="type" :disabled="disabled" :readonly="readonly" :clearable="clearable" :show-password="showPassword" :show-word-limit="showWordLimit" :autosize="autosize" :prefix-icon="prefixIcon" :suffix-icon="suffixIcon" @change="handleChange" :size="size === null ? undefined : size" :maxlength="maxlength === null ? undefined : maxlength" :rows="rows === null ? undefined : rows" :placeholder="placeholder === null ? undefined : placeholder" :label="label === null ? undefined : label" :autocomplete="autocomplete === null ? undefined : autocomplete" :autofocus="autofocus === null ? undefined : autofocus" :name="name === null ? undefined : name" :form="form === null ? undefined : form" :minlength="minlength === null ? undefined : minlength" :max="max === null ? undefined : max" :min="min === null ? undefined : min" :step="step === null ? undefined : step" :resize="resize === null ? undefined : resize" :tabindex="tabindex === null ? undefined : tabindex" :validate-event="validateEvent === null ? undefined : validateEvent" @input="elEmitInput" @blur="elEmitBlur" @focus="elEmitFocus" @clear="elEmitClear"></el-input>
#> </div>
#> <div id="name" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="name">{"x":{"el":"#name_container","data":{"value":"","type":"text","disabled":false,"readonly":false,"clearable":false,"showPassword":false,"showWordLimit":false,"autosize":false,"prefixIcon":null,"suffixIcon":null,"size":null,"maxlength":null,"rows":null,"placeholder":"Enter your name","label":null,"autocomplete":null,"autofocus":null,"name":null,"form":null,"minlength":null,"max":null,"min":null,"step":null,"resize":null,"tabindex":null,"validateEvent":null},"methods":{"elEmitInput":"function() { window.shinyElement.emit('name', 'input', arguments); }","elEmitBlur":"function() { window.shinyElement.emit('name', 'blur', arguments); }","elEmitFocus":"function() { window.shinyElement.emit('name', 'focus', arguments); }","elEmitClear":"function() { window.shinyElement.emit('name', 'clear', arguments); }","handleChange":"function(value) { Shiny.setInputValue('name', value); }"},"mounted":"function() { var self = this; var send = function() { Shiny.setInputValue(\"name\", self.value); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else { $(document).one('shiny:connected', send); } }"},"evals":["methods.elEmitInput","methods.elEmitBlur","methods.elEmitFocus","methods.elEmitClear","methods.handleChange","mounted"],"jsHooks":[]}</script>

# Clearable search input with icon
el_input("search", placeholder = "Search...",
         clearable = TRUE, prefix_icon = "el-icon-search")
#> <div id="search_container" style="display: contents">
#>   <el-input v-model="value" :type="type" :disabled="disabled" :readonly="readonly" :clearable="clearable" :show-password="showPassword" :show-word-limit="showWordLimit" :autosize="autosize" :prefix-icon="prefixIcon" :suffix-icon="suffixIcon" @change="handleChange" :size="size === null ? undefined : size" :maxlength="maxlength === null ? undefined : maxlength" :rows="rows === null ? undefined : rows" :placeholder="placeholder === null ? undefined : placeholder" :label="label === null ? undefined : label" :autocomplete="autocomplete === null ? undefined : autocomplete" :autofocus="autofocus === null ? undefined : autofocus" :name="name === null ? undefined : name" :form="form === null ? undefined : form" :minlength="minlength === null ? undefined : minlength" :max="max === null ? undefined : max" :min="min === null ? undefined : min" :step="step === null ? undefined : step" :resize="resize === null ? undefined : resize" :tabindex="tabindex === null ? undefined : tabindex" :validate-event="validateEvent === null ? undefined : validateEvent" @input="elEmitInput" @blur="elEmitBlur" @focus="elEmitFocus" @clear="elEmitClear"></el-input>
#> </div>
#> <div id="search" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="search">{"x":{"el":"#search_container","data":{"value":"","type":"text","disabled":false,"readonly":false,"clearable":true,"showPassword":false,"showWordLimit":false,"autosize":false,"prefixIcon":"el-icon-search","suffixIcon":null,"size":null,"maxlength":null,"rows":null,"placeholder":"Search...","label":null,"autocomplete":null,"autofocus":null,"name":null,"form":null,"minlength":null,"max":null,"min":null,"step":null,"resize":null,"tabindex":null,"validateEvent":null},"methods":{"elEmitInput":"function() { window.shinyElement.emit('search', 'input', arguments); }","elEmitBlur":"function() { window.shinyElement.emit('search', 'blur', arguments); }","elEmitFocus":"function() { window.shinyElement.emit('search', 'focus', arguments); }","elEmitClear":"function() { window.shinyElement.emit('search', 'clear', arguments); }","handleChange":"function(value) { Shiny.setInputValue('search', value); }"},"mounted":"function() { var self = this; var send = function() { Shiny.setInputValue(\"search\", self.value); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else { $(document).one('shiny:connected', send); } }"},"evals":["methods.elEmitInput","methods.elEmitBlur","methods.elEmitFocus","methods.elEmitClear","methods.handleChange","mounted"],"jsHooks":[]}</script>

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
