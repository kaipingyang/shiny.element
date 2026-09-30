# Element UI Tabs

A tabbed panel.

## Usage

``` r
el_tabs(
  id = NULL,
  tabs = list(),
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

  A list of tabs. Each is a named list with:

  name

  :   Unique tab identifier (string). Required.

  label

  :   Tab label. Required.

  content

  :   Tab body. Any tag or tagList, including this package's own
      components.

  disabled

  :   Whether the tab can be selected. Default `FALSE`.

- selected:

  Name of the initially selected tab. Defaults to the first.

- type:

  `NULL` for plain tabs, `"card"` or `"border-card"`.

- tab_position:

  `"top"` (default), `"right"`, `"bottom"` or `"left"`.

- closable:

  Show a close button on each tab. Closing removes the tab from the
  page; the server is told through `input$<id>_closed`.

- stretch:

  Stretch the tabs to fill the available width.

- session:

  Shiny session for module support.

## Value

An `htmltools` tag.

## Details

Rendered as plain markup carrying Element's own classes, driven by a
Shiny input binding rather than a Vue instance. That is what lets a tab
hold other components from this package: a Vue instance mounted here
would rebuild the DOM underneath them, leaving them rendered but
disconnected from the server. See `.claude/docs/lessons.md` §1.2.

## Shiny inputs

`input$<id>` — name of the selected tab, reported on load and on every
change. `input$<id>_closed` — name of the most recently closed tab, when
`closable = TRUE`.

## Examples

``` r
el_tabs("t1", selected = "a", tabs = list(
  list(name = "a", label = "First",  content = shiny::tags$p("One")),
  list(name = "b", label = "Second", content = shiny::tags$p("Two"))
))
#> <div id="t1" class="el-tabs el-tabs--top" data-el-tabs="true" data-position="top" data-carded="false">
#>   <div class="el-tabs__header is-top">
#>     <div class="el-tabs__nav-wrap is-top">
#>       <div class="el-tabs__nav-scroll">
#>         <div role="tablist" class="el-tabs__nav is-top">
#>           <div class="el-tabs__active-bar is-top"></div>
#>           <div id="t1-tab-a" role="tab" aria-selected="true" tabindex="0" class="el-tabs__item is-top is-active" data-el-name="a">First</div>
#>           <div id="t1-tab-b" role="tab" tabindex="-1" class="el-tabs__item is-top" data-el-name="b">Second</div>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="el-tabs__content">
#>     <div role="tabpanel" id="t1-pane-a" class="el-tab-pane" data-el-name="a">
#>       <p>One</p>
#>     </div>
#>     <div role="tabpanel" id="t1-pane-b" class="el-tab-pane" style="display:none" data-el-name="b">
#>       <p>Two</p>
#>     </div>
#>   </div>
#> </div>

