#' Element Plus Virtualized Table
#'
#' A table drawing only the rows and columns in view, for very large data.
#'
#' @param id Component ID. Auto-generated if `NULL`.
#' @param cache Number of rows rendered in advance to boost the performance.
#'   Element Plus's `cache`.
#' @param estimated_row_height The estimated row height for rendering dynamic
#'   height rows. Element Plus's `estimated-row-height`.
#' @param header_class Customized class name passed to header wrapper. Element
#'   Plus's `header-class`. Give it as [JS()].
#' @param header_props Customized props name passed to header component.
#'   Element Plus's `header-props`. Give it as [JS()].
#' @param header_cell_props Customized props name passed to header cell
#'   component. Element Plus's `header-cell-props`. Give it as [JS()].
#' @param header_height The height of the header is set by `height`. If given
#'   an array, it renders header rows equal to its length. Element Plus's
#'   `header-height`.
#' @param footer_height The height of the footer element, when provided, will
#'   be part to the calculation of the table's height. Element Plus's
#'   `footer-height`.
#' @param row_class Customized class name passed to row wrapper. Element
#'   Plus's `row-class`. Give it as [JS()].
#' @param row_key The key of each row, if not provided, will be the index of
#'   the row. Element Plus's `row-key`.
#' @param row_props Customized props name passed to row component. Element
#'   Plus's `row-props`. Give it as [JS()].
#' @param row_height The height of each row, used for calculating the total
#'   height of the table. Element Plus's `row-height`.
#' @param row_event_handlers A collection of handlers attached to each row.
#'   Element Plus's `row-event-handlers`.
#' @param cell_props Extra props passed to each cell (except header cells).
#'   Element Plus's `cell-props`. Give it as [JS()].
#' @param columns The columns: a list of `list(key =, dataKey =, title =,
#'   width =)` and Element Plus's other column fields. `NULL` makes one per
#'   variable of a data.frame `data`, 150 pixels wide.
#' @param data The rows: a data.frame, or a list of rows. Element Plus's
#'   `data`.
#' @param data_getter A method to customize data fetch from the data source.
#'   Element Plus's `data-getter`. Give it as [JS()].
#' @param fixed_data Data for rendering rows above the main content and below
#'   the header. Element Plus's `fixed-data`.
#' @param expand_column_key The column key indicates which row is expandable.
#'   Element Plus's `expand-column-key`.
#' @param expanded_row_keys An array of keys for expanded rows, can be used
#'   with `v-model`. Element Plus's `expanded-row-keys`.
#' @param default_expanded_row_keys An array of keys for default expanded
#'   rows, **NON REACTIVE**. Element Plus's `default-expanded-row-keys`.
#' @param fixed Flag indicates the table column's width to be fixed or
#'   flexible. Element Plus's `fixed`.
#' @param table_v2_width Width of the table, in pixels: Element Plus's
#'   `width`, which it needs as a number. Default `700`.
#' @param height Height of the table, in pixels. Default `400`.
#' @param auto_resize `TRUE` to size the table to its container, as Element
#'   Plus's `el-auto-resizer` does: `table_v2_width` and `height` are then
#'   ignored, and the container needs a height of its own.
#' @param max_height Maximum height of the table. Element Plus's `max-height`.
#' @param indent_size Horizontal indentation of tree table. Element Plus's
#'   `indent-size`.
#' @param h_scrollbar_size Indicates the horizontal scrollbar's size for the
#'   table, used to prevent the horizontal and vertical scrollbar to collapse.
#'   Element Plus's `h-scrollbar-size`.
#' @param v_scrollbar_size Indicates the vertical scrollbar's size for the
#'   table, used to prevent the horizontal and vertical scrollbar to collapse.
#'   Element Plus's `v-scrollbar-size`.
#' @param scrollbar_always_on If true, the scrollbar will always be shown
#'   instead of when mouse is placed above the table. Element Plus's
#'   `scrollbar-always-on`.
#' @param sort_by Sort indicator. Element Plus's `sort-by`.
#' @param sort_state Multiple sort indicator. Element Plus's `sort-state`.
#' @param width Component width, as a CSS unit.
#' @param slots Named list of Element slot contents: `cell`, `header`,
#'   `header-cell`, `row`, `footer`, `empty`, `overlay`. A scoped slot is
#'   written with [template()].
#' @param methods Named list of [JS()] functions that the slot templates can
#'   call by name. Element Plus's own examples build cells, header rows and
#'   rows in JavaScript; such a function, given the slot's scope, can do the
#'   same and return the cells to draw (`Vue.h()`, `Vue.cloneVNode()`). Each
#'   is drawn with `<component :is="cell" />`.
#'
#' @section Shiny inputs:
#' - `input$<id>_column_sort` -- Element Plus's `column-sort` event.
#' - `input$<id>_expanded_rows_change` -- Element Plus's `expanded-rows-change` event.
#' - `input$<id>_end_reached` -- Element Plus's `end-reached` event.
#' - `input$<id>_scroll` -- Element Plus's `scroll` event.
#' - `input$<id>_rows_rendered` -- Element Plus's `rows-rendered` event.
#' - `input$<id>_row_expand` -- Element Plus's `row-expand` event.
#'
#' @section Element methods:
#' Callable with [call_el()]: `scrollTo()`, `scrollToLeft()`, `scrollToTop()`, `scrollToRow()`.
#'
#' @return A Shiny UI element.
#' @examples
#' el_table_v2(
#'   "big",
#'   data = data.frame(x = 1:10000, y = rnorm(10000)),
#'   width = 600,
#'   height = 400
#' )
#' @export
el_table_v2 <- function(
  id = NULL,
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
  columns = NULL,
  data = NULL,
  data_getter = NULL,
  fixed_data = NULL,
  expand_column_key = NULL,
  expanded_row_keys = NULL,
  default_expanded_row_keys = NULL,
  fixed = NULL,
  table_v2_width = NULL,
  height = NULL,
  max_height = NULL,
  indent_size = NULL,
  h_scrollbar_size = NULL,
  v_scrollbar_size = NULL,
  scrollbar_always_on = NULL,
  sort_by = NULL,
  sort_state = NULL,
  width = NULL,
  slots = NULL,
  methods = NULL,
  auto_resize = FALSE
) {
  .el_check_choices("el_table_v2", environment())
  if (
    !is.null(methods) &&
      (!is.list(methods) ||
        is.null(names(methods)) ||
        any(!nzchar(names(methods))))
  ) {
    stop("`methods` must be a named list of JS() functions.", call. = FALSE)
  }
  if (is.null(id)) {
    id <- .el_auto_id("el_table_v2")
  }
  ns_id <- .el_ui_id(id, NULL)
  # A data.frame is rows; columns not given are one per variable
  if (is.data.frame(data)) {
    if (is.null(columns)) {
      columns <- lapply(names(data), function(n) {
        list(
          key = gsub(".", "_", n, fixed = TRUE),
          dataKey = gsub(".", "_", n, fixed = TRUE),
          title = n,
          width = 150
        )
      })
    }
    data <- .el_table_rows(data)
  }
  if (is.null(table_v2_width)) {
    table_v2_width <- 700
  }
  if (is.null(height) && is.null(max_height) && !isTRUE(auto_resize)) {
    height <- 400
  }
  events <- .el_event_bindings(
    ns_id,
    c(
      "column-sort",
      "expanded-rows-change",
      "end-reached",
      "scroll",
      "rows-rendered",
      "row-expand"
    ),
    # both fire on every frame of a scroll
    throttle = c("scroll", "rows-rendered")
  )
  attrs <- c(list(), events$attrs)
  props <- .el_props(
    list(
      cache = cache,
      estimated_row_height = estimated_row_height,
      header_class = header_class,
      header_props = header_props,
      header_cell_props = header_cell_props,
      header_height = header_height,
      footer_height = footer_height,
      row_class = row_class,
      row_key = row_key,
      row_props = row_props,
      row_height = row_height,
      row_event_handlers = row_event_handlers,
      cell_props = cell_props,
      columns = columns,
      data = data,
      data_getter = data_getter,
      fixed_data = fixed_data,
      expand_column_key = expand_column_key,
      expanded_row_keys = expanded_row_keys,
      default_expanded_row_keys = default_expanded_row_keys,
      fixed = fixed,
      table_v2_width = table_v2_width,
      height = height,
      max_height = max_height,
      indent_size = indent_size,
      h_scrollbar_size = h_scrollbar_size,
      v_scrollbar_size = v_scrollbar_size,
      scrollbar_always_on = scrollbar_always_on,
      sort_by = sort_by,
      sort_state = sort_state
    ),
    rename = c(table_v2_width = "width")
  )
  if (!isTRUE(auto_resize)) {
    return(el_widget(
      id = ns_id,
      markup = htmltools::tag("el-table-v2", c(attrs, props$attrs)),
      data = props$data,
      methods = c(events$methods, methods),
      width = width,
      slots = slots
    ))
  }
  # el-auto-resizer measures its box and hands the table its size through
  # its slot; the table's own slots go inside, on the table
  sized <- props$attrs[!names(props$attrs) %in% c(":width", ":height")]
  # ref="el": call_el() reaches the table, not the resizer around it
  table <- htmltools::tag(
    "el-table-v2",
    c(
      list(ref = "el"),
      attrs,
      sized,
      list(":width" = "size.width", ":height" = "size.height")
    )
  )
  filled <- if (length(slots)) {
    .el_slot_markup(
      slots,
      taken = c(names(props$data), names(events$methods), names(methods))
    )
  }
  table <- .el_append_children(table, filled$markup)
  el_widget(
    id = ns_id,
    markup = htmltools::tag(
      "el-auto-resizer",
      list(htmltools::tag("template", list("v-slot:default" = "size", table)))
    ),
    data = c(props$data, filled$data),
    methods = c(events$methods, methods, filled$methods),
    watch = filled$watch,
    dependency = filled$dependencies,
    width = width
  )
}


