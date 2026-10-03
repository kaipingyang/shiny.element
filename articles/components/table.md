# Table

Display multiple data with similar format. You can sort, filter, compare
your data in a table.

## Basic table

Basic table is just for data display.

After setting attribute `data` of `el-table` with an object array, you
can use `prop` (corresponding to a key of the object in `data` array) in
`el-table-column` to insert data to table columns, and set the attribute
`label` to define the column name. You can also use the attribute
`width` to define the width of columns.

``` r

el_table("cars", data = head(mtcars[, 1:5], 4))
```

## Striped Table

Striped table makes it easier to distinguish different rows.

Attribute `stripe` accepts a `Boolean`. If `true`, table will be
striped.

``` r

el_table("striped", data = head(mtcars[, 1:5], 4), stripe = TRUE)
```

## Table with border

By default, Table has no vertical border. If you need it, you can set
attribute `border` to `true`.

``` r

el_table("bordered", data = head(mtcars[, 1:5], 4), border = TRUE)
```

## Table with status

You can highlight your table content to distinguish between “success,
information, warning, danger” and other states.

Use `row-class-name` in `el-table` to add custom classes to a certain
row. Then you can style it with custom classes.

``` r

tagList(
  tags$style(
    ".el-table .warning-row { background: oldlace; }
              .el-table .success-row { background: #f0f9eb; }"
  ),
  el_table(
    "status",
    data = head(mtcars[, 1:4], 4),
    row_class_name = JS(
      "function({row, rowIndex}) {",
      "  return rowIndex === 1 ? 'warning-row' : rowIndex === 3 ? 'success-row' : '';",
      "}"
    )
  )
)
```

## Table with show overflow tooltip

When the content is too long, it will break into multiple lines, you can
use `show-overflow-tooltip` to keep it in one line.

Attribute `show-overflow-tooltip`, which accepts a `Boolean` value. When
set `true`, the extra content will show in tooltip when hover on the
cell.

``` r

el_table(
  "tt",
  show_overflow_tooltip = TRUE,
  data = data.frame(
    date = c("2016-05-03", "2016-05-02", "2016-05-04", "2016-05-01"),
    name = "Tom",
    address = "No. 189, Grove St, Los Angeles, a long address that runs on"
  ),
  columns = list(
    list(prop = "date", label = "Date", width = 120),
    list(prop = "name", label = "Name", width = 120),
    list(prop = "address", label = "Address", width = 200)
  )
)
```

## Table with fixed header

When there are too many rows, you can use a fixed header.

By setting the attribute `height` of `el-table`, you can fix the table
header without any other codes.

``` r

el_table("fixedhead", data = iris, height = "250px")
```

## Table with fixed column

When there are too many columns, you can fix some of them.

Attribute `fixed` is used in `el-table-column`, it accepts a `Boolean`.
If `true`, the column will be fixed at left. It also accepts two string
literals: ‘left’ and ‘right’, both indicating that the column will be
fixed at corresponding direction.

``` r

el_table(
  "fixedcol",
  data = head(mtcars, 4),
  border = TRUE,
  columns = c(
    list(list(prop = "mpg", label = "MPG", width = "120", fixed = TRUE)),
    lapply(names(mtcars)[-1], function(n) {
      list(prop = n, label = n, width = "120")
    }),
    list(list(
      label = "Operations",
      width = "120",
      fixed = "right",
      cell = el$button(link = TRUE, size = "small", "Detail")
    ))
  )
)
```

## Table with fixed columns and header

When you have huge chunks of data to put in a table, you can fix the
header and columns at the same time.

Fix columns and header at the same time by combining the above two
examples.

``` r

el_table(
  "fixedboth",
  data = head(mtcars, 12),
  height = "250px",
  columns = c(
    list(list(prop = "mpg", label = "MPG", width = "120", fixed = TRUE)),
    lapply(names(mtcars)[-1], function(n) {
      list(prop = n, label = n, width = "120")
    })
  )
)
```

## Fluid-height Table with fixed header (and columns)

When the the data is dynamically changed, you might want the table to
have a maximum height rather than a fixed height and to show the scroll
bar if needed.

By setting the attribute `max-height` of `el-table`, you can fix the
table header. The table body scrolls only if the height of the rows
exceeds the max height value.

``` r

el_table("fluid", data = head(mtcars[, 1:5], 10), max_height = "250px")
```

## Grouping table head

When the data structure is complex, you can use group header to show the
data hierarchy.

Only need to place el-table-column inside a el-table-column, you can
achieve group header.

