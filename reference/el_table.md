# Element UI Table Component

Create a table widget for Shiny using Element UI.

## Usage

``` r
el_table(
  id = NULL,
  data = list(),
  columns = list(),
  selection = FALSE,
  rownames = NULL,
  border = FALSE,
  stripe = NULL,
  size = NULL,
  height = NULL,
  max_height = NULL,
  fit = NULL,
  show_header = NULL,
  highlight_current_row = NULL,
  current_row_key = NULL,
  row_key = NULL,
  empty_text = NULL,
  default_expand_all = NULL,
  expand_row_keys = NULL,
  default_sort = NULL,
  tooltip_effect = NULL,
  show_summary = NULL,
  sum_text = NULL,
  select_on_indeterminate = NULL,
  indent = NULL,
  lazy = NULL,
  tree_props = NULL,
  row_class_name = NULL,
  row_style = NULL,
  cell_class_name = NULL,
  cell_style = NULL,
  header_row_class_name = NULL,
  header_row_style = NULL,
  header_cell_class_name = NULL,
  header_cell_style = NULL,
  span_method = NULL,
  summary_method = NULL,
  load = NULL,
  width = NULL,
  slots = NULL,
  highlight_selection_row = NULL,
  loading = FALSE,
  session = NULL
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
  from `data` when omitted. Beyond Element's column attributes, a column
  may carry:

  - `type` – `"index"` for row numbers, `"expand"` for a row that opens
    to show its `cell`, or `"selection"`.

  - `cell` – markup for each cell, rendered once per row. `scope.row`,
    `scope.column` and `scope.$index` are in reach, and raw Element tags
    (`el$tag()`, `el$button()`) work:
    `el$tag(":type" = "scope.row.ok ? 'success' : 'danger'", "{{ scope.row.status }}")`.
    A column without a `prop` – a column of buttons – is fine. See "Row
    actions" below.

  - `header_html` – markup for the header cell, inserted unescaped, so
    pass only what you control.

- selection:

  Enable row selection

- rownames:

  Whether to show a data.frame's row names as the first column. `NULL`
  (the default) shows them when they carry something – `mtcars`' car
  names – and leaves out automatic ones, which only count rows.

- border:

  Draw vertical borders between columns and a frame around the table.
  Default `FALSE`, as in Element.

- stripe:

  Whether rows alternate background colour.

- size:

  Row density: `"medium"`, `"small"` or `"mini"`.

- height:

  Table height. Fixes the header and scrolls the body.

- max_height:

  Maximum table height, beyond which the body scrolls.

- fit:

  Whether column widths stretch to fill the table. Default `TRUE`.

- show_header:

  Whether the header row is shown. Default `TRUE`.

- highlight_current_row:

  Whether the clicked row stays highlighted; pairs with
  `input$<id>_current`.

- current_row_key:

  Key of the row highlighted at start. Needs `row_key`.

- row_key:

  Column whose value identifies a row. Needed for tree data and reserved
  selection.

- empty_text:

  Text shown when there are no rows. Default `"No Data"`.

- default_expand_all:

  Whether expandable rows start expanded.

- expand_row_keys:

  Keys of the rows that start expanded. Needs `row_key`.

- default_sort:

  Initial sort, as `list(prop =, order =)`.

- tooltip_effect:

  Theme of overflow tooltips: `"dark"` (default) or `"light"`.

- show_summary:

  Whether to add a summary row at the bottom.

- sum_text:

  Label of the summary row's first cell. Default `"Sum"`.

- select_on_indeterminate:

  What the header checkbox does when only some rows are selected.
  Default `TRUE`.

- indent:

  Horizontal indent between tree levels, in pixels. Default `16`.

- lazy:

  Whether child rows of tree data are loaded on demand.

- tree_props:

  Field names for tree data, as `list(children =, hasChildren =)`.

- row_class_name:

  Class name for every row, or a JS function returning one.

- row_style:

  Inline style for every row, or a JS function returning one.

- cell_class_name:

  Class name for every cell, or a JS function returning one.

- cell_style:

  Inline style for every cell, or a JS function returning one.

- header_row_class_name:

  Class name for the header row, or a JS function returning one.

- header_row_style:

  Inline style for the header row, or a JS function returning one.

- header_cell_class_name:

  Class name for header cells, or a JS function returning one.

- header_cell_style:

  Inline style for header cells, or a JS function returning one.

- span_method:

  [`htmlwidgets::JS()`](https://rdrr.io/pkg/htmlwidgets/man/JS.html)
  function deciding row/column spans for merged cells.

- summary_method:

  [`htmlwidgets::JS()`](https://rdrr.io/pkg/htmlwidgets/man/JS.html)
  function returning the summary row's cells.

- load:

  [`htmlwidgets::JS()`](https://rdrr.io/pkg/htmlwidgets/man/JS.html)
  function loading child rows lazily. Needs `lazy = TRUE`.

- width:

  Component width, as a CSS unit. Replaces the table's default
  `width: 100%`. For a fixed header use `height` instead.

- slots:

  Named list of Element slot contents, such as
  `list(empty = shiny::tags$b("Nothing yet"))`. A shiny.element
  component given here is absorbed rather than nested. For a scoped
  slot, write the template with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).

- highlight_selection_row:

  Whether rows ticked with `selection = TRUE` are highlighted.

- loading:

  Whether to cover the table with Element's loading mask, as its
  `v-loading` does.
  [`update_el_table()`](https://kaipingyang.github.io/shiny.element/reference/update_el_table.md)
  turns it on and off around slow work.

- session:

  Deprecated. Inside a module, wrap `id` in `ns()`, as for any Shiny
  input; a session given here namespaces `id` once more, with a warning.

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

## Row actions

A button in a `cell` reports back with `rowAction()`:

    list(label = "", cell = el$button(size = "mini",
      "@click" = "rowAction('edit', scope)", "Edit"))

sets `input$<id>_edit` to `list(row_index =, row =)` – the 1-based row
number, to index your own data with, and the row as the table holds it.
It is an event input: clicking the same row twice reports twice.

## Element methods

Callable with
[`el_call()`](https://kaipingyang.github.io/shiny.element/reference/el_call.md):

- `clearFilter()` – Clear filters of the columns whose columnKey are
  passed in. If no params, clear all filters

- `clearSelection()` – Used in multiple selection Table, clear user
  selection

- `clearSort()` – Clear sorting, restore data to the original order

- `doLayout()` – Refresh the layout of Table. When the visibility of
  Table changes, you may need to call this method to get...

- `setCurrentRow()` – Used in single selection Table, set a certain row
  selected. If called without any parameter, it will clear...

- [`sort()`](https://rdrr.io/r/base/sort.html) – Sort Table manually.
  Property prop is used to set sort column, property order is used to
  set sort order

- `toggleAllSelection()` – Used in multiple selection Table, toggle the
  selected state of all rows

- `toggleRowExpansion()` – Used in expandable Table or tree Table,
  toggle if a certain row is expanded. With the second parameter,...

- `toggleRowSelection()` – Used in multiple selection Table, toggle if a
  certain row is selected. With the second parameter, you can...

## Examples

``` r
# A data.frame is enough -- columns are inferred
el_table("iris_preview", data = head(iris, 3))
#> <div id="iris_preview" data-el-vue-host style="display: contents">
#>   <div id="iris_preview_container" data-el-mount style="display: contents">
#>     <el-table :data="tableData" :border="border" style="width: 100%" v-loading="loading" @selection-change="handleSelectionChange" @select="elEmitSelect" @select-all="elEmitSelectAll" @cell-click="elEmitCellClick" @cell-dblclick="elEmitCellDblclick" @cell-mouse-enter="elEmitCellMouseEnter" @cell-mouse-leave="elEmitCellMouseLeave" @row-click="elEmitRowClick" @row-dblclick="elEmitRowDblclick" @row-contextmenu="elEmitRowContextmenu" @header-click="elEmitHeaderClick" @header-contextmenu="elEmitHeaderContextmenu" @header-dragend="elEmitHeaderDragend" @sort-change="elEmitSortChange" @filter-change="elEmitFilterChange" @current-change="elEmitCurrentChange" @expand-change="elEmitExpandChange" :stripe="stripe === null ? undefined : stripe" :size="size === null ? undefined : size" :height="height === null ? undefined : height" :max-height="maxHeight === null ? undefined : maxHeight" :fit="fit === null ? undefined : fit" :show-header="showHeader === null ? undefined : showHeader" :highlight-current-row="highlightCurrentRow === null ? undefined : highlightCurrentRow" :current-row-key="currentRowKey === null ? undefined : currentRowKey" :row-key="rowKey === null ? undefined : rowKey" :empty-text="emptyText === null ? undefined : emptyText" :default-expand-all="defaultExpandAll === null ? undefined : defaultExpandAll" :expand-row-keys="expandRowKeys === null ? undefined : expandRowKeys" :default-sort="defaultSort === null ? undefined : defaultSort" :tooltip-effect="tooltipEffect === null ? undefined : tooltipEffect" :show-summary="showSummary === null ? undefined : showSummary" :sum-text="sumText === null ? undefined : sumText" :select-on-indeterminate="selectOnIndeterminate === null ? undefined : selectOnIndeterminate" :indent="indent === null ? undefined : indent" :lazy="lazy === null ? undefined : lazy" :tree-props="treeProps === null ? undefined : treeProps" :row-class-name="rowClassName === null ? undefined : rowClassName" :row-style="rowStyle === null ? undefined : rowStyle" :cell-class-name="cellClassName === null ? undefined : cellClassName" :cell-style="cellStyle === null ? undefined : cellStyle" :header-row-class-name="headerRowClassName === null ? undefined : headerRowClassName" :header-row-style="headerRowStyle === null ? undefined : headerRowStyle" :header-cell-class-name="headerCellClassName === null ? undefined : headerCellClassName" :header-cell-style="headerCellStyle === null ? undefined : headerCellStyle" :span-method="spanMethod === null ? undefined : spanMethod" :summary-method="summaryMethod === null ? undefined : summaryMethod" :load="load === null ? undefined : load" :highlight-selection-row="highlightSelectionRow === null ? undefined : highlightSelectionRow">
#>       <el-table-column v-if="selection" type="selection" width="55"></el-table-column>
#>       <el-table-column v-for="col in (columns.length ? columns : autoColumns)" :key="col.prop" :prop="col.prop" :label="col.label" :width="col.width" :align="col.align" :header-align="col.headerAlign" :class-name="col.className" :label-class-name="col.labelClassName" :column-key="col.columnKey" :min-width="col.minWidth" :fixed="col.fixed" :resizable="col.resizable" :sortable="col.sortable" :sort-by="col.sortBy" :sort-orders="col.sortOrders" :show-overflow-tooltip="col.showOverflowTooltip" :filters="col.filters" :filtered-value="col.filteredValue" :filter-multiple="col.filterMultiple" :filter-placement="col.filterPlacement" :reserve-selection="col.reserveSelection" :index="col.index" :formatter="col.formatter" :filter-method="col.filterMethod" :sort-method="col.sortMethod" :render-header="col.renderHeader" :selectable="col.selectable" :type="col.type">
#>         <template v-slot:header="scope">
#>           <span v-if="col.headerHtml" v-html="col.headerHtml"></span>
#>           <span v-else>{{col.label}}</span>
#>         </template>
#>       </el-table-column>
#>     </el-table>
#>   </div>
#>   <script type="application/json" data-el-vue>{"options":{"data":{"tableData":[{"Sepal_Length":5.1,"Sepal_Width":3.5,"Petal_Length":1.4,"Petal_Width":0.2,"Species":"setosa"},{"Sepal_Length":4.9,"Sepal_Width":3,"Petal_Length":1.4,"Petal_Width":0.2,"Species":"setosa"},{"Sepal_Length":4.7,"Sepal_Width":3.2,"Petal_Length":1.3,"Petal_Width":0.2,"Species":"setosa"}],"columns":[],"autoColumns":[{"prop":"Sepal_Length","label":"Sepal.Length","slot":"none"},{"prop":"Sepal_Width","label":"Sepal.Width","slot":"none"},{"prop":"Petal_Length","label":"Petal.Length","slot":"none"},{"prop":"Petal_Width","label":"Petal.Width","slot":"none"},{"prop":"Species","label":"Species","slot":"none"}],"border":false,"selection":false,"selected":[],"selectedRows":[],"loading":false,"stripe":null,"size":null,"height":null,"maxHeight":null,"fit":null,"showHeader":null,"highlightCurrentRow":null,"currentRowKey":null,"rowKey":null,"emptyText":null,"defaultExpandAll":null,"expandRowKeys":null,"defaultSort":null,"tooltipEffect":null,"showSummary":null,"sumText":null,"selectOnIndeterminate":null,"indent":null,"lazy":null,"treeProps":null,"rowClassName":null,"rowStyle":null,"cellClassName":null,"cellStyle":null,"headerRowClassName":null,"headerRowStyle":null,"headerCellClassName":null,"headerCellStyle":null,"spanMethod":null,"summaryMethod":null,"load":null,"highlightSelectionRow":null},"methods":{"elEmitSelect":"function() { var shape = function(selection, row) { var vm = this; return {rows: (selection || []).map(function(r) { return window.shinyElement.rowIndex(vm, r); }), row_index: window.shinyElement.rowIndex(vm, row)}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyElement.emit('iris_preview', 'select', [v]); }","elEmitSelectAll":"function() { var shape = function(selection) { var vm = this; return {rows: (selection || []).map(function(r) { return window.shinyElement.rowIndex(vm, r); })}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyElement.emit('iris_preview', 'select_all', [v]); }","elEmitCellClick":"function() { var shape = function(row, column) { var prop = window.shinyElement.colProp(column); return {row_index: window.shinyElement.rowIndex(this, row), row: row, column: prop, value: row[prop]}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyElement.emit('iris_preview', 'cell_click', [v]); }","elEmitCellDblclick":"function() { var shape = function(row, column) { var prop = window.shinyElement.colProp(column); return {row_index: window.shinyElement.rowIndex(this, row), row: row, column: prop, value: row[prop]}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyElement.emit('iris_preview', 'cell_dblclick', [v]); }","elEmitCellMouseEnter":"function() { var shape = function(row, column) { var prop = window.shinyElement.colProp(column); return {row_index: window.shinyElement.rowIndex(this, row), row: row, column: prop, value: row[prop]}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyElement.emit('iris_preview', 'cell_mouse_enter', [v]); }","elEmitCellMouseLeave":"function() { var shape = function(row, column) { var prop = window.shinyElement.colProp(column); return {row_index: window.shinyElement.rowIndex(this, row), row: row, column: prop, value: row[prop]}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyElement.emit('iris_preview', 'cell_mouse_leave', [v]); }","elEmitRowClick":"function() { var shape = function(row, column) { return {row_index: window.shinyElement.rowIndex(this, row), row: row, column: window.shinyElement.colProp(column)}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyElement.emit('iris_preview', 'row_click', [v]); }","elEmitRowDblclick":"function() { var shape = function(row, column) { return {row_index: window.shinyElement.rowIndex(this, row), row: row, column: window.shinyElement.colProp(column)}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyElement.emit('iris_preview', 'row_dblclick', [v]); }","elEmitRowContextmenu":"function() { var shape = function(row, column) { return {row_index: window.shinyElement.rowIndex(this, row), row: row, column: window.shinyElement.colProp(column)}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyElement.emit('iris_preview', 'row_contextmenu', [v]); }","elEmitHeaderClick":"function() { var shape = function(column) { return {column: window.shinyElement.colProp(column), label: column.label}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyElement.emit('iris_preview', 'header_click', [v]); }","elEmitHeaderContextmenu":"function() { var shape = function(column) { return {column: window.shinyElement.colProp(column), label: column.label}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyElement.emit('iris_preview', 'header_contextmenu', [v]); }","elEmitHeaderDragend":"function() { var shape = function(newWidth, oldWidth, column) { return {column: window.shinyElement.colProp(column), width: newWidth, previous_width: oldWidth}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyElement.emit('iris_preview', 'header_dragend', [v]); }","elEmitSortChange":"function() { var shape = function(s) { return {column: s.prop, order: s.order}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyElement.emit('iris_preview', 'sort_change', [v]); }","elEmitFilterChange":"function() { window.shinyElement.emit('iris_preview', 'filter_change', arguments); }","elEmitCurrentChange":"function() { var shape = function(row, old) { return {row_index: window.shinyElement.rowIndex(this, row), row: row, previous_index: window.shinyElement.rowIndex(this, old)}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyElement.emit('iris_preview', 'current_change', [v]); }","elEmitExpandChange":"function() { var shape = function(row, expanded) { var vm = this; return {row_index: window.shinyElement.rowIndex(this, row), expanded: Array.isArray(expanded) ? expanded.map(function(r) { return window.shinyElement.rowIndex(vm, r); }) : expanded}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyElement.emit('iris_preview', 'expand_change', [v]); }","rowAction":"function(name, scope) { var se = window.shinyElement; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('iris_preview_' + name, {row_index: se.rowIndex(this, scope.row), row: se.plain(scope.row)}, {priority: 'event'}); }","handleSelectionChange":"function(selection) { var self = this; self.selected = selection; self.selectedRows = selection.map(function(r) { return self.tableData.indexOf(r) + 1; }); window.Shiny && Shiny.setInputValue && Shiny.setInputValue('iris_preview_selected', self.selected); window.Shiny && Shiny.setInputValue && Shiny.setInputValue('iris_preview_selected_rows', self.selectedRows); }"},"mounted":"function() { var self = this; var send = function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"iris_preview_selected\", self.selected); window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"iris_preview_selected_rows\", self.selectedRows); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } var prev = self._elReport; self._elReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"input":null,"rate":null,"type":null,"evals":["options.methods.elEmitSelect","options.methods.elEmitSelectAll","options.methods.elEmitCellClick","options.methods.elEmitCellDblclick","options.methods.elEmitCellMouseEnter","options.methods.elEmitCellMouseLeave","options.methods.elEmitRowClick","options.methods.elEmitRowDblclick","options.methods.elEmitRowContextmenu","options.methods.elEmitHeaderClick","options.methods.elEmitHeaderContextmenu","options.methods.elEmitHeaderDragend","options.methods.elEmitSortChange","options.methods.elEmitFilterChange","options.methods.elEmitCurrentChange","options.methods.elEmitExpandChange","options.methods.rowAction","options.methods.handleSelectionChange","options.mounted"]}</script>
#> </div>