#' Update Element Plus Virtualized Table
#'
#' Server-side update for [el_table_v2()]: every argument that can change
#' once the table is drawn, under the same name. One left `NULL` stays as it
#' is; `NA` returns a prop to Element's default. Rows are given as for
#' [el_table_v2()], a data.frame or a list of rows; a data.frame without
#' `columns` keeps the table's columns. `methods`, `slots`, `width`,
#' `auto_resize` and `default_expanded_row_keys`, which Element reads only
#' when the table is created, are not here.
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id Table ID (un-namespaced).
#' @param data,columns,sort_by,expanded_row_keys New values; `NULL` leaves
#'   one unchanged.
#' @inheritParams el_table_v2
#'
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$filter_on, {
#'     update_el_table_v2(id = "big", data = subset(big, keep))
#'   })
#'   # any other argument of el_table_v2()
#'   update_el_table_v2(id = "big", sort_state = list(id = "desc"))
#' }
#' @export
update_el_table_v2 <- function(
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
) {
  .el_check_session(session)
  props <- mget(
    c(
      "cache",
      "estimated_row_height",
      "header_class",
      "header_props",
      "header_cell_props",
      "header_height",
      "footer_height",
      "row_class",
      "row_key",
      "row_props",
      "row_height",
      "row_event_handlers",
      "cell_props",
      "data_getter",
      "fixed_data",
      "expand_column_key",
      "fixed",
      "table_v2_width",
      "height",
      "max_height",
      "indent_size",
      "h_scrollbar_size",
      "v_scrollbar_size",
      "scrollbar_always_on",
      "sort_state"
    ),
    environment()
  )
  msg <- c(
    list(id = session$ns(id)),
    .el_update_props(
      "el_table_v2",
      Filter(Negate(is.null), props),
      rename = c(table_v2_width = "width")
    )
  )
  if (is.data.frame(data)) {
    data <- .el_table_rows(data)
  }
  if (!is.null(data)) {
    msg$data <- data
  }
  if (!is.null(columns)) {
    msg$columns <- columns
  }
  if (!is.null(sort_by)) {
    msg$sortBy <- sort_by
  }
  if (!is.null(expanded_row_keys)) {
    # an array in Element Plus, even of one key: jsonlite would write "a"
    msg$expandedRowKeys <- as.list(expanded_row_keys)
  }
  .el_send_update(session, msg)
  invisible(NULL)
}
