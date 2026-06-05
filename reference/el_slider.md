# Element UI Slider Component

Creates an Element UI slider with Vue instance, supporting single value
and range modes, marks, vertical orientation, and optional numeric input
box.

## Usage

``` r
el_slider(
  id = NULL,
  value = 0,
  min = 0,
  max = 100,
  step = 1,
  range = FALSE,
  disabled = FALSE,
  show_input = FALSE,
  show_stops = FALSE,
  show_tooltip = TRUE,
  vertical = FALSE,
  height = NULL,
  marks = NULL,
  session = shiny::getDefaultReactiveDomain()
)
```

## Arguments

- id:

  Slider ID. Auto-generated UUID if `NULL`.

- value:

  Initial value. A single number, or `c(low, high)` when `range = TRUE`.
  When `range = TRUE` and a scalar is supplied, the upper bound is set
  to `max`.

- min:

  Minimum value. Default `0`.

- max:

  Maximum value. Default `100`.

- step:

  Step size. Default `1`.

- range:

  Whether to enable range selection. Default `FALSE`.

- disabled:

  Whether the slider is disabled. Default `FALSE`.

- show_input:

  Whether to display a numeric input box beside the slider (non-range
  mode only). Default `FALSE`.

- show_stops:

  Whether to display stop markers at each step. Default `FALSE`.

- show_tooltip:

  Whether to display the tooltip when dragging. Default `TRUE`.

- vertical:

  Whether to display in vertical orientation. Default `FALSE`.

- height:

  Height of the slider in vertical mode (e.g., `"200px"`). Defaults to
  `"200px"` when `vertical = TRUE` and not explicitly provided.

- marks:

  Named list of mark labels, e.g., `list("0" = "0km", "50" = "50km")`.
  Default `NULL` (no marks).

- session:

  Shiny session for module support.

## Value

An `htmltools` tagList with a Vue-managed slider component.

## Shiny input

`input$<id>` — Number (`range = FALSE`) or two-element array
(`range = TRUE`), updated when the user finishes dragging.

## Examples

``` r
# Basic usage
el_slider("slider1", value = 30, min = 0, max = 100)
#> <div id="slider1_container">
#>   <el-slider v-model="value" :min="min" :max="max" :step="step" :range="range" :disabled="disabled" :show-input="showInput" :show-stops="showStops" :show-tooltip="showTooltip" :vertical="vertical" @change="handleChange"></el-slider>
#> </div>
#> <div class="vue html-widget html-fill-item" id="slider1" style="width:960px;height:500px;"></div>
#> <script type="application/json" data-for="slider1">{"x":{"el":"#slider1_container","data":{"value":30,"min":0,"max":100,"step":1,"range":false,"disabled":false,"showInput":false,"showStops":false,"showTooltip":true,"vertical":false},"methods":{"handleChange":"function(value) { Shiny.setInputValue('slider1', value); }"}},"evals":["methods.handleChange"],"jsHooks":[]}</script>

# Range slider
el_slider("slider2", value = c(20, 80), range = TRUE)
#> <div id="slider2_container">
#>   <el-slider v-model="value" :min="min" :max="max" :step="step" :range="range" :disabled="disabled" :show-input="showInput" :show-stops="showStops" :show-tooltip="showTooltip" :vertical="vertical" @change="handleChange"></el-slider>
#> </div>
#> <div class="vue html-widget html-fill-item" id="slider2" style="width:960px;height:500px;"></div>
#> <script type="application/json" data-for="slider2">{"x":{"el":"#slider2_container","data":{"value":[20,80],"min":0,"max":100,"step":1,"range":true,"disabled":false,"showInput":false,"showStops":false,"showTooltip":true,"vertical":false},"methods":{"handleChange":"function(value) { Shiny.setInputValue('slider2', value); }"}},"evals":["methods.handleChange"],"jsHooks":[]}</script>

# Vertical slider with marks
el_slider("slider3", value = 50, vertical = TRUE, height = "200px",
          marks = list("0" = "0km", "50" = "50km", "100" = "100km"))
#> <div id="slider3_container">
#>   <el-slider v-model="value" :min="min" :max="max" :step="step" :range="range" :disabled="disabled" :show-input="showInput" :show-stops="showStops" :show-tooltip="showTooltip" :vertical="vertical" @change="handleChange" :height="height" :marks="marks"></el-slider>
#> </div>
#> <div class="vue html-widget html-fill-item" id="slider3" style="width:960px;height:500px;"></div>
#> <script type="application/json" data-for="slider3">{"x":{"el":"#slider3_container","data":{"value":50,"min":0,"max":100,"step":1,"range":false,"disabled":false,"showInput":false,"showStops":false,"showTooltip":true,"vertical":true,"height":"200px","marks":{"0":"0km","50":"50km","100":"100km"}},"methods":{"handleChange":"function(value) { Shiny.setInputValue('slider3', value); }"}},"evals":["methods.handleChange"],"jsHooks":[]}</script>

# Shiny app example
if (interactive()) {
  library(shiny)
  library(shiny.element)
  ui <- el_page(
    el_slider("slider1", value = 50, min = 0, max = 100),
    verbatimTextOutput("val")
  )
  server <- function(input, output, session) {
    output$val <- renderPrint(input$slider1)
  }
  shinyApp(ui, server)
}
```
