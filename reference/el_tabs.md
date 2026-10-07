# Element Plus Tabs

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
  add_icon = NULL,
  session = NULL
)

update_el_tabs(
  session = shiny::getDefaultReactiveDomain(),
  id,
  selected = NULL
)
```

## Arguments

- id:

  Tabs ID. Auto-generated UUID if `NULL`.

- tabs:

  A list of tabs, each an
  [`el_tab_pane()`](https://kaipingyang.github.io/shiny.element/reference/el_tab_pane.md)
  – or a named list with the same fields:

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

- add_icon:

  The add button's icon, by name. Default `"Plus"`.

- session:

  In `el_tabs()`, deprecated: inside a module, wrap `id` in `ns()`, as
  for any Shiny input; a session given here namespaces `id` once more,
  with a warning. In `update_el_tabs()`, the Shiny session, the current
  one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

## Value

An `htmltools` tag.

## Details

Rendered as plain markup carrying Element's own classes, driven by a
Shiny input binding rather than a Vue instance. That is what lets a tab
hold other components from this package: a Vue instance mounted here
would rebuild the DOM underneath them, leaving them rendered but
disconnected from the server.

## Shiny inputs

- `input$<id>` – name of the selected tab, on load and on every change.

- `input$<id>_tab_click` – name of the tab clicked, even if it was
  already selected.

- `input$<id>_tab_remove` – name of a tab just closed.

- `input$<id>_tab_add` – fires when the "+" button is clicked.

- `input$<id>_edit` – either of the last two, as Element's `edit` event:
  a list of `target` (the tab name, or `NULL` for an add) and `action`
  (`"remove"` or `"add"`).

## Updating from the server

Server-side update for `el_tabs()`.

`update_el_tabs()` is called for its side effect and returns `NULL`
invisibly.

## Examples

``` r
el_tabs(
  "t1",
  selected = "a",
  tabs = list(
    list(name = "a", label = "First", content = shiny::tags$p("One")),
    list(name = "b", label = "Second", content = shiny::tags$p("Two"))
  )
)
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
el_tabs(
  "t2",
  tabs = list(
    list(
      name = "data",
      label = "Data",
      content = el_table(data = head(iris, 3))
    ),
    list(name = "opts", label = "Options", content = el_switch("live"))
  )
)
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
#>       <div id="el_table_1237216b-79ee-4724-ac75-e8455612e618" data-shiny-vue style="display: contents">
#>         <script type="text/x-template" data-shiny-vue-template><div id="el_table_1237216b-79ee-4724-ac75-e8455612e618_container" style="display: contents">
#>   <el-table :data="tableData" :border="border" style="width: 100%" v-loading="loading" @selection-change="handleSelectionChange" @current-change="elEmitCurrentChange" @sort-change="elEmitSortChange" @filter-change="elEmitFilterChange" @expand-change="elEmitExpandChange" :stripe="stripe === null ? undefined : stripe" :size="size === null ? undefined : size" :height="height === null ? undefined : height" :max-height="maxHeight === null ? undefined : maxHeight" :fit="fit === null ? undefined : fit" :show-header="showHeader === null ? undefined : showHeader" :highlight-current-row="highlightCurrentRow === null ? undefined : highlightCurrentRow" :current-row-key="currentRowKey === null ? undefined : currentRowKey" :row-key="rowKey === null ? undefined : rowKey" :empty-text="emptyText === null ? undefined : emptyText" :default-expand-all="defaultExpandAll === null ? undefined : defaultExpandAll" :expand-row-keys="expandRowKeys === null ? undefined : expandRowKeys" :default-sort="defaultSort === null ? undefined : defaultSort" :tooltip-effect="tooltipEffect === null ? undefined : tooltipEffect" :show-summary="showSummary === null ? undefined : showSummary" :sum-text="sumText === null ? undefined : sumText" :select-on-indeterminate="selectOnIndeterminate === null ? undefined : selectOnIndeterminate" :indent="indent === null ? undefined : indent" :lazy="lazy === null ? undefined : lazy" :tree-props="treeProps === null ? undefined : treeProps" :row-class-name="rowClassName === null ? undefined : rowClassName" :row-style="rowStyle === null ? undefined : rowStyle" :cell-class-name="cellClassName === null ? undefined : cellClassName" :cell-style="cellStyle === null ? undefined : cellStyle" :header-row-class-name="headerRowClassName === null ? undefined : headerRowClassName" :header-row-style="headerRowStyle === null ? undefined : headerRowStyle" :header-cell-class-name="headerCellClassName === null ? undefined : headerCellClassName" :header-cell-style="headerCellStyle === null ? undefined : headerCellStyle" :span-method="spanMethod === null ? undefined : spanMethod" :summary-method="summaryMethod === null ? undefined : summaryMethod" :load="load === null ? elLoad : load" :allow-drag-last-column="allowDragLastColumn === null ? undefined : allowDragLastColumn" :append-filter-panel-to="appendFilterPanelTo === null ? undefined : appendFilterPanelTo" :flexible="flexible === null ? undefined : flexible" :native-scrollbar="nativeScrollbar === null ? undefined : nativeScrollbar" :preserve-expanded-content="preserveExpandedContent === null ? undefined : preserveExpandedContent" :row-expandable="rowExpandable === null ? undefined : rowExpandable" :scrollbar-always-on="scrollbarAlwaysOn === null ? undefined : scrollbarAlwaysOn" :scrollbar-tabindex="scrollbarTabindex === null ? undefined : scrollbarTabindex" :show-overflow-tooltip="showOverflowTooltip === null ? undefined : showOverflowTooltip" :table-layout="tableLayout === null ? undefined : tableLayout" :tooltip-formatter="tooltipFormatter === null ? undefined : tooltipFormatter" :tooltip-options="tooltipOptions === null ? undefined : tooltipOptions">
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
#>         <script type="application/json" data-shiny-vue-options>{"options":{"data":{"tableData":[{"Sepal_Length":5.1,"Sepal_Width":3.5,"Petal_Length":1.4,"Petal_Width":0.2,"Species":"setosa"},{"Sepal_Length":4.9,"Sepal_Width":3,"Petal_Length":1.4,"Petal_Width":0.2,"Species":"setosa"},{"Sepal_Length":4.7,"Sepal_Width":3.2,"Petal_Length":1.3,"Petal_Width":0.2,"Species":"setosa"}],"columns":[],"autoColumns":[{"prop":"Sepal_Length","label":"Sepal.Length","slot":"none"},{"prop":"Sepal_Width","label":"Sepal.Width","slot":"none"},{"prop":"Petal_Length","label":"Petal.Length","slot":"none"},{"prop":"Petal_Width","label":"Petal.Width","slot":"none"},{"prop":"Species","label":"Species","slot":"none"}],"border":false,"selection":false,"selected":[],"selectedRows":[],"editing":null,"restoredRows":[],"loading":false,"stripe":null,"size":null,"height":null,"maxHeight":null,"fit":null,"showHeader":null,"highlightCurrentRow":null,"currentRowKey":null,"rowKey":null,"emptyText":null,"defaultExpandAll":null,"expandRowKeys":null,"defaultSort":null,"tooltipEffect":null,"showSummary":null,"sumText":null,"selectOnIndeterminate":null,"indent":null,"lazy":null,"treeProps":null,"rowClassName":null,"rowStyle":null,"cellClassName":null,"cellStyle":null,"headerRowClassName":null,"headerRowStyle":null,"headerCellClassName":null,"headerCellStyle":null,"spanMethod":null,"summaryMethod":null,"load":null,"allowDragLastColumn":null,"appendFilterPanelTo":null,"flexible":null,"nativeScrollbar":null,"preserveExpandedContent":null,"rowExpandable":null,"scrollbarAlwaysOn":null,"scrollbarTabindex":null,"showOverflowTooltip":null,"tableLayout":null,"tooltipFormatter":null,"tooltipOptions":null},"methods":{"elEmitCurrentChange":"function() { var shape = function(row, old) { return {row_index: window.shinyElement.rowIndex(this, row), row: row, previous_index: window.shinyElement.rowIndex(this, old)}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('el_table_1237216b-79ee-4724-ac75-e8455612e618', 'current_change', [v]); }","elEmitSortChange":"function() { var shape = function(s) { return {column: s.prop, order: s.order}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('el_table_1237216b-79ee-4724-ac75-e8455612e618', 'sort_change', [v]); }","elEmitFilterChange":"function() { window.shinyVue.emit('el_table_1237216b-79ee-4724-ac75-e8455612e618', 'filter_change', arguments); }","elEmitExpandChange":"function() { var shape = function(row, expanded) { var vm = this; return {row_index: window.shinyElement.rowIndex(this, row), expanded: Array.isArray(expanded) ? expanded.map(function(r) { return window.shinyElement.rowIndex(vm, r); }) : expanded}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('el_table_1237216b-79ee-4724-ac75-e8455612e618', 'expand_change', [v]); }","elLoad":"function(row, treeNode, resolve) {\n  var key = this.rowKey && typeof this.rowKey === 'string' ? row[this.rowKey] : null;\n  window.shinyVue.ask('el_table_1237216b-79ee-4724-ac75-e8455612e618_load', {key: key, row: row, level: treeNode ? treeNode.level : null}, this)\n    .then(function(children) { resolve(children || []); },\n          function() { resolve([]); });\n}","rowAction":"function(name, scope) { var se = window.shinyElement; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('el_table_1237216b-79ee-4724-ac75-e8455612e618_' + name, {row_index: se.rowIndex(this, scope.row), row: window.shinyVue.plain(scope.row)}, {priority: 'event'}); }","isEditing":"function(scope, prop) { var e = this.editing; return !!e && e.row === scope.row && e.prop === prop; }","startEdit":"function(scope, prop) { var self = this; self.editing = {row: scope.row, prop: prop, value: scope.row[prop], old: scope.row[prop]}; self.$nextTick(function() { var root = self.$el && self.$el.querySelector ? self.$el : document; var f = root.querySelector('.el-table-edit-cell__editor input, .el-table-edit-cell__editor textarea'); if (f) f.focus(); }); }","cancelEdit":"function() { this.editing = null; }","commitEdit":"function(move, scope, prop) { var e = this.editing; if (!e || (scope && (e.row !== scope.row || e.prop !== prop))) return; this.editing = null; if (e.value !== e.old) { e.row[e.prop] = e.value; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('el_table_1237216b-79ee-4724-ac75-e8455612e618_cell_edit:shiny.element.cell_edit', {table: 'el_table_1237216b-79ee-4724-ac75-e8455612e618', row: window.shinyElement.rowIndex(this, e.row), column: e.prop, value: e.value, old: e.old}, {priority: 'event'}); } if (!move) return; var props = []; (function walk(cols) { (cols || []).forEach(function(c) { if (c.editableProp) props.push(c.editableProp); walk(c.children); }); })(this.columns && this.columns.length ? this.columns : this.autoColumns); var i = props.indexOf(e.prop), r = this.tableData.indexOf(e.row); if (i < 0 || r < 0) return; if (i + 1 < props.length) i++; else { i = 0; r++; } if (r < this.tableData.length) this.startEdit({row: this.tableData[r]}, props[i]); }","reportSelection":"function() { var self = this; self.selectedRows = (self.selected || []).map(function(r) { return window.shinyElement.rowIndex(self, r); }); window.Shiny && Shiny.setInputValue && Shiny.setInputValue('el_table_1237216b-79ee-4724-ac75-e8455612e618_selection_rows:shiny.element.rows', self.selectedRows); }","handleSelectionChange":"function(selection) { var self = this; self.selected = selection; self.reportSelection(); window.Shiny && Shiny.setInputValue && Shiny.setInputValue('el_table_1237216b-79ee-4724-ac75-e8455612e618_selection_change:shiny.element.selection', {table: 'el_table_1237216b-79ee-4724-ac75-e8455612e618', rows: self.selectedRows, data: window.shinyVue.plain(selection)}, {priority: 'event'}); }","shinyVueReceive":"function(d) { if (!('tableEdit' in d)) return d; var e = d.tableEdit, data = this.tableData, rows = e.rows || [], at = e.at === null || e.at === undefined ? [] : [].concat(e.at); delete d.tableEdit; if (e.op === 'insert') { var i = at.length ? at[0] - 1 : data.length; data.splice.apply(data, [i, 0].concat(rows)); } else if (e.op === 'replace') { at.forEach(function(i, k) { data.splice(i - 1, 1, rows[k]); }); } else if (e.op === 'delete') { at.slice().sort(function(a, b) { return b - a; }).forEach(function(i) { data.splice(i - 1, 1); }); } var self = this; this.$nextTick(function() { self.reportSelection(); }); return d; }"},"watch":{"restoredRows":{"immediate":true,"handler":"function(rows) { var self = this; if (!rows || !rows.length) return; self.$nextTick(function() { var t = window.shinyVue.componentOf(self, 'ElTable'); if (!t) return; rows.forEach(function(i) { var r = self.tableData[i - 1]; if (r) t.toggleRowSelection(r, true); }); self.restoredRows = []; }); }"}},"mounted":"function() { var self = this; var send = function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"el_table_1237216b-79ee-4724-ac75-e8455612e618_selection_rows:shiny.element.rows\", self.selectedRows); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } var prev = self._svReport; self._svReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"generated":true,"evals":["options.methods.elEmitCurrentChange","options.methods.elEmitSortChange","options.methods.elEmitFilterChange","options.methods.elEmitExpandChange","options.methods.elLoad","options.methods.rowAction","options.methods.isEditing","options.methods.startEdit","options.methods.cancelEdit","options.methods.commitEdit","options.methods.reportSelection","options.methods.handleSelectionChange","options.methods.shinyVueReceive","options.watch.restoredRows.handler","options.mounted"]}</script>
#>       </div>
#>     </div>
#>     <div role="tabpanel" id="t2-pane-opts" aria-labelledby="t2-tab-opts" aria-hidden="true" class="el-tab-pane" style="display:none" data-el-name="opts">
#>       <div id="live" data-shiny-vue style="display: contents">
#>         <script type="text/x-template" data-shiny-vue-template><div id="live_container" style="display: contents">
#>   <el-switch v-model="value" :disabled="disabled" :active-text="activeText" :inactive-text="inactiveText" :active-color="activeColor" :inactive-color="inactiveColor" :active-value="activeValue" :inactive-value="inactiveValue" @change="handleChange" :width="width === null ? undefined : width" :name="name === null ? undefined : name" :validate-event="validateEvent === null ? undefined : validateEvent" :active-action-icon="activeActionIcon === null ? undefined : activeActionIcon" :active-icon="activeIcon === null ? undefined : activeIcon" :aria-label="ariaLabel === null ? undefined : ariaLabel" :before-change="beforeChange === null ? undefined : beforeChange" :border-color="borderColor === null ? undefined : borderColor" :inactive-action-icon="inactiveActionIcon === null ? undefined : inactiveActionIcon" :inactive-icon="inactiveIcon === null ? undefined : inactiveIcon" :inline-prompt="inlinePrompt === null ? undefined : inlinePrompt" :loading="loading === null ? undefined : loading" :size="size === null ? undefined : size" :tabindex="tabindex === null ? undefined : tabindex"></el-switch>
#> </div></script>
#>         <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":false,"disabled":false,"activeText":"","inactiveText":"","activeColor":"","inactiveColor":"","activeValue":true,"inactiveValue":false,"width":null,"name":null,"validateEvent":null,"activeActionIcon":null,"activeIcon":null,"ariaLabel":null,"beforeChange":null,"borderColor":null,"inactiveActionIcon":null,"inactiveIcon":null,"inlinePrompt":null,"loading":null,"size":null,"tabindex":null},"methods":{"handleChange":"function(value) { }"}},"input":"value","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.handleChange"]}</script>
#>       </div>
#>     </div>
#>   </div>
#> </div>
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_tabs(session, "section", selected = "data")
  })
}
```
