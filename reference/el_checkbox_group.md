# Element UI Checkbox Group

Creates an Element UI checkbox group with Vue instance, supporting
individual checkboxes or button-style variants.

## Usage

``` r
el_checkbox_group(
  id = NULL,
  choices,
  selected = NULL,
  disabled = FALSE,
  size = NULL,
  min = NULL,
  max = NULL,
  button = FALSE,
  session = shiny::getDefaultReactiveDomain()
)
```

## Arguments

- id:

  Checkbox group ID. Auto-generated UUID if `NULL`.

- choices:

  Named character vector `c(Label = value)` or list of
  `list(value = ..., label = ...)` defining available options.

- selected:

  Character vector of initially checked values. `NULL` for none.

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

- session:

  Shiny session for module support.

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
#> <div id="cb1_container">
#>   <el-checkbox-group v-model="value" :disabled="disabled" @change="handleChange">
#>     <el-checkbox :label="opt.value" v-for="opt in options" :key="opt.value">{{opt.label}}</el-checkbox>
#>   </el-checkbox-group>
#> </div>
#> <div class="vue html-widget html-fill-item" id="cb1" style="width:960px;height:500px;"></div>
#> <script type="application/json" data-for="cb1">{"x":{"el":"#cb1_container","data":{"value":[],"options":[{"value":"a","label":"Option A"},{"value":"b","label":"Option B"}],"disabled":false},"methods":{"handleChange":"function(value) { Shiny.setInputValue('cb1', value); }"}},"evals":["methods.handleChange"],"jsHooks":[]}</script>

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
