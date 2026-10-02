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
  addable = FALSE,
  editable = FALSE,
  stretch = FALSE,
  before_leave = NULL,
  session = NULL
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

  closable

  :   Whether this one tab can be closed, when `closable` is off for the
      rest.

  lazy

  :   Render the content only when the tab is first selected. Its
      components do not exist, and report nothing, until then.

- selected:

  Name of the initially selected tab. Defaults to the first.

- type:

  `NULL` for plain tabs, `"card"` or `"border-card"`.

- tab_position:

  `"top"` (default), `"right"`, `"bottom"` or `"left"`.

- closable:

  Show a close button on each tab. Closing removes the tab from the
  page; the server is told through `input$<id>_tab_remove`.

- addable:

  Show a "+" button; clicking it reports `input$<id>_tab_add`, and the
  server adds a tab with
  [`insert_el_tab()`](https://kaipingyang.github.io/shiny.element/reference/insert_el_tab.md).

- editable:

  `closable` and `addable` together.

- stretch:

  Stretch the tabs to fill the available width.

- before_leave:

  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function `function(activeName, oldActiveName)` run before switching
  tabs; return `false`, or a promise that rejects, to stay put.

- session:

  Deprecated. Inside a module, wrap `id` in `ns()`, as for any Shiny
  input; a session given here namespaces `id` once more, with a warning.

## Value

An `htmltools` tag.

## Details

Rendered as plain markup carrying Element's own classes, driven by a
Shiny input binding rather than a Vue instance. That is what lets a tab
hold other components from this package: a Vue instance mounted here
would rebuild the DOM underneath them, leaving them rendered but
disconnected from the server. See `.claude/docs/lessons.md` §1.2.

## Shiny inputs

- `input$<id>` – name of the selected tab, on load and on every change.

- `input$<id>_tab_click` – name of the tab clicked, even if it was
  already selected.

- `input$<id>_tab_remove` – name of a tab just closed.

- `input$<id>_tab_add` – fires when the "+" button is clicked.

- `input$<id>_edit` – either of the last two, as Element's `edit` event:
  a list of `target` (the tab name, or `NULL` for an add) and `action`
  (`"remove"` or `"add"`).

## Examples

``` r
el_tabs("t1", selected = "a", tabs = list(
  list(name = "a", label = "First",  content = shiny::tags$p("One")),
  list(name = "b", label = "Second", content = shiny::tags$p("Two"))
))
#> <div id="t1" class="el-tabs el-tabs--top" data-el-tabs="true" data-position="top" data-carded="false" data-closable="false">
#>   <div class="el-tabs__header is-top">
#>     <div class="el-tabs__nav-wrap is-top">
#>       <div class="el-tabs__nav-scroll">
#>         <div role="tablist" class="el-tabs__nav is-top">
#>           <div class="el-tabs__active-bar is-top"></div>
#>           <div id="t1-tab-a" role="tab" aria-controls="t1-pane-a" aria-selected="true" tabindex="0" class="el-tabs__item is-top is-active" data-el-name="a">First</div>
#>           <div id="t1-tab-b" role="tab" aria-controls="t1-pane-b" tabindex="-1" class="el-tabs__item is-top" data-el-name="b">Second</div>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="el-tabs__content">
#>     <div role="tabpanel" id="t1-pane-a" aria-labelledby="t1-tab-a" class="el-tab-pane" data-el-name="a">
#>       <p>One</p>
#>     </div>
#>     <div role="tabpanel" id="t1-pane-b" aria-labelledby="t1-tab-b" aria-hidden="true" class="el-tab-pane" style="display:none" data-el-name="b">
#>       <p>Two</p>
#>     </div>
#>   </div>
#> </div>

# A tab can hold other components
el_tabs("t2", tabs = list(
  list(name = "data", label = "Data", content = el_table(data = head(iris, 3))),
  list(name = "opts", label = "Options", content = el_switch("live"))
))
#> <div id="t2" class="el-tabs el-tabs--top" data-el-tabs="true" data-position="top" data-carded="false" data-closable="false">
#>   <div class="el-tabs__header is-top">
#>     <div class="el-tabs__nav-wrap is-top">
#>       <div class="el-tabs__nav-scroll">
#>         <div role="tablist" class="el-tabs__nav is-top">
#>           <div class="el-tabs__active-bar is-top"></div>
#>           <div id="t2-tab-data" role="tab" aria-controls="t2-pane-data" aria-selected="true" tabindex="0" class="el-tabs__item is-top is-active" data-el-name="data">Data</div>
#>           <div id="t2-tab-opts" role="tab" aria-controls="t2-pane-opts" tabindex="-1" class="el-tabs__item is-top" data-el-name="opts">Options</div>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="el-tabs__content">
#>     <div role="tabpanel" id="t2-pane-data" aria-labelledby="t2-tab-data" class="el-tab-pane" data-el-name="data">
#>       <div id="el_table_bc1fb3aa-58d2-4148-aa09-3bf31954ad28" data-shiny-vue style="display: contents">
#>         <script type="text/x-template" data-shiny-vue-template><div id="el_table_bc1fb3aa-58d2-4148-aa09-3bf31954ad28_container" style="display: contents">
#>   <el-table :data="tableData" :border="border" style="width: 100%" v-loading="loading" @selection-change="handleSelectionChange" @select="elEmitSelect" @select-all="elEmitSelectAll" @cell-click="elEmitCellClick" @cell-dblclick="elEmitCellDblclick" @cell-mouse-enter="elEmitCellMouseEnter" @cell-mouse-leave="elEmitCellMouseLeave" @row-click="elEmitRowClick" @row-dblclick="elEmitRowDblclick" @row-contextmenu="elEmitRowContextmenu" @header-click="elEmitHeaderClick" @header-contextmenu="elEmitHeaderContextmenu" @header-dragend="elEmitHeaderDragend" @sort-change="elEmitSortChange" @filter-change="elEmitFilterChange" @current-change="elEmitCurrentChange" @expand-change="elEmitExpandChange" :stripe="stripe === null ? undefined : stripe" :size="size === null ? undefined : size" :height="height === null ? undefined : height" :max-height="maxHeight === null ? undefined : maxHeight" :fit="fit === null ? undefined : fit" :show-header="showHeader === null ? undefined : showHeader" :highlight-current-row="highlightCurrentRow === null ? undefined : highlightCurrentRow" :current-row-key="currentRowKey === null ? undefined : currentRowKey" :row-key="rowKey === null ? undefined : rowKey" :empty-text="emptyText === null ? undefined : emptyText" :default-expand-all="defaultExpandAll === null ? undefined : defaultExpandAll" :expand-row-keys="expandRowKeys === null ? undefined : expandRowKeys" :default-sort="defaultSort === null ? undefined : defaultSort" :tooltip-effect="tooltipEffect === null ? undefined : tooltipEffect" :show-summary="showSummary === null ? undefined : showSummary" :sum-text="sumText === null ? undefined : sumText" :select-on-indeterminate="selectOnIndeterminate === null ? undefined : selectOnIndeterminate" :indent="indent === null ? undefined : indent" :lazy="lazy === null ? undefined : lazy" :tree-props="treeProps === null ? undefined : treeProps" :row-class-name="rowClassName === null ? undefined : rowClassName" :row-style="rowStyle === null ? undefined : rowStyle" :cell-class-name="cellClassName === null ? undefined : cellClassName" :cell-style="cellStyle === null ? undefined : cellStyle" :header-row-class-name="headerRowClassName === null ? undefined : headerRowClassName" :header-row-style="headerRowStyle === null ? undefined : headerRowStyle" :header-cell-class-name="headerCellClassName === null ? undefined : headerCellClassName" :header-cell-style="headerCellStyle === null ? undefined : headerCellStyle" :span-method="spanMethod === null ? undefined : spanMethod" :summary-method="summaryMethod === null ? undefined : summaryMethod" :load="load === null ? elLoad : load" :highlight-selection-row="highlightSelectionRow === null ? undefined : highlightSelectionRow">
#>     <el-table-column v-if="selection" type="selection" width="55"></el-table-column>
#>     <el-table-column v-for="col in (columns.length ? columns : autoColumns)" :key="col.prop || col.label" :prop="col.prop" :label="col.label" :width="col.width" :align="col.align" :header-align="col.headerAlign" :class-name="col.className" :label-class-name="col.labelClassName" :column-key="col.columnKey" :min-width="col.minWidth" :fixed="col.fixed" :resizable="col.resizable" :sortable="col.sortable" :sort-by="col.sortBy" :sort-orders="col.sortOrders" :show-overflow-tooltip="col.showOverflowTooltip" :filters="col.filters" :filtered-value="col.filteredValue" :filter-multiple="col.filterMultiple" :filter-placement="col.filterPlacement" :reserve-selection="col.reserveSelection" :index="col.index" :formatter="col.formatter" :filter-method="col.filterMethod" :sort-method="col.sortMethod" :render-header="col.renderHeader" :selectable="col.selectable" :type="col.type">
#>       <template v-slot:header="scope">
#>         <span v-if="col.headerHtml" v-html="col.headerHtml"></span>
#>         <span v-else>{{col.label}}</span>
#>       </template>
#>       <el-table-column v-for="sub in (col.children || [])" :key="sub.prop || sub.label" :prop="sub.prop" :label="sub.label" :width="sub.width" :align="sub.align" :header-align="sub.headerAlign" :class-name="sub.className" :label-class-name="sub.labelClassName" :column-key="sub.columnKey" :min-width="sub.minWidth" :fixed="sub.fixed" :resizable="sub.resizable" :sortable="sub.sortable" :sort-by="sub.sortBy" :sort-orders="sub.sortOrders" :show-overflow-tooltip="sub.showOverflowTooltip" :filters="sub.filters" :filtered-value="sub.filteredValue" :filter-multiple="sub.filterMultiple" :filter-placement="sub.filterPlacement" :reserve-selection="sub.reserveSelection" :index="sub.index" :formatter="sub.formatter" :filter-method="sub.filterMethod" :sort-method="sub.sortMethod" :render-header="sub.renderHeader" :selectable="sub.selectable" :type="sub.type">
#>         <template v-slot:header="scope">
#>           <span v-if="sub.headerHtml" v-html="sub.headerHtml"></span>
#>           <span v-else>{{sub.label}}</span>
#>         </template>
#>         <el-table-column v-for="subx in (sub.children || [])" :key="subx.prop || subx.label" :prop="subx.prop" :label="subx.label" :width="subx.width" :align="subx.align" :header-align="subx.headerAlign" :class-name="subx.className" :label-class-name="subx.labelClassName" :column-key="subx.columnKey" :min-width="subx.minWidth" :fixed="subx.fixed" :resizable="subx.resizable" :sortable="subx.sortable" :sort-by="subx.sortBy" :sort-orders="subx.sortOrders" :show-overflow-tooltip="subx.showOverflowTooltip" :filters="subx.filters" :filtered-value="subx.filteredValue" :filter-multiple="subx.filterMultiple" :filter-placement="subx.filterPlacement" :reserve-selection="subx.reserveSelection" :index="subx.index" :formatter="subx.formatter" :filter-method="subx.filterMethod" :sort-method="subx.sortMethod" :render-header="subx.renderHeader" :selectable="subx.selectable" :type="subx.type">
#>           <template v-slot:header="scope">
#>             <span v-if="subx.headerHtml" v-html="subx.headerHtml"></span>
#>             <span v-else>{{subx.label}}</span>
#>           </template>
#>         </el-table-column>
#>       </el-table-column>
#>     </el-table-column>
#>   </el-table>
#> </div></script>
#>         <script type="application/json" data-shiny-vue-options>{"options":{"data":{"tableData":[{"Sepal_Length":5.1,"Sepal_Width":3.5,"Petal_Length":1.4,"Petal_Width":0.2,"Species":"setosa"},{"Sepal_Length":4.9,"Sepal_Width":3,"Petal_Length":1.4,"Petal_Width":0.2,"Species":"setosa"},{"Sepal_Length":4.7,"Sepal_Width":3.2,"Petal_Length":1.3,"Petal_Width":0.2,"Species":"setosa"}],"columns":[],"autoColumns":[{"prop":"Sepal_Length","label":"Sepal.Length","slot":"none"},{"prop":"Sepal_Width","label":"Sepal.Width","slot":"none"},{"prop":"Petal_Length","label":"Petal.Length","slot":"none"},{"prop":"Petal_Width","label":"Petal.Width","slot":"none"},{"prop":"Species","label":"Species","slot":"none"}],"border":false,"selection":false,"selected":[],"selectedRows":[],"loading":false,"stripe":null,"size":null,"height":null,"maxHeight":null,"fit":null,"showHeader":null,"highlightCurrentRow":null,"currentRowKey":null,"rowKey":null,"emptyText":null,"defaultExpandAll":null,"expandRowKeys":null,"defaultSort":null,"tooltipEffect":null,"showSummary":null,"sumText":null,"selectOnIndeterminate":null,"indent":null,"lazy":null,"treeProps":null,"rowClassName":null,"rowStyle":null,"cellClassName":null,"cellStyle":null,"headerRowClassName":null,"headerRowStyle":null,"headerCellClassName":null,"headerCellStyle":null,"spanMethod":null,"summaryMethod":null,"load":null,"highlightSelectionRow":null},"methods":{"elEmitSelect":"function() { var shape = function(selection, row) { var vm = this; return {rows: (selection || []).map(function(r) { return window.shinyElement.rowIndex(vm, r); }), row_index: window.shinyElement.rowIndex(vm, row)}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('el_table_bc1fb3aa-58d2-4148-aa09-3bf31954ad28', 'select', [v]); }","elEmitSelectAll":"function() { var shape = function(selection) { var vm = this; return {rows: (selection || []).map(function(r) { return window.shinyElement.rowIndex(vm, r); })}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('el_table_bc1fb3aa-58d2-4148-aa09-3bf31954ad28', 'select_all', [v]); }","elEmitCellClick":"function() { var shape = function(row, column) { var prop = window.shinyElement.colProp(column); return {row_index: window.shinyElement.rowIndex(this, row), row: row, column: prop, value: row[prop]}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('el_table_bc1fb3aa-58d2-4148-aa09-3bf31954ad28', 'cell_click', [v]); }","elEmitCellDblclick":"function() { var shape = function(row, column) { var prop = window.shinyElement.colProp(column); return {row_index: window.shinyElement.rowIndex(this, row), row: row, column: prop, value: row[prop]}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('el_table_bc1fb3aa-58d2-4148-aa09-3bf31954ad28', 'cell_dblclick', [v]); }","elEmitCellMouseEnter":"function() { var shape = function(row, column) { var prop = window.shinyElement.colProp(column); return {row_index: window.shinyElement.rowIndex(this, row), row: row, column: prop, value: row[prop]}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('el_table_bc1fb3aa-58d2-4148-aa09-3bf31954ad28', 'cell_mouse_enter', [v]); }","elEmitCellMouseLeave":"function() { var shape = function(row, column) { var prop = window.shinyElement.colProp(column); return {row_index: window.shinyElement.rowIndex(this, row), row: row, column: prop, value: row[prop]}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('el_table_bc1fb3aa-58d2-4148-aa09-3bf31954ad28', 'cell_mouse_leave', [v]); }","elEmitRowClick":"function() { var shape = function(row, column) { return {row_index: window.shinyElement.rowIndex(this, row), row: row, column: window.shinyElement.colProp(column)}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('el_table_bc1fb3aa-58d2-4148-aa09-3bf31954ad28', 'row_click', [v]); }","elEmitRowDblclick":"function() { var shape = function(row, column) { return {row_index: window.shinyElement.rowIndex(this, row), row: row, column: window.shinyElement.colProp(column)}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('el_table_bc1fb3aa-58d2-4148-aa09-3bf31954ad28', 'row_dblclick', [v]); }","elEmitRowContextmenu":"function() { var shape = function(row, column) { return {row_index: window.shinyElement.rowIndex(this, row), row: row, column: window.shinyElement.colProp(column)}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('el_table_bc1fb3aa-58d2-4148-aa09-3bf31954ad28', 'row_contextmenu', [v]); }","elEmitHeaderClick":"function() { var shape = function(column) { return {column: window.shinyElement.colProp(column), label: column.label}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('el_table_bc1fb3aa-58d2-4148-aa09-3bf31954ad28', 'header_click', [v]); }","elEmitHeaderContextmenu":"function() { var shape = function(column) { return {column: window.shinyElement.colProp(column), label: column.label}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('el_table_bc1fb3aa-58d2-4148-aa09-3bf31954ad28', 'header_contextmenu', [v]); }","elEmitHeaderDragend":"function() { var shape = function(newWidth, oldWidth, column) { return {column: window.shinyElement.colProp(column), width: newWidth, previous_width: oldWidth}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('el_table_bc1fb3aa-58d2-4148-aa09-3bf31954ad28', 'header_dragend', [v]); }","elEmitSortChange":"function() { var shape = function(s) { return {column: s.prop, order: s.order}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('el_table_bc1fb3aa-58d2-4148-aa09-3bf31954ad28', 'sort_change', [v]); }","elEmitFilterChange":"function() { window.shinyVue.emit('el_table_bc1fb3aa-58d2-4148-aa09-3bf31954ad28', 'filter_change', arguments); }","elEmitCurrentChange":"function() { var shape = function(row, old) { return {row_index: window.shinyElement.rowIndex(this, row), row: row, previous_index: window.shinyElement.rowIndex(this, old)}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('el_table_bc1fb3aa-58d2-4148-aa09-3bf31954ad28', 'current_change', [v]); }","elEmitExpandChange":"function() { var shape = function(row, expanded) { var vm = this; return {row_index: window.shinyElement.rowIndex(this, row), expanded: Array.isArray(expanded) ? expanded.map(function(r) { return window.shinyElement.rowIndex(vm, r); }) : expanded}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('el_table_bc1fb3aa-58d2-4148-aa09-3bf31954ad28', 'expand_change', [v]); }","elLoad":"function(row, treeNode, resolve) {\n  var key = this.rowKey && typeof this.rowKey === 'string' ? row[this.rowKey] : null;\n  window.shinyVue.ask('el_table_bc1fb3aa-58d2-4148-aa09-3bf31954ad28_load', {key: key, row: row, level: treeNode ? treeNode.level : null}, this)\n    .then(function(children) { resolve(children || []); });\n}","rowAction":"function(name, scope) { var se = window.shinyElement; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('el_table_bc1fb3aa-58d2-4148-aa09-3bf31954ad28_' + name, {row_index: se.rowIndex(this, scope.row), row: window.shinyVue.plain(scope.row)}, {priority: 'event'}); }","handleSelectionChange":"function(selection) { var self = this; self.selected = selection; self.selectedRows = selection.map(function(r) { return self.tableData.indexOf(r) + 1; }); window.Shiny && Shiny.setInputValue && Shiny.setInputValue('el_table_bc1fb3aa-58d2-4148-aa09-3bf31954ad28_selected', self.selected); window.Shiny && Shiny.setInputValue && Shiny.setInputValue('el_table_bc1fb3aa-58d2-4148-aa09-3bf31954ad28_selected_rows', self.selectedRows); }"},"mounted":"function() { var self = this; var send = function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"el_table_bc1fb3aa-58d2-4148-aa09-3bf31954ad28_selected\", self.selected); window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"el_table_bc1fb3aa-58d2-4148-aa09-3bf31954ad28_selected_rows\", self.selectedRows); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } var prev = self._elReport; self._elReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"input":null,"rate":null,"type":null,"evals":["options.methods.elEmitSelect","options.methods.elEmitSelectAll","options.methods.elEmitCellClick","options.methods.elEmitCellDblclick","options.methods.elEmitCellMouseEnter","options.methods.elEmitCellMouseLeave","options.methods.elEmitRowClick","options.methods.elEmitRowDblclick","options.methods.elEmitRowContextmenu","options.methods.elEmitHeaderClick","options.methods.elEmitHeaderContextmenu","options.methods.elEmitHeaderDragend","options.methods.elEmitSortChange","options.methods.elEmitFilterChange","options.methods.elEmitCurrentChange","options.methods.elEmitExpandChange","options.methods.elLoad","options.methods.rowAction","options.methods.handleSelectionChange","options.mounted"]}</script>
#>       </div>
#>     </div>
#>     <div role="tabpanel" id="t2-pane-opts" aria-labelledby="t2-tab-opts" aria-hidden="true" class="el-tab-pane" style="display:none" data-el-name="opts">
#>       <div id="live" data-shiny-vue style="display: contents">
#>         <script type="text/x-template" data-shiny-vue-template><div id="live_container" style="display: contents">
#>   <el-switch v-model="value" :disabled="disabled" :active-text="activeText" :inactive-text="inactiveText" :active-color="activeColor" :inactive-color="inactiveColor" :active-value="activeValue" :inactive-value="inactiveValue" @change="handleChange" :width="width === null ? undefined : width" :active-icon-class="activeIconClass === null ? undefined : activeIconClass" :inactive-icon-class="inactiveIconClass === null ? undefined : inactiveIconClass" :name="name === null ? undefined : name" :validate-event="validateEvent === null ? undefined : validateEvent"></el-switch>
#> </div></script>
#>         <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":false,"disabled":false,"activeText":"","inactiveText":"","activeColor":"","inactiveColor":"","activeValue":true,"inactiveValue":false,"width":null,"activeIconClass":null,"inactiveIconClass":null,"name":null,"validateEvent":null},"methods":{"handleChange":"function(value) { }"}},"input":"value","rate":null,"type":null,"evals":["options.methods.handleChange"]}</script>
#>       </div>
#>     </div>
#>   </div>
#> </div>
```
