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
  popper_class = NULL,
  filter_method = NULL,
  before_filter = NULL,
  width = NULL,
  slots = NULL,
  session = NULL
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

- popper_class:

  Extra class name for the dropdown panel.

- filter_method:

  [`htmlwidgets::JS()`](https://rdrr.io/pkg/htmlwidgets/man/JS.html)
  function filtering the options as the user types.

- before_filter:

  [`htmlwidgets::JS()`](https://rdrr.io/pkg/htmlwidgets/man/JS.html)
  function called before filtering; returning `false` cancels it.

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

A Shiny UI element.

## Element methods

Callable with
[`el_call()`](https://kaipingyang.github.io/shiny.element/reference/el_call.md):

- `getCheckedNodes()` – Get an array of currently selected node

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
