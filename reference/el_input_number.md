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
#> <div id="n1_container" style="display: contents">
#>   <el-input-number v-model="value" :min="min" :max="max" :step="step" :step-strictly="stepStrictly" :disabled="disabled" :controls="controls" :controls-position="controlsPosition" @change="handleChange" :size="size === null ? undefined : size" :precision="precision === null ? undefined : precision" :placeholder="placeholder === null ? undefined : placeholder" :label="label === null ? undefined : label"></el-input-number>
#> </div>
#> <div id="n1" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="n1">{"x":{"el":"#n1_container","data":{"value":5,"min":0,"max":100,"step":1,"stepStrictly":false,"disabled":false,"controls":true,"controlsPosition":"","size":null,"precision":null,"placeholder":null,"label":null},"methods":{"handleChange":"function(val) { Shiny.setInputValue('n1', val); }"},"mounted":"function() { var self = this; var send = function() { Shiny.setInputValue(\"n1\", self.value); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else { $(document).one('shiny:connected', send); } }"},"evals":["methods.handleChange","mounted"],"jsHooks":[]}</script>
el_input_number("n2", value = 1.5, step = 0.5, precision = 1)
#> <div id="n2_container" style="display: contents">
#>   <el-input-number v-model="value" :min="min" :max="max" :step="step" :step-strictly="stepStrictly" :disabled="disabled" :controls="controls" :controls-position="controlsPosition" @change="handleChange" :size="size === null ? undefined : size" :precision="precision === null ? undefined : precision" :placeholder="placeholder === null ? undefined : placeholder" :label="label === null ? undefined : label"></el-input-number>
#> </div>
#> <div id="n2" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="n2">{"x":{"el":"#n2_container","data":{"value":1.5,"min":-1e+308,"max":1e+308,"step":0.5,"stepStrictly":false,"disabled":false,"controls":true,"controlsPosition":"","size":null,"precision":1,"placeholder":null,"label":null},"methods":{"handleChange":"function(val) { Shiny.setInputValue('n2', val); }"},"mounted":"function() { var self = this; var send = function() { Shiny.setInputValue(\"n2\", self.value); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else { $(document).one('shiny:connected', send); } }"},"evals":["methods.handleChange","mounted"],"jsHooks":[]}</script>
```
