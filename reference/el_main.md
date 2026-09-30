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
#>   <div id="el_table_6856648f-a864-4420-b496-8af7d011e006_container" style="display: contents">
#>     <el-table :data="tableData" :border="border" style="width: 100%" @selection-change="handleSelectionChange" :stripe="stripe === null ? undefined : stripe" :size="size === null ? undefined : size" :height="height === null ? undefined : height" :max-height="maxHeight === null ? undefined : maxHeight" :fit="fit === null ? undefined : fit" :show-header="showHeader === null ? undefined : showHeader" :highlight-current-row="highlightCurrentRow === null ? undefined : highlightCurrentRow" :current-row-key="currentRowKey === null ? undefined : currentRowKey" :row-key="rowKey === null ? undefined : rowKey" :empty-text="emptyText === null ? undefined : emptyText" :default-expand-all="defaultExpandAll === null ? undefined : defaultExpandAll" :expand-row-keys="expandRowKeys === null ? undefined : expandRowKeys" :default-sort="defaultSort === null ? undefined : defaultSort" :tooltip-effect="tooltipEffect === null ? undefined : tooltipEffect" :show-summary="showSummary === null ? undefined : showSummary" :sum-text="sumText === null ? undefined : sumText" :select-on-indeterminate="selectOnIndeterminate === null ? undefined : selectOnIndeterminate" :indent="indent === null ? undefined : indent" :lazy="lazy === null ? undefined : lazy" :tree-props="treeProps === null ? undefined : treeProps" :row-class-name="rowClassName === null ? undefined : rowClassName" :row-style="rowStyle === null ? undefined : rowStyle" :cell-class-name="cellClassName === null ? undefined : cellClassName" :cell-style="cellStyle === null ? undefined : cellStyle" :header-row-class-name="headerRowClassName === null ? undefined : headerRowClassName" :header-row-style="headerRowStyle === null ? undefined : headerRowStyle" :header-cell-class-name="headerCellClassName === null ? undefined : headerCellClassName" :header-cell-style="headerCellStyle === null ? undefined : headerCellStyle" :span-method="spanMethod === null ? undefined : spanMethod" :summary-method="summaryMethod === null ? undefined : summaryMethod" :load="load === null ? undefined : load">
#>       <el-table-column v-if="selection" type="selection" width="55"></el-table-column>
#>       <el-table-column v-for="col in columns" :key="col.prop" :prop="col.prop" :label="col.label" :width="col.width" :align="col.align" :header-align="col.headerAlign" :class-name="col.className" :label-class-name="col.labelClassName" :column-key="col.columnKey" :min-width="col.minWidth" :fixed="col.fixed" :resizable="col.resizable" :sortable="col.sortable" :sort-by="col.sortBy" :sort-orders="col.sortOrders" :show-overflow-tooltip="col.showOverflowTooltip" :filters="col.filters" :filtered-value="col.filteredValue" :filter-multiple="col.filterMultiple" :filter-placement="col.filterPlacement" :reserve-selection="col.reserveSelection" :index="col.index" :formatter="col.formatter" :filter-method="col.filterMethod" :sort-method="col.sortMethod" :render-header="col.renderHeader" :selectable="col.selectable"></el-table-column>
#>     </el-table>
#>   </div>
#>   <div id="el_table_6856648f-a864-4420-b496-8af7d011e006" style="width:0px;height:0px;" class="vue html-widget"></div>
#>   <script type="application/json" data-for="el_table_6856648f-a864-4420-b496-8af7d011e006">{"x":{"el":"#el_table_6856648f-a864-4420-b496-8af7d011e006_container","data":{"tableData":[{"Sepal_Length":5.1,"Sepal_Width":3.5,"Petal_Length":1.4,"Petal_Width":0.2,"Species":"setosa"},{"Sepal_Length":4.9,"Sepal_Width":3,"Petal_Length":1.4,"Petal_Width":0.2,"Species":"setosa"},{"Sepal_Length":4.7,"Sepal_Width":3.2,"Petal_Length":1.3,"Petal_Width":0.2,"Species":"setosa"}],"columns":[{"prop":"Sepal_Length","label":"Sepal.Length"},{"prop":"Sepal_Width","label":"Sepal.Width"},{"prop":"Petal_Length","label":"Petal.Length"},{"prop":"Petal_Width","label":"Petal.Width"},{"prop":"Species","label":"Species"}],"border":true,"selection":false,"selected":[],"selectedRows":[],"stripe":null,"size":null,"height":null,"maxHeight":null,"fit":null,"showHeader":null,"highlightCurrentRow":null,"currentRowKey":null,"rowKey":null,"emptyText":null,"defaultExpandAll":null,"expandRowKeys":null,"defaultSort":null,"tooltipEffect":null,"showSummary":null,"sumText":null,"selectOnIndeterminate":null,"indent":null,"lazy":null,"treeProps":null,"rowClassName":null,"rowStyle":null,"cellClassName":null,"cellStyle":null,"headerRowClassName":null,"headerRowStyle":null,"headerCellClassName":null,"headerCellStyle":null,"spanMethod":null,"summaryMethod":null,"load":null},"methods":{"handleSelectionChange":"function(selection) { var self = this; self.selected = selection; self.selectedRows = selection.map(function(r) { return self.tableData.indexOf(r) + 1; }); Shiny.setInputValue('el_table_6856648f-a864-4420-b496-8af7d011e006_selected', self.selected); Shiny.setInputValue('el_table_6856648f-a864-4420-b496-8af7d011e006_selected_rows', self.selectedRows); }"},"mounted":"function() { var self = this; var send = function() { Shiny.setInputValue(\"el_table_6856648f-a864-4420-b496-8af7d011e006_selected\", self.selected); Shiny.setInputValue(\"el_table_6856648f-a864-4420-b496-8af7d011e006_selected_rows\", self.selectedRows); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else { $(document).one('shiny:connected', send); } }"},"evals":["methods.handleSelectionChange","mounted"],"jsHooks":[]}</script>
#> </div>
```
