# Virtualized Table

Along with evolutionary web development, table component has always been
the most popular component in our web apps especially for dashboards,
data analysis. For [Table
V1](https://kaipingyang.github.io/shiny.element/articles/components/table.md),
with even just 1000 records of data, it can be very annoying when using
it, because of the poor performance.

With Virtualized Table, you can render massive chunks of data in a blink
of an eye.

> **Tip**
>
> This component is **still under testing**, use at your own risk. If
> you find any bugs or issues, please report them at
> [GitHub](https://github.com/element-plus/element-plus/issues) for us
> to fix. Also there were some APIs which are not mentioned in this
> documentation, some of them were not fully developed yet, which is why
> they are not mentioned here.
>
> **Even though** Virtualized Table is efficient, when the data load is
> too large, your **network** and **memory size** can become the
> bottleneck of your app. So keep in mind that Virtualized Table is
> never the ultimate solution for everything, consider paginating your
> data, adding filters etc.

## Basic usage

Let’s demonstrate the performance of the Virtualized Table by rendering
a basic example with 10 columns and 1000 rows.

A data.frame, its columns made from its variables.

``` r

df <- as.data.frame(setNames(lapply(1:10, function(j) paste0("Row ", 1:1000, " - Col ", j)),
                             paste0("column-", 1:10)))
el_table_v2("tv_basic", data = df, table_v2_width = 700, height = 400)
```

## Auto resizer

When you do not want to manually pass the `width` and `height`
properties to the table, you can wrap the table component with the
AutoResizer. This will automatically update the width and height for
you.

Resize your browser to see how it works.

> **Tip**
>
> Make sure the parent node of the `AutoResizer` **HAS A FIXED HEIGHT**,
> since its default height value is set to 100%. Alternatively, you can
> define it by passing the `style` attribute to `AutoResizer`.

Element Plus’s table needs a width and height in pixels; give the size
the space has.

``` r

df <- data.frame(id = 1:1000, name = paste("Name", 1:1000), value = round(runif(1000) * 100))
el_table_v2("tv_auto", data = df, table_v2_width = 700, height = 400)
```

## Customize Cell Renderer

Of course, you can render the table cell according to your needs. Here’s
a simple example of how to customize your cell.

A cell drawn with a template: the `cell` slot, its scope the row and
column.

``` r

df <- data.frame(name = paste("User", 1:200), state = sample(c("active", "inactive"), 200, TRUE))
el_table_v2("tv_cell", data = df, table_v2_width = 700, height = 300, slots = list(
  cell = template(htmltools::HTML(paste0(
    "<el-tag v-if=\"column.dataKey === 'state'\" :type=\"rowData.state === 'active' ? 'success' : 'info'\">",
    "{{ rowData.state }}</el-tag><span v-else>{{ rowData[column.dataKey] }}</span>")),
    slot = "cell", scope = "{ rowData, column }")))
```

## Table with selections

Using customized cell renderer to allow selection for your table.

> **In R**
>
> Selection columns are drawn with a JSX cell renderer in Element Plus’s
> demo; in R, use `el_table(selection = TRUE)`, or a `cell` slot with a
> checkbox.

## Inline editing

Just as we demonstrated with selections above, you can use the same
method to enable inline editing.

> **In R**
>
> Editing in place is a JSX cell renderer upstream; in R, edit with a
> `cell` slot that holds an input, as
> [`el_table()`](https://kaipingyang.github.io/shiny.element/reference/el_table.md)’s
> cell templates do.

## Table with status

You can highlight your table content to distinguish between “success,
information, warning, danger” and other states.

To customize the appearance of rows, use the `row-class-name` attribute.
For example, every 10th row is highlighted using the `bg-blue-200`
class, and every 5th row with the `bg-red-100` class.

``` r

df <- data.frame(id = 1:200, name = paste("Name", 1:200))
tagList(
  tags$style(".tv-odd { background: var(--el-color-primary-light-9); }"),
  el_table_v2("tv_rowclass", data = df, table_v2_width = 700, height = 300,
              row_class = JS("function({ rowIndex }) { return rowIndex % 2 ? 'tv-odd' : ''; }")))
```

## Table with sticky rows

You can make some rows stick to the top of the table, and that can be
very easily achieved by using the `fixed-data` attribute.

You can dynamically set the sticky row based on scroll events, as shown
in this example.

``` r

df <- data.frame(id = 1:200, name = paste("Name", 1:200))
el_table_v2("tv_sticky", data = df, table_v2_width = 700, height = 300,
            fixed_data = list(list(id = "Pinned", name = "Stays on top")))
```

## Table with fixed columns

If you want to have columns stick to the left or right for some reason,
you can achieve this by adding special attributes to the table.

You can set the column’s attribute `fixed` to `true` (representing
`FixedDir.LEFT`) or `FixedDir.LEFT` or `FixedDir.RIGHT`

``` r

cols <- lapply(1:10, function(j) list(key = paste0("c", j), dataKey = paste0("c", j),
  title = paste("Column", j), width = 150, fixed = if (j == 1) "left" else if (j == 10) "right"))
df <- as.data.frame(setNames(lapply(1:10, function(j) paste0("Row ", 1:200, " - Col ", j)), paste0("c", 1:10)))
el_table_v2("tv_fixed", data = df, columns = cols, table_v2_width = 700, height = 300, fixed = TRUE)
```

## Grouping header

By customizing your header renderer, you can group your header as shown
in this example.

> **Tip**
>
> In this case we used `JSX` feature which is not supported in the
> playground. You may try them out in your local environment or on
> online IDEs such as `codesandbox`.
>
> It is recommended that you write your table component in JSX, since it
> contains VNode manipulations.

> **In R**
>
> Grouped headers are drawn with a JSX header renderer upstream;
> [`el_table()`](https://kaipingyang.github.io/shiny.element/reference/el_table.md)
> groups its headers with a column’s `children`.

## Filter

Virtualized Table provides custom header renderers for creating
customized headers. We can then utilize these to render filters.

> **In R**
>
> Filtering in the header is a JSX header renderer upstream; filter the
> data in R and `update_el_table_v2()` it, or use
> [`el_table()`](https://kaipingyang.github.io/shiny.element/reference/el_table.md)’s
> column filters.

## Sortable

You can sort the table with sort state.

Sorting is the server’s: `input$<id>_column_sort` says which column and
which way.

``` r

df <- data.frame(id = 1:200, value = round(runif(200) * 100))
cols <- list(list(key = "id", dataKey = "id", title = "Id", width = 150, sortable = TRUE),
             list(key = "value", dataKey = "value", title = "Value", width = 150, sortable = TRUE))
el_table_v2("tv_sort", data = df, columns = cols, table_v2_width = 700, height = 300,
            sort_by = list(key = "id", order = "asc"))
```

## Controlled Sort

You can define multiple sortable columns as needed. Keep in mind that if
you define multiple sortable columns, the UI may appear confusing to
your users, as it becomes unclear which column is currently being
sorted.

``` r

df <- data.frame(id = 1:200, value = round(runif(200) * 100))
cols <- list(list(key = "id", dataKey = "id", title = "Id", width = 150, sortable = TRUE),
             list(key = "value", dataKey = "value", title = "Value", width = 150, sortable = TRUE))
el_table_v2("tv_csort", data = df, columns = cols, table_v2_width = 700, height = 300,
            sort_state = list(id = "desc", value = "asc"))
```

## Cross hovering

When dealing with a large list, it’s easy to lose track of the current
row and column you are visiting. In such cases, using this feature can
be very helpful.

> **In R**
>
> Hovering across rows and columns is a JSX cell renderer upstream.

## Colspan

The virtualized table doesn’t use the built-in `table` element, so
`colspan` and `rowspan` behave a bit differently compared to
[TableV1](https://kaipingyang.github.io/shiny.element/articles/components/table.md).
However, with a customized row renderer, these features can still be
implemented. In this section, we’ll demonstrate how to achieve this.

> **In R**
>
> Spanning cells is a JSX row renderer upstream;
> `el_table(span_method =)` spans cells.

## Rowspan

Since we have covered [Colspan](#colspan), it’s worth noting that we
also have row span. It’s a little bit different from colspan but the
idea is basically the same.

> **In R**
>
> Spanning cells is a JSX row renderer upstream;
> `el_table(span_method =)` spans cells.

## Rowspan and Colspan together

We can combine rowspan and colspan together to meet your business goal!

> **In R**
>
> Spanning cells is a JSX row renderer upstream;
> `el_table(span_method =)` spans cells.

## Tree data

Virtual Table can also render data in a tree-like structure. By clicking
the arrow icon, you can expand or collapse the tree nodes.

``` r

rows <- lapply(1:50, function(i) list(id = paste0("r", i), name = paste("Parent", i),
  children = lapply(1:3, function(j) list(id = paste0("r", i, "-", j), name = paste("Child", i, j)))))
el_table_v2("tv_tree", data = rows, expand_column_key = "name", table_v2_width = 700, height = 300,
            columns = list(list(key = "name", dataKey = "name", title = "Name", width = 300),
                           list(key = "id", dataKey = "id", title = "Id", width = 150)))
```

## Dynamic height rows

Virtual Table is capable of rendering rows with dynamic heights. If
you’re working with data and are uncertain about the content size, this
feature is ideal for rendering rows that adjust to the content’s height.
To enable this, pass down the `estimated-row-height` attribute. The
closer the estimated height matches the actual content, the smoother the
rendering experience.

> **Tip**
>
> Each row’s height is dynamically measured during rendering the rows.
> As a result, if you’re trying to display a large amount of data, the
> UI **might be** bouncing.

`estimated_row_height` lets each row take the height of its content.

``` r

df <- data.frame(id = 1:100, text = vapply(1:100, function(i) strrep("text ", (i %% 7 + 1) * 8), ""))
el_table_v2("tv_dyn", data = df, estimated_row_height = 50, table_v2_width = 700, height = 300,
            columns = list(list(key = "id", dataKey = "id", title = "Id", width = 80),
                           list(key = "text", dataKey = "text", title = "Text", width = 600)))
```

## Detail view

Using dynamic height rendering, you can also display a detailed view
within the table.

> **In R**
>
> A row’s detail is a JSX row renderer upstream;
> [`el_table()`](https://kaipingyang.github.io/shiny.element/reference/el_table.md)’s
> expandable rows show one.

## Customized Footer

Render a customized footer when you want to show a concluding message or
information.

``` r

df <- data.frame(id = 1:200, name = paste("Name", 1:200))
el_table_v2("tv_footer", data = df, table_v2_width = 700, height = 300, footer_height = 50,
            slots = list(footer = tags$div(style = "display: flex; align-items: center; justify-content: center; height: 100%",
                                           "Display a message in the footer")))
```

## Customized Empty Renderer

Render a customized empty element.

``` r

el_table_v2("tv_empty", data = list(), table_v2_width = 700, height = 300,
            columns = list(list(key = "a", dataKey = "a", title = "A", width = 150)),
            slots = list(empty = tags$div(style = "display: flex; justify-content: center", el_empty())))
```

## Overlay

Render an overlay on top of the table when you want to show a loading
indicator or something else.

``` r

df <- data.frame(id = 1:200, name = paste("Name", 1:200))
el_table_v2("tv_overlay", data = df, table_v2_width = 700, height = 300,
            slots = list(overlay = tags$div(class = "el-loading-mask",
              style = "display: flex; align-items: center; justify-content: center",
              el_icon("Loading", class = "is-loading", size = "26px"))))
```

## Manual scrolling

Use the methods provided by Table V2 to scroll manually/programmatically
with desired offset/rows.

> **Tip**
>
> The second parameter for `scrollToRow` is the scrolling strategy which
> by default is `auto`, it calculates the position to scroll by itself.
> If you wish to scroll to a specific position, you can define the
> strategy yourself. The available options are
> `"auto" | "center" | "end" | "start" | "smart"`
>
> The difference between `smart` and `auto` is that `auto` is a subset
> of `smart` scroll strategy.

`el_call(session, "tv_scroll", "scrollToRow", list(100))` scrolls it
from the server.

``` r

df <- data.frame(id = 1:1000, name = paste("Name", 1:1000))
el_table_v2("tv_scroll", data = df, table_v2_width = 700, height = 300)
```

## API

Element Plus’s tables, and beside each entry where it is in R.

### TableV2 Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `cache` | `cache` | Number of rows rendered in advance to boost the performance | `number` |  | 2 |
| `estimated-row-height` | `estimated_row_height` | The estimated row height for rendering dynamic height rows | `number` |  | — |
| `header-class` | `header_class` | Customized class name passed to header wrapper | `string` / Function\<[HeaderClassGetter](#typings)\> |  | — |
| `header-props` | `header_props` | Customized props name passed to header component | `object` / Function\<[HeaderPropsGetter](#typings)\> |  | — |
| `header-cell-props` | `header_cell_props` | Customized props name passed to header cell component | `object` / Function\<[HeaderCellPropsGetter](#typings)\> |  | — |
| `header-height` | `header_height` | The height of the header is set by `height`. If given an array, it renders header rows equal to its length | `number`/ `number[]` |  | 50 |
| `footer-height` | `footer_height` | The height of the footer element, when provided, will be part to the calculation of the table’s height. | `number` |  | 0 |
| `row-class` | `row_class` | Customized class name passed to row wrapper | `string` / Function\<[RowClassGetter](#typings)\> |  | — |
| `row-key` | `row_key` | The key of each row, if not provided, will be the index of the row | `string` / `Symbol` / `number` |  | id |
| `row-props` | `row_props` | Customized props name passed to row component | `object` / Function\<[RowPropsGetter](#typings)\> |  | — |
| `row-height` | `row_height` | The height of each row, used for calculating the total height of the table | `number` |  | 50 |
| `row-event-handlers` | `row_event_handlers` | A collection of handlers attached to each row | `object`\<[RowEventHandlers](#typings)\> |  | — |
| `cell-props` | `cell_props` | extra props passed to each cell (except header cells) | `object` / Function\<[CellPropsGetter](#typings)\> |  | — |
| `columns` | `columns` | An array of column definitions. | [Column\[\]](#column-attribute) |  | — |
| `data` | `data` | An array of data to be rendered in the table. | [Data\[\]](#typings) |  | \[\] |
| `data-getter` | `data_getter` | A method to customize data fetch from the data source. | Function\<[DataGetter\<T\>](#typings)\> |  | — |
| `fixed-data` | `fixed_data` | Data for rendering rows above the main content and below the header | `object`\<[Data](#typings)\> |  | — |
| `expand-column-key` | `expand_column_key` | The column key indicates which row is expandable | `string` |  | — |
| `expanded-row-keys` | `expanded_row_keys` | An array of keys for expanded rows, can be used with `v-model` | [KeyType\[\]](#typings) |  | — |
| `default-expanded-row-keys` | `default_expanded_row_keys` | An array of keys for default expanded rows, **NON REACTIVE** | [KeyType\[\]](#typings) |  | — |
| `class` | an HTML attribute of the tag; [`tagAppendAttributes()`](https://rstudio.github.io/htmltools/reference/tagAppendAttributes.html) | Class name for the virtual table, will be applied to all three tables (left, right, main) | `string` / `array` / `object` |  | — |
| `fixed` | `fixed` | Flag indicates the table column’s width to be fixed or flexible. | `boolean` |  | false |
| `width` | `width` | Width of the table | `number` |  | — |
| `height` | `height` | Height of the table | `number` |  | — |
| `max-height` | `max_height` | Maximum height of the table | `number` |  | — |
| `indent-size` | `indent_size` | horizontal indentation of tree table | `number` |  | 12 |
| `h-scrollbar-size` | `h_scrollbar_size` | Indicates the horizontal scrollbar’s size for the table, used to prevent the horizontal and vertical scrollbar to collapse | `number` |  | 6 |
| `v-scrollbar-size` | `v_scrollbar_size` | Indicates the vertical scrollbar’s size for the table, used to prevent the horizontal and vertical scrollbar to collapse | `number` |  | 6 |
| `scrollbar-always-on` | `scrollbar_always_on` | If true, the scrollbar will always be shown instead of when mouse is placed above the table | `boolean` |  | false |
| `sort-by` | `sort_by` | Sort indicator | `object`\<[SortBy](#typings)\> |  | {} |
| `sort-state` | `sort_state` | Multiple sort indicator | `object`\<[SortState](#typings)\> |  | undefined |

### TableV2 Slots

| Element | In R | Description |
|----|----|----|
| `cell` | `slots = list(cell = )` | `object`\<[CellSlotProps](#typings)\> |
| `header` | `slots = list(header = )` | `object`\<[HeaderSlotProps](#typings)\> |
| `header-cell` | `slots = list(header-cell = )` | `object`\<[HeaderCellSlotProps](#typings)\> |
| `row` | `slots = list(row = )` | `object`\<[RowSlotProps](#typings)\> |
| `footer` | `slots = list(footer = )` | — |
| `empty` | `slots = list(empty = )` | — |
| `overlay` | `slots = list(overlay = )` | — |

### TableV2 Events

| Element | In R | Description |
|----|----|----|
| `column-sort` | `input$<id>_column_sort` | Invoked when column sorted |
| `expanded-rows-change` | `input$<id>_expanded_rows_change` | Invoked when expanded rows changed |
| `end-reached` | `input$<id>_end_reached` | Invoked when the end of the table is reached. The callback contain the remain distance, it is the usually the scrollbar height. |
| `scroll` | `input$<id>_scroll` | Invoked after scrolling |
| `rows-rendered` | `input$<id>_rows_rendered` | Invoked when rows are rendered |
| `row-expand` | `input$<id>_row_expand` | Invoked when expand/collapse the tree node by clicking the arrow icon |

### TableV2 Exposes

| Element | In R | Description |
|----|----|----|
| `scrollTo` | `el_call(session, id, "scrollTo")` | Scroll to a given position |
| `scrollToLeft` | `el_call(session, id, "scrollToLeft")` | Scroll to a given horizontal position |
| `scrollToTop` | `el_call(session, id, "scrollToTop")` | Scroll to a given vertical position |
| `scrollToRow` | `el_call(session, id, "scrollToRow")` | scroll to a given row with specified scroll strategy |

### Column Attribute

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `align` | field `align` of each of `columns` | Alignment of the table cell content | [Alignment](https://github.com/element-plus/element-plus/blob/b92b22932758f0ddea98810ae248f6ca62f77e25/packages/components/table-v2/src/constants.ts#L6) |  | left |
| `class` | an HTML attribute of the tag; [`tagAppendAttributes()`](https://rstudio.github.io/htmltools/reference/tagAppendAttributes.html) | Class name for the column | `string` |  | — |
| `key` | field `key` of each of `columns` | Unique identification | [KeyType](#typings) |  | — |
| `dataKey` | field `data_key` of each of `columns` | Unique identification of data | [KeyType](#typings) |  | — |
| `fixed` | `fixed` | Fixed direction of the column | `boolean` / [FixedDir](https://github.com/element-plus/element-plus/blob/b92b22932758f0ddea98810ae248f6ca62f77e25/packages/components/table-v2/src/constants.ts#L11) |  | false |
| `flexGrow` | field `flex_grow` of each of `columns` | CSSProperties flex grow, Only useful when this is not a fixed table | `number` |  | 0 |
| `flexShrink` | field `flex_shrink` of each of `columns` | CSSProperties flex shrink, Only useful when this is not a fixed table | `number` |  | 1 |
| `headerClass` | `header_class` | Used for customizing header column class | `string` |  | — |
| `hidden` | field `hidden` of each of `columns` | Whether the column is invisible | `boolean` |  | — |
| `style` | an HTML attribute of the tag; [`tagAppendAttributes()`](https://rstudio.github.io/htmltools/reference/tagAppendAttributes.html) | Customized style for column cell, will be merged with grid cell | [^1]`CSSProperties` |  | — |
| `sortable` | field `sortable` of each of `columns` | Indicates whether the column is sortable | `boolean` |  | — |
| `title` | field `title` of each of `columns` | The default text rendered in header cell | `string` |  | — |
| `maxWidth` | field `max_width` of each of `columns` | Maximum width for the column | `number` |  | — |
| `minWidth` | field `min_width` of each of `columns` | Minimum width for the column | `number` |  | — |
| `width` | `width` | Width for the column | `number` |  | — |
| `cellRenderer` | field `cell_renderer` of each of `columns` | Customized Cell renderer | `VueComponent` / (props: [CellRenderProps](#typings)) =\> VNode |  | — |
| `headerCellRenderer` | field `header_cell_renderer` of each of `columns` | Customized Header renderer | `VueComponent` / (props: [HeaderRenderProps](#typings)) =\> VNode |  | — |

[^1]: object
