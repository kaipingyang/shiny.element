# Element UI Table Component

Create a table widget for Shiny using Element UI.

## Usage

``` r
el_table(
  id = NULL,
  data = list(),
  columns = list(),
  selection = FALSE,
  border = TRUE,
  session = shiny::getDefaultReactiveDomain()
)
```

## Arguments

- id:

  Table ID (auto-generated if NULL)

- data:

  A data.frame, or a list of rows (each a named list). A data.frame is
  converted to rows automatically and its column names are sanitised
  (`.` becomes `_`) so `el-table`'s dotted `prop` lookup works.

- columns:

  List of column configs, each `list(prop=, label=, width=)`. Inferred
  from `data` when omitted.

- selection:

  Enable row selection

- border:

  Show table border

- session:

  Shiny session for module support

## Value

A Shiny UI element.

## Server inputs

With `selection = TRUE` the component reports two inputs:
`input$<id>_selected` (the selected row objects) and
`input$<id>_selected_rows` (their 1-based row numbers). Prefer the
latter to index back into your original data: a row object with mixed
column types is simplified to a character vector on its way back through
JSON, so numbers arrive as strings. Both are `NULL` while nothing is
selected, matching how Shiny reports an empty
[`shiny::checkboxGroupInput()`](https://rdrr.io/pkg/shiny/man/checkboxGroupInput.html).

## Examples

``` r
# A data.frame is enough -- columns are inferred
el_table("iris_preview", data = head(iris, 3))
#> <div id="iris_preview_container" style="display: contents">
#>   <el-table :data="tableData" :border="border" style="width: 100%" @selection-change="handleSelectionChange">
#>     <el-table-column v-if="selection" type="selection" width="55"></el-table-column>
#>     <el-table-column v-for="col in columns" :key="col.prop" :prop="col.prop" :label="col.label" :width="col.width"></el-table-column>
#>   </el-table>
#> </div>
#> <div id="iris_preview" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="iris_preview">{"x":{"el":"#iris_preview_container","data":{"tableData":[{"Sepal_Length":5.1,"Sepal_Width":3.5,"Petal_Length":1.4,"Petal_Width":0.2,"Species":"setosa"},{"Sepal_Length":4.9,"Sepal_Width":3,"Petal_Length":1.4,"Petal_Width":0.2,"Species":"setosa"},{"Sepal_Length":4.7,"Sepal_Width":3.2,"Petal_Length":1.3,"Petal_Width":0.2,"Species":"setosa"}],"columns":[{"prop":"Sepal_Length","label":"Sepal.Length"},{"prop":"Sepal_Width","label":"Sepal.Width"},{"prop":"Petal_Length","label":"Petal.Length"},{"prop":"Petal_Width","label":"Petal.Width"},{"prop":"Species","label":"Species"}],"border":true,"selection":false,"selected":[],"selectedRows":[]},"methods":{"handleSelectionChange":"function(selection) { var self = this; self.selected = selection; self.selectedRows = selection.map(function(r) { return self.tableData.indexOf(r) + 1; }); Shiny.setInputValue('iris_preview_selected', self.selected); Shiny.setInputValue('iris_preview_selected_rows', self.selectedRows); }"},"mounted":"function() { var self = this; var send = function() { Shiny.setInputValue(\"iris_preview_selected\", self.selected); Shiny.setInputValue(\"iris_preview_selected_rows\", self.selectedRows); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else { $(document).one('shiny:connected', send); } }"},"evals":["methods.handleSelectionChange","mounted"],"jsHooks":[]}</script>

# Explicit columns
el_table(
  "scores",
  data = data.frame(name = c("A", "B"), value = c(1, 2)),
  columns = list(
    list(prop = "name", label = "Name"),
    list(prop = "value", label = "Value", width = "100")
  )
)
#> <div id="scores_container" style="display: contents">
#>   <el-table :data="tableData" :border="border" style="width: 100%" @selection-change="handleSelectionChange">
#>     <el-table-column v-if="selection" type="selection" width="55"></el-table-column>
#>     <el-table-column v-for="col in columns" :key="col.prop" :prop="col.prop" :label="col.label" :width="col.width"></el-table-column>
#>   </el-table>
#> </div>
#> <div id="scores" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="scores">{"x":{"el":"#scores_container","data":{"tableData":[{"name":"A","value":1},{"name":"B","value":2}],"columns":[{"prop":"name","label":"Name"},{"prop":"value","label":"Value","width":"100"}],"border":true,"selection":false,"selected":[],"selectedRows":[]},"methods":{"handleSelectionChange":"function(selection) { var self = this; self.selected = selection; self.selectedRows = selection.map(function(r) { return self.tableData.indexOf(r) + 1; }); Shiny.setInputValue('scores_selected', self.selected); Shiny.setInputValue('scores_selected_rows', self.selectedRows); }"},"mounted":"function() { var self = this; var send = function() { Shiny.setInputValue(\"scores_selected\", self.selected); Shiny.setInputValue(\"scores_selected_rows\", self.selectedRows); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else { $(document).one('shiny:connected', send); } }"},"evals":["methods.handleSelectionChange","mounted"],"jsHooks":[]}</script>

# Shiny app with row selection and server-side updates
if (interactive()) {
  library(shiny)
  library(shiny.element)
  ui <- el_page(
    el_table("my_table", data = head(iris, 5), selection = TRUE),
    el_button("reload", "Show more rows"),
    verbatimTextOutput("selected_rows")
  )
  server <- function(input, output, session) {
    output$selected_rows <- renderPrint({
      # *_selected_rows holds 1-based row numbers, with original R types
      head(iris, 5)[input$my_table_selected_rows, ]
    })
    observeEvent(input$reload, {
      update_el_table(session, "my_table", data = head(iris, 10))
    })
  }
  shinyApp(ui, server)
}
```
