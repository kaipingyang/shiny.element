# shiny.element

**shiny.element** provides R/Shiny bindings for Element-UI (Vue2) components, enabling modern, interactive, and flexible UI development in Shiny apps.

## Installation

```r
remotes::install_github("kaipingyang/shiny.element")
```

## Features

- Element-UI buttons, tables, cascader, and layout components for Shiny
- Automatic Vue mounting—no manual setup required
- Shiny module namespace support
- Seamless integration with Shiny's reactive system

## Quick Example

```r
library(shiny)
library(shiny.element)

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
      list(value = "form", label = "Form")
    )
  )
)

ui <- fluidPage(
  vueR::html_dependency_vue(),
  element_ui_dependency(),
  el_layout_css_dependency(),
  el_button(id = "button1", label = "Click Me"),
  el_table(
    id = "table1",
    data = list(
      list(RowName = "A", Value = 1),
      list(RowName = "B", Value = 2)
    ),
    columns = list(
      list(prop = "RowName", label = "Row Name", width = "120"),
      list(prop = "Value", label = "Value", width = "80")
    )
  ),
  el_cascader(
    id = "cascader1",
    options = cascader_options,
    placeholder = "Please select",
    clearable = TRUE
  )
)

server <- function(input, output, session) {}

shinyApp(ui, server)
```

## el_page

```r
library(shiny)
library(shiny.element)

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
      list(value = "form", label = "Form")
    )
  )
)

ui <- el_page(
  el_button(id = "button1", label = "Click Me"),
  el_table(
    id = "table1",
    data = list(
      list(RowName = "A", Value = 1),
      list(RowName = "B", Value = 2)
    ),
    columns = list(
      list(prop = "RowName", label = "Row Name", width = "120"),
      list(prop = "Value", label = "Value", width = "80")
    )
  ),
  el_cascader(
    id = "cascader1",
    options = cascader_options,
    placeholder = "Please select",
    clearable = TRUE
  )
)

server <- function(input, output, session) {}

shinyApp(ui, server)
```

## Main Components

- `el_button()`: Element-UI Button
- `el_table()`: Element-UI Table
- `el_cascader()`: Element-UI Cascader
- `el_header()`, `el_main()`, `el_footer()`, `el_aside()`: Element-UI Layout Containers

## Dependencies

- [Element-UI](https://element.eleme.io/)
- [vueR](https://github.com/renozao/vueR)
- [shiny](https://shiny.rstudio.com/)

## Contributing

Feedback and contributions are welcome via GitHub issues.
