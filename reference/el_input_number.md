# Element UI Input Number

A numeric input with increment/decrement buttons.

## Usage

``` r
el_input_number(
  id = NULL,
  value = 0,
  min = -Inf,
  max = Inf,
  step = 1,
  step_strictly = FALSE,
  precision = NULL,
  size = NULL,
  disabled = FALSE,
  controls = TRUE,
  controls_position = "",
  placeholder = NULL,
  label = NULL,
  session = shiny::getDefaultReactiveDomain()
)
```

## Arguments

- id:

  Input ID. Auto-generated UUID if `NULL`.

- value:

  Initial numeric value. Default `0`.

- min:

  Minimum allowed value. Default `-Inf`.

- max:

  Maximum allowed value. Default `Inf`.

- step:

  Step increment. Default `1`.

- step_strictly:

  Force the value to be a multiple of `step`. Default `FALSE`.

- precision:

  Decimal precision (non-negative integer). `NULL` for auto.

- size:

  Component size: `NULL`, `"medium"`, `"small"`, `"mini"`.

- disabled:

  Whether the component is disabled. Default `FALSE`.

- controls:

  Whether to show the +/- control buttons. Default `TRUE`.

- controls_position:

  Button layout: `""` (default, left-right) or `"right"` (both on the
  right).

- placeholder:

  Placeholder text. `NULL` for none.

- label:

  Accessible label text. `NULL` for none.

- session:

  Shiny session for module support.

## Value

An `htmltools` tagList with a Vue-managed input-number component.

## Shiny input

`input$<id>` — numeric value, updated on each valid change.

## Examples

``` r
el_input_number("n1", value = 5, min = 0, max = 100)
#> <div id="n1_container">
#>   <el-input-number v-model="value" :min="min" :max="max" :step="step" :step-strictly="stepStrictly" :disabled="disabled" :controls="controls" :controls-position="controlsPosition" @change="handleChange"></el-input-number>
#> </div>
#> <div class="vue html-widget html-fill-item" id="n1" style="width:960px;height:500px;"></div>
#> <script type="application/json" data-for="n1">{"x":{"el":"#n1_container","data":{"value":5,"min":0,"max":100,"step":1,"stepStrictly":false,"disabled":false,"controls":true,"controlsPosition":""},"methods":{"handleChange":"function(val) { Shiny.setInputValue('n1', val); }"}},"evals":["methods.handleChange"],"jsHooks":[]}</script>
el_input_number("n2", value = 1.5, step = 0.5, precision = 1)
#> <div id="n2_container">
#>   <el-input-number v-model="value" :min="min" :max="max" :step="step" :step-strictly="stepStrictly" :disabled="disabled" :controls="controls" :controls-position="controlsPosition" @change="handleChange" :precision="precision"></el-input-number>
#> </div>
#> <div class="vue html-widget html-fill-item" id="n2" style="width:960px;height:500px;"></div>
#> <script type="application/json" data-for="n2">{"x":{"el":"#n2_container","data":{"value":1.5,"min":-1e+308,"max":1e+308,"step":0.5,"stepStrictly":false,"disabled":false,"controls":true,"controlsPosition":"","precision":1},"methods":{"handleChange":"function(val) { Shiny.setInputValue('n2', val); }"}},"evals":["methods.handleChange"],"jsHooks":[]}</script>
```
