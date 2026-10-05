# Element Plus Input OTP

A one-time password or verification code, typed one character per field.

## Usage

``` r
el_input_otp(
  id = NULL,
  value = NULL,
  length = NULL,
  validator = NULL,
  inputmode = NULL,
  type = NULL,
  size = NULL,
  mask = NULL,
  disabled = NULL,
  separator = NULL,
  validate_event = NULL,
  readonly = NULL,
  aria_label = NULL,
  label = NULL,
  label_position = c("top", "left", "right"),
  label_width = NULL,
  label_suffix = NULL,
  required = FALSE,
  error = NULL,
  show_message = TRUE,
  inline_message = FALSE,
  width = NULL,
  slots = NULL
)

update_el_input_otp(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  disabled = NULL,
  label = NULL,
  error = NULL,
  length = NULL,
  validator = NULL,
  inputmode = NULL,
  type = NULL,
  size = NULL,
  mask = NULL,
  separator = NULL,
  validate_event = NULL,
  readonly = NULL,
  aria_label = NULL
)
```

## Arguments

- id:

  Component ID. Auto-generated if `NULL`.

- value:

  The value of the OTP fields. Since numbers must not have leading
  zeros, `modelValue` is allowed to be a number only during
  initialization: Element Plus's `model-value`, reported as
  `input$<id>`.

- length:

  The OTP fields length. Element Plus's `length` (number).

- validator:

  Custom validator function. Element Plus's `validator` ((char: string,
  index: number) =\> boolean). Give it as
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md).

- inputmode:

  Native `inputmode` attribute. Element Plus's `inputmode` (string).

- type:

  The type of the OTP fields. Element Plus's `type` ('outlined' \|
  'filled' \| 'underlined').

- size:

  The size of the OTP fields. Element Plus's `size` ('large' \|
  'default' \| 'small').

- mask:

  Whether to enable password mode. Element Plus's `mask` (boolean).

- disabled:

  Whether the OTP fields are disabled. Element Plus's `disabled`
  (boolean).

- separator:

  The separator between OTP fields. Element Plus's `separator` (string /
  VNode / () =\> string \| VNode). Give it as
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md).

- validate_event:

  Whether to trigger form validation. Element Plus's `validate-event`
  (boolean).

- readonly:

  Same as `readonly` in native input. Element Plus's `readonly`
  (boolean).

- aria_label:

  Native `aria-label` attribute. Element Plus's `aria-label` (string).

- label:

  A label shown with the component, as Shiny's inputs have: text or a
  tag. `NULL`, the default, shows none. It is the component's accessible
  name too – tied to it with `for` where the component has a native
  input that takes the id `<id>-input`, else with `aria-labelledby`.

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

  Component width, as a CSS unit.

- slots:

  Named list of Element slot contents: `separator`. A scoped slot is
  written with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

## Value

A Shiny UI element.

## Shiny inputs

- `input$<id>` – the value, on load and on every change.

- `input$<id>_change` – Element Plus's `change` event.

- `input$<id>_finish` – Element Plus's `finish` event.

- `input$<id>_focus` – Element Plus's `focus` event.

- `input$<id>_blur` – Element Plus's `blur` event.

## Element methods

Callable with
[`call_el()`](https://kaipingyang.github.io/shiny.element/reference/call_el.md):
`focus()`, `blur()`.

## Updating from the server

Server-side update for `el_input_otp()`.

Every other argument of `el_input_otp()` that can change once it is
drawn is an argument here too, under the same name. One left `NULL`
stays as it is; `NA` returns it to Element's default.

`update_el_input_otp()` is called for its side effect and returns `NULL`
invisibly.

## Examples

``` r
el_input_otp("code", length = 6)
#> <div id="code" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="code_container" style="display: contents">
#>   <el-input-otp v-model="value" @change="elEmitChange" @finish="elEmitFinish" @focus="elEmitFocus" @blur="elEmitBlur" :length="length === null ? undefined : length" :validator="validator === null ? undefined : validator" :inputmode="inputmode === null ? undefined : inputmode" :type="type === null ? undefined : type" :size="size === null ? undefined : size" :mask="mask === null ? undefined : mask" :disabled="disabled === null ? undefined : disabled" :separator="separator === null ? undefined : separator" :validate-event="validateEvent === null ? undefined : validateEvent" :readonly="readonly === null ? undefined : readonly" :aria-label="ariaLabel === null ? undefined : ariaLabel"></el-input-otp>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":null,"length":6,"validator":null,"inputmode":null,"type":null,"size":null,"mask":null,"disabled":null,"separator":null,"validateEvent":null,"readonly":null,"ariaLabel":null},"methods":{"elEmitChange":"function() { window.shinyVue.emit('code', 'change', arguments); }","elEmitFinish":"function() { window.shinyVue.emit('code', 'finish', arguments); }","elEmitFocus":"function() { window.shinyVue.emit('code', 'focus', arguments); }","elEmitBlur":"function() { window.shinyVue.emit('code', 'blur', arguments); }"},"watch":{"value":"function(v) { }"}},"input":"value","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.elEmitChange","options.methods.elEmitFinish","options.methods.elEmitFocus","options.methods.elEmitBlur","options.watch.value"]}</script>
#> </div>
el_input_otp("pin", length = 4, mask = TRUE, type = "underlined")
#> <div id="pin" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="pin_container" style="display: contents">
#>   <el-input-otp v-model="value" @change="elEmitChange" @finish="elEmitFinish" @focus="elEmitFocus" @blur="elEmitBlur" :length="length === null ? undefined : length" :validator="validator === null ? undefined : validator" :inputmode="inputmode === null ? undefined : inputmode" :type="type === null ? undefined : type" :size="size === null ? undefined : size" :mask="mask === null ? undefined : mask" :disabled="disabled === null ? undefined : disabled" :separator="separator === null ? undefined : separator" :validate-event="validateEvent === null ? undefined : validateEvent" :readonly="readonly === null ? undefined : readonly" :aria-label="ariaLabel === null ? undefined : ariaLabel"></el-input-otp>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":null,"length":4,"validator":null,"inputmode":null,"type":"underlined","size":null,"mask":true,"disabled":null,"separator":null,"validateEvent":null,"readonly":null,"ariaLabel":null},"methods":{"elEmitChange":"function() { window.shinyVue.emit('pin', 'change', arguments); }","elEmitFinish":"function() { window.shinyVue.emit('pin', 'finish', arguments); }","elEmitFocus":"function() { window.shinyVue.emit('pin', 'focus', arguments); }","elEmitBlur":"function() { window.shinyVue.emit('pin', 'blur', arguments); }"},"watch":{"value":"function(v) { }"}},"input":"value","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.elEmitChange","options.methods.elEmitFinish","options.methods.elEmitFocus","options.methods.elEmitBlur","options.watch.value"]}</script>
#> </div>
if (interactive()) {
  # inside a server function
  observeEvent(input$reset, update_el_input_otp(session, "x", value = NULL))
}
```
