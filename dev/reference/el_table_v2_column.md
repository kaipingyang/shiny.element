# A column of [`el_table_v2()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_table_v2.md)

A column definition for `el_table_v2(columns =)` and
[`update_el_table_v2()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_table_v2.md),
under Element Plus's own field names.

## Usage

``` r
el_table_v2_column(
  key,
  title = NULL,
  data_key = key,
  width = 150,
  min_width = NULL,
  max_width = NULL,
  align = NULL,
  fixed = NULL,
  flex_grow = NULL,
  flex_shrink = NULL,
  sortable = NULL,
  hidden = NULL,
  class = NULL,
  header_class = NULL,
  style = NULL,
  cell_renderer = NULL,
  header_cell_renderer = NULL
)
```

## Arguments

- key:

  The column's unique key.

- title:

  The text of its header cell.

- data_key:

  The field of each row it shows. Defaults to `key`.

- width:

  The column's width, in pixels.

- min_width, max_width:

  Its bounds, in pixels.

- align:

  Alignment of its cells: `"left"`, `"center"` or `"right"`.

- fixed:

  Fix it at the `"left"` (or `TRUE`) or the `"right"`.

- flex_grow, flex_shrink:

  Flex grow and shrink, in a table that is not `fixed`.

- sortable:

  Whether it sorts; the sort is reported, the rows are yours to reorder.

- hidden:

  Whether it is hidden.

- class, header_class:

  Class of its cells and of its header cell.

- style:

  Style of its cells, a list of CSS properties.

- cell_renderer, header_cell_renderer:

  [`JS()`](https://kaipingyang.github.io/shiny.element/dev/reference/JS.md)
  functions drawing a cell and the header cell, returning Vue's `h()`.

## Value

A column, for `el_table_v2(columns =)`.

## See also

Other items:
[`el_anchor_link()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_anchor_link.md),
[`el_breadcrumb_item()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_breadcrumb_item.md),
[`el_carousel_item()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_carousel_item.md),
[`el_collapse_item()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_collapse_item.md),
[`el_descriptions_item()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_descriptions_item.md),
[`el_dropdown_item()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_dropdown_item.md),
[`el_menu_item()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_menu_item.md),
[`el_option()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_option.md),
[`el_skeleton_item()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_skeleton_item.md),
[`el_step()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_step.md),
[`el_tab_pane()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_tab_pane.md),
[`el_table_column()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_table_column.md),
[`el_timeline_item()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_timeline_item.md),
[`el_tour_step()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_tour_step.md)

## Examples

``` r
el_table_v2(
  "tv",
  data = data.frame(id = 1:3, name = c("a", "b", "c")),
  columns = list(
    el_table_v2_column("id", "Id", width = 80, fixed = "left"),
    el_table_v2_column("name", "Name", width = 200, sortable = TRUE)
  )
)
#> <div id="tv" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="tv_container" style="display: contents">
#>   <el-table-v2 v-bind="$optional(&#39;table-v2&#39;)" @column-sort="svEmitColumnSort" @end-reached="svEmitEndReached"></el-table-v2>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"cache":null,"estimatedRowHeight":null,"headerClass":null,"headerProps":null,"headerCellProps":null,"headerHeight":null,"footerHeight":null,"rowClass":null,"rowKey":null,"rowProps":null,"rowHeight":null,"rowEventHandlers":null,"cellProps":null,"columns":[{"key":"id","dataKey":"id","title":"Id","width":80,"fixed":"left"},{"key":"name","dataKey":"name","title":"Name","width":200,"sortable":true}],"data":[{"id":1,"name":"a"},{"id":2,"name":"b"},{"id":3,"name":"c"}],"dataGetter":null,"fixedData":null,"expandColumnKey":null,"expandedRowKeys":null,"defaultExpandedRowKeys":null,"fixed":null,"width":700,"height":400,"maxHeight":null,"indentSize":null,"hScrollbarSize":null,"vScrollbarSize":null,"scrollbarAlwaysOn":null,"sortBy":null,"sortState":null},"methods":{"svEmitColumnSort":"function() { window.shinyVue.emit('tv', 'column_sort', arguments); }","svEmitEndReached":"function() { window.shinyVue.emit('tv', 'end_reached', arguments); }"}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"optional":{"table-v2":{"cache":"cache","estimated-row-height":"estimatedRowHeight","header-class":"headerClass","header-props":"headerProps","header-cell-props":"headerCellProps","header-height":"headerHeight","footer-height":"footerHeight","row-class":"rowClass","row-key":"rowKey","row-props":"rowProps","row-height":"rowHeight","row-event-handlers":"rowEventHandlers","cell-props":"cellProps","columns":"columns","data":"data","data-getter":"dataGetter","fixed-data":"fixedData","expand-column-key":"expandColumnKey","expanded-row-keys":"expandedRowKeys","default-expanded-row-keys":"defaultExpandedRowKeys","fixed":"fixed","width":"width","height":"height","max-height":"maxHeight","indent-size":"indentSize","h-scrollbar-size":"hScrollbarSize","v-scrollbar-size":"vScrollbarSize","scrollbar-always-on":"scrollbarAlwaysOn","sort-by":"sortBy","sort-state":"sortState"}},"evals":["options.methods.svEmitColumnSort","options.methods.svEmitEndReached"]}</script>
#> </div>
```
