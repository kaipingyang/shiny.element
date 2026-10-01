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
  name = NULL,
  width = NULL,
  slots = NULL,
  session = NULL
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

- name:

  Native `name` attribute of the inner input.

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

An `htmltools` tagList with a Vue-managed input-number component.

## Element methods

Callable with
[`el_call()`](https://kaipingyang.github.io/shiny.element/reference/el_call.md):

- `focus()` – Focus the Input component

- `select()` – Select the text in input element

## Shiny input

`input$<id>` — numeric value, updated on each valid change.

## Examples

``` r
el_input_number("n1", value = 5, min = 0, max = 100)
#> <div id="n1" data-el-vue-host style="display: contents">
#>   <div id="n1_container" data-el-mount style="display: contents">
#>     <el-input-number v-model="value" :min="min" :max="max" :step="step" :step-strictly="stepStrictly" :disabled="disabled" :controls="controls" :controls-position="controlsPosition" @change="handleChange" :size="size === null ? undefined : size" :precision="precision === null ? undefined : precision" :placeholder="placeholder === null ? undefined : placeholder" :label="label === null ? undefined : label" :name="name === null ? undefined : name" @blur="elEmitBlur" @focus="elEmitFocus"></el-input-number>
#>   </div>
#>   <script type="application/json" data-el-vue>{"options":{"data":{"value":5,"min":0,"max":100,"step":1,"stepStrictly":false,"disabled":false,"controls":true,"controlsPosition":"","size":null,"precision":null,"placeholder":null,"label":null,"name":null},"methods":{"elEmitBlur":"function() { window.shinyElement.emit('n1', 'blur', arguments); }","elEmitFocus":"function() { window.shinyElement.emit('n1', 'focus', arguments); }","handleChange":"function(val) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('n1', val); }"}},"input":"value","rate":null,"type":null,"evals":["options.methods.elEmitBlur","options.methods.elEmitFocus","options.methods.handleChange"]}</script>
#> </div>
el_input_number("n2", value = 1.5, step = 0.5, precision = 1)
#> <div id="n2" data-el-vue-host style="display: contents">
#>   <div id="n2_container" data-el-mount style="display: contents">
#>     <el-input-number v-model="value" :min="min" :max="max" :step="step" :step-strictly="stepStrictly" :disabled="disabled" :controls="controls" :controls-position="controlsPosition" @change="handleChange" :size="size === null ? undefined : size" :precision="precision === null ? undefined : precision" :placeholder="placeholder === null ? undefined : placeholder" :label="label === null ? undefined : label" :name="name === null ? undefined : name" @blur="elEmitBlur" @focus="elEmitFocus"></el-input-number>
#>   </div>
#>   <script type="application/json" data-el-vue>{"options":{"data":{"value":1.5,"min":-1e+308,"max":1e+308,"step":0.5,"stepStrictly":false,"disabled":false,"controls":true,"controlsPosition":"","size":null,"precision":1,"placeholder":null,"label":null,"name":null},"methods":{"elEmitBlur":"function() { window.shinyElement.emit('n2', 'blur', arguments); }","elEmitFocus":"function() { window.shinyElement.emit('n2', 'focus', arguments); }","handleChange":"function(val) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('n2', val); }"}},"input":"value","rate":null,"type":null,"evals":["options.methods.elEmitBlur","options.methods.elEmitFocus","options.methods.handleChange"]}</script>
#> </div>
```
