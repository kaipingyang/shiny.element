# Element Plus Radio Group Component

Creates an Element Plus `<el-radio-group>` component backed by a Vue
instance. Supports both standard radio buttons (`<el-radio>`) and
button-style radios (`<el-radio-button>`).

## Usage

``` r
el_radio_group(
  id = NULL,
  choices = NULL,
  selected = NULL,
  disabled = FALSE,
  size = NULL,
  button = FALSE,
  fill = NULL,
  text_color = NULL,
  label = NULL,
  label_position = c("top", "left", "right"),
  label_width = NULL,
  label_suffix = NULL,
  required = FALSE,
  error = NULL,
  show_message = TRUE,
  inline_message = FALSE,
  width = NULL,
  slots = NULL,
  value = NULL,
  options = NULL,
  aria_label = NULL,
  props = NULL,
  type = NULL,
  validate_event = NULL,
  session = NULL
)
```

## Arguments

- id:

  Input ID. Auto-generated UUID if `NULL`.

- choices, options:

  The choices: a named character vector (`c(Label = value)`) or a list
  of
  [`el_option()`](https://kaipingyang.github.io/shiny.element/reference/el_option.md)s
  – which can be `disabled` – or of `list(value = ..., label = ...)`.
  Unnamed vectors are allowed; the element is used as both value and
  label. `choices` is Shiny's name for it, `options` Element's; give
  either.

- selected, value:

  Initially selected value; nothing by default. `selected` is Shiny's
  name, `value` Element's (its `v-model`); give either.

- disabled:

  Whether the entire group is disabled. Default `FALSE`.

- size:

  Size: `"large"`, `"default"` or `"small"`; `NULL` follows the form or
  the page. Only affects button-style radios (`button = TRUE`).

- button:

  Whether to render as `<el-radio-button>` (pill/button style) instead
  of standard `<el-radio>`. Default `FALSE`.

- fill:

  Border and background colour of a checked radio button.

- text_color:

  Text colour of a checked radio button.

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

  Component width, as a CSS unit – `"200px"`, `"50%"`, or a number taken
  as pixels. Element's own markup carries it, so it behaves like the
  `width` argument of a Shiny input.

- slots:

  Named list of Element slot contents, such as
  `list(title = shiny::tags$b("Bold"))`. A shiny.element component given
  here is absorbed rather than nested. For a scoped slot, write the
  template with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).

- aria_label:

  Same as `aria-label` in RadioGroup. Element Plus's `aria-label`
  (string).

- props:

  Configuration options. Element Plus's `props`
  (`{ value?: string, label?: string, disabled?: string}`).

- type:

  Component type to render options (e.g. `'button'`). Element Plus's
  `type` ('radio' \| 'button').

- validate_event:

  Whether to trigger form validation. Element Plus's `validate-event`
  (boolean).

- session:

  Deprecated. Inside a module, wrap `id` in `ns()`, as for any Shiny
  input; a session given here namespaces `id` once more, with a warning.

## Value

An `htmltools` tagList containing the Vue-managed radio group.

## Shiny inputs

`input$<id>` — string or number reflecting the currently selected value,
updated on each change.

## Examples

``` r
# Standard radio buttons from a named vector
el_radio_group(
  "size",
  choices = c(Small = "s", Medium = "m", Large = "l"),
  selected = "m"
)
#> <div id="size" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="size_container" style="display: contents">
#>   <el-radio-group v-model="value" :disabled="disabled" @change="handleChange" :size="size === null ? undefined : size" :fill="fill === null ? undefined : fill" :text-color="textColor === null ? undefined : textColor" :aria-label="ariaLabel === null ? undefined : ariaLabel" :props="props === null ? undefined : props" :type="type === null ? undefined : type" :validate-event="validateEvent === null ? undefined : validateEvent">
#>     <el-radio :label="opt.value" v-for="opt in options" :key="opt.value" :disabled="opt.disabled" :border="opt.border" :name="opt.name" @change="handleItemChange(opt, $event)">{{opt.label}}</el-radio>
#>   </el-radio-group>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"m","options":[{"value":"s","label":"Small"},{"value":"m","label":"Medium"},{"value":"l","label":"Large"}],"disabled":false,"size":null,"fill":null,"textColor":null,"ariaLabel":null,"props":null,"type":null,"validateEvent":null},"methods":{"handleItemChange":"function(opt, checked) { window.shinyVue.emit('size', 'item_change', [{value: opt.value, label: opt.label, checked: checked}]); }","handleChange":"function(value) { }"}},"input":"value","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.handleItemChange","options.methods.handleChange"]}</script>
#> </div>

# Button-style radio group
el_radio_group(
  "theme",
  choices = c(Light = "light", Dark = "dark"),
  button = TRUE,
  size = "small"
)
#> <div id="theme" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="theme_container" style="display: contents">
#>   <el-radio-group v-model="value" :disabled="disabled" @change="handleChange" :size="size === null ? undefined : size" :fill="fill === null ? undefined : fill" :text-color="textColor === null ? undefined : textColor" :aria-label="ariaLabel === null ? undefined : ariaLabel" :props="props === null ? undefined : props" :type="type === null ? undefined : type" :validate-event="validateEvent === null ? undefined : validateEvent">
#>     <el-radio-button :label="opt.value" v-for="opt in options" :key="opt.value" :disabled="opt.disabled" :border="opt.border" :name="opt.name" @change="handleItemChange(opt, $event)">{{opt.label}}</el-radio-button>
#>   </el-radio-group>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"","options":[{"value":"light","label":"Light"},{"value":"dark","label":"Dark"}],"disabled":false,"size":"small","fill":null,"textColor":null,"ariaLabel":null,"props":null,"type":null,"validateEvent":null},"methods":{"handleItemChange":"function(opt, checked) { window.shinyVue.emit('theme', 'item_change', [{value: opt.value, label: opt.label, checked: checked}]); }","handleChange":"function(value) { }"}},"input":"value","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.handleItemChange","options.methods.handleChange"]}</script>
#> </div>

# Shiny app example
if (interactive()) {
  library(shiny)
  library(shiny.element)
  ui <- el_page(
    el_radio_group(
      "fruit",
      choices = c(Apple = "apple", Banana = "banana", Cherry = "cherry"),
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
