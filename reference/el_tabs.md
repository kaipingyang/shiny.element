# Element UI Tabs Component

Creates an Element UI tabs component with Vue instance. Each tab can
have a label, content, and optional disabled state.

## Usage

``` r
el_tabs(
  id = NULL,
  tabs,
  selected = NULL,
  type = NULL,
  tab_position = "top",
  closable = FALSE,
  stretch = FALSE,
  session = shiny::getDefaultReactiveDomain()
)
```

## Arguments

- id:

  Tabs ID. Auto-generated UUID if `NULL`.

- tabs:

  A list of tab definitions. Each element is a list with:

  `name`

  :   Unique string identifier for the tab (v-model value).

  `label`

  :   Display text for the tab.

  `content`

  :   Optional tagList/tag for the tab body. `NULL` for empty.

  `disabled`

  :   Logical. Whether the tab is disabled. Default `FALSE`.

- selected:

  Initial active tab name. Defaults to the first tab's name.

- type:

  Tab style type: `NULL` (default), `"card"`, or `"border-card"`.

- tab_position:

  Position of the tab bar: `"top"` (default), `"right"`, `"bottom"`, or
  `"left"`.

- closable:

  Whether tabs show a close button. Default `FALSE`.

- stretch:

  Whether tab headers stretch to fill the tab bar. Default `FALSE`.

- session:

  Shiny session for module support.

## Value

An `htmltools` tagList with a Vue-managed tabs component.

## Shiny input

`input$<id>` — String (active tab name), updated on each tab click.

## Examples

``` r
# Basic usage
el_tabs(
  id = "my_tabs",
  tabs = list(
    list(name = "tab1", label = "Tab 1", content = shiny::tags$p("Content 1")),
    list(name = "tab2", label = "Tab 2", content = shiny::tags$p("Content 2")),
    list(name = "tab3", label = "Tab 3", disabled = TRUE)
  ),
  selected = "tab1"
)
#> <div id="my_tabs_container">
#>   <el-tabs v-model="activeTab" :tab-position="tabPosition" :stretch="stretch" @tab-click="handleTabClick">
#>     <el-tab-pane name="tab1" label="Tab 1">
#>       <p>Content 1</p>
#>     </el-tab-pane>
#>     <el-tab-pane name="tab2" label="Tab 2">
#>       <p>Content 2</p>
#>     </el-tab-pane>
#>     <el-tab-pane name="tab3" label="Tab 3" disabled></el-tab-pane>
#>   </el-tabs>
#> </div>
#> <div class="vue html-widget html-fill-item" id="my_tabs" style="width:960px;height:500px;"></div>
#> <script type="application/json" data-for="my_tabs">{"x":{"el":"#my_tabs_container","data":{"activeTab":"tab1","tabPosition":"top","stretch":false,"closable":false},"methods":{"handleTabClick":"function(tab, event) { Shiny.setInputValue('my_tabs', tab.name); }"}},"evals":["methods.handleTabClick"],"jsHooks":[]}</script>

# Card style with position
if (interactive()) {
  library(shiny)
  library(shiny.element)
  ui <- el_page(
    el_tabs(
      id = "tabs1",
      type = "card",
      tab_position = "top",
      tabs = list(
        list(name = "a", label = "First",  content = shiny::tags$p("Hello")),
        list(name = "b", label = "Second", content = shiny::tags$p("World"))
      )
    ),
    verbatimTextOutput("active")
  )
  server <- function(input, output, session) {
    output$active <- renderPrint(input$tabs1)
  }
  shinyApp(ui, server)
}
```
