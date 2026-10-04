# Element Plus Checkbox Group

Creates an Element Plus checkbox group with Vue instance, supporting
individual checkboxes or button-style variants.

## Usage

``` r
el_checkbox_group(
  id = NULL,
  choices = NULL,
  selected = NULL,
  disabled = FALSE,
  size = NULL,
  min = NULL,
  max = NULL,
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
  tag = NULL,
  type = NULL,
  validate_event = NULL,
  session = NULL
)
```

## Arguments

- id:

  Checkbox group ID. Auto-generated UUID if `NULL`.

- choices, options:

  The choices: a named character vector (`c(Label = value)`) or a list
  of `list(value = ..., label = ...)`. `choices` is Shiny's name for it,
  `options` Element's; give either.

- selected, value:

  Character vector of initially checked values; none by default.
  `selected` is Shiny's name, `value` Element's (its `v-model`); give
  either.

- disabled:

  Whether the entire group is disabled. Default `FALSE`.

- size:

  `"large"`, `"default"` or `"small"`.

- min:

  Minimum number of checked items.

- max:

  Maximum number of checked items.

- button:

  Whether to use button-style checkboxes (`el-checkbox-button`). Default
  `FALSE`.

- fill:

  Border and background colour when `button = TRUE` and checked.

- text_color:

  Text colour when `button = TRUE` and checked.

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

  Native `aria-label` attribute. Element Plus's `aria-label` (string).

- props:

  Configuration options. Element Plus's `props`
  (`{ value?: string, label?: string, disabled?: string}`).

- tag:

  Element tag of the checkbox group. Element Plus's `tag` (string).

- type:

  Component type to render options (e.g. `'button'`). Element Plus's
  `type` ('checkbox' \| 'button').

- validate_event:

  Whether to trigger form validation. Element Plus's `validate-event`
  (boolean).

- session:

  Deprecated. Inside a module, wrap `id` in `ns()`, as for any Shiny
  input; a session given here namespaces `id` once more, with a warning.

## Value

An `htmltools` tagList with a Vue-managed checkbox group component.

## Shiny inputs

`input$<id>` — character vector of currently selected values.

## Examples

``` r
el_checkbox_group(
  "cb1",
  choices = c("Option A" = "a", "Option B" = "b")
)
#> <div id="cb1" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="cb1_container" style="display: contents">
#>   <el-checkbox-group v-model="value" :disabled="disabled" @change="handleChange" :size="size === null ? undefined : size" :min="min === null ? undefined : min" :max="max === null ? undefined : max" :fill="fill === null ? undefined : fill" :text-color="textColor === null ? undefined : textColor" :aria-label="ariaLabel === null ? undefined : ariaLabel" :props="props === null ? undefined : props" :tag="tag === null ? undefined : tag" :type="type === null ? undefined : type" :validate-event="validateEvent === null ? undefined : validateEvent">
#>     <el-checkbox :label="opt.value" v-for="opt in options" :key="opt.value" :disabled="opt.disabled" :border="opt.border" :name="opt.name" @change="handleItemChange(opt, $event)" :checked="opt.checked" :indeterminate="opt.indeterminate" :true-label="opt.trueLabel" :false-label="opt.falseLabel">{{opt.label}}</el-checkbox>
#>   </el-checkbox-group>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":[],"options":[{"value":"a","label":"Option A"},{"value":"b","label":"Option B"}],"disabled":false,"size":null,"min":null,"max":null,"fill":null,"textColor":null,"ariaLabel":null,"props":null,"tag":null,"type":null,"validateEvent":null},"methods":{"handleItemChange":"function(opt, checked) { window.shinyVue.emit('cb1', 'item_change', [{value: opt.value, label: opt.label, checked: checked}]); }","handleChange":"function(value) { }"}},"input":"value","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.handleItemChange","options.methods.handleChange"]}</script>
#> </div>

if (interactive()) {
  library(shiny)
  library(shiny.element)
  ui <- el_page(
    el_checkbox_group(
      "cb1",
      choices = c("Apple" = "apple", "Banana" = "banana"),
      selected = "apple"
    ),
    verbatimTextOutput("selected")
  )
  server <- function(input, output, session) {
    output$selected <- renderPrint(input$cb1)
  }
  shinyApp(ui, server)
}
```