# Explicit columns
el_table(
  "scores",
  data = data.frame(name = c("A", "B"), value = c(1, 2)),
  columns = list(
    list(prop = "name", label = "Name"),
    list(prop = "value", label = "Value", width = "100")
  )
)
#> <div id="scores" data-el-vue-host style="display: contents">
#>   <div id="scores_container" data-el-mount style="display: contents">
#>     <el-table :data="tableData" :border="border" style="width: 100%" v-loading="loading" @selection-change="handleSelectionChange" @select="elEmitSelect" @select-all="elEmitSelectAll" @cell-click="elEmitCellClick" @cell-dblclick="elEmitCellDblclick" @cell-mouse-enter="elEmitCellMouseEnter" @cell-mouse-leave="elEmitCellMouseLeave" @row-click="elEmitRowClick" @row-dblclick="elEmitRowDblclick" @row-contextmenu="elEmitRowContextmenu" @header-click="elEmitHeaderClick" @header-contextmenu="elEmitHeaderContextmenu" @header-dragend="elEmitHeaderDragend" @sort-change="elEmitSortChange" @filter-change="elEmitFilterChange" @current-change="elEmitCurrentChange" @expand-change="elEmitExpandChange" :stripe="stripe === null ? undefined : stripe" :size="size === null ? undefined : size" :height="height === null ? undefined : height" :max-height="maxHeight === null ? undefined : maxHeight" :fit="fit === null ? undefined : fit" :show-header="showHeader === null ? undefined : showHeader" :highlight-current-row="highlightCurrentRow === null ? undefined : highlightCurrentRow" :current-row-key="currentRowKey === null ? undefined : currentRowKey" :row-key="rowKey === null ? undefined : rowKey" :empty-text="emptyText === null ? undefined : emptyText" :default-expand-all="defaultExpandAll === null ? undefined : defaultExpandAll" :expand-row-keys="expandRowKeys === null ? undefined : expandRowKeys" :default-sort="defaultSort === null ? undefined : defaultSort" :tooltip-effect="tooltipEffect === null ? undefined : tooltipEffect" :show-summary="showSummary === null ? undefined : showSummary" :sum-text="sumText === null ? undefined : sumText" :select-on-indeterminate="selectOnIndeterminate === null ? undefined : selectOnIndeterminate" :indent="indent === null ? undefined : indent" :lazy="lazy === null ? undefined : lazy" :tree-props="treeProps === null ? undefined : treeProps" :row-class-name="rowClassName === null ? undefined : rowClassName" :row-style="rowStyle === null ? undefined : rowStyle" :cell-class-name="cellClassName === null ? undefined : cellClassName" :cell-style="cellStyle === null ? undefined : cellStyle" :header-row-class-name="headerRowClassName === null ? undefined : headerRowClassName" :header-row-style="headerRowStyle === null ? undefined : headerRowStyle" :header-cell-class-name="headerCellClassName === null ? undefined : headerCellClassName" :header-cell-style="headerCellStyle === null ? undefined : headerCellStyle" :span-method="spanMethod === null ? undefined : spanMethod" :summary-method="summaryMethod === null ? undefined : summaryMethod" :load="load === null ? undefined : load" :highlight-selection-row="highlightSelectionRow === null ? undefined : highlightSelectionRow">
#>       <el-table-column v-if="selection" type="selection" width="55"></el-table-column>
#>       <el-table-column v-for="col in (columns.length ? columns : autoColumns)" :key="col.prop" :prop="col.prop" :label="col.label" :width="col.width" :align="col.align" :header-align="col.headerAlign" :class-name="col.className" :label-class-name="col.labelClassName" :column-key="col.columnKey" :min-width="col.minWidth" :fixed="col.fixed" :resizable="col.resizable" :sortable="col.sortable" :sort-by="col.sortBy" :sort-orders="col.sortOrders" :show-overflow-tooltip="col.showOverflowTooltip" :filters="col.filters" :filtered-value="col.filteredValue" :filter-multiple="col.filterMultiple" :filter-placement="col.filterPlacement" :reserve-selection="col.reserveSelection" :index="col.index" :formatter="col.formatter" :filter-method="col.filterMethod" :sort-method="col.sortMethod" :render-header="col.renderHeader" :selectable="col.selectable" :type="col.type">
#>         <template v-slot:header="scope">
#>           <span v-if="col.headerHtml" v-html="col.headerHtml"></span>
#>           <span v-else>{{col.label}}</span>
#>         </template>
#>       </el-table-column>
#>     </el-table>
#>   </div>
#>   <script type="application/json" data-el-vue>{"options":{"data":{"tableData":[{"name":"A","value":1},{"name":"B","value":2}],"columns":[{"prop":"name","label":"Name","slot":"none"},{"prop":"value","label":"Value","width":"100","slot":"none"}],"autoColumns":[{"prop":"name","label":"name","slot":"none"},{"prop":"value","label":"value","slot":"none"}],"border":false,"selection":false,"selected":[],"selectedRows":[],"loading":false,"stripe":null,"size":null,"height":null,"maxHeight":null,"fit":null,"showHeader":null,"highlightCurrentRow":null,"currentRowKey":null,"rowKey":null,"emptyText":null,"defaultExpandAll":null,"expandRowKeys":null,"defaultSort":null,"tooltipEffect":null,"showSummary":null,"sumText":null,"selectOnIndeterminate":null,"indent":null,"lazy":null,"treeProps":null,"rowClassName":null,"rowStyle":null,"cellClassName":null,"cellStyle":null,"headerRowClassName":null,"headerRowStyle":null,"headerCellClassName":null,"headerCellStyle":null,"spanMethod":null,"summaryMethod":null,"load":null,"highlightSelectionRow":null},"methods":{"elEmitSelect":"function() { var shape = function(selection, row) { var vm = this; return {rows: (selection || []).map(function(r) { return window.shinyElement.rowIndex(vm, r); }), row_index: window.shinyElement.rowIndex(vm, row)}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyElement.emit('scores', 'select', [v]); }","elEmitSelectAll":"function() { var shape = function(selection) { var vm = this; return {rows: (selection || []).map(function(r) { return window.shinyElement.rowIndex(vm, r); })}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyElement.emit('scores', 'select_all', [v]); }","elEmitCellClick":"function() { var shape = function(row, column) { var prop = window.shinyElement.colProp(column); return {row_index: window.shinyElement.rowIndex(this, row), row: row, column: prop, value: row[prop]}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyElement.emit('scores', 'cell_click', [v]); }","elEmitCellDblclick":"function() { var shape = function(row, column) { var prop = window.shinyElement.colProp(column); return {row_index: window.shinyElement.rowIndex(this, row), row: row, column: prop, value: row[prop]}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyElement.emit('scores', 'cell_dblclick', [v]); }","elEmitCellMouseEnter":"function() { var shape = function(row, column) { var prop = window.shinyElement.colProp(column); return {row_index: window.shinyElement.rowIndex(this, row), row: row, column: prop, value: row[prop]}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyElement.emit('scores', 'cell_mouse_enter', [v]); }","elEmitCellMouseLeave":"function() { var shape = function(row, column) { var prop = window.shinyElement.colProp(column); return {row_index: window.shinyElement.rowIndex(this, row), row: row, column: prop, value: row[prop]}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyElement.emit('scores', 'cell_mouse_leave', [v]); }","elEmitRowClick":"function() { var shape = function(row, column) { return {row_index: window.shinyElement.rowIndex(this, row), row: row, column: window.shinyElement.colProp(column)}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyElement.emit('scores', 'row_click', [v]); }","elEmitRowDblclick":"function() { var shape = function(row, column) { return {row_index: window.shinyElement.rowIndex(this, row), row: row, column: window.shinyElement.colProp(column)}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyElement.emit('scores', 'row_dblclick', [v]); }","elEmitRowContextmenu":"function() { var shape = function(row, column) { return {row_index: window.shinyElement.rowIndex(this, row), row: row, column: window.shinyElement.colProp(column)}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyElement.emit('scores', 'row_contextmenu', [v]); }","elEmitHeaderClick":"function() { var shape = function(column) { return {column: window.shinyElement.colProp(column), label: column.label}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyElement.emit('scores', 'header_click', [v]); }","elEmitHeaderContextmenu":"function() { var shape = function(column) { return {column: window.shinyElement.colProp(column), label: column.label}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyElement.emit('scores', 'header_contextmenu', [v]); }","elEmitHeaderDragend":"function() { var shape = function(newWidth, oldWidth, column) { return {column: window.shinyElement.colProp(column), width: newWidth, previous_width: oldWidth}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyElement.emit('scores', 'header_dragend', [v]); }","elEmitSortChange":"function() { var shape = function(s) { return {column: s.prop, order: s.order}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyElement.emit('scores', 'sort_change', [v]); }","elEmitFilterChange":"function() { window.shinyElement.emit('scores', 'filter_change', arguments); }","elEmitCurrentChange":"function() { var shape = function(row, old) { return {row_index: window.shinyElement.rowIndex(this, row), row: row, previous_index: window.shinyElement.rowIndex(this, old)}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyElement.emit('scores', 'current_change', [v]); }","elEmitExpandChange":"function() { var shape = function(row, expanded) { var vm = this; return {row_index: window.shinyElement.rowIndex(this, row), expanded: Array.isArray(expanded) ? expanded.map(function(r) { return window.shinyElement.rowIndex(vm, r); }) : expanded}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyElement.emit('scores', 'expand_change', [v]); }","rowAction":"function(name, scope) { var se = window.shinyElement; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('scores_' + name, {row_index: se.rowIndex(this, scope.row), row: se.plain(scope.row)}, {priority: 'event'}); }","handleSelectionChange":"function(selection) { var self = this; self.selected = selection; self.selectedRows = selection.map(function(r) { return self.tableData.indexOf(r) + 1; }); window.Shiny && Shiny.setInputValue && Shiny.setInputValue('scores_selected', self.selected); window.Shiny && Shiny.setInputValue && Shiny.setInputValue('scores_selected_rows', self.selectedRows); }"},"mounted":"function() { var self = this; var send = function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"scores_selected\", self.selected); window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"scores_selected_rows\", self.selectedRows); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } var prev = self._elReport; self._elReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"input":null,"rate":null,"type":null,"evals":["options.methods.elEmitSelect","options.methods.elEmitSelectAll","options.methods.elEmitCellClick","options.methods.elEmitCellDblclick","options.methods.elEmitCellMouseEnter","options.methods.elEmitCellMouseLeave","options.methods.elEmitRowClick","options.methods.elEmitRowDblclick","options.methods.elEmitRowContextmenu","options.methods.elEmitHeaderClick","options.methods.elEmitHeaderContextmenu","options.methods.elEmitHeaderDragend","options.methods.elEmitSortChange","options.methods.elEmitFilterChange","options.methods.elEmitCurrentChange","options.methods.elEmitExpandChange","options.methods.rowAction","options.methods.handleSelectionChange","options.mounted"]}</script>
#> </div>

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
