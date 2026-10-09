# A column of [`el_table()`](https://kaipingyang.github.io/shiny.element/reference/el_table.md)

Element Plus's `el-table-column`, for `el_table(columns =)` and
[`update_el_table()`](https://kaipingyang.github.io/shiny.element/reference/el_table.md).
A column with columns of its own in `...` is a group header, nested as
deep as you like.

## Usage

``` r
el_table_column(
  prop = NULL,
  label = NULL,
  ...,
  cell = NULL,
  editable = NULL,
  editor = NULL,
  header = NULL,
  header_html = NULL,
  filter_icon = NULL,
  type = NULL,
  index = NULL,
  column_key = NULL,
  width = NULL,
  min_width = NULL,
  fixed = NULL,
  render_header = NULL,
  sortable = NULL,
  sort_method = NULL,
  sort_by = NULL,
  sort_orders = NULL,
  resizable = NULL,
  formatter = NULL,
  show_overflow_tooltip = NULL,
  align = NULL,
  header_align = NULL,
  class_name = NULL,
  label_class_name = NULL,
  selectable = NULL,
  reserve_selection = NULL,
  filters = NULL,
  filter_placement = NULL,
  filter_class_name = NULL,
  filter_multiple = NULL,
  filter_method = NULL,
  filtered_value = NULL,
  tooltip_formatter = NULL
)
```

## Arguments

- prop:

  The field of each row the column shows.

- label:

  The column's title.

- ...:

  Columns under this one, each an `el_table_column()`: the column is
  then a group header,
  `el_table_column(label = "Info", el_table_column( "name", "Name"), ...)`.

- cell:

  A template for each cell, drawn once per row: tags or a string, with
  `scope.row`, `scope.column` and `scope.$index` in reach and raw
  Element tags (`el$tag()`) working. A button in it reports with
  `rowAction('edit', scope)`; see
  [`el_table()`](https://kaipingyang.github.io/shiny.element/reference/el_table.md).

- editable:

  Whether the column's cells are edited in place, and with what: `TRUE`
  or `"input"` for text, `"number"`, `"select"` or `"date"` – Element's
  input, input-number, select and date picker. A double click opens the
  editor; Enter or leaving it commits, Escape abandons, Tab commits and
  moves to the next editable cell. Each edit is shown at once, applied
  to the server's copy of the data
  ([`el_table_data()`](https://kaipingyang.github.io/shiny.element/reference/el_table_data.md))
  and reported as `input$<id>_cell_edit`; see
  [`el_table()`](https://kaipingyang.github.io/shiny.element/reference/el_table.md).
  Not with `cell`.

- editor:

  The editor's props, under Element's names in snake_case:
  `list(min = 0, precision = 2)` for a number,
  `list(choices = c("a", "b"))` for a select,
  `list(placeholder = "...")`.

- header:

  A template for the header cell, as `cell` is for the others: a search
  box, a button.

- header_html:

  Markup for the header cell, inserted as it is: pass only what you
  control.

- filter_icon:

  The filter's icon, by name.

- type:

  `"selection"` (a checkbox), `"index"` (row numbers) or `"expand"` (an
  arrow opening the row to its `cell`); Element's default is
  `"default"`.

- index:

  For `type = "index"`, a number to start from or a
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function of the row's index.

- column_key:

  The column's key, which `filter-change` names.

- width, min_width:

  The column's width; `min_width` columns share what `width` columns
  leave, in proportion.

- fixed:

  Fix the column at the `"left"` (or `TRUE`) or the `"right"`.

- render_header:

  A
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  render function for the header.

- sortable:

  Whether the column sorts; `"custom"` sorts on the server, through the
  table's `sort-change` input.

- sort_method:

  A
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  comparison function.

- sort_by:

  The field, fields or
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function to sort by.

- sort_orders:

  The orders a click cycles through:
  `list("ascending", "descending", NULL)`.

- resizable:

  Whether the column can be resized, with `border = TRUE`.

- formatter:

  A
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function formatting the cell.

- show_overflow_tooltip:

  Hide overflowing content behind a tooltip; `TRUE`, or the tooltip's
  options.

- align, header_align:

  Alignment of the cells and of the header: `"left"`, `"center"` or
  `"right"`.

- class_name, label_class_name:

  Class of the cells and of the header.

- selectable:

  For `type = "selection"`, a
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function deciding whether a row can be ticked.

- reserve_selection:

  For `type = "selection"`, keep ticks when the data changes; needs the
  table's `row_key`.

- filters:

  The filter's choices: `list(list(text =, value =), ...)`.

- filter_placement:

  Where the filter's dropdown opens.

- filter_class_name:

  Class of the filter's dropdown.

- filter_multiple:

  Whether several filter choices can be ticked.

- filter_method:

  A
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function `(value, row, column)` keeping a row.

- filtered_value:

  The filter's ticked values.

- tooltip_formatter:

  A
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function of `{row, column, cellValue}` for the overflow tooltip's
  content.

## Value

A column, for `el_table(columns =)`.

## See also

Other items:
[`el_anchor_link()`](https://kaipingyang.github.io/shiny.element/reference/el_anchor_link.md),
[`el_breadcrumb_item()`](https://kaipingyang.github.io/shiny.element/reference/el_breadcrumb_item.md),
[`el_carousel_item()`](https://kaipingyang.github.io/shiny.element/reference/el_carousel_item.md),
[`el_collapse_item()`](https://kaipingyang.github.io/shiny.element/reference/el_collapse_item.md),
[`el_descriptions_item()`](https://kaipingyang.github.io/shiny.element/reference/el_descriptions_item.md),
[`el_dropdown_item()`](https://kaipingyang.github.io/shiny.element/reference/el_dropdown_item.md),
[`el_menu_item()`](https://kaipingyang.github.io/shiny.element/reference/el_menu_item.md),
[`el_option()`](https://kaipingyang.github.io/shiny.element/reference/el_option.md),
[`el_skeleton_item()`](https://kaipingyang.github.io/shiny.element/reference/el_skeleton_item.md),
[`el_step()`](https://kaipingyang.github.io/shiny.element/reference/el_step.md),
[`el_tab_pane()`](https://kaipingyang.github.io/shiny.element/reference/el_tab_pane.md),
[`el_table_v2_column()`](https://kaipingyang.github.io/shiny.element/reference/el_table_v2_column.md),
[`el_timeline_item()`](https://kaipingyang.github.io/shiny.element/reference/el_timeline_item.md),
[`el_tour_step()`](https://kaipingyang.github.io/shiny.element/reference/el_tour_step.md)

## Examples

``` r
el_table(
  "t",
  data = data.frame(date = "2016-05-03", name = "Tom", city = "LA"),
  columns = list(
    el_table_column("date", "Date", width = 150, sortable = TRUE),
    el_table_column(
      label = "Delivery Info",
      el_table_column("name", "Name"),
      el_table_column("city", "City")
    )
  )
)
#> <div id="t" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="t_container" style="display: contents">
#>   <el-table :data="tableData" :border="border" style="width: 100%" v-loading="loading" @selection-change="handleSelectionChange" v-bind="loadingAttrs" @sort-change="svEmitSortChange" @filter-change="svEmitFilterChange" @current-change="svEmitCurrentChange" @expand-change="svEmitExpandChange" :stripe="stripe === null ? undefined : stripe" :size="size === null ? undefined : size" :height="height === null ? undefined : height" :max-height="maxHeight === null ? undefined : maxHeight" :fit="fit === null ? undefined : fit" :show-header="showHeader === null ? undefined : showHeader" :highlight-current-row="highlightCurrentRow === null ? undefined : highlightCurrentRow" :current-row-key="currentRowKey === null ? undefined : currentRowKey" :row-key="rowKey === null ? undefined : rowKey" :empty-text="emptyText === null ? undefined : emptyText" :default-expand-all="defaultExpandAll === null ? undefined : defaultExpandAll" :expand-row-keys="expandRowKeys === null ? undefined : expandRowKeys" :default-sort="defaultSort === null ? undefined : defaultSort" :tooltip-effect="tooltipEffect === null ? undefined : tooltipEffect" :show-summary="showSummary === null ? undefined : showSummary" :sum-text="sumText === null ? undefined : sumText" :select-on-indeterminate="selectOnIndeterminate === null ? undefined : selectOnIndeterminate" :indent="indent === null ? undefined : indent" :lazy="lazy === null ? undefined : lazy" :tree-props="treeProps === null ? undefined : treeProps" :row-class-name="rowClassName === null ? undefined : rowClassName" :row-style="rowStyle === null ? undefined : rowStyle" :cell-class-name="cellClassName === null ? undefined : cellClassName" :cell-style="cellStyle === null ? undefined : cellStyle" :header-row-class-name="headerRowClassName === null ? undefined : headerRowClassName" :header-row-style="headerRowStyle === null ? undefined : headerRowStyle" :header-cell-class-name="headerCellClassName === null ? undefined : headerCellClassName" :header-cell-style="headerCellStyle === null ? undefined : headerCellStyle" :span-method="spanMethod === null ? undefined : spanMethod" :summary-method="summaryMethod === null ? undefined : summaryMethod" :load="load === null ? elLoad : load" :allow-drag-last-column="allowDragLastColumn === null ? undefined : allowDragLastColumn" :append-filter-panel-to="appendFilterPanelTo === null ? undefined : appendFilterPanelTo" :flexible="flexible === null ? undefined : flexible" :native-scrollbar="nativeScrollbar === null ? undefined : nativeScrollbar" :preserve-expanded-content="preserveExpandedContent === null ? undefined : preserveExpandedContent" :row-expandable="rowExpandable === null ? undefined : rowExpandable" :scrollbar-always-on="scrollbarAlwaysOn === null ? undefined : scrollbarAlwaysOn" :scrollbar-tabindex="scrollbarTabindex === null ? undefined : scrollbarTabindex" :show-overflow-tooltip="showOverflowTooltip === null ? undefined : showOverflowTooltip" :table-layout="tableLayout === null ? undefined : tableLayout" :tooltip-formatter="tooltipFormatter === null ? undefined : tooltipFormatter" :tooltip-options="tooltipOptions === null ? undefined : tooltipOptions">
#>     <el-table-column v-if="selection" type="selection" width="55"></el-table-column>
#>     <el-table-column v-for="col in (columns.length ? columns : autoColumns)" :key="col.prop || col.label" :prop="col.prop" :label="col.label" :width="col.width" :align="col.align" :header-align="col.headerAlign" :class-name="col.className" :label-class-name="col.labelClassName" :column-key="col.columnKey" :min-width="col.minWidth" :fixed="col.fixed" :resizable="col.resizable" :sortable="col.sortable" :sort-by="col.sortBy" :sort-orders="col.sortOrders" :show-overflow-tooltip="col.showOverflowTooltip" :filters="col.filters" :filtered-value="col.filteredValue" :filter-multiple="col.filterMultiple" :filter-placement="col.filterPlacement" :reserve-selection="col.reserveSelection" :index="col.index" :formatter="col.formatter" :filter-method="col.filterMethod" :filter-class-name="col.filterClassName" :tooltip-formatter="col.tooltipFormatter" :sort-method="col.sortMethod" :render-header="col.renderHeader" :selectable="col.selectable" :type="col.type">
#>       <template v-slot:header="scope">
#>         <span v-if="col.headerHtml" v-html="col.headerHtml"></span>
#>         <span v-else>{{col.label}}</span>
#>       </template>
#>       <template v-slot:[col.filterIcon?'filter-icon':'no-filter-icon']><el-icon><component :is="col.filterIcon" /></el-icon></template>
#>       <template v-slot:default="scope">
#>         <template v-if="col.children &amp;&amp; col.children.length">
#>           <el-table-column v-for="colx in col.children" :key="colx.prop || colx.label" :prop="colx.prop" :label="colx.label" :width="colx.width" :align="colx.align" :header-align="colx.headerAlign" :class-name="colx.className" :label-class-name="colx.labelClassName" :column-key="colx.columnKey" :min-width="colx.minWidth" :fixed="colx.fixed" :resizable="colx.resizable" :sortable="colx.sortable" :sort-by="colx.sortBy" :sort-orders="colx.sortOrders" :show-overflow-tooltip="colx.showOverflowTooltip" :filters="colx.filters" :filtered-value="colx.filteredValue" :filter-multiple="colx.filterMultiple" :filter-placement="colx.filterPlacement" :reserve-selection="colx.reserveSelection" :index="colx.index" :formatter="colx.formatter" :filter-method="colx.filterMethod" :filter-class-name="colx.filterClassName" :tooltip-formatter="colx.tooltipFormatter" :sort-method="colx.sortMethod" :render-header="colx.renderHeader" :selectable="colx.selectable" :type="colx.type">
#>             <template v-slot:header="scope">
#>               <span v-if="colx.headerHtml" v-html="colx.headerHtml"></span>
#>               <span v-else>{{colx.label}}</span>
#>             </template>
#>             <template v-slot:[colx.filterIcon?'filter-icon':'no-filter-icon']><el-icon><component :is="colx.filterIcon" /></el-icon></template>
#>             <template v-slot:default="scope">
#>               <template v-if="colx.children &amp;&amp; colx.children.length">
#>                 <el-table-column v-for="colxx in colx.children" :key="colxx.prop || colxx.label" :prop="colxx.prop" :label="colxx.label" :width="colxx.width" :align="colxx.align" :header-align="colxx.headerAlign" :class-name="colxx.className" :label-class-name="colxx.labelClassName" :column-key="colxx.columnKey" :min-width="colxx.minWidth" :fixed="colxx.fixed" :resizable="colxx.resizable" :sortable="colxx.sortable" :sort-by="colxx.sortBy" :sort-orders="colxx.sortOrders" :show-overflow-tooltip="colxx.showOverflowTooltip" :filters="colxx.filters" :filtered-value="colxx.filteredValue" :filter-multiple="colxx.filterMultiple" :filter-placement="colxx.filterPlacement" :reserve-selection="colxx.reserveSelection" :index="colxx.index" :formatter="colxx.formatter" :filter-method="colxx.filterMethod" :filter-class-name="colxx.filterClassName" :tooltip-formatter="colxx.tooltipFormatter" :sort-method="colxx.sortMethod" :render-header="colxx.renderHeader" :selectable="colxx.selectable" :type="colxx.type">
#>                   <template v-slot:header="scope">
#>                     <span v-if="colxx.headerHtml" v-html="colxx.headerHtml"></span>
#>                     <span v-else>{{colxx.label}}</span>
#>                   </template>
#>                   <template v-slot:[colxx.filterIcon?'filter-icon':'no-filter-icon']><el-icon><component :is="colxx.filterIcon" /></el-icon></template>
#>                   <template v-slot:default="scope"></template>
#>                 </el-table-column>
#>               </template>
#>             </template>
#>           </el-table-column>
#>         </template>
#>       </template>
#>     </el-table-column>
#>   </el-table>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"tableData":[{"date":"2016-05-03","name":"Tom","city":"LA"}],"columns":[{"prop":"date","label":"Date","width":150,"sortable":true,"slot":"none"},{"label":"Delivery Info","children":[{"prop":"name","label":"Name","slot":"none"},{"prop":"city","label":"City","slot":"none"}],"slot":"none"}],"autoColumns":[{"prop":"date","label":"date","slot":"none"},{"prop":"name","label":"name","slot":"none"},{"prop":"city","label":"city","slot":"none"}],"border":false,"selection":false,"selected":[],"selectedRows":[],"editing":null,"restoredRows":[],"loading":false,"loadingAttrs":{},"stripe":null,"size":null,"height":null,"maxHeight":null,"fit":null,"showHeader":null,"highlightCurrentRow":null,"currentRowKey":null,"rowKey":null,"emptyText":null,"defaultExpandAll":null,"expandRowKeys":null,"defaultSort":null,"tooltipEffect":null,"showSummary":null,"sumText":null,"selectOnIndeterminate":null,"indent":null,"lazy":null,"treeProps":null,"rowClassName":null,"rowStyle":null,"cellClassName":null,"cellStyle":null,"headerRowClassName":null,"headerRowStyle":null,"headerCellClassName":null,"headerCellStyle":null,"spanMethod":null,"summaryMethod":null,"load":null,"allowDragLastColumn":null,"appendFilterPanelTo":null,"flexible":null,"nativeScrollbar":null,"preserveExpandedContent":null,"rowExpandable":null,"scrollbarAlwaysOn":null,"scrollbarTabindex":null,"showOverflowTooltip":null,"tableLayout":null,"tooltipFormatter":null,"tooltipOptions":null},"methods":{"svEmitSortChange":"function() { var shape = function(s) { return {column: s.prop, order: s.order}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('t', 'sort_change', [v]); }","svEmitFilterChange":"function() { window.shinyVue.emit('t', 'filter_change', arguments); }","svEmitCurrentChange":"function() { var shape = function(row, old) { return {row_index: window.shinyElement.rowIndex(this, row), row: row, previous_index: window.shinyElement.rowIndex(this, old)}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('t', 'current_change', [v]); }","svEmitExpandChange":"function() { var shape = function(row, expanded) { var vm = this; return {row_index: window.shinyElement.rowIndex(this, row), expanded: Array.isArray(expanded) ? expanded.map(function(r) { return window.shinyElement.rowIndex(vm, r); }) : expanded}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('t', 'expand_change', [v]); }","elLoad":"function(row, treeNode, resolve) {\n  var key = this.rowKey && typeof this.rowKey === 'string' ? row[this.rowKey] : null;\n  window.shinyVue.ask('t_load', {key: key, row: row, level: treeNode ? treeNode.level : null}, this)\n    .then(function(children) { resolve(children || []); },\n          function() { resolve([]); });\n}","rowAction":"function(name, scope) { var se = window.shinyElement; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('t_' + name, {row_index: se.rowIndex(this, scope.row), row: window.shinyVue.plain(scope.row)}, {priority: 'event'}); }","isEditing":"function(scope, prop) { var e = this.editing; return !!e && e.row === scope.row && e.prop === prop; }","startEdit":"function(scope, prop) { var self = this; self.editing = {row: scope.row, prop: prop, value: scope.row[prop], old: scope.row[prop]}; self.$nextTick(function() { var root = self.$el && self.$el.querySelector ? self.$el : document; var f = root.querySelector('.el-table-edit-cell__editor input, .el-table-edit-cell__editor textarea'); if (f) f.focus(); }); }","cancelEdit":"function() { this.editing = null; }","commitEdit":"function(move, scope, prop) { var e = this.editing; if (!e || (scope && (e.row !== scope.row || e.prop !== prop))) return; this.editing = null; if (e.value !== e.old) { e.row[e.prop] = e.value; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('t_cell_edit:shiny.element.cell_edit', {table: 't', row: window.shinyElement.rowIndex(this, e.row), column: e.prop, value: e.value, old: e.old}, {priority: 'event'}); } if (!move) return; var props = []; (function walk(cols) { (cols || []).forEach(function(c) { if (c.editableProp) props.push(c.editableProp); walk(c.children); }); })(this.columns && this.columns.length ? this.columns : this.autoColumns); var i = props.indexOf(e.prop), r = this.tableData.indexOf(e.row); if (i < 0 || r < 0) return; if (i + 1 < props.length) i++; else { i = 0; r++; } if (r < this.tableData.length) this.startEdit({row: this.tableData[r]}, props[i]); }","reportSelection":"function() { var self = this; self.selectedRows = (self.selected || []).map(function(r) { return window.shinyElement.rowIndex(self, r); }); window.Shiny && Shiny.setInputValue && Shiny.setInputValue('t_selection_rows:shiny.element.rows', self.selectedRows); }","handleSelectionChange":"function(selection) { var self = this; self.selected = selection; self.reportSelection(); window.Shiny && Shiny.setInputValue && Shiny.setInputValue('t_selection_change:shiny.element.selection', {table: 't', rows: self.selectedRows, data: window.shinyVue.plain(selection)}, {priority: 'event'}); }","shinyVueEdited":"function() { var self = this; this.$nextTick(function() { self.reportSelection(); }); }"},"watch":{"restoredRows":{"immediate":true,"handler":"function(rows) { var self = this; if (!rows || !rows.length) return; self.$nextTick(function() { var t = window.shinyVue.componentOf(self, 'ElTable'); if (!t) return; rows.forEach(function(i) { var r = self.tableData[i - 1]; if (r) t.toggleRowSelection(r, true); }); self.restoredRows = []; }); }"}},"mounted":"function() { var self = this; var send = function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"t_selection_rows:shiny.element.rows\", self.selectedRows); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } var prev = self._svReport; self._svReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.svEmitSortChange","options.methods.svEmitFilterChange","options.methods.svEmitCurrentChange","options.methods.svEmitExpandChange","options.methods.elLoad","options.methods.rowAction","options.methods.isEditing","options.methods.startEdit","options.methods.cancelEdit","options.methods.commitEdit","options.methods.reportSelection","options.methods.handleSelectionChange","options.methods.shinyVueEdited","options.watch.restoredRows.handler","options.mounted"]}</script>
#> </div>
```
