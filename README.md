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
  use_element(),
  el_button(id = "button1", label = "Click Me"),
  el_cascader(
    id = "cascader1",
    options = cascader_options,
    placeholder = "Please select",
    clearable = TRUE
  ),
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
  )

)

server <- function(input, output, session) {
  observeEvent(input$button1, {
    showNotification(paste("Button clicked!", "Count:", input$button1))
  })
}

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
  el_cascader(
    id = "cascader1",
    options = cascader_options,
    placeholder = "Please select",
    clearable = TRUE
  ),
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
  )
)

server <- function(input, output, session) {
  observeEvent(input$button1, {
    showNotification(paste("Button clicked!", "Count:", input$button1))
  })
}

shinyApp(ui, server)
```

## Using bslib Layouts with Element-UI Components

You can use Element-UI components (such as el_button) inside bslib layouts. Just call use_element() at the top of your UI to load all required dependencies, then use Element-UI widgets inside bslib layout functions:

```r
library(shiny)
library(shiny.element)
library(bslib)

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

ui <- page_sidebar(
  use_element(), # Loads Element-UI dependencies
  sidebar = sidebar(
    el_button("sidebar_btn", "Sidebar Button", type = "primary")
  ),
  layout_columns(
    col_widths = c(4, 4, 12),
    row_heights = c(2, 8),
    el_button("btn1", "Primary", type = "primary"),
    el_cascader(
      id = "cascader1",
      options = cascader_options,
      placeholder = "Please select",
      clearable = TRUE
    ),
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
    )
  )
)

server <- function(input, output, session) {
  observeEvent(input$button1, {
    showNotification(paste("Button clicked!", "Count:", input$button1))
  })
}

shinyApp(ui, server)
```

Note:
The Element-UI layout functions (el_container, el_row, el_col) are experimental and fundamentally different from bslib’s layout system (page_sidebar, layout_columns). They cannot be directly nested or mixed. For most use cases, prefer bslib layouts with Element-UI components. The Element-UI layout functions may be deprecated in future releases.

## Main Components

- `el_button()`: Element-UI Button
- `el_table()`: Element-UI Table
- `el_cascader()`: Element-UI Cascader
- `el_header()`, `el_main()`, `el_footer()`, `el_aside()`: Element-UI Layout Containers (may be deprecated in future releases)

## Dependencies

- [Element-UI](https://element.eleme.io/)
- [vueR](https://github.com/renozao/vueR)
- [shiny](https://shiny.rstudio.com/)

## Contributing

Feedback and contributions are welcome via GitHub issues.
