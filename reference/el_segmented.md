# Element Plus Segmented

A row of options, one of them selected: a compact radio group.

## Usage

``` r
el_segmented(
  id = NULL,
  value = NULL,
  options = NULL,
  size = NULL,
  block = NULL,
  disabled = NULL,
  validate_event = NULL,
  aria_label = NULL,
  direction = NULL,
  props = NULL,
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
```

## Arguments

- id:

  Component ID. Auto-generated if `NULL`.

- value:

  Binding value: Element Plus's `model-value`, reported as `input$<id>`.

- options:

  The options: a named vector `c(Label = value)`, a vector, or a list of
  `list(value =, label =, disabled =)`, as Element Plus takes them.

- size:

  Size of component. Element Plus's `size` (” \| 'large' \| 'default' \|
  'small').

- block:

  Fit width of parent content. Element Plus's `block` (boolean).

- disabled:

  Whether segmented is disabled. Element Plus's `disabled` (boolean).

- validate_event:

  Whether to trigger form validation. Element Plus's `validate-event`
  (boolean).

- aria_label:

  Native `aria-label` attribute. Element Plus's `aria-label` (string).

- direction:

  Display direction. Element Plus's `direction` ('horizontal' \|
  'vertical').

- props:

  Which field of an option holds what, when the options are records
  named otherwise: `list(value =, label =, disabled =)`, Element Plus's
  `props`.

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

  Named list of Element slot contents. A scoped slot is written with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).

## Value

A Shiny UI element.

## Shiny inputs

- `input$<id>` – the value, on load and on every change.

- `input$<id>_change` – Element Plus's `change` event.

## Examples

``` r
el_segmented(
  "period",
  options = c(Day = "d", Week = "w", Month = "m"),
  value = "w"
)
#> <div id="period" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="period_container" style="display: contents">
#>   <el-segmented v-model="value" @change="handleChange" :options="options === null ? undefined : options" :size="size === null ? undefined : size" :block="block === null ? undefined : block" :disabled="disabled === null ? undefined : disabled" :validate-event="validateEvent === null ? undefined : validateEvent" :aria-label="ariaLabel === null ? undefined : ariaLabel" :direction="direction === null ? undefined : direction" :props="props === null ? undefined : props"></el-segmented>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"w","options":[{"value":"d","label":"Day"},{"value":"w","label":"Week"},{"value":"m","label":"Month"}],"size":null,"block":null,"disabled":null,"validateEvent":null,"ariaLabel":null,"direction":null,"props":null},"methods":{"handleChange":"function(v) { }"}},"input":"value","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.handleChange"]}</script>
#> </div>
```
