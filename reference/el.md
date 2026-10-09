# Element Plus tags, for markup inside a component

A tag generator for every Element tag, as `tags$p` is for HTML:
`el$button(type = "primary", "Go")` writes `<el-button type="primary">`.
Nothing more – no Vue instance, no Shiny input, no id.

## Usage

``` r
el
```

## Value

A named list of tag-generating functions, one per Element Plus tag.

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

A logical attribute is a Vue boolean: `el$button(link = TRUE)` writes
`<el-button link>` and `plain = FALSE` writes `:plain="false"` – as
text, `link="TRUE"`, Element Plus would refuse it.

Mounting a Vue instance over such markup automatically is deliberately
not done: it would rebuild every component and Shiny input inside it,
leaving them on screen but disconnected from the server.

## Examples

``` r
names(el)
#>   [1] "button"              "button_group"        "link"               
#>   [4] "text"                "icon"                "scrollbar"          
#>   [7] "space"               "splitter"            "splitter_panel"     
#>  [10] "container"           "header"              "aside"              
#>  [13] "main"                "footer"              "row"                
#>  [16] "col"                 "config_provider"     "form"               
#>  [19] "form_item"           "input"               "input_number"       
#>  [22] "input_otp"           "input_tag"           "radio"              
#>  [25] "radio_group"         "radio_button"        "checkbox"           
#>  [28] "checkbox_button"     "checkbox_group"      "switch"             
#>  [31] "select"              "select_v2"           "option"             
#>  [34] "option_group"        "cascader"            "cascader_panel"     
#>  [37] "slider"              "time_picker"         "time_select"        
#>  [40] "date_picker"         "date_picker_panel"   "upload"             
#>  [43] "rate"                "color_picker"        "color_picker_panel" 
#>  [46] "transfer"            "autocomplete"        "mention"            
#>  [49] "tree_select"         "table"               "table_column"       
#>  [52] "table_v2"            "tag"                 "check_tag"          
#>  [55] "progress"            "tree"                "tree_v2"            
#>  [58] "pagination"          "badge"               "avatar"             
#>  [61] "avatar_group"        "calendar"            "card"               
#>  [64] "carousel"            "carousel_item"       "collapse"           
#>  [67] "collapse_item"       "timeline"            "timeline_item"      
#>  [70] "image"               "image_viewer"        "empty"              
#>  [73] "skeleton"            "skeleton_item"       "result"             
#>  [76] "statistic"           "countdown"           "descriptions"       
#>  [79] "descriptions_item"   "segmented"           "tour"               
#>  [82] "tour_step"           "affix"               "anchor"             
#>  [85] "anchor_link"         "menu"                "sub_menu"           
#>  [88] "menu_item"           "menu_item_group"     "tabs"               
#>  [91] "tab_pane"            "breadcrumb"          "breadcrumb_item"    
#>  [94] "dropdown"            "dropdown_menu"       "dropdown_item"      
#>  [97] "steps"               "step"                "page_header"        
#> [100] "backtop"             "dialog"              "alert"              
#> [103] "drawer"              "popover"             "tooltip"            
#> [106] "popconfirm"          "divider"             "watermark"          
#> [109] "collapse_transition" "auto_resizer"       

# As a wrapper's trigger, compiled by the tooltip's own instance
el_tooltip("hint", el$button(type = "primary", "Hover me"), content = "Help")
#> <div id="hint" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="hint_container" style="display: contents">
#>   <el-tooltip :content="tipContent === null ? undefined : tipContent" :placement="tipPlacement === null ? undefined : tipPlacement" :effect="tipEffect === null ? undefined : tipEffect" :disabled="tipDisabled === null ? undefined : tipDisabled" :offset="tipOffset === null ? undefined : tipOffset" :hide-after="tipHideAfter === null ? undefined : tipHideAfter" :enterable="tipEnterable === null ? undefined : tipEnterable" :transition="tipTransition === null ? undefined : tipTransition" :popper-class="tipPopperClass === null ? undefined : tipPopperClass" :popper-options="tipPopperOptions === null ? undefined : tipPopperOptions" :append-to="tipAppendTo === null ? undefined : tipAppendTo" :aria-label="tipAriaLabel === null ? undefined : tipAriaLabel" :arrow-offset="tipArrowOffset === null ? undefined : tipArrowOffset" :auto-close="tipAutoClose === null ? undefined : tipAutoClose" :fallback-placements="tipFallbackPlacements === null ? undefined : tipFallbackPlacements" :focus-on-target="tipFocusOnTarget === null ? undefined : tipFocusOnTarget" :persistent="tipPersistent === null ? undefined : tipPersistent" :popper-style="tipPopperStyle === null ? undefined : tipPopperStyle" :raw-content="tipRawContent === null ? undefined : tipRawContent" :show-after="tipShowAfter === null ? undefined : tipShowAfter" :show-arrow="tipShowArrow === null ? undefined : tipShowArrow" :teleported="tipTeleported === null ? undefined : tipTeleported" :trigger="tipTrigger === null ? undefined : tipTrigger" :trigger-keys="tipTriggerKeys === null ? undefined : tipTriggerKeys" :virtual-ref="$elRef(tipVirtualRef)" :virtual-triggering="tipVirtualTriggering === null ? undefined : tipVirtualTriggering" :visible="tipVisible === null ? undefined : tipVisible">
#>     <el-button type="primary">Hover me</el-button>
#>   </el-tooltip>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"tipContent":"Help","tipPlacement":null,"tipEffect":null,"tipDisabled":null,"tipOffset":null,"tipHideAfter":null,"tipEnterable":null,"tipTransition":null,"tipPopperClass":null,"tipPopperOptions":null,"tipAppendTo":null,"tipAriaLabel":null,"tipArrowOffset":null,"tipAutoClose":null,"tipFallbackPlacements":null,"tipFocusOnTarget":null,"tipPersistent":null,"tipPopperStyle":null,"tipRawContent":null,"tipShowAfter":null,"tipShowArrow":null,"tipTeleported":null,"tipTrigger":null,"tipTriggerKeys":null,"tipVirtualRef":null,"tipVirtualTriggering":null,"tipVisible":null}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"evals":[]}</script>
#> </div>

# In a table cell, once per row
el_table(
  "tasks",
  data = data.frame(task = c("Draft", "Review"), done = c(TRUE, FALSE)),
  columns = list(
    list(prop = "task", label = "Task"),
    list(
      label = "State",
      cell = el$tag(
        ":type" = "scope.row.done ? 'success' : 'info'",
        "{{ scope.row.done ? 'done' : 'open' }}"
      )
    )
  )
)
#> <div id="tasks" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="tasks_container" style="display: contents">
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
#>         <template v-else-if="col.cellKey === &#39;cell_State&#39;">
#>           <el-tag :type="scope.row.done ? &#39;success&#39; : &#39;info&#39;">{{ scope.row.done ? 'done' : 'open' }}</el-tag>
#>         </template>
#>       </template>
#>     </el-table-column>
#>   </el-table>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"tableData":[{"task":"Draft","done":true},{"task":"Review","done":false}],"columns":[{"prop":"task","label":"Task","slot":"none"},{"label":"State","cellKey":"cell_State","slot":"default"}],"autoColumns":[{"prop":"task","label":"task","slot":"none"},{"prop":"done","label":"done","slot":"none"}],"border":false,"selection":false,"selected":[],"selectedRows":[],"editing":null,"restoredRows":[],"loading":false,"loadingAttrs":{},"stripe":null,"size":null,"height":null,"maxHeight":null,"fit":null,"showHeader":null,"highlightCurrentRow":null,"currentRowKey":null,"rowKey":null,"emptyText":null,"defaultExpandAll":null,"expandRowKeys":null,"defaultSort":null,"tooltipEffect":null,"showSummary":null,"sumText":null,"selectOnIndeterminate":null,"indent":null,"lazy":null,"treeProps":null,"rowClassName":null,"rowStyle":null,"cellClassName":null,"cellStyle":null,"headerRowClassName":null,"headerRowStyle":null,"headerCellClassName":null,"headerCellStyle":null,"spanMethod":null,"summaryMethod":null,"load":null,"allowDragLastColumn":null,"appendFilterPanelTo":null,"flexible":null,"nativeScrollbar":null,"preserveExpandedContent":null,"rowExpandable":null,"scrollbarAlwaysOn":null,"scrollbarTabindex":null,"showOverflowTooltip":null,"tableLayout":null,"tooltipFormatter":null,"tooltipOptions":null},"methods":{"svEmitSortChange":"function() { var shape = function(s) { return {column: s.prop, order: s.order}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('tasks', 'sort_change', [v]); }","svEmitFilterChange":"function() { window.shinyVue.emit('tasks', 'filter_change', arguments); }","svEmitCurrentChange":"function() { var shape = function(row, old) { return {row_index: window.shinyElement.rowIndex(this, row), row: row, previous_index: window.shinyElement.rowIndex(this, old)}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('tasks', 'current_change', [v]); }","svEmitExpandChange":"function() { var shape = function(row, expanded) { var vm = this; return {row_index: window.shinyElement.rowIndex(this, row), expanded: Array.isArray(expanded) ? expanded.map(function(r) { return window.shinyElement.rowIndex(vm, r); }) : expanded}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('tasks', 'expand_change', [v]); }","elLoad":"function(row, treeNode, resolve) {\n  var key = this.rowKey && typeof this.rowKey === 'string' ? row[this.rowKey] : null;\n  window.shinyVue.ask('tasks_load', {key: key, row: row, level: treeNode ? treeNode.level : null}, this)\n    .then(function(children) { resolve(children || []); },\n          function() { resolve([]); });\n}","rowAction":"function(name, scope) { var se = window.shinyElement; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('tasks_' + name, {row_index: se.rowIndex(this, scope.row), row: window.shinyVue.plain(scope.row)}, {priority: 'event'}); }","isEditing":"function(scope, prop) { var e = this.editing; return !!e && e.row === scope.row && e.prop === prop; }","startEdit":"function(scope, prop) { var self = this; self.editing = {row: scope.row, prop: prop, value: scope.row[prop], old: scope.row[prop]}; self.$nextTick(function() { var root = self.$el && self.$el.querySelector ? self.$el : document; var f = root.querySelector('.el-table-edit-cell__editor input, .el-table-edit-cell__editor textarea'); if (f) f.focus(); }); }","cancelEdit":"function() { this.editing = null; }","commitEdit":"function(move, scope, prop) { var e = this.editing; if (!e || (scope && (e.row !== scope.row || e.prop !== prop))) return; this.editing = null; if (e.value !== e.old) { e.row[e.prop] = e.value; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('tasks_cell_edit:shiny.element.cell_edit', {table: 'tasks', row: window.shinyElement.rowIndex(this, e.row), column: e.prop, value: e.value, old: e.old}, {priority: 'event'}); } if (!move) return; var props = []; (function walk(cols) { (cols || []).forEach(function(c) { if (c.editableProp) props.push(c.editableProp); walk(c.children); }); })(this.columns && this.columns.length ? this.columns : this.autoColumns); var i = props.indexOf(e.prop), r = this.tableData.indexOf(e.row); if (i < 0 || r < 0) return; if (i + 1 < props.length) i++; else { i = 0; r++; } if (r < this.tableData.length) this.startEdit({row: this.tableData[r]}, props[i]); }","reportSelection":"function() { var self = this; self.selectedRows = (self.selected || []).map(function(r) { return window.shinyElement.rowIndex(self, r); }); window.Shiny && Shiny.setInputValue && Shiny.setInputValue('tasks_selection_rows:shiny.element.rows', self.selectedRows); }","handleSelectionChange":"function(selection) { var self = this; self.selected = selection; self.reportSelection(); window.Shiny && Shiny.setInputValue && Shiny.setInputValue('tasks_selection_change:shiny.element.selection', {table: 'tasks', rows: self.selectedRows, data: window.shinyVue.plain(selection)}, {priority: 'event'}); }","shinyVueEdited":"function() { var self = this; this.$nextTick(function() { self.reportSelection(); }); }"},"watch":{"restoredRows":{"immediate":true,"handler":"function(rows) { var self = this; if (!rows || !rows.length) return; self.$nextTick(function() { var t = window.shinyVue.componentOf(self, 'ElTable'); if (!t) return; rows.forEach(function(i) { var r = self.tableData[i - 1]; if (r) t.toggleRowSelection(r, true); }); self.restoredRows = []; }); }"}},"mounted":"function() { var self = this; var send = function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"tasks_selection_rows:shiny.element.rows\", self.selectedRows); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } var prev = self._svReport; self._svReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.svEmitSortChange","options.methods.svEmitFilterChange","options.methods.svEmitCurrentChange","options.methods.svEmitExpandChange","options.methods.elLoad","options.methods.rowAction","options.methods.isEditing","options.methods.startEdit","options.methods.cancelEdit","options.methods.commitEdit","options.methods.reportSelection","options.methods.handleSelectionChange","options.methods.shinyVueEdited","options.watch.restoredRows.handler","options.mounted"]}</script>
#> </div>

# As the markup of a component of your own
el_widget(
  "me",
  markup = el$avatar(":size" = "size", "{{ initials }}"),
  data = list(size = 48, initials = "KY")
)
#> <div id="me" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="me_container" style="display: contents">
#>   <el-avatar :size="size">{{ initials }}</el-avatar>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"size":48,"initials":"KY"}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"evals":[]}</script>
#> </div>
```
