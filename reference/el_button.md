# Element UI Button with Vue Instance

Creates an Element UI button with Vue instance, supporting all Element
UI button variants including `plain`, `round`, `circle`, and `loading`
states.

## Usage

``` r
el_button(
  id = NULL,
  label = "Button",
  type = "default",
  size = NULL,
  plain = FALSE,
  round = FALSE,
  circle = FALSE,
  loading = FALSE,
  disabled = FALSE,
  icon = NULL,
  native_type = "button",
  autofocus = FALSE,
  session = shiny::getDefaultReactiveDomain()
)
```

## Arguments

- id:

  Button ID. Auto-generated UUID if `NULL`.

- label:

  Button text. Ignored (and defaults to `""`) when `circle = TRUE`.

- type:

  Button type: `"default"`, `"primary"`, `"success"`, `"warning"`,
  `"danger"`, `"info"`, `"text"`.

- size:

  Button size: `NULL`, `"medium"`, `"small"`, `"mini"`.

- plain:

  Whether to use the plain (hollow) style. Default `FALSE`.

- round:

  Whether to use rounded corners. Default `FALSE`.

- circle:

  Whether to render as a circle button (icon only, no label). Default
  `FALSE`.

- loading:

  Whether to show loading spinner. Disables click while active. Default
  `FALSE`.

- disabled:

  Whether the button is disabled. Default `FALSE`.

- icon:

  Either an Element icon class name such as `"el-icon-search"`, which
  Element renders itself and
  [`update_el_button()`](https://kaipingyang.github.io/shiny.element/reference/update_el_button.md)
  can change, or a tag (for example from
  [`el_icon()`](https://kaipingyang.github.io/shiny.element/reference/el_icon.md)),
  which is inserted as button content.

- native_type:

  HTML native button type: `"button"` (default), `"submit"`, `"reset"`.

- autofocus:

  Whether the button takes focus on page load. Default `FALSE`.

- session:

  Shiny session for module support.

## Value

An `htmltools` tagList with a Vue-managed button component.

## Shiny input

`input$<id>` — click count (integer), incremented on each click when
neither `disabled` nor `loading` is `TRUE`.

## Examples

``` r
# Basic usage
el_button("btn_primary", "Primary", type = "primary")
#> <div id="btn_primary_container" style="display: contents">
#>   <el-button :type="type" :plain="plain" :round="round" :circle="circle" :loading="loading" :disabled="disabled" :native-type="native_type" @click="handleClick" :size="size === null ? undefined : size" :icon="icon === null ? undefined : icon" :autofocus="autofocus === null ? undefined : autofocus">{{label}}</el-button>
#> </div>
#> <div id="btn_primary" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="btn_primary">{"x":{"el":"#btn_primary_container","data":{"label":"Primary","type":"primary","size":null,"plain":false,"round":false,"circle":false,"loading":false,"disabled":false,"native_type":"button","icon":null,"count":0,"autofocus":false},"methods":{"handleClick":"function() { if (!this.disabled && !this.loading) { this.count++; Shiny.setInputValue('btn_primary', this.count); } }"}},"evals":["methods.handleClick"],"jsHooks":[]}</script>

# Shiny app example
if (interactive()) {
  library(shiny)
  library(shiny.element)
  ui <- el_page(
    el_button("btn1", "Primary", type = "primary"),
    verbatimTextOutput("count")
  )
  server <- function(input, output, session) {
    output$count <- renderPrint(input$btn1)
  }
  shinyApp(ui, server)
}
```
