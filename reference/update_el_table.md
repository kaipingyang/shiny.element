# Update Element Plus Table

Changes a table from the server, as
[`shiny::updateSelectInput()`](https://rdrr.io/pkg/shiny/man/updateSelectInput.html)
does a select: every argument of
[`el_table()`](https://kaipingyang.github.io/shiny.element/reference/el_table.md)
that can change once the table is drawn, under the same name. One left
`NULL` stays as it is; `NA` returns a prop to Element's default.
`rownames`, `slots`, `width` and the `default_*` arguments, which
Element reads only when the table is created, are not here.

## Usage

``` r
update_el_table(
  session = shiny::getDefaultReactiveDomain(),
  id,
  data = NULL,
  columns = NULL,
  border = NULL,
  selection = NULL,
  loading = NULL,
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

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Table ID (un-namespaced).

- data:

  New data: a data.frame or a list of rows.

- columns:

  New column configs. Omitted, the table keeps the columns it was
  created with – labels, formatters, cell templates – and a table whose
  columns were inferred infers them again from the new `data`.
  [`list()`](https://rdrr.io/r/base/list.html) drops written columns and
  goes back to inferring them.

- border:

  New border state.

- selection:

  New row-selection state.

- loading:

  Show or hide the loading mask.

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

  Whether the clicked row stays highlighted; pairs with
  `input$<id>_current`.

- current_row_key:

  Key of the row highlighted at start. Needs `row_key`.

- row_key:

  Column whose value identifies a row. Needed for tree data and reserved
  selection.

- empty_text:

  Text shown when there are no rows. Default `"No Data"`.

- expand_row_keys:

  Keys of the rows that start expanded. Needs `row_key`.

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

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

A column's `cell` template is part of the table's markup, made when the
table is. New columns given here keep the template of the column with
the same `prop` (or label) and may drop it, but cannot bring a template
the table was not created with.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_table(session, "tbl", data = head(mtcars, 10))
  })
  # any other argument of el_table()
  update_el_table(session, "tbl", stripe = TRUE, table_layout = "auto")
  # back to Element's default
  update_el_table(session, "tbl", stripe = NA)
}
```
