# Element Plus Table Component

Rows of data, with sorting, selection, fixed columns, cell templates and
row actions that report to the server.

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
  loading = FALSE,
  loading_options = NULL,
  allow_drag_last_column = NULL,
  append_filter_panel_to = NULL,
  flexible = NULL,
  native_scrollbar = NULL,
  preserve_expanded_content = NULL,
  row_expandable = NULL,
  scrollbar_always_on = NULL,
  scrollbar_tabindex = NULL,
  show_overflow_tooltip = NULL,
  table_layout = NULL,
  tooltip_formatter = NULL,
  tooltip_options = NULL,
  session = NULL,
  events = NULL,
  on = NULL
)

update_el_table(
  session = shiny::getDefaultReactiveDomain(),
  id,
  data = NULL,
  insert = NULL,
  replace = NULL,
  delete = NULL,
  at = NULL,
  columns = NULL,
  border = NULL,
  selection = NULL,
  loading = NULL,
  loading_options = NULL,
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
  expand_row_keys = NULL,
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
  allow_drag_last_column = NULL,
  append_filter_panel_to = NULL,
  flexible = NULL,
  native_scrollbar = NULL,
  preserve_expanded_content = NULL,
  row_expandable = NULL,
  scrollbar_always_on = NULL,
  scrollbar_tabindex = NULL,
  show_overflow_tooltip = NULL,
  table_layout = NULL,
  tooltip_formatter = NULL,
  tooltip_options = NULL
)
```

## Arguments

- id:

  The table's id. Leave it out: in an app the output's id is the
  table's. A table given an id in the UI still reports its inputs, but
  its data is then fixed in the page and `input$<id>_selection_change`
  gets its rows back through JSON rather than as R subsets them.

- data:

  A data.frame, or a list of rows (each a named list). A data.frame is
  converted to rows automatically and its column names are sanitised
  (`.` becomes `_`) so `el-table`'s dotted `prop` lookup works. A
  data.frame inside the rows, or in a list column, is rows too. A vector
  of one element travels as a single value, as in Shiny; wrap it in
  [`I()`](https://rdrr.io/r/base/AsIs.html) to keep it an array:
  `tags = I("red")`.

- columns:

  The columns, each an
  [`el_table_column()`](https://kaipingyang.github.io/shiny.element/reference/el_table_column.md)
  – or a list of the same fields, `list(prop =, label =, width =)`.
  Inferred from `data` when omitted. Beyond Element's column attributes,
  a column may carry:

  - `type` – `"index"` for row numbers, `"expand"` for a row that opens
    to show its `cell`, or `"selection"`.

  - `cell` – markup for each cell, rendered once per row. `scope.row`,
    `scope.column` and `scope.$index` are in reach, and raw Element tags
    (`el$tag()`, `el$button()`) work:
    `el$tag(":type" = "scope.row.ok ? 'success' : 'danger'", "{{ scope.row.status }}")`.
    A column without a `prop` – a column of buttons – is fine. See "Row
    actions" below.

  - `filter_icon` – the filter's icon, by name.

  - `header_html` – markup for the header cell, a string or htmltools
    tags, inserted unescaped, so pass only what you control.

  - `header` – a template for the header cell, as `cell` is for the
    others: components and all, `scope.column` and `scope.$index` in
    reach. `el$input(size = "small", ...)` puts a search box there.

  - `children` – the columns under a group header, as Element nests
    `el-table-column`: `list(label = "Address", children = list(...))`,
    as deep as you nest them; each child column takes `cell`, `header`
    and `header_html` as a top-level one does.

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

  Size: `"large"`, `"default"` or `"small"`; `NULL` follows the form or
  the page.

- height:

  Table height. Fixes the header and scrolls the body.

- max_height:

  Maximum table height, beyond which the body scrolls.

- fit:

  Whether column widths stretch to fill the table. Default `TRUE`.

- show_header:

  Whether the header row is shown. Default `TRUE`.

- highlight_current_row:

  Whether the clicked row stays highlighted; the row clicked arrives as
  `input$<id>_current_change`.

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

  Whether child rows of tree data are loaded on demand – from the
  server, unless `load` is given.

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

  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function deciding row/column spans for merged cells.

- summary_method:

  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function returning the summary row's cells.

- load:

  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function loading child rows in the browser instead of from the server.
  Needs `lazy = TRUE`.

- width:

  Component width, as a CSS unit. Replaces the table's default
  `width: 100%`. For a fixed header use `height` instead.

- slots:

  Named list of Element slot contents, such as
  `list(empty = shiny::tags$b("Nothing yet"))`. A shiny.element
  component given here is absorbed rather than nested. For a scoped
  slot, write the template with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).

- loading:

  Whether to cover the table with Element's loading mask, as its
  `v-loading` does. `update_el_table()` turns it on and off around slow
  work.

- loading_options:

  How the mask looks, as a list with the names of
  [`el_loading()`](https://kaipingyang.github.io/shiny.element/reference/el_loading.md)'s
  arguments – `text`, `spinner`, `svg`, `svg_view_box`, `background`,
  `custom_class` – Element's `element-loading-*` attributes.

- allow_drag_last_column:

  Whether to allow drag the last column. Element Plus's
  `allow-drag-last-column` (boolean).

- append_filter_panel_to:

  Which element the filter panels appends to. Element Plus's
  `append-filter-panel-to` (string).

- flexible:

  Ensure main axis minimum-size doesn't follow the content. Element
  Plus's `flexible` (boolean).

- native_scrollbar:

  Whether to use native scrollbars. Element Plus's `native-scrollbar`
  (boolean).

- preserve_expanded_content:

  Whether to preserve expanded row content in DOM when collapsed.
  Element Plus's `preserve-expanded-content` (boolean).

- row_expandable:

  Enable expandable rows, works when the table has a column
  type="expand". Element Plus's `row-expandable` ((row: any, index:
  number) =\> boolean).

- scrollbar_always_on:

  Always show scrollbar. Element Plus's `scrollbar-always-on` (boolean).

- scrollbar_tabindex:

  Body scrollbar's wrap container tabindex. Element Plus's
  `scrollbar-tabindex` (string / number).

- show_overflow_tooltip:

  Whether to hide extra content and show them in a tooltip when hovering
  on the cell.It will affect all the table columns, refer to table
  tooltip-options. Element Plus's `show-overflow-tooltip` (boolean).

- table_layout:

  Sets the algorithm used to lay out table cells, rows, and columns.
  Element Plus's `table-layout` ('fixed' \| 'auto').

- tooltip_formatter:

  Customize tooltip content when using `show-overflow-tooltip`. Element
  Plus's `tooltip-formatter` (Function). Give it as
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md).

- tooltip_options:

  The options for the overflow tooltip, see the following tooltip
  component. Element Plus's `tooltip-options` (object).

- session:

  In `el_table()`, deprecated: inside a module, wrap `id` in `ns()`, as
  for any Shiny input; a session given here namespaces `id` once more,
  with a warning. In `update_el_table()`, the Shiny session, the current
  one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- events:

  Element's events to report besides those reported unasked, by name:
  `events = "node_drop"` reports `input$<id>_node_drop`. The component's
  are listed under "Shiny inputs", and by
  [`el_events()`](https://kaipingyang.github.io/shiny.element/reference/el_events.md);
  a name it does not have is an error.

- on:

  Handlers of your own, for an event not reported or to send something
  else: a named list of
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  functions, one per event – Element's, or a DOM event with Vue's
  modifiers (`"keyup.enter"`). Each is called with `report` and the
  event's arguments; `report(name, value)` sets `input$<id>_<name>`. See
  [`el_widget()`](https://kaipingyang.github.io/shiny.element/reference/el_widget.md).

- insert:

  Rows to insert – a data.frame, or a list of rows – before row `at`, or
  at the end.

- replace:

  Rows to put in place of rows `at`, one for each.

- delete:

  Numbers of the rows to delete.

- at:

  Where `insert` goes, one row number; which rows `replace` replaces.
  Row numbers count the rows the table shows, as
  `input$<id>_selection_rows` does.

## Value

An `el_table` object, drawn as a table wherever UI goes.

## Details

In a Shiny app a table is an output, as DT's and reactable's are: the
page holds
[`el_table_output()`](https://kaipingyang.github.io/shiny.element/reference/el_table_output.md),
the server renders `el_table()` into it with
[`render_el_table()`](https://kaipingyang.github.io/shiny.element/reference/el_table_output.md),
and the output's id names the table's inputs. Without Shiny – R
Markdown, Quarto, a pkgdown page – `el_table()` is placed as it is, with
no id.

`el_table()` returns the table's specification, drawn when it is placed
(as an htmlwidget is).

## Shiny inputs

|  |  |  |
|----|----|----|
| Input | Reported | Value |
| `input$<id>_selection_rows` | unasked | the selected row numbers |
| `input$<id>_selection_change` | unasked | the selected rows, `data[rows, , drop = FALSE]` |
| `input$<id>_cell_edit` | unasked | an edited cell: `list(row, column, value, old)` |
| `input$<id>_load` | unasked | with `lazy = TRUE`, a row asking for its children; answer with [`el_load_children()`](https://kaipingyang.github.io/shiny.element/reference/el_load_children.md) |
| `input$<id>_select` | `events = "select"` | `list(rows, row_index)`: the selected row numbers, and the row ticked or unticked |
| `input$<id>_select_all` | `events = "select_all"` | `list(rows)`, the selected row numbers |
| `input$<id>_cell_mouse_enter` | `events = "cell_mouse_enter"` | `list(row_index, row, column, value)` |
| `input$<id>_cell_mouse_leave` | `events = "cell_mouse_leave"` | `list(row_index, row, column, value)` |
| `input$<id>_cell_click` | `events = "cell_click"` | `list(row_index, row, column, value)` |
| `input$<id>_cell_dblclick` | `events = "cell_dblclick"` | `list(row_index, row, column, value)` |
| `input$<id>_cell_contextmenu` | `events = "cell_contextmenu"` | `list(row_index, row, column, value)` |
| `input$<id>_row_click` | `events = "row_click"` | `list(row_index, row, column)` |
| `input$<id>_row_contextmenu` | `events = "row_contextmenu"` | `list(row_index, row, column)` |
| `input$<id>_row_dblclick` | `events = "row_dblclick"` | `list(row_index, row, column)` |
| `input$<id>_header_click` | `events = "header_click"` | `list(column, label)` |
| `input$<id>_header_contextmenu` | `events = "header_contextmenu"` | `list(column, label)` |
| `input$<id>_sort_change` | unasked | `list(column, order)` |
| `input$<id>_filter_change` | unasked | the filters, `list(<column key> = values)` |
| `input$<id>_current_change` | unasked | `list(row_index, row, previous_index)` |
| `input$<id>_header_dragend` | `events = "header_dragend"` | `list(column, width, previous_width)` |
| `input$<id>_expand_change` | unasked | `list(row_index, expanded)` |
| `input$<id>_scroll` | `events = "scroll"` | `list(scroll_left, scroll_top)`, at most every 200 ms |

The same list as `el_events("el_table")`, which says how an event's
arguments travel.

Rendered into `el_table_output("tbl")`, the inputs are `input$tbl_...`.
`input$tbl` itself is not used: Element's table has no value of its own
(no `v-model`), and the name stays free.

An edit is shown at once and applied to the server's copy of the data,
so
[`el_table_data()`](https://kaipingyang.github.io/shiny.element/reference/el_table_data.md)
and `input$tbl_selection_change` see it; an observer of
`input$tbl_cell_edit` saves it, or refuses it by putting the old value
back:
`update_el_table(session, "tbl", replace = row, at = input$tbl_cell_edit$row)`.

Row numbers count rows of the data the table shows, whatever the user's
sort – the data
[`el_table_data()`](https://kaipingyang.github.io/shiny.element/reference/el_table_data.md)
returns. Rendering the same data again keeps the user's ticks, sort and
open rows; new data clears the selection, as Element does, unless rows
carry a key: `row_key` and a selection column with
`reserve_selection = TRUE` keep the ticked rows that are still there.
Rows inserted, replaced or deleted with `update_el_table()` leave the
other rows' ticks alone.

With tree data, `lazy = TRUE` and no `load` of your own, the server
loads a row's children when it is opened: `input$<id>_load` asks, with
`key` (the row's `row_key` field), `row` and `request`; answer with
[`el_load_children()`](https://kaipingyang.github.io/shiny.element/reference/el_load_children.md).
A row with children to load carries `hasChildren = TRUE`.

## Row actions

A button in a `cell` reports back with `rowAction()`:

    list(label = "", cell = el$button(size = "small",
      "@click" = "rowAction('edit', scope)", "Edit"))

sets `input$<id>_edit` to `list(row_index =, row =)` – the 1-based row
number, to index your own data with, and the row as the table holds it.
It is an event input: clicking the same row twice reports twice.

## Element methods

Callable with
[`call_el()`](https://kaipingyang.github.io/shiny.element/reference/call_el.md):

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

## Updating from the server

Changes a table from the server, as
[`shiny::updateSelectInput()`](https://rdrr.io/pkg/shiny/man/updateSelectInput.html)
does a select: every argument of `el_table()` that can change once the
table is drawn, under the same name. One left `NULL` stays as it is;
`NA` returns a prop to Element's default. `rownames`, `slots`, `width`,
`events` and the `default_*` arguments, which are read only when the
table is created, are not here. A table in
[`el_table_output()`](https://kaipingyang.github.io/shiny.element/reference/el_table_output.md)
is reached by the output's id; rendering it again with
[`render_el_table()`](https://kaipingyang.github.io/shiny.element/reference/el_table_output.md)
does the same for any argument.

**Rows.** `data` replaces them all; `insert`, `replace` and `delete`
change a few and send only those, one of them per call. The server's
copy of the data
([`el_table_data()`](https://kaipingyang.github.io/shiny.element/reference/el_table_data.md))
is changed as R would change it –
[`rbind()`](https://rdrr.io/r/base/cbind.html) to insert,
`data[at, ] <- replace`, `data[-delete, ]` – and the browser gets the
rows as they then stand, so both hold the same data. Rows not touched
keep their ticks and open state; the selection's row numbers are
reported again, renumbered.

Data that comes from reactive expressions is best rendered: the table is
patched in place either way, and one render is one source of the data.
An update suits a change an observer makes – a row the user added,
edited or deleted. A render after an update leaves the update's rows in
place unless the render's own data changed.

A column's `cell` template is part of the table's markup, made when the
table is. New columns given here keep the template of the column with
the same `prop` (or label) and may drop it, but cannot bring a template
the table was not created with.

`update_el_table()` is called for its side effect and returns `NULL`
invisibly.

## Examples

``` r
# A data.frame is enough -- columns are inferred
el_table(data = head(iris, 3))
#> <div id="el_table_b5b7a982-7d7e-47c9-8330-8965571b8bf6" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="el_table_b5b7a982-7d7e-47c9-8330-8965571b8bf6_container" style="display: contents">
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
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"tableData":[{"Sepal_Length":5.1,"Sepal_Width":3.5,"Petal_Length":1.4,"Petal_Width":0.2,"Species":"setosa"},{"Sepal_Length":4.9,"Sepal_Width":3,"Petal_Length":1.4,"Petal_Width":0.2,"Species":"setosa"},{"Sepal_Length":4.7,"Sepal_Width":3.2,"Petal_Length":1.3,"Petal_Width":0.2,"Species":"setosa"}],"columns":[],"autoColumns":[{"prop":"Sepal_Length","label":"Sepal.Length","slot":"none"},{"prop":"Sepal_Width","label":"Sepal.Width","slot":"none"},{"prop":"Petal_Length","label":"Petal.Length","slot":"none"},{"prop":"Petal_Width","label":"Petal.Width","slot":"none"},{"prop":"Species","label":"Species","slot":"none"}],"border":false,"selection":false,"selected":[],"selectedRows":[],"editing":null,"restoredRows":[],"loading":false,"loadingAttrs":{},"stripe":null,"size":null,"height":null,"maxHeight":null,"fit":null,"showHeader":null,"highlightCurrentRow":null,"currentRowKey":null,"rowKey":null,"emptyText":null,"defaultExpandAll":null,"expandRowKeys":null,"defaultSort":null,"tooltipEffect":null,"showSummary":null,"sumText":null,"selectOnIndeterminate":null,"indent":null,"lazy":null,"treeProps":null,"rowClassName":null,"rowStyle":null,"cellClassName":null,"cellStyle":null,"headerRowClassName":null,"headerRowStyle":null,"headerCellClassName":null,"headerCellStyle":null,"spanMethod":null,"summaryMethod":null,"load":null,"allowDragLastColumn":null,"appendFilterPanelTo":null,"flexible":null,"nativeScrollbar":null,"preserveExpandedContent":null,"rowExpandable":null,"scrollbarAlwaysOn":null,"scrollbarTabindex":null,"showOverflowTooltip":null,"tableLayout":null,"tooltipFormatter":null,"tooltipOptions":null},"methods":{"svEmitSortChange":"function() { var shape = function(s) { return {column: s.prop, order: s.order}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('el_table_b5b7a982-7d7e-47c9-8330-8965571b8bf6', 'sort_change', [v]); }","svEmitFilterChange":"function() { window.shinyVue.emit('el_table_b5b7a982-7d7e-47c9-8330-8965571b8bf6', 'filter_change', arguments); }","svEmitCurrentChange":"function() { var shape = function(row, old) { return {row_index: window.shinyElement.rowIndex(this, row), row: row, previous_index: window.shinyElement.rowIndex(this, old)}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('el_table_b5b7a982-7d7e-47c9-8330-8965571b8bf6', 'current_change', [v]); }","svEmitExpandChange":"function() { var shape = function(row, expanded) { var vm = this; return {row_index: window.shinyElement.rowIndex(this, row), expanded: Array.isArray(expanded) ? expanded.map(function(r) { return window.shinyElement.rowIndex(vm, r); }) : expanded}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('el_table_b5b7a982-7d7e-47c9-8330-8965571b8bf6', 'expand_change', [v]); }","elLoad":"function(row, treeNode, resolve) {\n  var key = this.rowKey && typeof this.rowKey === 'string' ? row[this.rowKey] : null;\n  window.shinyVue.ask('el_table_b5b7a982-7d7e-47c9-8330-8965571b8bf6_load', {key: key, row: row, level: treeNode ? treeNode.level : null}, this)\n    .then(function(children) { resolve(children || []); },\n          function() { resolve([]); });\n}","rowAction":"function(name, scope) { var se = window.shinyElement; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('el_table_b5b7a982-7d7e-47c9-8330-8965571b8bf6_' + name, {row_index: se.rowIndex(this, scope.row), row: window.shinyVue.plain(scope.row)}, {priority: 'event'}); }","isEditing":"function(scope, prop) { var e = this.editing; return !!e && e.row === scope.row && e.prop === prop; }","startEdit":"function(scope, prop) { var self = this; self.editing = {row: scope.row, prop: prop, value: scope.row[prop], old: scope.row[prop]}; self.$nextTick(function() { var root = self.$el && self.$el.querySelector ? self.$el : document; var f = root.querySelector('.el-table-edit-cell__editor input, .el-table-edit-cell__editor textarea'); if (f) f.focus(); }); }","cancelEdit":"function() { this.editing = null; }","commitEdit":"function(move, scope, prop) { var e = this.editing; if (!e || (scope && (e.row !== scope.row || e.prop !== prop))) return; this.editing = null; if (e.value !== e.old) { e.row[e.prop] = e.value; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('el_table_b5b7a982-7d7e-47c9-8330-8965571b8bf6_cell_edit:shiny.element.cell_edit', {table: 'el_table_b5b7a982-7d7e-47c9-8330-8965571b8bf6', row: window.shinyElement.rowIndex(this, e.row), column: e.prop, value: e.value, old: e.old}, {priority: 'event'}); } if (!move) return; var props = []; (function walk(cols) { (cols || []).forEach(function(c) { if (c.editableProp) props.push(c.editableProp); walk(c.children); }); })(this.columns && this.columns.length ? this.columns : this.autoColumns); var i = props.indexOf(e.prop), r = this.tableData.indexOf(e.row); if (i < 0 || r < 0) return; if (i + 1 < props.length) i++; else { i = 0; r++; } if (r < this.tableData.length) this.startEdit({row: this.tableData[r]}, props[i]); }","reportSelection":"function() { var self = this; self.selectedRows = (self.selected || []).map(function(r) { return window.shinyElement.rowIndex(self, r); }); window.Shiny && Shiny.setInputValue && Shiny.setInputValue('el_table_b5b7a982-7d7e-47c9-8330-8965571b8bf6_selection_rows:shiny.element.rows', self.selectedRows); }","handleSelectionChange":"function(selection) { var self = this; self.selected = selection; self.reportSelection(); window.Shiny && Shiny.setInputValue && Shiny.setInputValue('el_table_b5b7a982-7d7e-47c9-8330-8965571b8bf6_selection_change:shiny.element.selection', {table: 'el_table_b5b7a982-7d7e-47c9-8330-8965571b8bf6', rows: self.selectedRows, data: window.shinyVue.plain(selection)}, {priority: 'event'}); }","shinyVueEdited":"function() { var self = this; this.$nextTick(function() { self.reportSelection(); }); }"},"watch":{"restoredRows":{"immediate":true,"handler":"function(rows) { var self = this; if (!rows || !rows.length) return; self.$nextTick(function() { var t = window.shinyVue.componentOf(self, 'ElTable'); if (!t) return; rows.forEach(function(i) { var r = self.tableData[i - 1]; if (r) t.toggleRowSelection(r, true); }); self.restoredRows = []; }); }"}},"mounted":"function() { var self = this; var send = function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"el_table_b5b7a982-7d7e-47c9-8330-8965571b8bf6_selection_rows:shiny.element.rows\", self.selectedRows); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } var prev = self._svReport; self._svReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"generated":true,"evals":["options.methods.svEmitSortChange","options.methods.svEmitFilterChange","options.methods.svEmitCurrentChange","options.methods.svEmitExpandChange","options.methods.elLoad","options.methods.rowAction","options.methods.isEditing","options.methods.startEdit","options.methods.cancelEdit","options.methods.commitEdit","options.methods.reportSelection","options.methods.handleSelectionChange","options.methods.shinyVueEdited","options.watch.restoredRows.handler","options.mounted"]}</script>
#> </div>