# A tab can hold other components
el_tabs("t2", tabs = list(
  list(name = "data", label = "Data", content = el_table(data = head(iris, 3))),
  list(name = "opts", label = "Options", content = el_switch("live"))
))
#> <div id="t2" class="el-tabs el-tabs--top" data-el-tabs="true" data-position="top" data-carded="false">
#>   <div class="el-tabs__header is-top">
#>     <div class="el-tabs__nav-wrap is-top">
#>       <div class="el-tabs__nav-scroll">
#>         <div role="tablist" class="el-tabs__nav is-top">
#>           <div class="el-tabs__active-bar is-top"></div>
#>           <div id="t2-tab-data" role="tab" aria-selected="true" tabindex="0" class="el-tabs__item is-top is-active" data-el-name="data">Data</div>
#>           <div id="t2-tab-opts" role="tab" tabindex="-1" class="el-tabs__item is-top" data-el-name="opts">Options</div>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="el-tabs__content">
#>     <div role="tabpanel" id="t2-pane-data" class="el-tab-pane" data-el-name="data">
#>       <div id="el_table_80d22795-7923-4847-b6dd-64b56bc1dcf5_container" style="display: contents">
#>         <el-table :data="tableData" :border="border" style="width: 100%" @selection-change="handleSelectionChange" @select="elEmitSelect" @select-all="elEmitSelectAll" @cell-click="elEmitCellClick" @cell-dblclick="elEmitCellDblclick" @cell-mouse-enter="elEmitCellMouseEnter" @cell-mouse-leave="elEmitCellMouseLeave" @row-click="elEmitRowClick" @row-dblclick="elEmitRowDblclick" @row-contextmenu="elEmitRowContextmenu" @header-click="elEmitHeaderClick" @header-contextmenu="elEmitHeaderContextmenu" @header-dragend="elEmitHeaderDragend" @sort-change="elEmitSortChange" @filter-change="elEmitFilterChange" @current-change="elEmitCurrentChange" @expand-change="elEmitExpandChange" :stripe="stripe === null ? undefined : stripe" :size="size === null ? undefined : size" :height="height === null ? undefined : height" :max-height="maxHeight === null ? undefined : maxHeight" :fit="fit === null ? undefined : fit" :show-header="showHeader === null ? undefined : showHeader" :highlight-current-row="highlightCurrentRow === null ? undefined : highlightCurrentRow" :current-row-key="currentRowKey === null ? undefined : currentRowKey" :row-key="rowKey === null ? undefined : rowKey" :empty-text="emptyText === null ? undefined : emptyText" :default-expand-all="defaultExpandAll === null ? undefined : defaultExpandAll" :expand-row-keys="expandRowKeys === null ? undefined : expandRowKeys" :default-sort="defaultSort === null ? undefined : defaultSort" :tooltip-effect="tooltipEffect === null ? undefined : tooltipEffect" :show-summary="showSummary === null ? undefined : showSummary" :sum-text="sumText === null ? undefined : sumText" :select-on-indeterminate="selectOnIndeterminate === null ? undefined : selectOnIndeterminate" :indent="indent === null ? undefined : indent" :lazy="lazy === null ? undefined : lazy" :tree-props="treeProps === null ? undefined : treeProps" :row-class-name="rowClassName === null ? undefined : rowClassName" :row-style="rowStyle === null ? undefined : rowStyle" :cell-class-name="cellClassName === null ? undefined : cellClassName" :cell-style="cellStyle === null ? undefined : cellStyle" :header-row-class-name="headerRowClassName === null ? undefined : headerRowClassName" :header-row-style="headerRowStyle === null ? undefined : headerRowStyle" :header-cell-class-name="headerCellClassName === null ? undefined : headerCellClassName" :header-cell-style="headerCellStyle === null ? undefined : headerCellStyle" :span-method="spanMethod === null ? undefined : spanMethod" :summary-method="summaryMethod === null ? undefined : summaryMethod" :load="load === null ? undefined : load" :highlight-selection-row="highlightSelectionRow === null ? undefined : highlightSelectionRow">
#>           <el-table-column v-if="selection" type="selection" width="55"></el-table-column>
#>           <el-table-column v-for="col in columns" :key="col.prop" :prop="col.prop" :label="col.label" :width="col.width" :align="col.align" :header-align="col.headerAlign" :class-name="col.className" :label-class-name="col.labelClassName" :column-key="col.columnKey" :min-width="col.minWidth" :fixed="col.fixed" :resizable="col.resizable" :sortable="col.sortable" :sort-by="col.sortBy" :sort-orders="col.sortOrders" :show-overflow-tooltip="col.showOverflowTooltip" :filters="col.filters" :filtered-value="col.filteredValue" :filter-multiple="col.filterMultiple" :filter-placement="col.filterPlacement" :reserve-selection="col.reserveSelection" :index="col.index" :formatter="col.formatter" :filter-method="col.filterMethod" :sort-method="col.sortMethod" :render-header="col.renderHeader" :selectable="col.selectable">
#>             <template slot="header" slot-scope="scope">
#>               <span v-if="col.headerHtml" v-html="col.headerHtml"></span>
#>               <span v-else>{{col.label}}</span>
#>             </template>
#>           </el-table-column>
#>         </el-table>
#>       </div>
#>       <div id="el_table_80d22795-7923-4847-b6dd-64b56bc1dcf5" style="width:0px;height:0px;" class="vue html-widget"></div>
#>       <script type="application/json" data-for="el_table_80d22795-7923-4847-b6dd-64b56bc1dcf5">{"x":{"el":"#el_table_80d22795-7923-4847-b6dd-64b56bc1dcf5_container","data":{"tableData":[{"Sepal_Length":5.1,"Sepal_Width":3.5,"Petal_Length":1.4,"Petal_Width":0.2,"Species":"setosa"},{"Sepal_Length":4.9,"Sepal_Width":3,"Petal_Length":1.4,"Petal_Width":0.2,"Species":"setosa"},{"Sepal_Length":4.7,"Sepal_Width":3.2,"Petal_Length":1.3,"Petal_Width":0.2,"Species":"setosa"}],"columns":[{"prop":"Sepal_Length","label":"Sepal.Length"},{"prop":"Sepal_Width","label":"Sepal.Width"},{"prop":"Petal_Length","label":"Petal.Length"},{"prop":"Petal_Width","label":"Petal.Width"},{"prop":"Species","label":"Species"}],"border":true,"selection":false,"selected":[],"selectedRows":[],"stripe":null,"size":null,"height":null,"maxHeight":null,"fit":null,"showHeader":null,"highlightCurrentRow":null,"currentRowKey":null,"rowKey":null,"emptyText":null,"defaultExpandAll":null,"expandRowKeys":null,"defaultSort":null,"tooltipEffect":null,"showSummary":null,"sumText":null,"selectOnIndeterminate":null,"indent":null,"lazy":null,"treeProps":null,"rowClassName":null,"rowStyle":null,"cellClassName":null,"cellStyle":null,"headerRowClassName":null,"headerRowStyle":null,"headerCellClassName":null,"headerCellStyle":null,"spanMethod":null,"summaryMethod":null,"load":null,"highlightSelectionRow":null},"methods":{"elEmitSelect":"function() { var shape = function(selection, row) { var vm = this; return {rows: (selection || []).map(function(r) { return window.shinyElement.rowIndex(vm, r); }), row_index: window.shinyElement.rowIndex(vm, row)}; }; window.shinyElement.emit('el_table_80d22795-7923-4847-b6dd-64b56bc1dcf5', 'select', [shape.apply(this, arguments)]); }","elEmitSelectAll":"function() { var shape = function(selection) { var vm = this; return {rows: (selection || []).map(function(r) { return window.shinyElement.rowIndex(vm, r); })}; }; window.shinyElement.emit('el_table_80d22795-7923-4847-b6dd-64b56bc1dcf5', 'select_all', [shape.apply(this, arguments)]); }","elEmitCellClick":"function() { var shape = function(row, column) { var prop = window.shinyElement.colProp(column); return {row_index: window.shinyElement.rowIndex(this, row), row: row, column: prop, value: row[prop]}; }; window.shinyElement.emit('el_table_80d22795-7923-4847-b6dd-64b56bc1dcf5', 'cell_click', [shape.apply(this, arguments)]); }","elEmitCellDblclick":"function() { var shape = function(row, column) { var prop = window.shinyElement.colProp(column); return {row_index: window.shinyElement.rowIndex(this, row), row: row, column: prop, value: row[prop]}; }; window.shinyElement.emit('el_table_80d22795-7923-4847-b6dd-64b56bc1dcf5', 'cell_dblclick', [shape.apply(this, arguments)]); }","elEmitCellMouseEnter":"function() { var shape = function(row, column) { var prop = window.shinyElement.colProp(column); return {row_index: window.shinyElement.rowIndex(this, row), row: row, column: prop, value: row[prop]}; }; window.shinyElement.emit('el_table_80d22795-7923-4847-b6dd-64b56bc1dcf5', 'cell_mouse_enter', [shape.apply(this, arguments)]); }","elEmitCellMouseLeave":"function() { var shape = function(row, column) { var prop = window.shinyElement.colProp(column); return {row_index: window.shinyElement.rowIndex(this, row), row: row, column: prop, value: row[prop]}; }; window.shinyElement.emit('el_table_80d22795-7923-4847-b6dd-64b56bc1dcf5', 'cell_mouse_leave', [shape.apply(this, arguments)]); }","elEmitRowClick":"function() { var shape = function(row, column) { return {row_index: window.shinyElement.rowIndex(this, row), row: row, column: window.shinyElement.colProp(column)}; }; window.shinyElement.emit('el_table_80d22795-7923-4847-b6dd-64b56bc1dcf5', 'row_click', [shape.apply(this, arguments)]); }","elEmitRowDblclick":"function() { var shape = function(row, column) { return {row_index: window.shinyElement.rowIndex(this, row), row: row, column: window.shinyElement.colProp(column)}; }; window.shinyElement.emit('el_table_80d22795-7923-4847-b6dd-64b56bc1dcf5', 'row_dblclick', [shape.apply(this, arguments)]); }","elEmitRowContextmenu":"function() { var shape = function(row, column) { return {row_index: window.shinyElement.rowIndex(this, row), row: row, column: window.shinyElement.colProp(column)}; }; window.shinyElement.emit('el_table_80d22795-7923-4847-b6dd-64b56bc1dcf5', 'row_contextmenu', [shape.apply(this, arguments)]); }","elEmitHeaderClick":"function() { var shape = function(column) { return {column: window.shinyElement.colProp(column), label: column.label}; }; window.shinyElement.emit('el_table_80d22795-7923-4847-b6dd-64b56bc1dcf5', 'header_click', [shape.apply(this, arguments)]); }","elEmitHeaderContextmenu":"function() { var shape = function(column) { return {column: window.shinyElement.colProp(column), label: column.label}; }; window.shinyElement.emit('el_table_80d22795-7923-4847-b6dd-64b56bc1dcf5', 'header_contextmenu', [shape.apply(this, arguments)]); }","elEmitHeaderDragend":"function() { var shape = function(newWidth, oldWidth, column) { return {column: window.shinyElement.colProp(column), width: newWidth, previous_width: oldWidth}; }; window.shinyElement.emit('el_table_80d22795-7923-4847-b6dd-64b56bc1dcf5', 'header_dragend', [shape.apply(this, arguments)]); }","elEmitSortChange":"function() { var shape = function(s) { return {column: s.prop, order: s.order}; }; window.shinyElement.emit('el_table_80d22795-7923-4847-b6dd-64b56bc1dcf5', 'sort_change', [shape.apply(this, arguments)]); }","elEmitFilterChange":"function() { window.shinyElement.emit('el_table_80d22795-7923-4847-b6dd-64b56bc1dcf5', 'filter_change', arguments); }","elEmitCurrentChange":"function() { var shape = function(row, old) { return {row_index: window.shinyElement.rowIndex(this, row), row: row, previous_index: window.shinyElement.rowIndex(this, old)}; }; window.shinyElement.emit('el_table_80d22795-7923-4847-b6dd-64b56bc1dcf5', 'current_change', [shape.apply(this, arguments)]); }","elEmitExpandChange":"function() { var shape = function(row, expanded) { var vm = this; return {row_index: window.shinyElement.rowIndex(this, row), expanded: Array.isArray(expanded) ? expanded.map(function(r) { return window.shinyElement.rowIndex(vm, r); }) : expanded}; }; window.shinyElement.emit('el_table_80d22795-7923-4847-b6dd-64b56bc1dcf5', 'expand_change', [shape.apply(this, arguments)]); }","handleSelectionChange":"function(selection) { var self = this; self.selected = selection; self.selectedRows = selection.map(function(r) { return self.tableData.indexOf(r) + 1; }); Shiny.setInputValue('el_table_80d22795-7923-4847-b6dd-64b56bc1dcf5_selected', self.selected); Shiny.setInputValue('el_table_80d22795-7923-4847-b6dd-64b56bc1dcf5_selected_rows', self.selectedRows); }"},"mounted":"function() { var self = this; var send = function() { Shiny.setInputValue(\"el_table_80d22795-7923-4847-b6dd-64b56bc1dcf5_selected\", self.selected); Shiny.setInputValue(\"el_table_80d22795-7923-4847-b6dd-64b56bc1dcf5_selected_rows\", self.selectedRows); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else { $(document).one('shiny:connected', send); } }"},"evals":["methods.elEmitSelect","methods.elEmitSelectAll","methods.elEmitCellClick","methods.elEmitCellDblclick","methods.elEmitCellMouseEnter","methods.elEmitCellMouseLeave","methods.elEmitRowClick","methods.elEmitRowDblclick","methods.elEmitRowContextmenu","methods.elEmitHeaderClick","methods.elEmitHeaderContextmenu","methods.elEmitHeaderDragend","methods.elEmitSortChange","methods.elEmitFilterChange","methods.elEmitCurrentChange","methods.elEmitExpandChange","methods.handleSelectionChange","mounted"],"jsHooks":[]}</script>
#>     </div>
#>     <div role="tabpanel" id="t2-pane-opts" class="el-tab-pane" style="display:none" data-el-name="opts">
#>       <div id="live_container" style="display: contents">
#>         <el-switch v-model="value" :disabled="disabled" :active-text="activeText" :inactive-text="inactiveText" :active-color="activeColor" :inactive-color="inactiveColor" :active-value="activeValue" :inactive-value="inactiveValue" @change="handleChange" :width="width === null ? undefined : width" :active-icon-class="activeIconClass === null ? undefined : activeIconClass" :inactive-icon-class="inactiveIconClass === null ? undefined : inactiveIconClass" :name="name === null ? undefined : name" :validate-event="validateEvent === null ? undefined : validateEvent"></el-switch>
#>       </div>
#>       <div id="live" style="width:0px;height:0px;" class="vue html-widget"></div>
#>       <script type="application/json" data-for="live">{"x":{"el":"#live_container","data":{"value":false,"disabled":false,"activeText":"","inactiveText":"","activeColor":"","inactiveColor":"","activeValue":true,"inactiveValue":false,"width":null,"activeIconClass":null,"inactiveIconClass":null,"name":null,"validateEvent":null},"methods":{"handleChange":"function(value) { Shiny.setInputValue('live', value); }"},"mounted":"function() { var self = this; var send = function() { Shiny.setInputValue(\"live\", self.value); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else { $(document).one('shiny:connected', send); } }"},"evals":["methods.handleChange","mounted"],"jsHooks":[]}</script>
#>     </div>
#>   </div>
#> </div>
```
