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

- session:

  Shiny session for module support.

## Value

An `htmltools` tagList with a Vue-managed input component.

## Shiny input

`input$<id>` — string value of the input, updated on `change` event
(triggered on blur or Enter key press).

## Examples

``` r
# Basic text input
el_input("name", placeholder = "Enter your name")
#> <div id="name_container">
#>   <el-input v-model="value" :type="type" :disabled="disabled" :readonly="readonly" :clearable="clearable" :show-password="showPassword" :show-word-limit="showWordLimit" :autosize="autosize" :prefix-icon="prefixIcon" :suffix-icon="suffixIcon" @change="handleChange" :placeholder="placeholder"></el-input>
#> </div>
#> <div class="vue html-widget html-fill-item" id="name" style="width:960px;height:500px;"></div>
#> <script type="application/json" data-for="name">{"x":{"el":"#name_container","data":{"value":"","type":"text","disabled":false,"readonly":false,"clearable":false,"showPassword":false,"showWordLimit":false,"autosize":false,"prefixIcon":null,"suffixIcon":null,"placeholder":"Enter your name"},"methods":{"handleChange":"function(value) { Shiny.setInputValue('name', value); }"}},"evals":["methods.handleChange"],"jsHooks":[]}</script>

# Clearable search input with icon
el_input("search", placeholder = "Search...",
         clearable = TRUE, prefix_icon = "el-icon-search")
#> <div id="search_container">
#>   <el-input v-model="value" :type="type" :disabled="disabled" :readonly="readonly" :clearable="clearable" :show-password="showPassword" :show-word-limit="showWordLimit" :autosize="autosize" :prefix-icon="prefixIcon" :suffix-icon="suffixIcon" @change="handleChange" :placeholder="placeholder"></el-input>
#> </div>
#> <div class="vue html-widget html-fill-item" id="search" style="width:960px;height:500px;"></div>
#> <script type="application/json" data-for="search">{"x":{"el":"#search_container","data":{"value":"","type":"text","disabled":false,"readonly":false,"clearable":true,"showPassword":false,"showWordLimit":false,"autosize":false,"prefixIcon":"el-icon-search","suffixIcon":null,"placeholder":"Search..."},"methods":{"handleChange":"function(value) { Shiny.setInputValue('search', value); }"}},"evals":["methods.handleChange"],"jsHooks":[]}</script>

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
