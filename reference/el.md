# Element UI tags, for markup inside a component

A tag generator for every Element tag, as `tags$p` is for HTML:
`el$button(type = "primary", "Go")` writes `<el-button type="primary">`.
Nothing more – no Vue instance, no Shiny input, no id.

## Usage

``` r
el
```

## Value

A named list of tag-generating functions, one per Element UI tag.

## Details

An `<el-*>` tag becomes an Element component only when a Vue instance
compiles it, so these belong where one already does:

- the `markup` of
  [`el_widget()`](https://kaipingyang.github.io/shiny.element/reference/el_widget.md),
  when building a component of your own;

- a
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md)
  or a component's `slots`;

- a table column's `cell` in
  [`el_table()`](https://kaipingyang.github.io/shiny.element/reference/el_table.md);

- the trigger of a wrapper –
  [`el_tooltip()`](https://kaipingyang.github.io/shiny.element/reference/el_tooltip.md),
  [`el_popover()`](https://kaipingyang.github.io/shiny.element/reference/el_popover.md),
  [`el_popconfirm()`](https://kaipingyang.github.io/shiny.element/reference/el_popconfirm.md).

Anywhere else – the top level of a page, or inside the markup-only
containers
([`el_tabs()`](https://kaipingyang.github.io/shiny.element/reference/el_tabs.md),
[`el_collapse()`](https://kaipingyang.github.io/shiny.element/reference/el_collapse.md),
[`el_dialog()`](https://kaipingyang.github.io/shiny.element/reference/el_dialog.md),
[`el_drawer()`](https://kaipingyang.github.io/shiny.element/reference/el_drawer.md),
[`el_row()`](https://kaipingyang.github.io/shiny.element/reference/el_row.md),
[`el_container()`](https://kaipingyang.github.io/shiny.element/reference/el_container.md))
– nothing compiles them and they show as bare text; the browser console
says so. There, use the component functions:
[`el_button()`](https://kaipingyang.github.io/shiny.element/reference/el_button.md),
[`el_tag()`](https://kaipingyang.github.io/shiny.element/reference/el_tag.md)
and the rest.

Mounting a Vue instance over such markup automatically is deliberately
not done: it would rebuild every component and Shiny input inside it,
leaving them on screen but disconnected from the server.

## Examples

``` r
names(el)
#>  [1] "button"              "button_group"        "link"               
#>  [4] "icon"                "container"           "header"             
#>  [7] "aside"               "main"                "footer"             
#> [10] "row"                 "col"                 "form"               
#> [13] "form_item"           "input"               "input_number"       
#> [16] "radio"               "radio_group"         "radio_button"       
#> [19] "checkbox"            "checkbox_button"     "checkbox_group"     
#> [22] "switch"              "select"              "option"             
#> [25] "option_group"        "cascader"            "cascader_panel"     
#> [28] "slider"              "time_picker"         "time_select"        
#> [31] "date_picker"         "upload"              "rate"               
#> [34] "color_picker"        "transfer"            "autocomplete"       
#> [37] "table"               "table_column"        "tag"                
#> [40] "progress"            "tree"                "pagination"         
#> [43] "badge"               "avatar"              "calendar"           
#> [46] "card"                "carousel"            "carousel_item"      
#> [49] "collapse"            "collapse_item"       "timeline"           
#> [52] "timeline_item"       "divider"             "image"              
#> [55] "empty"               "skeleton"            "result"             
#> [58] "statistic"           "descriptions"        "descriptions_item"  
#> [61] "skeleton_item"       "menu"                "submenu"            
#> [64] "menu_item"           "menu_item_group"     "tabs"               
#> [67] "tab_pane"            "breadcrumb"          "breadcrumb_item"    
#> [70] "dropdown"            "dropdown_menu"       "dropdown_item"      
#> [73] "steps"               "step"                "page_header"        
#> [76] "backtop"             "dialog"              "alert"              
#> [79] "drawer"              "popover"             "tooltip"            
#> [82] "popconfirm"          "spinner"             "scrollbar"          
#> [85] "collapse_transition"

# As a wrapper's trigger, compiled by the tooltip's own instance
el_tooltip("hint", el$button(type = "primary", "Hover me"), content = "Help")
#> <div id="hint" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="hint_container" style="display: contents">
#>   <el-tooltip v-model="tipValue" :content="tipContent === null ? undefined : tipContent" :placement="tipPlacement === null ? undefined : tipPlacement" :effect="tipEffect === null ? undefined : tipEffect" :disabled="tipDisabled === null ? undefined : tipDisabled" :offset="tipOffset === null ? undefined : tipOffset" :open-delay="tipOpenDelay === null ? undefined : tipOpenDelay" :hide-after="tipHideAfter === null ? undefined : tipHideAfter" :enterable="tipEnterable === null ? undefined : tipEnterable" :visible-arrow="tipVisibleArrow === null ? undefined : tipVisibleArrow" :transition="tipTransition === null ? undefined : tipTransition" :popper-class="tipPopperClass === null ? undefined : tipPopperClass" :popper-options="tipPopperOptions === null ? undefined : tipPopperOptions" :manual="tipManual === null ? undefined : tipManual" :tabindex="tipTabindex === null ? undefined : tipTabindex">
#>     <el-button type="primary">Hover me</el-button>
#>   </el-tooltip>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"tipValue":false,"tipContent":"Help","tipPlacement":null,"tipEffect":null,"tipDisabled":null,"tipOffset":null,"tipOpenDelay":null,"tipHideAfter":null,"tipEnterable":null,"tipVisibleArrow":null,"tipTransition":null,"tipPopperClass":null,"tipPopperOptions":null,"tipManual":null,"tipTabindex":null}},"input":null,"rate":null,"type":null,"evals":[]}</script>
#> </div>

# In a table cell, once per row
el_table("tasks", data = data.frame(task = c("Draft", "Review"), done = c(TRUE, FALSE)),
  columns = list(
    list(prop = "task", label = "Task"),
    list(label = "State", cell = el$tag(
      ":type" = "scope.row.done ? 'success' : 'info'",
      "{{ scope.row.done ? 'done' : 'open' }}"))))
#> <div id="tasks" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="tasks_container" style="display: contents">
#>   <el-table :data="tableData" :border="border" style="width: 100%" v-loading="loading" @selection-change="handleSelectionChange" @select="elEmitSelect" @select-all="elEmitSelectAll" @cell-click="elEmitCellClick" @cell-dblclick="elEmitCellDblclick" @cell-mouse-enter="elEmitCellMouseEnter" @cell-mouse-leave="elEmitCellMouseLeave" @row-click="elEmitRowClick" @row-dblclick="elEmitRowDblclick" @row-contextmenu="elEmitRowContextmenu" @header-click="elEmitHeaderClick" @header-contextmenu="elEmitHeaderContextmenu" @header-dragend="elEmitHeaderDragend" @sort-change="elEmitSortChange" @filter-change="elEmitFilterChange" @current-change="elEmitCurrentChange" @expand-change="elEmitExpandChange" :stripe="stripe === null ? undefined : stripe" :size="size === null ? undefined : size" :height="height === null ? undefined : height" :max-height="maxHeight === null ? undefined : maxHeight" :fit="fit === null ? undefined : fit" :show-header="showHeader === null ? undefined : showHeader" :highlight-current-row="highlightCurrentRow === null ? undefined : highlightCurrentRow" :current-row-key="currentRowKey === null ? undefined : currentRowKey" :row-key="rowKey === null ? undefined : rowKey" :empty-text="emptyText === null ? undefined : emptyText" :default-expand-all="defaultExpandAll === null ? undefined : defaultExpandAll" :expand-row-keys="expandRowKeys === null ? undefined : expandRowKeys" :default-sort="defaultSort === null ? undefined : defaultSort" :tooltip-effect="tooltipEffect === null ? undefined : tooltipEffect" :show-summary="showSummary === null ? undefined : showSummary" :sum-text="sumText === null ? undefined : sumText" :select-on-indeterminate="selectOnIndeterminate === null ? undefined : selectOnIndeterminate" :indent="indent === null ? undefined : indent" :lazy="lazy === null ? undefined : lazy" :tree-props="treeProps === null ? undefined : treeProps" :row-class-name="rowClassName === null ? undefined : rowClassName" :row-style="rowStyle === null ? undefined : rowStyle" :cell-class-name="cellClassName === null ? undefined : cellClassName" :cell-style="cellStyle === null ? undefined : cellStyle" :header-row-class-name="headerRowClassName === null ? undefined : headerRowClassName" :header-row-style="headerRowStyle === null ? undefined : headerRowStyle" :header-cell-class-name="headerCellClassName === null ? undefined : headerCellClassName" :header-cell-style="headerCellStyle === null ? undefined : headerCellStyle" :span-method="spanMethod === null ? undefined : spanMethod" :summary-method="summaryMethod === null ? undefined : summaryMethod" :load="load === null ? elLoad : load" :highlight-selection-row="highlightSelectionRow === null ? undefined : highlightSelectionRow">
#>     <el-table-column v-if="selection" type="selection" width="55"></el-table-column>
#>     <el-table-column v-for="col in (columns.length ? columns : autoColumns)" :key="col.prop" :prop="col.prop" :label="col.label" :width="col.width" :align="col.align" :header-align="col.headerAlign" :class-name="col.className" :label-class-name="col.labelClassName" :column-key="col.columnKey" :min-width="col.minWidth" :fixed="col.fixed" :resizable="col.resizable" :sortable="col.sortable" :sort-by="col.sortBy" :sort-orders="col.sortOrders" :show-overflow-tooltip="col.showOverflowTooltip" :filters="col.filters" :filtered-value="col.filteredValue" :filter-multiple="col.filterMultiple" :filter-placement="col.filterPlacement" :reserve-selection="col.reserveSelection" :index="col.index" :formatter="col.formatter" :filter-method="col.filterMethod" :sort-method="col.sortMethod" :render-header="col.renderHeader" :selectable="col.selectable" :type="col.type">
#>       <template v-slot:header="scope">
#>         <span v-if="col.headerHtml" v-html="col.headerHtml"></span>
#>         <span v-else>{{col.label}}</span>
#>       </template>
#>       <template v-slot:[col.slot]="scope">
#>         <template v-if="col.cellKey === &#39;cell_State&#39;">
#>           <el-tag :type="scope.row.done ? &#39;success&#39; : &#39;info&#39;">{{ scope.row.done ? 'done' : 'open' }}</el-tag>
#>         </template>
#>       </template>
#>     </el-table-column>
#>   </el-table>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"tableData":[{"task":"Draft","done":true},{"task":"Review","done":false}],"columns":[{"prop":"task","label":"Task","slot":"none"},{"label":"State","cellKey":"cell_State","slot":"default"}],"autoColumns":[{"prop":"task","label":"task","slot":"none"},{"prop":"done","label":"done","slot":"none"}],"border":false,"selection":false,"selected":[],"selectedRows":[],"loading":false,"stripe":null,"size":null,"height":null,"maxHeight":null,"fit":null,"showHeader":null,"highlightCurrentRow":null,"currentRowKey":null,"rowKey":null,"emptyText":null,"defaultExpandAll":null,"expandRowKeys":null,"defaultSort":null,"tooltipEffect":null,"showSummary":null,"sumText":null,"selectOnIndeterminate":null,"indent":null,"lazy":null,"treeProps":null,"rowClassName":null,"rowStyle":null,"cellClassName":null,"cellStyle":null,"headerRowClassName":null,"headerRowStyle":null,"headerCellClassName":null,"headerCellStyle":null,"spanMethod":null,"summaryMethod":null,"load":null,"highlightSelectionRow":null},"methods":{"elEmitSelect":"function() { var shape = function(selection, row) { var vm = this; return {rows: (selection || []).map(function(r) { return window.shinyElement.rowIndex(vm, r); }), row_index: window.shinyElement.rowIndex(vm, row)}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('tasks', 'select', [v]); }","elEmitSelectAll":"function() { var shape = function(selection) { var vm = this; return {rows: (selection || []).map(function(r) { return window.shinyElement.rowIndex(vm, r); })}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('tasks', 'select_all', [v]); }","elEmitCellClick":"function() { var shape = function(row, column) { var prop = window.shinyElement.colProp(column); return {row_index: window.shinyElement.rowIndex(this, row), row: row, column: prop, value: row[prop]}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('tasks', 'cell_click', [v]); }","elEmitCellDblclick":"function() { var shape = function(row, column) { var prop = window.shinyElement.colProp(column); return {row_index: window.shinyElement.rowIndex(this, row), row: row, column: prop, value: row[prop]}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('tasks', 'cell_dblclick', [v]); }","elEmitCellMouseEnter":"function() { var shape = function(row, column) { var prop = window.shinyElement.colProp(column); return {row_index: window.shinyElement.rowIndex(this, row), row: row, column: prop, value: row[prop]}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('tasks', 'cell_mouse_enter', [v]); }","elEmitCellMouseLeave":"function() { var shape = function(row, column) { var prop = window.shinyElement.colProp(column); return {row_index: window.shinyElement.rowIndex(this, row), row: row, column: prop, value: row[prop]}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('tasks', 'cell_mouse_leave', [v]); }","elEmitRowClick":"function() { var shape = function(row, column) { return {row_index: window.shinyElement.rowIndex(this, row), row: row, column: window.shinyElement.colProp(column)}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('tasks', 'row_click', [v]); }","elEmitRowDblclick":"function() { var shape = function(row, column) { return {row_index: window.shinyElement.rowIndex(this, row), row: row, column: window.shinyElement.colProp(column)}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('tasks', 'row_dblclick', [v]); }","elEmitRowContextmenu":"function() { var shape = function(row, column) { return {row_index: window.shinyElement.rowIndex(this, row), row: row, column: window.shinyElement.colProp(column)}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('tasks', 'row_contextmenu', [v]); }","elEmitHeaderClick":"function() { var shape = function(column) { return {column: window.shinyElement.colProp(column), label: column.label}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('tasks', 'header_click', [v]); }","elEmitHeaderContextmenu":"function() { var shape = function(column) { return {column: window.shinyElement.colProp(column), label: column.label}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('tasks', 'header_contextmenu', [v]); }","elEmitHeaderDragend":"function() { var shape = function(newWidth, oldWidth, column) { return {column: window.shinyElement.colProp(column), width: newWidth, previous_width: oldWidth}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('tasks', 'header_dragend', [v]); }","elEmitSortChange":"function() { var shape = function(s) { return {column: s.prop, order: s.order}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('tasks', 'sort_change', [v]); }","elEmitFilterChange":"function() { window.shinyVue.emit('tasks', 'filter_change', arguments); }","elEmitCurrentChange":"function() { var shape = function(row, old) { return {row_index: window.shinyElement.rowIndex(this, row), row: row, previous_index: window.shinyElement.rowIndex(this, old)}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('tasks', 'current_change', [v]); }","elEmitExpandChange":"function() { var shape = function(row, expanded) { var vm = this; return {row_index: window.shinyElement.rowIndex(this, row), expanded: Array.isArray(expanded) ? expanded.map(function(r) { return window.shinyElement.rowIndex(vm, r); }) : expanded}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('tasks', 'expand_change', [v]); }","elLoad":"function(row, treeNode, resolve) {\n  var key = this.rowKey && typeof this.rowKey === 'string' ? row[this.rowKey] : null;\n  window.shinyVue.ask('tasks_load', {key: key, row: row, level: treeNode ? treeNode.level : null})\n    .then(function(children) { resolve(children || []); });\n}","rowAction":"function(name, scope) { var se = window.shinyElement; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('tasks_' + name, {row_index: se.rowIndex(this, scope.row), row: window.shinyVue.plain(scope.row)}, {priority: 'event'}); }","handleSelectionChange":"function(selection) { var self = this; self.selected = selection; self.selectedRows = selection.map(function(r) { return self.tableData.indexOf(r) + 1; }); window.Shiny && Shiny.setInputValue && Shiny.setInputValue('tasks_selected', self.selected); window.Shiny && Shiny.setInputValue && Shiny.setInputValue('tasks_selected_rows', self.selectedRows); }"},"mounted":"function() { var self = this; var send = function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"tasks_selected\", self.selected); window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"tasks_selected_rows\", self.selectedRows); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } var prev = self._elReport; self._elReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"input":null,"rate":null,"type":null,"evals":["options.methods.elEmitSelect","options.methods.elEmitSelectAll","options.methods.elEmitCellClick","options.methods.elEmitCellDblclick","options.methods.elEmitCellMouseEnter","options.methods.elEmitCellMouseLeave","options.methods.elEmitRowClick","options.methods.elEmitRowDblclick","options.methods.elEmitRowContextmenu","options.methods.elEmitHeaderClick","options.methods.elEmitHeaderContextmenu","options.methods.elEmitHeaderDragend","options.methods.elEmitSortChange","options.methods.elEmitFilterChange","options.methods.elEmitCurrentChange","options.methods.elEmitExpandChange","options.methods.elLoad","options.methods.rowAction","options.methods.handleSelectionChange","options.mounted"]}</script>
#> </div>

# As the markup of a component of your own
el_widget("me", markup = el$avatar(":size" = "size", "{{ initials }}"),
          data = list(size = 48, initials = "KY"))
#> <div id="me" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="me_container" style="display: contents">
#>   <el-avatar :size="size">{{ initials }}</el-avatar>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"size":48,"initials":"KY"}},"input":null,"rate":null,"type":null,"evals":[]}</script>
#> </div>
```
