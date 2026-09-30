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
#> <div id="sw1_container" style="display: contents">
#>   <el-switch v-model="value" :disabled="disabled" :active-text="activeText" :inactive-text="inactiveText" :active-color="activeColor" :inactive-color="inactiveColor" :active-value="activeValue" :inactive-value="inactiveValue" @change="handleChange" :width="width === null ? undefined : width"></el-switch>
#> </div>
#> <div id="sw1" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="sw1">{"x":{"el":"#sw1_container","data":{"value":true,"disabled":false,"activeText":"","inactiveText":"","activeColor":"","inactiveColor":"","activeValue":true,"inactiveValue":false,"width":null},"methods":{"handleChange":"function(value) { Shiny.setInputValue('sw1', value); }"},"mounted":"function() { var self = this; var send = function() { Shiny.setInputValue(\"sw1\", self.value); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else { $(document).one('shiny:connected', send); } }"},"evals":["methods.handleChange","mounted"],"jsHooks":[]}</script>

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
