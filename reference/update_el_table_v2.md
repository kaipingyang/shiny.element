# Update Element Plus Virtualized Table

Server-side update for
[`el_table_v2()`](https://kaipingyang.github.io/shiny.element/reference/el_table_v2.md):
every argument that can change once the table is drawn, under the same
name. One left `NULL` stays as it is; `NA` returns a prop to Element's
default. Rows are given as for
[`el_table_v2()`](https://kaipingyang.github.io/shiny.element/reference/el_table_v2.md),
a data.frame or a list of rows; a data.frame without `columns` keeps the
table's columns. `methods`, `slots`, `width`, `auto_resize` and
`default_expanded_row_keys`, which Element reads only when the table is
created, are not here.

## Usage

``` r
update_el_table_v2(
  session = shiny::getDefaultReactiveDomain(),
  id,
  data = NULL,
  columns = NULL,
  sort_by = NULL,
  expanded_row_keys = NULL,
  cache = NULL,
  estimated_row_height = NULL,
  header_class = NULL,
  header_props = NULL,
  header_cell_props = NULL,
  header_height = NULL,
  footer_height = NULL,
  row_class = NULL,
  row_key = NULL,
  row_props = NULL,
  row_height = NULL,
  row_event_handlers = NULL,
  cell_props = NULL,
  data_getter = NULL,
  fixed_data = NULL,
  expand_column_key = NULL,
  fixed = NULL,
  table_v2_width = NULL,
  height = NULL,
  max_height = NULL,
  indent_size = NULL,
  h_scrollbar_size = NULL,
  v_scrollbar_size = NULL,
  scrollbar_always_on = NULL,
  sort_state = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Table ID (un-namespaced).

- data, columns, sort_by, expanded_row_keys:

  New values; `NULL` leaves one unchanged.

- cache:

  Number of rows rendered in advance to boost the performance. Element
  Plus's `cache`.

- estimated_row_height:

  The estimated row height for rendering dynamic height rows. Element
  Plus's `estimated-row-height`.

- header_class:

  Customized class name passed to header wrapper. Element Plus's
  `header-class`. Give it as
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md).

- header_props:

  Customized props name passed to header component. Element Plus's
  `header-props`. Give it as
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md).

- header_cell_props:

  Customized props name passed to header cell component. Element Plus's
  `header-cell-props`. Give it as
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md).

- header_height:

  The height of the header is set by `height`. If given an array, it
  renders header rows equal to its length. Element Plus's
  `header-height`.

- footer_height:

  The height of the footer element, when provided, will be part to the
  calculation of the table's height. Element Plus's `footer-height`.

- row_class:

  Customized class name passed to row wrapper. Element Plus's
  `row-class`. Give it as
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md).

- row_key:

  The key of each row, if not provided, will be the index of the row.
  Element Plus's `row-key`.

- row_props:

  Customized props name passed to row component. Element Plus's
  `row-props`. Give it as
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md).

- row_height:

  The height of each row, used for calculating the total height of the
  table. Element Plus's `row-height`.

- row_event_handlers:

  A collection of handlers attached to each row. Element Plus's
  `row-event-handlers`.

- cell_props:

  Extra props passed to each cell (except header cells). Element Plus's
  `cell-props`. Give it as
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md).

- data_getter:

  A method to customize data fetch from the data source. Element Plus's
  `data-getter`. Give it as
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md).

- fixed_data:

  Data for rendering rows above the main content and below the header.
  Element Plus's `fixed-data`.

- expand_column_key:

  The column key indicates which row is expandable. Element Plus's
  `expand-column-key`.

- fixed:

  Flag indicates the table column's width to be fixed or flexible.
  Element Plus's `fixed`.

- table_v2_width:

  Width of the table, in pixels: Element Plus's `width`, which it needs
  as a number. Default `700`.

- height:

  Height of the table, in pixels. Default `400`.

- max_height:

  Maximum height of the table. Element Plus's `max-height`.

- indent_size:

  Horizontal indentation of tree table. Element Plus's `indent-size`.

- h_scrollbar_size:

  Indicates the horizontal scrollbar's size for the table, used to
  prevent the horizontal and vertical scrollbar to collapse. Element
  Plus's `h-scrollbar-size`.

- v_scrollbar_size:

  Indicates the vertical scrollbar's size for the table, used to prevent
  the horizontal and vertical scrollbar to collapse. Element Plus's
  `v-scrollbar-size`.

- scrollbar_always_on:

  If true, the scrollbar will always be shown instead of when mouse is
  placed above the table. Element Plus's `scrollbar-always-on`.

- sort_state:

  Multiple sort indicator. Element Plus's `sort-state`.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$filter_on, {
    update_el_table_v2(id = "big", data = subset(big, keep))
  })
  # any other argument of el_table_v2()
  update_el_table_v2(id = "big", sort_state = list(id = "desc"))
}
```
