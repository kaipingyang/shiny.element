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
  label_position = c("top", "left", "right"),
  label_width = NULL,
  label_suffix = NULL,
  required = FALSE,
  error = NULL,
  show_message = TRUE,
  inline_message = FALSE,
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

  A label shown with the component, as Shiny's inputs have: text or a
  tag. `NULL`, the default, shows none. It is the component's accessible
  name too – tied to it with `for` where the component has a native
  input that takes the id `<id>-input`, else with `aria-labelledby`.

- name:

  Native `name` attribute of the inner input.

- label_position:

  Where the label sits, as
  [`el_form()`](https://kaipingyang.github.io/shiny.element/reference/el_form.md)'s
  `label_position`: `"top"` (the default, as Shiny's labels sit), or
  beside the component, its text aligned `"left"` or `"right"` – which
  shows once `label_width` gives the labels a common width.

- label_width:

  Width of a label beside the component, as a CSS unit, so that several
  line up. Element's `label-width`.

- label_suffix:

  Text after the label, such as `":"`. Element's `label-suffix`.

- required:

  Draw Element's red asterisk before the label. It marks the field; it
  does not check it – shinyvalidate or
  [`el_form()`](https://kaipingyang.github.io/shiny.element/reference/el_form.md)
  does that.

- error:

  An error message shown under the component in Element's style, the
  field framed in red. Element's `error`.

- show_message, inline_message:

  Whether `error`'s message is shown, and whether beside the component
  rather than under it. Element's `show-message` and `inline-message`.

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

## Shiny inputs

`input$<id>` — numeric value, updated on each valid change.

## Examples

``` r
el_input_number("n1", value = 5, min = 0, max = 100)
#> <div id="n1" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="n1_container" style="display: contents">
#>   <el-input-number v-model="value" :min="min" :max="max" :step="step" :step-strictly="stepStrictly" :disabled="disabled" :controls="controls" :controls-position="controlsPosition" @change="handleChange" :size="size === null ? undefined : size" :precision="precision === null ? undefined : precision" :placeholder="placeholder === null ? undefined : placeholder" :label="label === null ? undefined : label" :name="name === null ? undefined : name" @blur="elEmitBlur" @focus="elEmitFocus"></el-input-number>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":5,"min":0,"max":100,"step":1,"stepStrictly":false,"disabled":false,"controls":true,"controlsPosition":"","size":null,"precision":null,"placeholder":null,"label":null,"name":null},"methods":{"elEmitBlur":"function() { window.shinyVue.emit('n1', 'blur', arguments); }","elEmitFocus":"function() { window.shinyVue.emit('n1', 'focus', arguments); }","handleChange":"function(val) { }"}},"input":"value","rate":{"policy":"debounce","delay":250},"type":null,"evals":["options.methods.elEmitBlur","options.methods.elEmitFocus","options.methods.handleChange"]}</script>
#> </div>
el_input_number("n2", value = 1.5, step = 0.5, precision = 1)
#> <div id="n2" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="n2_container" style="display: contents">
#>   <el-input-number v-model="value" :min="min" :max="max" :step="step" :step-strictly="stepStrictly" :disabled="disabled" :controls="controls" :controls-position="controlsPosition" @change="handleChange" :size="size === null ? undefined : size" :precision="precision === null ? undefined : precision" :placeholder="placeholder === null ? undefined : placeholder" :label="label === null ? undefined : label" :name="name === null ? undefined : name" @blur="elEmitBlur" @focus="elEmitFocus"></el-input-number>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":1.5,"min":-1e+308,"max":1e+308,"step":0.5,"stepStrictly":false,"disabled":false,"controls":true,"controlsPosition":"","size":null,"precision":1,"placeholder":null,"label":null,"name":null},"methods":{"elEmitBlur":"function() { window.shinyVue.emit('n2', 'blur', arguments); }","elEmitFocus":"function() { window.shinyVue.emit('n2', 'focus', arguments); }","handleChange":"function(val) { }"}},"input":"value","rate":{"policy":"debounce","delay":250},"type":null,"evals":["options.methods.elEmitBlur","options.methods.elEmitFocus","options.methods.handleChange"]}</script>
#> </div>
```
