# Element UI Radio Group Component

Creates an Element UI `<el-radio-group>` component backed by a Vue
instance. Supports both standard radio buttons (`<el-radio>`) and
button-style radios (`<el-radio-button>`).

## Usage

``` r
el_radio_group(
  id = NULL,
  choices,
  selected = NULL,
  disabled = FALSE,
  size = NULL,
  button = FALSE,
  session = shiny::getDefaultReactiveDomain()
)
```

## Arguments

- id:

  Input ID. Auto-generated UUID if `NULL`.

- choices:

  Named character vector (`c(Label = value)`) or a list of
  `list(value = ..., label = ...)` items. Unnamed vectors are allowed;
  the element is used as both value and label.

- selected:

  Initial selected value. Defaults to `""` (nothing selected).

- disabled:

  Whether the entire group is disabled. Default `FALSE`.

- size:

  Component size: `NULL`, `"medium"`, `"small"`, or `"mini"`. Only
  affects button-style radios (`button = TRUE`).

- button:

  Whether to render as `<el-radio-button>` (pill/button style) instead
  of standard `<el-radio>`. Default `FALSE`.

- session:

  Shiny session for module namespace support.

## Value

An `htmltools` tagList containing the Vue-managed radio group.

## Shiny input

`input$<id>` — string or number reflecting the currently selected value,
updated on each change.

## Examples

``` r
# Standard radio buttons from a named vector
el_radio_group("size",
  choices  = c(Small = "s", Medium = "m", Large = "l"),
  selected = "m"
)
#> <div id="size_container">
#>   <el-radio-group v-model="value" :disabled="disabled" @change="handleChange">
#>     <el-radio :label="opt.value" v-for="opt in options" :key="opt.value">{{opt.label}}</el-radio>
#>   </el-radio-group>
#> </div>
#> <div class="vue html-widget html-fill-item" id="size" style="width:960px;height:500px;"></div>
#> <script type="application/json" data-for="size">{"x":{"el":"#size_container","data":{"value":"m","options":[{"value":"s","label":"Small"},{"value":"m","label":"Medium"},{"value":"l","label":"Large"}],"disabled":false},"methods":{"handleChange":"function(value) { Shiny.setInputValue('size', value); }"}},"evals":["methods.handleChange"],"jsHooks":[]}</script>

# Button-style radio group
el_radio_group("theme",
  choices = c(Light = "light", Dark = "dark"),
  button  = TRUE,
  size    = "small"
)
#> <div id="theme_container">
#>   <el-radio-group v-model="value" :disabled="disabled" @change="handleChange" :size="size">
#>     <el-radio-button :label="opt.value" v-for="opt in options" :key="opt.value">{{opt.label}}</el-radio-button>
#>   </el-radio-group>
#> </div>
#> <div class="vue html-widget html-fill-item" id="theme" style="width:960px;height:500px;"></div>
#> <script type="application/json" data-for="theme">{"x":{"el":"#theme_container","data":{"value":"","options":[{"value":"light","label":"Light"},{"value":"dark","label":"Dark"}],"disabled":false,"size":"small"},"methods":{"handleChange":"function(value) { Shiny.setInputValue('theme', value); }"}},"evals":["methods.handleChange"],"jsHooks":[]}</script>

# Shiny app example
if (interactive()) {
  library(shiny)
  library(shiny.element)
  ui <- el_page(
    el_radio_group("fruit",
      choices  = c(Apple = "apple", Banana = "banana", Cherry = "cherry"),
      selected = "apple"
    ),
    verbatimTextOutput("selected")
  )
  server <- function(input, output, session) {
    output$selected <- renderPrint(input$fruit)
  }
  shinyApp(ui, server)
}
```
