# Element UI Checkbox Group

Creates an Element UI checkbox group with Vue instance, supporting
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
  width = NULL,
  slots = NULL,
  value = NULL,
  options = NULL,
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

  Size for button style only: `"medium"`, `"small"`, `"mini"`.

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

An `htmltools` tagList with a Vue-managed checkbox group component.

## Shiny input

`input$<id>` — character vector of currently selected values.

## Examples

``` r
el_checkbox_group(
  "cb1",
  choices = c("Option A" = "a", "Option B" = "b")
)
#> <div id="cb1" data-el-vue-host style="display: contents">
#>   <div id="cb1_container" data-el-mount style="display: contents">
#>     <el-checkbox-group v-model="value" :disabled="disabled" @change="handleChange" :size="size === null ? undefined : size" :min="min === null ? undefined : min" :max="max === null ? undefined : max" :fill="fill === null ? undefined : fill" :text-color="textColor === null ? undefined : textColor">
#>       <el-checkbox :label="opt.value" v-for="opt in options" :key="opt.value" :disabled="opt.disabled" :border="opt.border" :name="opt.name" @change="handleItemChange(opt, $event)" :checked="opt.checked" :indeterminate="opt.indeterminate" :true-label="opt.trueLabel" :false-label="opt.falseLabel">{{opt.label}}</el-checkbox>
#>     </el-checkbox-group>
#>   </div>
#>   <script type="application/json" data-el-vue>{"options":{"data":{"value":[],"options":[{"value":"a","label":"Option A"},{"value":"b","label":"Option B"}],"disabled":false,"size":null,"min":null,"max":null,"fill":null,"textColor":null},"methods":{"handleItemChange":"function(opt, checked) { window.shinyElement.emit('cb1', 'item_change', [{value: opt.value, label: opt.label, checked: checked}]); }","handleChange":"function(value) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('cb1', value); }"}},"input":"value","rate":null,"type":null,"evals":["options.methods.handleItemChange","options.methods.handleChange"]}</script>
#> </div>

if (interactive()) {
  library(shiny)
  library(shiny.element)
  ui <- el_page(
    el_checkbox_group(
      "cb1",
      choices  = c("Apple" = "apple", "Banana" = "banana"),
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
