# Element UI Select Component

Creates an Element UI `<el-select>` component backed by a Vue instance.
Supports single and multiple selection, filtering, and all standard
Element UI select props.

## Usage

``` r
el_select(
  id = NULL,
  choices,
  selected = NULL,
  multiple = FALSE,
  placeholder = NULL,
  disabled = FALSE,
  clearable = FALSE,
  filterable = FALSE,
  size = NULL,
  multiple_limit = 0,
  collapse_tags = FALSE,
  session = shiny::getDefaultReactiveDomain()
)
```

## Arguments

- id:

  Input ID. Auto-generated UUID if `NULL`.

- choices:

  Named character vector (`c(Label = value)`) or a list of
  `list(value = ..., label = ...)` items. Unnamed vectors are allowed;
  the element is used as both value and label.

- selected:

  Initial selected value(s). Use a character vector for multiple
  selection. Defaults to `""` (single) or
  [`list()`](https://rdrr.io/r/base/list.html) (multiple).

- multiple:

  Whether multiple items can be selected. Default `FALSE`.

- placeholder:

  Placeholder text shown when nothing is selected.

- disabled:

  Whether the select is disabled. Default `FALSE`.

- clearable:

  Whether to show a clear button. Default `FALSE`.

- filterable:

  Whether typing filters the options. Default `FALSE`.

- size:

  Component size: `NULL`, `"medium"`, `"small"`, or `"mini"`.

- multiple_limit:

  Maximum number of items that can be selected when `multiple = TRUE`.
  `0` means unlimited. Default `0`.

- collapse_tags:

  Whether to collapse selected tags into a summary when
  `multiple = TRUE`. Default `FALSE`.

- session:

  Shiny session for module namespace support.

## Value

An `htmltools` tagList containing the Vue-managed select component.

## Shiny input

`input$<id>` — string (single) or character vector (multiple), updated
on each change.

## Examples

``` r
# Single-select from a named vector
el_select("sel1",
  choices  = c(Apple = "apple", Banana = "banana", Cherry = "cherry"),
  selected = "banana"
)
#> <div id="sel1_container">
#>   <el-select v-model="value" :multiple="multiple" :disabled="disabled" :clearable="clearable" :filterable="filterable" :multiple-limit="multipleLimit" :collapse-tags="collapseTags" @change="handleChange">
#>     <el-option v-for="opt in options" :key="opt.value" :value="opt.value" :label="opt.label"></el-option>
#>   </el-select>
#> </div>
#> <div class="vue html-widget html-fill-item" id="sel1" style="width:960px;height:500px;"></div>
#> <script type="application/json" data-for="sel1">{"x":{"el":"#sel1_container","data":{"value":"banana","options":[{"value":"apple","label":"Apple"},{"value":"banana","label":"Banana"},{"value":"cherry","label":"Cherry"}],"multiple":false,"disabled":false,"clearable":false,"filterable":false,"multipleLimit":0,"collapseTags":false},"methods":{"handleChange":"function(value) { Shiny.setInputValue('sel1', value); }"}},"evals":["methods.handleChange"],"jsHooks":[]}</script>

# Shiny app example
if (interactive()) {
  library(shiny)
  library(shiny.element)
  ui <- el_page(
    el_select("fruit",
      choices  = c(Apple = "apple", Banana = "banana", Cherry = "cherry"),
      selected = "apple",
      clearable = TRUE
    ),
    verbatimTextOutput("selected")
  )
  server <- function(input, output, session) {
    output$selected <- renderPrint(input$fruit)
  }
  shinyApp(ui, server)
}
```
