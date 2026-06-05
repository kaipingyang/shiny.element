# Element UI Switch

Creates an Element UI switch with Vue instance.

## Usage

``` r
el_switch(
  id = NULL,
  value = FALSE,
  disabled = FALSE,
  width = NULL,
  active_text = NULL,
  inactive_text = NULL,
  active_color = NULL,
  inactive_color = NULL,
  active_value = TRUE,
  inactive_value = FALSE,
  session = shiny::getDefaultReactiveDomain()
)
```

## Arguments

- id:

  Switch ID. Auto-generated UUID if `NULL`.

- value:

  Initial switch state. Default `FALSE`.

- disabled:

  Whether the switch is disabled. Default `FALSE`.

- width:

  Switch width in pixels (integer).

- active_text:

  Text displayed when switch is on.

- inactive_text:

  Text displayed when switch is off.

- active_color:

  Background color when switch is on (e.g. `"#409EFF"`).

- inactive_color:

  Background color when switch is off.

- active_value:

  Value reported to Shiny when switch is on. Default `TRUE`.

- inactive_value:

  Value reported to Shiny when switch is off. Default `FALSE`.

- session:

  Shiny session for module support.

## Value

An `htmltools` tagList with a Vue-managed switch component.

## Shiny input

`input$<id>` — the value of `active_value` (when on) or `inactive_value`
(when off), matching the types of those arguments.

## Examples

``` r
el_switch("sw1", value = TRUE)
#> <div id="sw1_container">
#>   <el-switch v-model="value" :disabled="disabled" :active-text="activeText" :inactive-text="inactiveText" :active-color="activeColor" :inactive-color="inactiveColor" :active-value="activeValue" :inactive-value="inactiveValue" @change="handleChange"></el-switch>
#> </div>
#> <div class="vue html-widget html-fill-item" id="sw1" style="width:960px;height:500px;"></div>
#> <script type="application/json" data-for="sw1">{"x":{"el":"#sw1_container","data":{"value":true,"disabled":false,"activeText":"","inactiveText":"","activeColor":"","inactiveColor":"","activeValue":true,"inactiveValue":false},"methods":{"handleChange":"function(value) { Shiny.setInputValue('sw1', value); }"}},"evals":["methods.handleChange"],"jsHooks":[]}</script>

if (interactive()) {
  library(shiny)
  library(shiny.element)
  ui <- el_page(
    el_switch("sw1", active_text = "On", inactive_text = "Off"),
    verbatimTextOutput("state")
  )
  server <- function(input, output, session) {
    output$state <- renderPrint(input$sw1)
  }
  shinyApp(ui, server)
}
```
