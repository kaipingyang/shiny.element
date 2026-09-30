# Element UI Main

Element UI Main

## Usage

``` r
el_main(..., style = NULL, class = NULL)
```

## Arguments

- ...:

  Content.

- style:

  Extra inline style.

- class:

  Extra CSS classes.

## Value

A Shiny UI element.

## Examples

``` r
el_main("Body content")
#> <div class="el-main">Body content</div>
el_main(el_table(data = head(iris, 3)))
#> <div class="el-main">
#>   <div id="el_table_29332750-6c12-45ea-b14f-c150aebc6ba0_container" style="display: contents">
#>     <el-table :data="tableData" :border="border" style="width: 100%" @selection-change="handleSelectionChange">
#>       <el-table-column v-if="selection" type="selection" width="55"></el-table-column>
#>       <el-table-column v-for="col in columns" :key="col.prop" :prop="col.prop" :label="col.label" :width="col.width"></el-table-column>
#>     </el-table>
#>   </div>
#>   <div id="el_table_29332750-6c12-45ea-b14f-c150aebc6ba0" style="width:0px;height:0px;" class="vue html-widget"></div>
#>   <script type="application/json" data-for="el_table_29332750-6c12-45ea-b14f-c150aebc6ba0">{"x":{"el":"#el_table_29332750-6c12-45ea-b14f-c150aebc6ba0_container","data":{"tableData":[{"Sepal_Length":5.1,"Sepal_Width":3.5,"Petal_Length":1.4,"Petal_Width":0.2,"Species":"setosa"},{"Sepal_Length":4.9,"Sepal_Width":3,"Petal_Length":1.4,"Petal_Width":0.2,"Species":"setosa"},{"Sepal_Length":4.7,"Sepal_Width":3.2,"Petal_Length":1.3,"Petal_Width":0.2,"Species":"setosa"}],"columns":[{"prop":"Sepal_Length","label":"Sepal.Length"},{"prop":"Sepal_Width","label":"Sepal.Width"},{"prop":"Petal_Length","label":"Petal.Length"},{"prop":"Petal_Width","label":"Petal.Width"},{"prop":"Species","label":"Species"}],"border":true,"selection":false,"selected":[],"selectedRows":[]},"methods":{"handleSelectionChange":"function(selection) { var self = this; self.selected = selection; self.selectedRows = selection.map(function(r) { return self.tableData.indexOf(r) + 1; }); Shiny.setInputValue('el_table_29332750-6c12-45ea-b14f-c150aebc6ba0_selected', self.selected); Shiny.setInputValue('el_table_29332750-6c12-45ea-b14f-c150aebc6ba0_selected_rows', self.selectedRows); }"},"mounted":"function() { var self = this; var send = function() { Shiny.setInputValue(\"el_table_29332750-6c12-45ea-b14f-c150aebc6ba0_selected\", self.selected); Shiny.setInputValue(\"el_table_29332750-6c12-45ea-b14f-c150aebc6ba0_selected_rows\", self.selectedRows); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else { $(document).one('shiny:connected', send); } }"},"evals":["methods.handleSelectionChange","mounted"],"jsHooks":[]}</script>
#> </div>
```