# Explicit columns
el_table(
  data = data.frame(name = c("A", "B"), value = c(1, 2)),
  columns = list(
    list(prop = "name", label = "Name"),
    list(prop = "value", label = "Value", width = "100")
  )
)
#> <div id="el_table_f5433220-d672-4fde-a791-3cf8880ae8e3" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="el_table_f5433220-d672-4fde-a791-3cf8880ae8e3_container" style="display: contents">
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
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"tableData":[{"name":"A","value":1},{"name":"B","value":2}],"columns":[{"prop":"name","label":"Name","slot":"none"},{"prop":"value","label":"Value","width":"100","slot":"none"}],"autoColumns":[{"prop":"name","label":"name","slot":"none"},{"prop":"value","label":"value","slot":"none"}],"border":false,"selection":false,"selected":[],"selectedRows":[],"editing":null,"restoredRows":[],"loading":false,"loadingAttrs":{},"stripe":null,"size":null,"height":null,"maxHeight":null,"fit":null,"showHeader":null,"highlightCurrentRow":null,"currentRowKey":null,"rowKey":null,"emptyText":null,"defaultExpandAll":null,"expandRowKeys":null,"defaultSort":null,"tooltipEffect":null,"showSummary":null,"sumText":null,"selectOnIndeterminate":null,"indent":null,"lazy":null,"treeProps":null,"rowClassName":null,"rowStyle":null,"cellClassName":null,"cellStyle":null,"headerRowClassName":null,"headerRowStyle":null,"headerCellClassName":null,"headerCellStyle":null,"spanMethod":null,"summaryMethod":null,"load":null,"allowDragLastColumn":null,"appendFilterPanelTo":null,"flexible":null,"nativeScrollbar":null,"preserveExpandedContent":null,"rowExpandable":null,"scrollbarAlwaysOn":null,"scrollbarTabindex":null,"showOverflowTooltip":null,"tableLayout":null,"tooltipFormatter":null,"tooltipOptions":null},"methods":{"svEmitSortChange":"function() { var shape = function(s) { return {column: s.prop, order: s.order}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('el_table_f5433220-d672-4fde-a791-3cf8880ae8e3', 'sort_change', [v]); }","svEmitFilterChange":"function() { window.shinyVue.emit('el_table_f5433220-d672-4fde-a791-3cf8880ae8e3', 'filter_change', arguments); }","svEmitCurrentChange":"function() { var shape = function(row, old) { return {row_index: window.shinyElement.rowIndex(this, row), row: row, previous_index: window.shinyElement.rowIndex(this, old)}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('el_table_f5433220-d672-4fde-a791-3cf8880ae8e3', 'current_change', [v]); }","svEmitExpandChange":"function() { var shape = function(row, expanded) { var vm = this; return {row_index: window.shinyElement.rowIndex(this, row), expanded: Array.isArray(expanded) ? expanded.map(function(r) { return window.shinyElement.rowIndex(vm, r); }) : expanded}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('el_table_f5433220-d672-4fde-a791-3cf8880ae8e3', 'expand_change', [v]); }","elLoad":"function(row, treeNode, resolve) {\n  var key = this.rowKey && typeof this.rowKey === 'string' ? row[this.rowKey] : null;\n  window.shinyVue.ask('el_table_f5433220-d672-4fde-a791-3cf8880ae8e3_load', {key: key, row: row, level: treeNode ? treeNode.level : null}, this)\n    .then(function(children) { resolve(children || []); },\n          function() { resolve([]); });\n}","rowAction":"function(name, scope) { var se = window.shinyElement; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('el_table_f5433220-d672-4fde-a791-3cf8880ae8e3_' + name, {row_index: se.rowIndex(this, scope.row), row: window.shinyVue.plain(scope.row)}, {priority: 'event'}); }","isEditing":"function(scope, prop) { var e = this.editing; return !!e && e.row === scope.row && e.prop === prop; }","startEdit":"function(scope, prop) { var self = this; self.editing = {row: scope.row, prop: prop, value: scope.row[prop], old: scope.row[prop]}; self.$nextTick(function() { var root = self.$el && self.$el.querySelector ? self.$el : document; var f = root.querySelector('.el-table-edit-cell__editor input, .el-table-edit-cell__editor textarea'); if (f) f.focus(); }); }","cancelEdit":"function() { this.editing = null; }","commitEdit":"function(move, scope, prop) { var e = this.editing; if (!e || (scope && (e.row !== scope.row || e.prop !== prop))) return; this.editing = null; if (e.value !== e.old) { e.row[e.prop] = e.value; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('el_table_f5433220-d672-4fde-a791-3cf8880ae8e3_cell_edit:shiny.element.cell_edit', {table: 'el_table_f5433220-d672-4fde-a791-3cf8880ae8e3', row: window.shinyElement.rowIndex(this, e.row), column: e.prop, value: e.value, old: e.old}, {priority: 'event'}); } if (!move) return; var props = []; (function walk(cols) { (cols || []).forEach(function(c) { if (c.editableProp) props.push(c.editableProp); walk(c.children); }); })(this.columns && this.columns.length ? this.columns : this.autoColumns); var i = props.indexOf(e.prop), r = this.tableData.indexOf(e.row); if (i < 0 || r < 0) return; if (i + 1 < props.length) i++; else { i = 0; r++; } if (r < this.tableData.length) this.startEdit({row: this.tableData[r]}, props[i]); }","reportSelection":"function() { var self = this; self.selectedRows = (self.selected || []).map(function(r) { return window.shinyElement.rowIndex(self, r); }); window.Shiny && Shiny.setInputValue && Shiny.setInputValue('el_table_f5433220-d672-4fde-a791-3cf8880ae8e3_selection_rows:shiny.element.rows', self.selectedRows); }","handleSelectionChange":"function(selection) { var self = this; self.selected = selection; self.reportSelection(); window.Shiny && Shiny.setInputValue && Shiny.setInputValue('el_table_f5433220-d672-4fde-a791-3cf8880ae8e3_selection_change:shiny.element.selection', {table: 'el_table_f5433220-d672-4fde-a791-3cf8880ae8e3', rows: self.selectedRows, data: window.shinyVue.plain(selection)}, {priority: 'event'}); }","shinyVueEdited":"function() { var self = this; this.$nextTick(function() { self.reportSelection(); }); }"},"watch":{"restoredRows":{"immediate":true,"handler":"function(rows) { var self = this; if (!rows || !rows.length) return; self.$nextTick(function() { var t = window.shinyVue.componentOf(self, 'ElTable'); if (!t) return; rows.forEach(function(i) { var r = self.tableData[i - 1]; if (r) t.toggleRowSelection(r, true); }); self.restoredRows = []; }); }"}},"mounted":"function() { var self = this; var send = function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"el_table_f5433220-d672-4fde-a791-3cf8880ae8e3_selection_rows:shiny.element.rows\", self.selectedRows); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } var prev = self._svReport; self._svReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"generated":true,"evals":["options.methods.svEmitSortChange","options.methods.svEmitFilterChange","options.methods.svEmitCurrentChange","options.methods.svEmitExpandChange","options.methods.elLoad","options.methods.rowAction","options.methods.isEditing","options.methods.startEdit","options.methods.cancelEdit","options.methods.commitEdit","options.methods.reportSelection","options.methods.handleSelectionChange","options.methods.shinyVueEdited","options.watch.restoredRows.handler","options.mounted"]}</script>
#> </div>

