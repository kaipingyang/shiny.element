# Element UI Radio Group Component

Creates an Element UI `<el-radio-group>` component backed by a Vue
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
  width = NULL,
  slots = NULL,
  value = NULL,
  options = NULL,
  session = NULL
)
```

## Arguments

- id:

  Input ID. Auto-generated UUID if `NULL`.

- choices, options:

  The choices: a named character vector (`c(Label = value)`) or a list
  of `list(value = ..., label = ...)`. Unnamed vectors are allowed; the
  element is used as both value and label. `choices` is Shiny's name for
  it, `options` Element's; give either.

- selected, value:

  Initially selected value; nothing by default. `selected` is Shiny's
  name, `value` Element's (its `v-model`); give either.

- disabled:

  Whether the entire group is disabled. Default `FALSE`.

- size:

  Component size: `NULL`, `"medium"`, `"small"`, or `"mini"`. Only
  affects button-style radios (`button = TRUE`).

- button:

  Whether to render as `<el-radio-button>` (pill/button style) instead
  of standard `<el-radio>`. Default `FALSE`.

- fill:

  Border and background colour of a checked radio button.

- text_color:

  Text colour of a checked radio button.

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

An `htmltools` tagList containing the Vue-managed radio group.

## Shiny input

`input$<id>` — string or number reflecting the currently selected value,
updated on each change.

## Examples

``` r
# Standard radio buttons from a named vector
el_radio_group("size",
  choices  = c(Small = "s", Medium = "m", Large = "l"),
  selected = "m"
)
#> <div id="size" data-el-vue-host style="display: contents">
#>   <div id="size_container" data-el-mount style="display: contents">
#>     <el-radio-group v-model="value" :disabled="disabled" @change="handleChange" :size="size === null ? undefined : size" :fill="fill === null ? undefined : fill" :text-color="textColor === null ? undefined : textColor">
#>       <el-radio :label="opt.value" v-for="opt in options" :key="opt.value" :disabled="opt.disabled" :border="opt.border" :name="opt.name" @change="handleItemChange(opt, $event)">{{opt.label}}</el-radio>
#>     </el-radio-group>
#>   </div>
#>   <script type="application/json" data-el-vue>{"options":{"data":{"value":"m","options":[{"value":"s","label":"Small"},{"value":"m","label":"Medium"},{"value":"l","label":"Large"}],"disabled":false,"size":null,"fill":null,"textColor":null},"methods":{"handleItemChange":"function(opt, checked) { window.shinyElement.emit('size', 'item_change', [{value: opt.value, label: opt.label, checked: checked}]); }","handleChange":"function(value) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('size', value); }"}},"input":"value","rate":null,"type":null,"evals":["options.methods.handleItemChange","options.methods.handleChange"]}</script>
#> </div>

# Button-style radio group
el_radio_group("theme",
  choices = c(Light = "light", Dark = "dark"),
  button  = TRUE,
  size    = "small"
)
#> <div id="theme" data-el-vue-host style="display: contents">
#>   <div id="theme_container" data-el-mount style="display: contents">
#>     <el-radio-group v-model="value" :disabled="disabled" @change="handleChange" :size="size === null ? undefined : size" :fill="fill === null ? undefined : fill" :text-color="textColor === null ? undefined : textColor">
#>       <el-radio-button :label="opt.value" v-for="opt in options" :key="opt.value" :disabled="opt.disabled" :border="opt.border" :name="opt.name" @change="handleItemChange(opt, $event)">{{opt.label}}</el-radio-button>
#>     </el-radio-group>
#>   </div>
#>   <script type="application/json" data-el-vue>{"options":{"data":{"value":"","options":[{"value":"light","label":"Light"},{"value":"dark","label":"Dark"}],"disabled":false,"size":"small","fill":null,"textColor":null},"methods":{"handleItemChange":"function(opt, checked) { window.shinyElement.emit('theme', 'item_change', [{value: opt.value, label: opt.label, checked: checked}]); }","handleChange":"function(value) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('theme', value); }"}},"input":"value","rate":null,"type":null,"evals":["options.methods.handleItemChange","options.methods.handleChange"]}</script>
#> </div>

# Shiny app example
if (interactive()) {
  library(shiny)
  library(shiny.element)
  ui <- el_page(
    el_radio_group("fruit",
      choices  = c(Apple = "apple", Banana = "banana", Cherry = "cherry"),
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
