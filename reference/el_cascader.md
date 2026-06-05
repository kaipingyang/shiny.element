# Element UI Cascader Widget

Create a cascader (multi-level dropdown) input for Shiny using Element
UI.

## Usage

``` r
el_cascader(
  id = NULL,
  options = list(),
  value = NULL,
  placeholder = "Please select",
  props = NULL,
  clearable = FALSE,
  filterable = FALSE,
  disabled = FALSE,
  size = NULL,
  show_all_levels = TRUE,
  collapse_tags = FALSE,
  separator = " / ",
  debounce = 300,
  icon = NULL,
  session = getDefaultReactiveDomain()
)
```

## Arguments

- id:

  Cascader ID (auto-generated if NULL)

- options:

  Cascader options data (hierarchical list)

- value:

  Initial selected value

- placeholder:

  Placeholder text

- props:

  Configuration object for cascader behavior

- clearable:

  Whether clearable

- filterable:

  Whether filterable (searchable)

- disabled:

  Whether disabled

- size:

  Size of cascader (medium, small, mini)

- show_all_levels:

  Whether to show all levels in input

- collapse_tags:

  Whether to collapse tags in multiple mode

- separator:

  Separator for display

- debounce:

  Debounce delay for filter

- icon:

  Icon for the cascader (shiny.tag or NULL)

- session:

  Shiny session for module support

## Examples

``` r
# Basic cascader usage
cascader_options <- list(
  list(
    value = "guide",
    label = "Guide",
    children = list(
      list(value = "principle", label = "Principle"),
      list(value = "navigation", label = "Navigation")
    )
  ),
  list(
    value = "component",
    label = "Component",
    children = list(
      list(value = "basic", label = "Basic"),
      list(value = "form", label = "Form", disabled = TRUE)
    )
  )
)

if (interactive()) {
  library(shiny)
  library(shiny.element)
  ui <- el_page(
    el_cascader(
      id = "cascader1",
      options = cascader_options,
      placeholder = "Please select",
      clearable = TRUE
    ),
    verbatimTextOutput("selected")
  )
  server <- function(input, output, session) {
    output$selected <- renderPrint(input$cascader1_value)
  }
  shinyApp(ui, server)
}

# Advanced: custom props and update
custom_props <- list(
  expandTrigger = "hover",
  multiple = FALSE,
  checkStrictly = FALSE,
  emitPath = TRUE,
  lazy = FALSE,
  value = "value",
  label = "label",
  children = "children"
)

# Update cascader options in server:
# update_el_cascader(session, "cascader1", options = new_options)
```