``` r

people <- data.frame(
  date = "2016-05-03",
  name = "Tom",
  state = "California",
  city = "Los Angeles",
  address = "No. 189, Grove St",
  zip = "CA 90036"
)
el_table(
  "grouped",
  data = people[rep(1, 3), ],
  border = TRUE,
  columns = list(
    list(prop = "date", label = "Date", width = "150"),
    list(
      label = "Delivery Info",
      children = list(
        list(prop = "name", label = "Name", width = "120"),
        list(
          label = "Address Info",
          children = list(
            list(prop = "state", label = "State", width = "120"),
            list(prop = "city", label = "City", width = "120"),
            list(prop = "address", label = "Address"),
            list(prop = "zip", label = "Zip", width = "120")
          )
        )
      )
    )
  )
)
```

## Table with fixed group header

fixed group head is supported

The attribute `fixed` of the group header is determined by the outermost
`el-table-column`

``` r

el_table(
  "fg",
  height = "250px",
  data = data.frame(
    date = c("2016-05-03", "2016-05-02", "2016-05-04", "2016-05-01"),
    name = "Tom",
    address = "No. 189, Grove St, Los Angeles, a long address that runs on"
  ),
  columns = list(
    list(prop = "date", label = "Date", width = 150, fixed = "left"),
    list(
      label = "Delivery Info",
      children = list(
        list(prop = "name", label = "Name", width = 120),
        list(
          label = "Address Info",
          children = list(list(
            prop = "address",
            label = "Address",
            width = 300
          ))
        )
      )
    )
  )
)
```

## Single select

Single row selection is supported.

Table supports single row selection. You can activate it by adding the
`highlight-current-row` attribute. An event called `current-change` will
be triggered when row selection changes, and its parameters are the rows
after and before this change: `currentRow` and `oldCurrentRow`. If you
need to display row index, you can add a new `el-table-column` with its
`type` attribute assigned to `index`, and you will see the index
starting from 1.

``` r

ui <- el_page(
  el_table("single", data = head(iris, 4), highlight_current_row = TRUE),
  el_button("second", "Select second row"),
  el_button("clear", "Clear selection"),
  verbatimTextOutput("current")
)

server <- function(input, output, session) {
  observeEvent(
    input$second,
    el_call(session, "single", "setCurrentRow", list(el_table_row(2)))
  )
  observeEvent(input$clear, el_call(session, "single", "setCurrentRow"))
  output$current <- renderPrint(input$single_current_change$row_index)
}

shinyApp(ui, server)
```

![The single-select example,
running](../../shots/table-single-select.png)

## Multiple select

You can also select multiple rows.

After 2.8.3, `toggleRowSelection` supports the third parameter
`ignoreSelectable` to determine whether to ignore the selectable
attribute.

Activating multiple selection is easy: simply add an `el-table-column`
with its `type` set to `selection`.

``` r

cars <- head(mtcars[, 1:4], 5)

ui <- el_page(
  el_table("cars", data = cars, selection = TRUE),
  el_button("toggle", "Toggle rows 2 and 3"),
  el_button("none", "Clear selection"),
  verbatimTextOutput("picked")
)

server <- function(input, output, session) {
  observeEvent(
    input$toggle,
    for (i in 2:3) {
      el_call(session, "cars", "toggleRowSelection", list(el_table_row(i)))
    }
  )
  observeEvent(input$none, el_call(session, "cars", "clearSelection"))
  output$picked <- renderPrint(cars[input$cars_selected_rows, ])
}

shinyApp(ui, server)
```

![The multi-select example, running](../../shots/table-multi-select.png)

## Sorting

Sort the data to find or compare data quickly.

Set attribute `sortable` in a certain column to sort the data based on
this column. It accepts `Boolean` with a default value `false`. Set
table attribute `default-sort` to determine default sort column and
order. To apply your own sorting rules, use `sort-method` or `sort-by`.
If you need remote sorting from backend, set `sortable` to `custom`, and
listen to the `sort-change` event on Table. In the event handler, you
have access to the sorting column and sorting order so that you can
fetch sorted table data from API. In this example we use another
attribute named `formatter` to format the value of certain columns. It
accepts a function which has two parameters: `row` and `column`. You can
handle it according to your own needs.

``` r

el_table(
  "sorted",
  data = head(mtcars[, 1:4], 6),
  default_sort = list(prop = "mpg", order = "descending"),
  columns = list(
    list(prop = "mpg", label = "MPG", sortable = TRUE),
    list(prop = "cyl", label = "Cylinders", sortable = TRUE),
    list(prop = "disp", label = "Displacement")
  )
)
```

## Filter

Filter the table to find desired data.

Set attribute `filters` and `filter-method` in `el-table-column` makes
this column filterable. `filters` is an array, and `filter-method` is a
function deciding which rows are displayed. It has three parameters:
`value`, `row` and `column`.