# A Shiny app: the table is an output, its inputs named after it
if (interactive()) {
  library(shiny)
  library(shiny.element)
  ui <- el_page(
    el_input_number("n", value = 5, min = 1),
    el_table_output("flowers"),
    verbatimTextOutput("picked")
  )
  server <- function(input, output, session) {
    output$flowers <- render_el_table(
      el_table(
        data = head(iris, input$n),
        selection = TRUE,
        events = "row_dblclick"
      )
    )
    # the ticked rows, as R subsets them
    output$picked <- renderPrint(input$flowers_selection_change)
    observeEvent(input$flowers_row_dblclick, {
      el_message(message = paste("Row", input$flowers_row_dblclick$row_index))
    })
  }
  shinyApp(ui, server)
}
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_table(session, "tbl", data = head(mtcars, 10))
  })
  # any other argument of el_table()
  update_el_table(session, "tbl", stripe = TRUE, table_layout = "auto")
  # back to Element's default
  update_el_table(session, "tbl", stripe = NA)
  # a few rows, leaving the rest as they are
  update_el_table(session, "tbl", insert = head(mtcars, 1), at = 1)
  update_el_table(session, "tbl", replace = mtcars[3, ], at = 3)
  update_el_table(session, "tbl", delete = c(2, 5))
}
```
