# Element UI Table Component

Create a table widget for Shiny using Element UI.

## Usage

``` r
el_table(
  data = list(),
  columns = list(),
  id = NULL,
  selection = FALSE,
  border = TRUE,
  session = shiny::getDefaultReactiveDomain()
)
```

## Arguments

- data:

  List of row data

- columns:

  List of column configs (see `el_table_config`)

- id:

  Table ID (auto-generated if NULL)

- selection:

  Enable row selection

- border:

  Show table border

- session:

  Shiny session for module support

## Examples

``` r
# Basic usage
data <- list(
  list(name = "A", value = 1),
  list(name = "B", value = 2)
)
columns <- list(
  list(prop = "name", label = "Name"),
  list(prop = "value", label = "Value")
)
el_table(data = data, columns = columns)
#> <div id="el_table_5e3f8f80-925f-4fbe-a898-2fc604ae5890_container">
#>   <el-table :data="tableData" style="width: 100%" border>
#>     <el-table-column prop="name" label="Name"></el-table-column>
#>     <el-table-column prop="value" label="Value"></el-table-column>
#>   </el-table>
#> </div>
#> <div class="vue html-widget html-fill-item" id="el_table_5e3f8f80-925f-4fbe-a898-2fc604ae5890" style="width:960px;height:500px;"></div>
#> <script type="application/json" data-for="el_table_5e3f8f80-925f-4fbe-a898-2fc604ae5890">{"x":{"el":"#el_table_5e3f8f80-925f-4fbe-a898-2fc604ae5890_container","data":{"tableData":[{"name":"A","value":1},{"name":"B","value":2}]},"methods":[]},"evals":[],"jsHooks":[]}</script>

# With row selection
el_table(data = data, columns = columns, selection = TRUE)
#> <div id="el_table_ebe6e16e-73bc-4007-ab37-804a7bc12178_container">
#>   <el-table :data="tableData" style="width: 100%" border @selection-change="handleSelectionChange">
#>     <el-table-column type="selection" width="55"></el-table-column>
#>     <el-table-column prop="name" label="Name"></el-table-column>
#>     <el-table-column prop="value" label="Value"></el-table-column>
#>   </el-table>
#> </div>
#> <div class="vue html-widget html-fill-item" id="el_table_ebe6e16e-73bc-4007-ab37-804a7bc12178" style="width:960px;height:500px;"></div>
#> <script type="application/json" data-for="el_table_ebe6e16e-73bc-4007-ab37-804a7bc12178">{"x":{"el":"#el_table_ebe6e16e-73bc-4007-ab37-804a7bc12178_container","data":{"tableData":[{"name":"A","value":1},{"name":"B","value":2}]},"methods":{"handleSelectionChange":"function(selection) { Shiny.setInputValue('el_table_ebe6e16e-73bc-4007-ab37-804a7bc12178_selected', selection); }"}},"evals":["methods.handleSelectionChange"],"jsHooks":[]}</script>

# Shiny app example
if (interactive()) {
  library(shiny)
  library(shiny.element)
  df <- data.frame(
    name = c("A", "B", "C"),
    value = c(1, 2, 3)
  )
  config <- el_table_config(df)
  ui <- el_page(
    el_table(
      id = "my_table",
      data = config$data,
      columns = config$columns,
      selection = TRUE
    ),
    verbatimTextOutput("selected_rows")
  )
  server <- function(input, output, session) {
    output$selected_rows <- renderPrint({
      input$my_table_selected
    })
  }
  shinyApp(ui, server)
}
```