``` r

staff <- data.frame(
  name = c("Tom", "Ada", "Linus", "Grace"),
  tag = c("Home", "Office", "Home", "Office")
)
el_table(
  "filtered",
  data = staff,
  columns = list(
    list(prop = "name", label = "Name"),
    list(
      prop = "tag",
      label = "Tag",
      filters = list(
        list(text = "Home", value = "Home"),
        list(text = "Office", value = "Office")
      ),
      filter_method = JS("function(value, row) { return row.tag === value; }"),
      cell = el$tag(
        ":type" = "scope.row.tag === 'Home' ? 'primary' : 'success'",
        "disable-transitions" = NA,
        "{{ scope.row.tag }}"
      )
    )
  )
)
```

## Custom column template

Customize table column so it can be integrated with other components.

You have access to the following data: row, column, \$index and store
(state management of Table) by
[slot](https://v3.vuejs.org/guide/component-slots.html).

``` r

tasks <- data.frame(
  task = c("Draft", "Review", "Publish"),
  done = c(100, 60, 0)
)

ui <- el_page(
  el_table(
    "tasks",
    data = tasks,
    columns = list(
      list(prop = "task", label = "Task"),
      list(
        prop = "done",
        label = "Progress",
        cell = el$progress(":percentage" = "scope.row.done")
      ),
      list(
        label = "Operations",
        cell = tagList(
          el$button(
            size = "small",
            "@click" = "rowAction('edit', scope)",
            "Edit"
          ),
          el$button(
            size = "small",
            type = "danger",
            "@click" = "rowAction('delete', scope)",
            "Delete"
          )
        )
      )
    )
  ),
  verbatimTextOutput("which")
)

server <- function(input, output, session) {
  output$which <- renderPrint(list(
    edit = input$tasks_edit$row_index,
    delete = input$tasks_delete$row_index
  ))
}

shinyApp(ui, server)
```

![The custom-column example,
running](../../shots/table-custom-column.png)

## Table with custom header

Customize table header so it can be even more customized.

You can customize how the header looks by header
[slots](https://v3.vuejs.org/guide/component-slots.html).

``` r

el_table(
  "hdr",
  data = head(mtcars[, 1:3], 3),
  columns = list(
    list(
      prop = "mpg",
      label = "MPG",
      header_html = "<b>MPG</b> <small>(miles/gallon)</small>"
    ),
    list(prop = "cyl", label = "Cylinders"),
    list(prop = "disp", label = "Displacement")
  )
)
```

## Expandable row

When the row content is too long and you do not want to display the
horizontal scroll bar, you can use the expandable row feature.

After 2.9.7, `preserve-expanded-content` is added to control whether to
preserve expanded row content in DOM when collapsed.

Activate expandable row by adding type=“expand” and slot. The template
for el-table-column will be rendered as the contents of the expanded
row, and you can access the same attributes as when you are using `slot`
in custom column templates.

``` r

el_table(
  "exp",
  data = data.frame(
    name = c("Tom", "Ada"),
    city = c("Los Angeles", "London"),
    shop = c("No. 189, Grove St", "1 Baker St")
  ),
  default_expand_all = TRUE,
  columns = list(
    list(
      type = "expand",
      cell = tags$p("City: {{ scope.row.city }} -- Shop: {{ scope.row.shop }}")
    ),
    list(prop = "name", label = "Name")
  )
)
```

## Tree data and lazy mode

You can display tree structure data. When row contains the `children`
field, it is treated as nested data. For rendering nested data, the prop
`row-key` is required. Also, child row data can be loaded
asynchronously. Set `lazy` property of Table to true and the function
`load`. Specify `hasChildren` attribute in row to determine which row
contains children. Both `children` and `hasChildren` can be configured
via `tree-props`.

``` r

teams <- data.frame(
  id = c(1, 2),
  name = c("Engineering", "Design"),
  size = c(42, 9),
  hasChildren = c(TRUE, FALSE)
)

ui <- el_page(el_table(
  "teams",
  data = teams,
  row_key = "id",
  lazy = TRUE,
  columns = list(
    list(prop = "name", label = "Team"),
    list(prop = "size", label = "People")
  )
))

server <- function(input, output, session) {
  observeEvent(input$teams_load, {
    el_load_children(
      id = "teams",
      request = input$teams_load,
      children = data.frame(
        id = c(11, 12),
        name = c("Platform", "Product"),
        size = c(18, 24)
      )
    )
  })
}

shinyApp(ui, server)
```

![The tree-and-lazy example,
running](../../shots/table-tree-and-lazy.png)

## Selectable tree

When `treeProps.checkStrictly` is true, the selection state of parent
and child nodes is no longer associated, that is, when the parent node
is selected, its child nodes will not be selected; when
`treeProps.checkStrictly` is false, the selection state of parent and
child nodes will be associated with the selection state of child nodes,
that is, when the parent node is selected, all its child nodes will be
selected.

A tree table’s rows tick on their own, not with their children.

``` r

el_table(
  "strict",
  row_key = "id",
  selection = TRUE,
  default_expand_all = TRUE,
  data = list(
    list(id = 1, date = "2016-05-02", name = "Tom"),
    list(
      id = 3,
      date = "2016-05-01",
      name = "Tom",
      children = list(
        list(id = 31, date = "2016-05-01", name = "Tom"),
        list(id = 32, date = "2016-05-01", name = "Tom")
      )
    )
  ),
  columns = list(
    list(prop = "date", label = "Date"),
    list(prop = "name", label = "Name")
  )
)
```

## Summary row

For table of numbers, you can add an extra row at the table footer
displaying each column’s sum.

You can add the summary row by setting `show-summary` to `true`. By
default, for the summary row, the first column does not sum anything up
but always displays ‘Sum’ (you can configure the displayed text using
`sum-text`), while other columns sum every number in that column up and
display them. You can of course define your own sum behaviour. To do so,
pass a method to `summary-method`, which returns an array, and each
element of the returned array will be displayed in the columns of the
summary row, It can be a VNode or string. The second table of this
example is a detailed demo.

``` r

el_table(
  "sums",
  data = head(mtcars[, c("mpg", "hp", "wt")], 5),
  show_summary = TRUE,
  sum_text = "Total",
  border = TRUE
)
```

## Rowspan and colspan

Configuring rowspan and colspan allows you to merge cells

Use the `span-method` attribute to configure rowspan and colspan. It
accepts a method, and passes an object to that method including current
row `row`, current column `column`, current row index `rowIndex` and
current column index `columnIndex`. The method should return an array of
two numbers, the first number being `rowspan` and second `colspan`. It
can also return an object with `rowspan` and `colspan` props.

``` r

el_table(
  "spans",
  data = head(mtcars[, 1:4], 6),
  border = TRUE,
  span_method = JS(
    "function({row, column, rowIndex, columnIndex}) {",
    "  if (columnIndex === 0) return rowIndex % 2 === 0 ? [2, 1] : [0, 0];",
    "}"
  )
)
```

## Custom index

You can customize row index in `type=index` columns.

To customize row indices, use `index` attribute on `el-table-column`
with `type=index`. If it is assigned to a number, all indices will have
an offset of that number. It also accepts a method with each index
(starting from `0`) as parameter, and the returned value will be
displayed as index.

``` r

el_table(
  "idx",
  data = head(iris[, c(1, 5)], 4),
  columns = list(
    list(type = "index", index = JS("function(i) { return i * 2; }")),
    list(prop = "Sepal_Length", label = "Sepal length"),
    list(prop = "Species", label = "Species")
  )
)
```

## Table Layout

The
[table-layout](https://developer.mozilla.org/en-US/docs/Web/CSS/table-layout)
property sets the algorithm used to lay out table cells, rows, and
columns.

``` r

el_table(
  "layout_auto",
  table_layout = "auto",
  data = data.frame(
    date = c("2016-05-03", "2016-05-02", "2016-05-04", "2016-05-01"),
    name = "Tom",
    address = "No. 189, Grove St, Los Angeles, a long address that runs on"
  )
)
```

## Tooltip formatter

You can use `tooltip-formatter` to customize the tooltip content.

``` r

el_table(
  "tt_fmt",
  show_overflow_tooltip = TRUE,
  data = data.frame(
    date = c("2016-05-03", "2016-05-02", "2016-05-04", "2016-05-01"),
    name = "Tom",
    address = "No. 189, Grove St, Los Angeles, a long address that runs on"
  ),
  tooltip_formatter = JS("function(d) { return 'Address: ' + d.row.address; }"),
  columns = list(
    list(prop = "date", label = "Date", width = 120),
    list(prop = "address", label = "Address", width = 200)
  )
)
```

## API

Element Plus’s tables, and beside each entry where it is in R.

### Table Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `data` | `data` | table data | [^1]`any[]` |  | \[\] |
| `height` | `height` | table’s height. By default it has an `auto` height. If its value is a number, the height is measured in pixels; if its value is a string, the value will be assigned to element’s style.height, the height is affected by external styles | [^2] / [^3] |  | — |
| `max-height` | `max_height` | table’s max-height. The legal value is a number or the height in px | [^4] / [^5] |  | — |
| `stripe` | `stripe` | whether Table is striped | [^6] |  | false |
| `border` | `border` | whether Table has vertical border | [^7] |  | false |
| `size` | `size` | size of Table | [^8]`'' \\| 'large' \\| 'default' \\| 'small'` |  | — |
| `fit` | `fit` | whether width of column automatically fits its container | [^9] |  | true |
| `show-header` | `show_header` | whether Table header is visible | [^10] |  | true |
| `highlight-current-row` | `highlight_current_row` | whether current row is highlighted | [^11] |  | false |
| `current-row-key` | `current_row_key` | key of current row, a set only prop | [^12] / [^13] |  | — |
| `row-class-name` | `row_class_name` | function that returns custom class names for a row, or a string assigning class names for every row | [^14]`(data: { row: any, rowIndex: number }) => string` / [^15] |  | — |
| `row-style` | `row_style` | function that returns custom style for a row, or an object assigning custom style for every row | [^16]`(data: { row: any, rowIndex: number }) => CSSProperties` / [^17]`CSSProperties` |  | — |
| `cell-class-name` | `cell_class_name` | function that returns custom class names for a cell, or a string assigning class names for every cell | [^18]`(data: { row: any, column: TableColumnCtx<T>, rowIndex: number, columnIndex: number }) => string` / [^19] |  | — |
| `cell-style` | `cell_style` | function that returns custom style for a cell, or an object assigning custom style for every cell | [^20]`(data: { row: any, column: TableColumnCtx<T>, rowIndex: number, columnIndex: number }) => CSSProperties` / [^21]`CSSProperties` |  | — |
| `header-row-class-name` | `header_row_class_name` | function that returns custom class names for a row in table header, or a string assigning class names for every row in table header | [^22]`(data: { row: any, rowIndex: number }) => string` / [^23] |  | — |
| `header-row-style` | `header_row_style` | function that returns custom style for a row in table header, or an object assigning custom style for every row in table header | [^24]`(data: { row: any, rowIndex: number }) => CSSProperties` / [^25]`CSSProperties` |  | — |
| `header-cell-class-name` | `header_cell_class_name` | function that returns custom class names for a cell in table header, or a string assigning class names for every cell in table header | [^26]`(data: { row: any, column: TableColumnCtx<T>, rowIndex: number, columnIndex: number }) => string` / [^27] |  | — |
| `header-cell-style` | `header_cell_style` | function that returns custom style for a cell in table header, or an object assigning custom style for every cell in table header | [^28]`(data: { row: any, column: TableColumnCtx<T>, rowIndex: number, columnIndex: number }) => CSSProperties` / [^29]`CSSProperties` |  | — |
| `row-key` | `row_key` | key of row data, used for optimizing rendering. Required if `reserve-selection` is on or display tree data. When its type is String, multi-level access is supported, e.g. `user.info.id`, but `user.info[0].id` is not supported, in which case `Function` should be used | [^30]`(row: any) => string` / [^31] |  | — |
| `empty-text` | `empty_text` | displayed text when data is empty. You can customize this area with `#empty` | [^32] |  | No Data |
| `default-expand-all` | `default_expand_all` | whether expand all rows by default, works when the table has a column type=“expand” or contains tree structure data | [^33] |  | false |
| `expand-row-keys` | `expand_row_keys` | set expanded rows by this prop, prop’s value is the keys of expand rows, you should set row-key before using this prop. | [^34]`Array<string>` |  | — |
| `default-sort` | `default_sort` | set the default sort column and order. property `prop` is used to set default sort column, property `order` is used to set default sort order | [^35]`Sort` |  | if `prop` is set, and `order` is not set, then `order` is default to ascending |
| `tooltip-effect` | `tooltip_effect` | the `effect` of the overflow tooltip | [^36]`'dark' \\| 'light'` |  | dark |
| `tooltip-options` | `tooltip_options` | the options for the overflow tooltip, [see the following tooltip component](https://kaipingyang.github.io/shiny.element/articles/components/tooltip.html#attributes) | [^37]`Pick<ElTooltipProps, 'effect' \\| 'enterable' \\| 'hideAfter' \\| 'offset' \\| 'placement' \\| 'popperClass' \\| 'popperOptions' \\| 'showAfter' \\| 'showArrow'>` |  | [^38]`{ enterable: true, placement: 'top', showArrow: true, hideAfter: 200, popperOptions: { strategy: 'fixed' } }` |
| `append-filter-panel-to` | `append_filter_panel_to` | which element the filter panels appends to | [^39] |  | — |
| `show-summary` | `show_summary` | whether to display a summary row | [^40] |  | false |
| `sum-text` | `sum_text` | displayed text for the first column of summary row | [^41] |  | Sum |
| `summary-method` | `summary_method` | custom summary method | [^42]`(data: { columns: any[], data: any[] }) => (VNode \\| string)[]` |  | — |
| `span-method` | `span_method` | method that returns rowspan and colspan | [^43]`(data: { row: any, column: TableColumnCtx<T>, rowIndex: number, columnIndex: number }) => number[] \\| { rowspan: number, colspan: number } \\| void` |  | — |
| `select-on-indeterminate` | `select_on_indeterminate` | controls the behavior of master checkbox in multi-select tables when only some rows are selected (but not all). If true, all rows will be selected, else deselected | [^44] |  | true |
| `indent` | `indent` | horizontal indentation of tree data | [^45] |  | 16 |
| `lazy` | `lazy` | whether to lazy loading data | [^46] |  | false |
| `load` | `load` | method for loading child row data, only works when `lazy` is true | [^47]`(row: any, treeNode: TreeNode, resolve: (data: any[]) => void) => void` |  | — |
| `tree-props` | `tree_props` | configuration for rendering nested data | [^48]`{ hasChildren?: string, children?: string, checkStrictly?: boolean }` |  | [^49]`{ hasChildren: 'hasChildren', children: 'children', checkStrictly: false }` |
| `table-layout` | `table_layout` | sets the algorithm used to lay out table cells, rows, and columns | [^50]`'fixed' \\| 'auto'` |  | fixed |
| `scrollbar-always-on` | `scrollbar_always_on` | always show scrollbar | [^51] |  | false |
| `show-overflow-tooltip` | `show_overflow_tooltip` | whether to hide extra content and show them in a tooltip when hovering on the cell.It will affect all the table columns, refer to table [tooltip-options](#table-attributes) | [^52] / [`object`](#table-attributes) ^(2.3.7) |  | — |
| `flexible` | `flexible` | ensure main axis minimum-size doesn’t follow the content | [^53] |  | false |
| `scrollbar-tabindex` | `scrollbar_tabindex` | body scrollbar’s wrap container tabindex | [^54] / [^55] |  | — |
| `allow-drag-last-column` | `allow_drag_last_column` | whether to allow drag the last column | [^56] |  | true |
| `tooltip-formatter` | `tooltip_formatter` | customize tooltip content when using `show-overflow-tooltip` | [^57]`(data: { row: any, column: TableColumnCtx<T>, cellValue: any }) => VNode \\| string` |  | — |
| `preserve-expanded-content` | `preserve_expanded_content` | whether to preserve expanded row content in DOM when collapsed | [^58] |  | false |
| `native-scrollbar` | `native_scrollbar` | whether to use native scrollbars | [^59] |  | false |
| `row-expandable` | `row_expandable` | enable expandable rows, works when the table has a column type=“expand” | [^60]`(row: any, index: number) => boolean` |  | — |

### Table Events

| Element | In R | Description |
|----|----|----|
| `select` | `input$<id>_select` | triggers when user clicks the checkbox in a row |
| `select-all` | `input$<id>_select_all` | triggers when user clicks the checkbox in table header |
| `selection-change` | one of the component’s inputs – see its reference page | triggers when selection changes |
| `cell-mouse-enter` | `input$<id>_cell_mouse_enter` | triggers when hovering into a cell |
| `cell-mouse-leave` | `input$<id>_cell_mouse_leave` | triggers when hovering out of a cell |
| `cell-click` | `input$<id>_cell_click` | triggers when clicking a cell |
| `cell-dblclick` | `input$<id>_cell_dblclick` | triggers when double clicking a cell |
| `cell-contextmenu` | `input$<id>_cell_contextmenu` | triggers when user right clicks on a cell |
| `row-click` | `input$<id>_row_click` | triggers when clicking a row |
| `row-contextmenu` | `input$<id>_row_contextmenu` | triggers when user right clicks on a row |
| `row-dblclick` | `input$<id>_row_dblclick` | triggers when double clicking a row |
| `header-click` | `input$<id>_header_click` | triggers when clicking a column header |
| `header-contextmenu` | `input$<id>_header_contextmenu` | triggers when user right clicks on a column header |
| `sort-change` | `input$<id>_sort_change` | triggers when Table’s sorting changes |
| `filter-change` | `input$<id>_filter_change` | triggers when the table’s filter changes |
| `current-change` | `input$<id>_current_change` | triggers when current row changes |
| `header-dragend` | `input$<id>_header_dragend` | triggers after changing a column’s width by dragging the column header’s border |
| `expand-change` | `input$<id>_expand_change` | triggers when user expands or collapses a row (for expandable table, second param is expandedRows; for tree Table, second param is expanded) |
| `scroll` | `input$<id>_scroll` | Invoked after scrolled |

### Table Slots

| Element | In R | Description |
|----|----|----|
| `default` | default content | customize default content |
| `append` | `slots = list(append = )` | Contents to be inserted after the last row. You may need this slot if you want to implement infinite scroll for the table. This slot will be displayed above the summary row if there is one. |
| `empty` | `slots = list(empty = )` | you can customize content when data is empty. |

### Table Exposes

| Element | In R | Description |
|----|----|----|
| `clearSelection` | `el_call(session, id, "clearSelection")` | used in multiple selection Table, clear user selection |
| `getSelectionRows` | `el_call(session, id, "getSelectionRows")` | returns the currently selected rows |
| `getHalfSelectionRows` | `el_call(session, id, "getHalfSelectionRows")` | returns the currently half-selected rows |
| `toggleRowSelection` | `el_call(session, id, "toggleRowSelection")` | used in multiple selection Table, toggle if a certain row is selected. With the second parameter, you can directly set if this row is selected |
| `toggleAllSelection` | `el_call(session, id, "toggleAllSelection")` | used in multiple selection Table, toggle select all and deselect all |
| `toggleRowExpansion` | `el_call(session, id, "toggleRowExpansion")` | used in expandable Table or tree Table, toggle if a certain row is expanded. With the second parameter, you can directly set if this row is expanded or collapsed |
| `setCurrentRow` | `el_call(session, id, "setCurrentRow")` | used in single selection Table, set a certain row selected. If called without any parameter, it will clear selection |
| `clearSort` | `el_call(session, id, "clearSort")` | clear sorting, restore data to the original order |
| `clearFilter` | `el_call(session, id, "clearFilter")` | clear filters of the columns whose `columnKey` are passed in. If no params, clear all filters |
| `doLayout` | `el_call(session, id, "doLayout")` | refresh the layout of Table. When the visibility of Table changes, you may need to call this method to get a correct layout |
| `sort` | `el_call(session, id, "sort")` | sort Table manually. Property `prop` is used to set sort column, property `order` is used to set sort order |
| `scrollTo` | `el_call(session, id, "scrollTo")` | scrolls to a particular set of coordinates |
| `setScrollTop` | `el_call(session, id, "setScrollTop")` | set vertical scroll position |
| `setScrollLeft` | `el_call(session, id, "setScrollLeft")` | set horizontal scroll position |
| `updateKeyChildren` | `el_call(session, id, "updateKeyChildren")` | used in lazy Table, must set `rowKey`, update key children |

### Table-column Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `type` | field `type` of each of `columns` | type of the column. If set to `selection`, the column will display checkbox. If set to `index`, the column will display index of the row (staring from 1). If set to `expand`, the column will display expand icon | [^61]`'default' \\| 'selection' \\| 'index' \\| 'expand'` |  | default |
| `index` | field `index` of each of `columns` | customize indices for each row, works on columns with `type=index` | [^62] / [^63]`(index: number) => number` |  | — |
| `label` | field `label` of each of `columns` | column label | [^64] |  | — |
| `column-key` | field `column_key` of each of `columns` | column’s key. If you need to use the filter-change event, you need this attribute to identify which column is being filtered | [^65] |  | — |
| `prop` | field `prop` of each of `columns` | field name. You can also use its alias: `property` | [^66] |  | — |
| `width` | `width` | column width | [^67] / [^68] |  | ’’ |
| `min-width` | field `min_width` of each of `columns` | column minimum width. Columns with `width` has a fixed width, while columns with `min-width` has a width that is distributed in proportion | [^69] / [^70] |  | ’’ |
| `fixed` | field `fixed` of each of `columns` | whether column is fixed at left / right. Will be fixed at left if `true` | [^71]`'left' \\| 'right'` / [^72] |  | false |
| `render-header` | field `render_header` of each of `columns` | render function for table header of this column | [^73]`(data: { column: TableColumnCtx<T>, $index: number }) => void` |  | — |
| `sortable` | field `sortable` of each of `columns` | whether column can be sorted. Remote sorting can be done by setting this attribute to ‘custom’ and listening to the `sort-change` event of Table | [^74] / [^75] |  | false |
| `sort-method` | field `sort_method` of each of `columns` | sorting method, works when `sortable` is `true`. Should return a number, just like Array.sort | [^76]`<T = any>(a: T, b: T) => number` |  | — |
| `sort-by` | field `sort_by` of each of `columns` | specify which property to sort by, works when `sortable` is `true` and `sort-method` is `undefined`. If set to an Array, the column will sequentially sort by the next property if the previous one is equal | [^77]`(row: any, index: number) => string` / [^78] / [^79]`string[]` |  | — |
| `sort-orders` | field `sort_orders` of each of `columns` | the order of the sorting strategies used when sorting the data, works when `sortable` is `true`. Accepts an array, as the user clicks on the header, the column is sorted in order of the elements in the array | [^80]`('ascending' \\| 'descending' \\| null)[]` |  | \[‘ascending’, ‘descending’, null\] |
| `resizable` | field `resizable` of each of `columns` | whether column width can be resized, works when `border` of `el-table` is `true` | [^81] |  | true |
| `formatter` | field `formatter` of each of `columns` | function that formats cell content | [^82]`(row: any, column: TableColumnCtx<T>, cellValue: any, index: number) => VNode \\| string` |  | — |
| `show-overflow-tooltip` | `show_overflow_tooltip` | whether to hide extra content and show them in a tooltip when hovering on the cell | [^83] / [`object`](#table-attributes) ^(2.2.28) |  | undefined |
| `align` | field `align` of each of `columns` | alignment | [^84]`'left' \\| 'center' \\| 'right'` |  | left |
| `header-align` | field `header_align` of each of `columns` | alignment of the table header. If omitted, the value of the above `align` attribute will be applied | [^85]`'left' \\| 'center' \\| 'right'` |  | left |
| `class-name` | field `class_name` of each of `columns` | class name of cells in the column | [^86] |  | — |
| `label-class-name` | field `label_class_name` of each of `columns` | class name of the label of this column | [^87] |  | — |
| `selectable` | field `selectable` of each of `columns` | function that determines if a certain row can be selected, works when `type` is ‘selection’ | [^88]`(row: any, index: number) => boolean` |  | — |
| `reserve-selection` | field `reserve_selection` of each of `columns` | whether to reserve selection after data refreshing, works when `type` is ‘selection’. Note that `row-key` is required for this to work | [^89] |  | false |
| `filters` | field `filters` of each of `columns` | an array of data filtering options. For each element in this array, `text` and `value` are required | [^90]`Array<{text: string, value: string}>` |  | — |
| `filter-placement` | field `filter_placement` of each of `columns` | placement for the filter dropdown | [^91]`'top' \\| 'top-start' \\| 'top-end' \\| 'bottom' \\| 'bottom-start' \\| 'bottom-end' \\| 'left' \\| 'left-start' \\| 'left-end' \\| 'right' \\| 'right-start' \\| 'right-end'` |  | — |
| `filter-class-name` | field `filter_class_name` of each of `columns` | className for the filter dropdown | [^92] |  | — |
| `filter-multiple` | field `filter_multiple` of each of `columns` | whether data filtering supports multiple options | [^93] |  | true |
| `filter-method` | field `filter_method` of each of `columns` | data filtering method. If `filter-multiple` is on, this method will be called multiple times for each row, and a row will display if one of the calls returns `true` | [^94]`(value: any, row: any, column: TableColumnCtx<T>) => void` |  | — |
| `filtered-value` | field `filtered_value` of each of `columns` | filter value for selected data, might be useful when table header is rendered with `render-header` | [^95]`string[]` |  | — |
| `tooltip-formatter` | `tooltip_formatter` | customize tooltip content when using `show-overflow-tooltip` | [^96]`(data: { row: any, column: TableColumnCtx<T>, cellValue: any }) => VNode \\| string` |  | — |

### Table-column Slots

| Element | In R | Description |
|----|----|----|
| `default` | default content | Custom content for table columns |
| `header` | `slots = list(header = )` | Custom content for table header |
| `filter-icon` | `slots = list(filter-icon = )` | Custom content for filter icon |
| `expand` | `slots = list(expand = )` | Custom content for expand columns. The `expandable` property is supported starting from v2.13.2. |

[^1]: array

[^2]: string

[^3]: number

[^4]: string

[^5]: number

[^6]: boolean

[^7]: boolean

[^8]: enum

[^9]: boolean

[^10]: boolean

[^11]: boolean

[^12]: string

[^13]: number

[^14]: Function

[^15]: string

[^16]: Function

[^17]: object

[^18]: Function

[^19]: string

[^20]: Function

[^21]: object

[^22]: Function

[^23]: string

[^24]: Function

[^25]: object

[^26]: Function

[^27]: string

[^28]: Function

[^29]: object

[^30]: Function

[^31]: string

[^32]: string

[^33]: boolean

[^34]: array

[^35]: object

[^36]: enum

[^37]: object

[^38]: object

[^39]: string

[^40]: boolean

[^41]: string

[^42]: Function

[^43]: Function

[^44]: boolean

[^45]: number

[^46]: boolean

[^47]: Function

[^48]: object

[^49]: object

[^50]: enum

[^51]: boolean

[^52]: boolean

[^53]: boolean

[^54]: string

[^55]: number

[^56]: boolean

[^57]: Function

[^58]: boolean

[^59]: boolean

[^60]: Function

[^61]: enum

[^62]: number

[^63]: Function

[^64]: string

[^65]: string

[^66]: string

[^67]: string

[^68]: number

[^69]: string

[^70]: number

[^71]: enum

[^72]: boolean

[^73]: Function

[^74]: boolean

[^75]: string

[^76]: Function

[^77]: Function

[^78]: string

[^79]: array

[^80]: object

[^81]: boolean

[^82]: Function

[^83]: boolean

[^84]: enum

[^85]: enum

[^86]: string

[^87]: string

[^88]: Function

[^89]: boolean

[^90]: array

[^91]: enum

[^92]: string

[^93]: boolean

[^94]: Function

[^95]: array

[^96]: Function
