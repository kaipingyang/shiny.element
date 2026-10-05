# Element Plus Input Number

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
  align = NULL,
  aria_label = NULL,
  disabled_scientific = NULL,
  formatter = NULL,
  inputmode = NULL,
  parser = NULL,
  readonly = NULL,
  tabindex = NULL,
  validate_event = NULL,
  value_on_clear = NULL,
  width = NULL,
  slots = NULL,
  session = NULL
)

update_el_input_number(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  min = NULL,
  max = NULL,
  disabled = NULL,
  label = NULL,
  error = NULL,
  step = NULL,
  step_strictly = NULL,
  precision = NULL,
  size = NULL,
  controls = NULL,
  controls_position = NULL,
  placeholder = NULL,
  name = NULL,
  align = NULL,
  aria_label = NULL,
  disabled_scientific = NULL,
  formatter = NULL,
  inputmode = NULL,
  parser = NULL,
  readonly = NULL,
  tabindex = NULL,
  validate_event = NULL,
  value_on_clear = NULL
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

  Size: `"large"`, `"default"` or `"small"`; `NULL` follows the form or
  the page.

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

- align:

  Alignment for the inner input text. Element Plus's `align` ('left' \|
  'center' \| 'right').

- aria_label:

  Same as `aria-label` in native input. Element Plus's `aria-label`
  (string).

- disabled_scientific:

  Disables input of scientific notation (e.g. 'e'). Element Plus's
  `disabled-scientific` (boolean).

- formatter:

  Specifies the format of the value presented in the input. Element
  Plus's `formatter` ((value: string) =\> string).

- inputmode:

  Same as `inputmode` in native input. Element Plus's `inputmode`
  (string).

- parser:

  Specifies the value extracted from the formatted input. Element Plus's
  `parser` ((value: string) =\> string).

- readonly:

  Same as `readonly` in native input. Element Plus's `readonly`
  (boolean).

- tabindex:

  Same as `tabindex` in native input. Element Plus's `tabindex` (string
  / number).

- validate_event:

  Whether to trigger form validation. Element Plus's `validate-event`
  (boolean).

- value_on_clear:

  Value should be set when input box is cleared. Element Plus's
  `value-on-clear` (number / null / 'min' \| 'max').

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

  In `el_input_number()`, deprecated: inside a module, wrap `id` in
  `ns()`, as for any Shiny input; a session given here namespaces `id`
  once more, with a warning. In `update_el_input_number()`, the Shiny
  session, the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

## Value

An `htmltools` tagList with a Vue-managed input-number component.

## Element methods

Callable with
[`call_el()`](https://kaipingyang.github.io/shiny.element/reference/call_el.md):

- `focus()` – Focus the Input component

- `select()` – Select the text in input element

## Shiny inputs

`input$<id>` – numeric value, updated on each valid change.

## Updating from the server

Server-side update for `el_input_number()`.

Every other argument of `el_input_number()` that can change once it is
drawn is an argument here too, under the same name. One left `NULL`
stays as it is; `NA` returns it to Element's default.

`update_el_input_number()` is called for its side effect and returns
`NULL` invisibly.

## Examples

``` r
el_input_number("n1", value = 5, min = 0, max = 100)
#> <div id="n1" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="n1_container" style="display: contents">
#>   <el-input-number v-model="value" :min="min" :max="max" :step="step" :step-strictly="stepStrictly" :disabled="disabled" :controls="controls" :controls-position="controlsPosition" @change="handleChange" :size="size === null ? undefined : size" :precision="precision === null ? undefined : precision" :placeholder="placeholder === null ? undefined : placeholder" :label="label === null ? undefined : label" :name="name === null ? undefined : name" @blur="elEmitBlur" @focus="elEmitFocus" :align="align === null ? undefined : align" :aria-label="ariaLabel === null ? undefined : ariaLabel" :disabled-scientific="disabledScientific === null ? undefined : disabledScientific" :formatter="formatter === null ? undefined : formatter" :inputmode="inputmode === null ? undefined : inputmode" :parser="parser === null ? undefined : parser" :readonly="readonly === null ? undefined : readonly" :tabindex="tabindex === null ? undefined : tabindex" :validate-event="validateEvent === null ? undefined : validateEvent" :value-on-clear="valueOnClear === null ? undefined : valueOnClear"></el-input-number>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":5,"min":0,"max":100,"step":1,"stepStrictly":false,"disabled":false,"controls":true,"controlsPosition":"","size":null,"precision":null,"placeholder":null,"label":null,"name":null,"align":null,"ariaLabel":null,"disabledScientific":null,"formatter":null,"inputmode":null,"parser":null,"readonly":null,"tabindex":null,"validateEvent":null,"valueOnClear":null},"methods":{"elEmitBlur":"function() { window.shinyVue.emit('n1', 'blur', arguments); }","elEmitFocus":"function() { window.shinyVue.emit('n1', 'focus', arguments); }","handleChange":"function(val) { }"}},"input":"value","rate":{"policy":"debounce","delay":250},"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.elEmitBlur","options.methods.elEmitFocus","options.methods.handleChange"]}</script>
#> </div>
el_input_number("n2", value = 1.5, step = 0.5, precision = 1)
#> <div id="n2" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="n2_container" style="display: contents">
#>   <el-input-number v-model="value" :min="min" :max="max" :step="step" :step-strictly="stepStrictly" :disabled="disabled" :controls="controls" :controls-position="controlsPosition" @change="handleChange" :size="size === null ? undefined : size" :precision="precision === null ? undefined : precision" :placeholder="placeholder === null ? undefined : placeholder" :label="label === null ? undefined : label" :name="name === null ? undefined : name" @blur="elEmitBlur" @focus="elEmitFocus" :align="align === null ? undefined : align" :aria-label="ariaLabel === null ? undefined : ariaLabel" :disabled-scientific="disabledScientific === null ? undefined : disabledScientific" :formatter="formatter === null ? undefined : formatter" :inputmode="inputmode === null ? undefined : inputmode" :parser="parser === null ? undefined : parser" :readonly="readonly === null ? undefined : readonly" :tabindex="tabindex === null ? undefined : tabindex" :validate-event="validateEvent === null ? undefined : validateEvent" :value-on-clear="valueOnClear === null ? undefined : valueOnClear"></el-input-number>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":1.5,"min":-1e+308,"max":1e+308,"step":0.5,"stepStrictly":false,"disabled":false,"controls":true,"controlsPosition":"","size":null,"precision":1,"placeholder":null,"label":null,"name":null,"align":null,"ariaLabel":null,"disabledScientific":null,"formatter":null,"inputmode":null,"parser":null,"readonly":null,"tabindex":null,"validateEvent":null,"valueOnClear":null},"methods":{"elEmitBlur":"function() { window.shinyVue.emit('n2', 'blur', arguments); }","elEmitFocus":"function() { window.shinyVue.emit('n2', 'focus', arguments); }","handleChange":"function(val) { }"}},"input":"value","rate":{"policy":"debounce","delay":250},"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.elEmitBlur","options.methods.elEmitFocus","options.methods.handleChange"]}</script>
#> </div>
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_input_number(session, "age", value = 42)
  })
}
```
