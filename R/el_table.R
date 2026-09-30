#' Coerce table data to a list of rows
#'
#' Element UI's `el-table` binds `:data` to an array of row objects. An R
#' data.frame handed straight to htmlwidgets serialises column-wise into
#' `{col: [...]}`, which the component silently renders as an empty table.
#'
#' Column names are sanitised because `el-table-column`'s `prop` is resolved
#' as a dotted path (`getPropByPath`), so a column literally named
#' `Sepal.Length` would be looked up as `row$Sepal$Length` and come back empty.
#'
#' @param data A data.frame or an already row-shaped list.
#' @return A list of named lists, one per row.
#' @keywords internal
.el_table_rows <- function(data) {
  if (!is.data.frame(data)) return(data)

  nms  <- names(data)
  safe <- gsub("\\.", "_", nms)

  lapply(seq_len(nrow(data)), function(i) {
    row <- lapply(nms, function(col) {
      val <- data[[col]][i]
      if (is.factor(val)) as.character(val) else val
    })
    names(row) <- safe
    row
  })
}

#' Derive `el-table-column` configs from data
#'
#' @param data A data.frame or a row-shaped list.
#' @return A list of `list(prop=, label=)` configs.
#' @keywords internal
.el_table_infer_columns <- function(data) {
  if (is.data.frame(data)) {
    nms <- names(data)
  } else {
    if (!length(data)) return(list())
    nms <- names(data[[1]])
  }
  if (!length(nms)) return(list())

  # Row names carry no heading, as when R prints a data.frame
  labels <- ifelse(nms == "rowname", "", nms)
  Map(function(prop, label) list(prop = prop, label = label),
      gsub("\\.", "_", nms), labels, USE.NAMES = FALSE)
}

#' Align user-supplied column configs with sanitised data keys
#'
#' @param columns A list of column configs.
#' @return The same list with each `prop` sanitised.
#' @keywords internal
.el_table_sanitize_columns <- function(columns) {
  if (!is.list(columns)) {
    stop(
      "`columns` must be a list of column definitions, not ",
      class(columns)[1], ". Did you mean el_table(id = ..., data = ...)?",
      call. = FALSE
    )
  }
  lapply(columns, function(col) {
    if (!is.null(col$prop)) col$prop <- gsub("\\.", "_", col$prop)
    # The template reads each prop off the column object in camelCase, so a
    # snake_case key would be there but never looked at -- silently doing
    # nothing. Accept both, as the rest of the package does.
    snake <- grep("_", names(col), value = TRUE)
    for (key in setdiff(snake, "header_html")) {
      col[[.el_camel_case(key)]] <- col[[key]]
      col[[key]] <- NULL
    }
    if (!is.null(col$header_html)) {
      col$headerHtml <- col$header_html
      col$header_html <- NULL
    }
    col
  })
}

#' What each table event reports
#'
#' Element hands most table events the row object and its internal column
#' object. Sent as they are they reach R flattened into one character vector,
#' so each event is shaped into a named list instead: the 1-based
#' `row_index` to index the original data with, the `row` itself, and the
#' column's `prop` rather than the column object.
#'
#' @return A named list of JavaScript functions, one per event.
#' @keywords internal
.el_table_event_shapes <- function() {
  idx <- "window.shinyElement.rowIndex(this, %s)"
  col <- "window.shinyElement.colProp(%s)"
  row_event <- sprintf(
    "function(row, column) { return {row_index: %s, row: row, column: %s}; }",
    sprintf(idx, "row"), sprintf(col, "column"))
  cell_event <- sprintf(paste0(
    "function(row, column) { var prop = %s; ",
    "return {row_index: %s, row: row, column: prop, value: row[prop]}; }"),
    sprintf(col, "column"), sprintf(idx, "row"))
  header_event <- sprintf(
    "function(column) { return {column: %s, label: column.label}; }",
    sprintf(col, "column"))
  sel_rows <- paste0(
    "(selection || []).map(function(r) { return window.shinyElement.rowIndex(vm, r); })")

  list(
    "row-click"          = row_event,
    "row-dblclick"       = row_event,
    "row-contextmenu"    = row_event,
    "cell-click"         = cell_event,
    "cell-dblclick"      = cell_event,
    "cell-mouse-enter"   = cell_event,
    "cell-mouse-leave"   = cell_event,
    "header-click"       = header_event,
    "header-contextmenu" = header_event,
    "select" = paste0(
      "function(selection, row) { var vm = this; return {rows: ", sel_rows,
      ", row_index: window.shinyElement.rowIndex(vm, row)}; }"),
    "select-all" = paste0(
      "function(selection) { var vm = this; return {rows: ", sel_rows, "}; }"),
    "sort-change" =
      "function(s) { return {column: s.prop, order: s.order}; }",
    "current-change" = sprintf(paste0(
      "function(row, old) { return {row_index: %s, row: row, ",
      "previous_index: %s}; }"), sprintf(idx, "row"), sprintf(idx, "old")),
    "header-dragend" = sprintf(paste0(
      "function(newWidth, oldWidth, column) { return {column: %s, ",
      "width: newWidth, previous_width: oldWidth}; }"), sprintf(col, "column")),
    "expand-change" = sprintf(paste0(
      "function(row, expanded) { var vm = this; return {row_index: %s, ",
      "expanded: Array.isArray(expanded) ? expanded.map(function(r) { ",
      "return window.shinyElement.rowIndex(vm, r); }) : expanded}; }"),
      sprintf(idx, "row"))
  )
}


#' Keep a data.frame's row names as a column, when they mean something
#'
#' `mtcars` keeps its car names in the row names, and a table that drops them
#' drops the one column saying what each row is. Automatic row names -- 1 to
#' n -- say nothing, so they are left out unless asked for.
#'
#' @param data A data.frame, or anything else (returned unchanged).
#' @param rownames `TRUE` or `FALSE` to force it; `NULL` keeps them only when
#'   they are not the automatic ones.
#' @return The data, with a `rowname` column first when kept.
#' @keywords internal
.el_table_rownames <- function(data, rownames = NULL) {
  if (!is.data.frame(data)) return(data)
  # Row numbers are not names, whether automatic (1..n) or left over from a
  # subset (3, 7, 12) -- .row_names_info() calls head(iris)'s names real ones
  keep <- if (is.null(rownames)) {
    !all(grepl("^[0-9]+$", rownames(data)))
  } else {
    isTRUE(rownames)
  }
  if (!keep || "rowname" %in% names(data)) return(data)
  cbind(data.frame(rowname = rownames(data), stringsAsFactors = FALSE), data)
}


#' Accept the pre-0.1.0 `el_table(data, columns, id)` argument order
#'
#' `el_table()` used to take `data` first, which put it out of step with every
#' other component. Positional calls written against the old order land a
#' data.frame in `id`, so shift them back one slot and warn, rather than
#' letting the data be used as an element id.
#'
#' @param id,data,columns The arguments as received by [el_table()].
#' @return A list with elements `id`, `data` and `columns`.
#' @keywords internal
.el_table_args <- function(id, data, columns) {
  if (is.null(id) || (is.character(id) && length(id) == 1L)) {
    return(list(id = id, data = data, columns = columns))
  }

  warning(
    "el_table() now takes `id` first, to match the other components. ",
    "Interpreting the first argument as `data`. Name the arguments to ",
    "silence this: el_table(id = \"my_table\", data = df).",
    call. = FALSE
  )

  list(
    # The old order was (data, columns, id): each argument moves one slot left.
    id = if (is.character(columns) && length(columns) == 1L) columns else NULL,
    data = id,
    columns = if (is.list(data)) data else list()
  )
}

#' Normalise the data/columns pair for `el_table()`
#'
#' @param data A data.frame or a row-shaped list.
#' @param columns A list of column configs; inferred from `data` when empty.
#' @return A list with elements `rows` and `columns`.
#' @keywords internal
.el_table_prep <- function(data = list(), columns = list()) {
  list(
    rows = .el_table_rows(data),
    columns = if (length(columns)) {
      .el_table_sanitize_columns(columns)
    } else {
      .el_table_infer_columns(data)
    }
  )
}

#' Element UI Table Component
#'
#' Create a table widget for Shiny using Element UI.
#'
#' @param id Table ID (auto-generated if NULL)
#' @param data A data.frame, or a list of rows (each a named list). A
#'   data.frame is converted to rows automatically and its column names are
#'   sanitised (`.` becomes `_`) so `el-table`'s dotted `prop` lookup works.
#' @param columns List of column configs, each `list(prop=, label=, width=)`.
#'   Inferred from `data` when omitted. A column may also carry
#'   `header_html`, markup for its header cell -- inserted unescaped, so pass
#'   only what you control.
#' @param rownames Whether to show a data.frame's row names as the first
#'   column. `NULL` (the default) shows them when they carry something --
#'   `mtcars`' car names -- and leaves out automatic ones, which only count
#'   rows.
#' @param selection Enable row selection
#' @param border Show table border
#' @param session Shiny session for module support
#' @param stripe Whether rows alternate background colour.
#' @param size Row density: `"medium"`, `"small"` or `"mini"`.
#' @param height Table height. Fixes the header and scrolls the body.
#' @param max_height Maximum table height, beyond which the body scrolls.
#' @param fit Whether column widths stretch to fill the table. Default `TRUE`.
#' @param show_header Whether the header row is shown. Default `TRUE`.
#' @param highlight_current_row Whether the clicked row stays highlighted; pairs with `input$<id>_current`.
#' @param current_row_key Key of the row highlighted at start. Needs `row_key`.
#' @param row_key Column whose value identifies a row. Needed for tree data and reserved selection.
#' @param empty_text Text shown when there are no rows. Default `"No Data"`.
#' @param default_expand_all Whether expandable rows start expanded.
#' @param expand_row_keys Keys of the rows that start expanded. Needs `row_key`.
#' @param default_sort Initial sort, as `list(prop =, order =)`.
#' @param tooltip_effect Theme of overflow tooltips: `"dark"` (default) or `"light"`.
#' @param show_summary Whether to add a summary row at the bottom.
#' @param sum_text Label of the summary row's first cell. Default `"Sum"`.
#' @param select_on_indeterminate What the header checkbox does when only some rows are selected. Default `TRUE`.
#' @param indent Horizontal indent between tree levels, in pixels. Default `16`.
#' @param lazy Whether child rows of tree data are loaded on demand.
#' @param tree_props Field names for tree data, as `list(children =, hasChildren =)`.
#' @param row_class_name Class name for every row, or a JS function returning one.
#' @param row_style Inline style for every row, or a JS function returning one.
#' @param cell_class_name Class name for every cell, or a JS function returning one.
#' @param cell_style Inline style for every cell, or a JS function returning one.
#' @param header_row_class_name Class name for the header row, or a JS function returning one.
#' @param header_row_style Inline style for the header row, or a JS function returning one.
#' @param header_cell_class_name Class name for header cells, or a JS function returning one.
#' @param header_cell_style Inline style for header cells, or a JS function returning one.
#' @param span_method `htmlwidgets::JS()` function deciding row/column spans for merged cells.
#' @param summary_method `htmlwidgets::JS()` function returning the summary row's cells.
#' @param load `htmlwidgets::JS()` function loading child rows lazily. Needs `lazy = TRUE`.
#' @param width Component width, as a CSS unit. Replaces the table's default
#' @param slots Named list of Element slot contents, such as
#' @param highlight_selection_row Whether rows ticked with `selection = TRUE` are highlighted.
#'   `list(title = shiny::tags$b("Bold"))`. A shiny.element component
#'   given here is absorbed rather than nested. For a scoped slot, write
#'   the template with [template()].
#'   `width: 100%`. For a fixed header use `height` instead.
#'
#' @section Server inputs:
#' With `selection = TRUE` the component reports two inputs:
#' `input$<id>_selected` (the selected row objects) and
#' `input$<id>_selected_rows` (their 1-based row numbers). Prefer the latter to
#' index back into your original data: a row object with mixed column types is
#' simplified to a character vector on its way back through JSON, so numbers
#' arrive as strings. Both are `NULL` while nothing is selected, matching how
#' Shiny reports an empty [shiny::checkboxGroupInput()].
#'
#' @section Element methods:
#' Callable with [el_call()]:
#'
#' - `clearFilter()` -- Clear filters of the columns whose columnKey are passed in. If no params, clear all filters
#' - `clearSelection()` -- Used in multiple selection Table, clear user selection
#' - `clearSort()` -- Clear sorting, restore data to the original order
#' - `doLayout()` -- Refresh the layout of Table. When the visibility of Table changes, you may need to call this method to get...
#' - `setCurrentRow()` -- Used in single selection Table, set a certain row selected. If called without any parameter, it will clear...
#' - `sort()` -- Sort Table manually. Property prop is used to set sort column, property order is used to set sort order
#' - `toggleAllSelection()` -- Used in multiple selection Table, toggle the selected state of all rows
#' - `toggleRowExpansion()` -- Used in expandable Table or tree Table, toggle if a certain row is expanded. With the second parameter,...
#' - `toggleRowSelection()` -- Used in multiple selection Table, toggle if a certain row is selected. With the second parameter, you can...
#'
#' @return A Shiny UI element.
#' @export
#' @examples
#' # A data.frame is enough -- columns are inferred
#' el_table("iris_preview", data = head(iris, 3))
#'
#' # Explicit columns
#' el_table(
#'   "scores",
#'   data = data.frame(name = c("A", "B"), value = c(1, 2)),
#'   columns = list(
#'     list(prop = "name", label = "Name"),
#'     list(prop = "value", label = "Value", width = "100")
#'   )
#' )
#'
#' # Shiny app with row selection and server-side updates
#' if (interactive()) {
#'   library(shiny)
#'   library(shiny.element)
#'   ui <- el_page(
#'     el_table("my_table", data = head(iris, 5), selection = TRUE),
#'     el_button("reload", "Show more rows"),
#'     verbatimTextOutput("selected_rows")
#'   )
#'   server <- function(input, output, session) {
#'     output$selected_rows <- renderPrint({
#'       # *_selected_rows holds 1-based row numbers, with original R types
#'       head(iris, 5)[input$my_table_selected_rows, ]
#'     })
#'     observeEvent(input$reload, {
#'       update_el_table(session, "my_table", data = head(iris, 10))
#'     })
#'   }
#'   shinyApp(ui, server)
#' }
el_table <- function(id = NULL,
                     data = list(),
                     columns = list(),
                     selection = FALSE,
                     rownames = NULL,
                     border = TRUE,
                     stripe  = NULL,
                     size    = NULL,
                     height  = NULL,
                     max_height = NULL,
                     fit     = NULL,
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
                     indent  = NULL,
                     lazy    = NULL,
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
                     load    = NULL,
                     width  = NULL,
                     slots   = NULL,
                     highlight_selection_row = NULL,
                     session = shiny::getDefaultReactiveDomain()) {
  args <- .el_table_args(id, data, columns)
  id <- args$id
  data <- args$data
  columns <- args$columns

  if (is.null(id)) {
    id <- paste0("el_table_", uuid::UUIDgenerate())
  }
  ns_id <- if (!is.null(session)) session$ns(id) else id
  container_id <- paste0(ns_id, "_container")

  data <- .el_table_rownames(data, rownames)
  prep <- .el_table_prep(data, columns)

  # Columns are rendered with v-for rather than baked into the markup, so
  # update_el_table() can change them -- Vue only tracks fields declared in
  # `data`, and a column set generated in R would be frozen at render time.
  selection_col <- htmltools::tag("el-table-column", list(
    "v-if" = "selection",
    type   = "selection",
    width  = "55"
  ))
  # Every documented column prop is bound off the column object, so a user
  # writes list(prop = "x", sortable = TRUE, align = "center") and Element
  # sees it. An absent key reads back as undefined, which is Element's own
  # default -- the same fallback .el_optional_bind() arranges for props.
  data_col <- htmltools::tag("el-table-column", list(
    "v-for"  = "col in columns",
    ":key"   = "col.prop",
    ":prop"  = "col.prop",
    ":label" = "col.label",
    ":width" = "col.width",
    ":align" = "col.align",
    ":header-align" = "col.headerAlign",
    ":class-name" = "col.className",
    ":label-class-name" = "col.labelClassName",
    ":column-key" = "col.columnKey",
    ":min-width" = "col.minWidth",
    ":fixed" = "col.fixed",
    ":resizable" = "col.resizable",
    ":sortable" = "col.sortable",
    ":sort-by" = "col.sortBy",
    ":sort-orders" = "col.sortOrders",
    ":show-overflow-tooltip" = "col.showOverflowTooltip",
    ":filters" = "col.filters",
    ":filtered-value" = "col.filteredValue",
    ":filter-multiple" = "col.filterMultiple",
    ":filter-placement" = "col.filterPlacement",
    ":reserve-selection" = "col.reserveSelection",
    ":index" = "col.index",
    # Props taking a function: pass htmlwidgets::JS("function(...) {...}") in
    # the column definition and it is evaluated in the browser.
    ":formatter" = "col.formatter",
    ":filter-method" = "col.filterMethod",
    ":sort-method" = "col.sortMethod",
    ":render-header" = "col.renderHeader",
    ":selectable" = "col.selectable",
    # A column may render its own header: give it header_html in the column
    # definition. It is inserted as markup, so only pass what you control.
    htmltools::tag("template", list(
      slot = "header", "slot-scope" = "scope",
      htmltools::tag("span", list("v-if" = "col.headerHtml",
                                  "v-html" = "col.headerHtml")),
      htmltools::tag("span", list("v-else" = NA, "{{col.label}}"))
    ))
  ))

  table_attrs <- list(
    ":data"             = "tableData",
    ":border"           = "border",
    style               = "width: 100%",
    # Always bound: selection can be switched on later by update_el_table().
    "@selection-change" = "handleSelectionChange"
  )

  # The rest of Element's table events are forwarded as-is; each sets
  # input$<id>_<event>, e.g. input$tbl_row_click.
  events <- .el_event_bindings(ns_id, c(
    "select", "select-all", "cell-click", "cell-dblclick",
    "cell-mouse-enter", "cell-mouse-leave", "row-click", "row-dblclick",
    "row-contextmenu", "header-click", "header-contextmenu", "header-dragend",
    "sort-change", "filter-change", "current-change", "expand-change"
  ), shapes = .el_table_event_shapes())
  table_attrs <- c(table_attrs, events$attrs)

  table_attrs[[":stripe"]] <- .el_optional_bind("stripe")

  table_attrs[[":size"]] <- .el_optional_bind("size")

  table_attrs[[":height"]] <- .el_optional_bind("height")

  table_attrs[[":max-height"]] <- .el_optional_bind("maxHeight")

  table_attrs[[":fit"]] <- .el_optional_bind("fit")

  table_attrs[[":show-header"]] <- .el_optional_bind("showHeader")

  table_attrs[[":highlight-current-row"]] <- .el_optional_bind("highlightCurrentRow")

  table_attrs[[":current-row-key"]] <- .el_optional_bind("currentRowKey")

  table_attrs[[":row-key"]] <- .el_optional_bind("rowKey")

  table_attrs[[":empty-text"]] <- .el_optional_bind("emptyText")

  table_attrs[[":default-expand-all"]] <- .el_optional_bind("defaultExpandAll")

  table_attrs[[":expand-row-keys"]] <- .el_optional_bind("expandRowKeys")

  table_attrs[[":default-sort"]] <- .el_optional_bind("defaultSort")

  table_attrs[[":tooltip-effect"]] <- .el_optional_bind("tooltipEffect")

  table_attrs[[":show-summary"]] <- .el_optional_bind("showSummary")

  table_attrs[[":sum-text"]] <- .el_optional_bind("sumText")

  table_attrs[[":select-on-indeterminate"]] <- .el_optional_bind("selectOnIndeterminate")

  table_attrs[[":indent"]] <- .el_optional_bind("indent")

  table_attrs[[":lazy"]] <- .el_optional_bind("lazy")

  table_attrs[[":tree-props"]] <- .el_optional_bind("treeProps")

  table_attrs[[":row-class-name"]] <- .el_optional_bind("rowClassName")

  table_attrs[[":row-style"]] <- .el_optional_bind("rowStyle")

  table_attrs[[":cell-class-name"]] <- .el_optional_bind("cellClassName")

  table_attrs[[":cell-style"]] <- .el_optional_bind("cellStyle")

  table_attrs[[":header-row-class-name"]] <- .el_optional_bind("headerRowClassName")

  table_attrs[[":header-row-style"]] <- .el_optional_bind("headerRowStyle")

  table_attrs[[":header-cell-class-name"]] <- .el_optional_bind("headerCellClassName")

  table_attrs[[":header-cell-style"]] <- .el_optional_bind("headerCellStyle")

  table_attrs[[":span-method"]] <- .el_optional_bind("spanMethod")

  table_attrs[[":summary-method"]] <- .el_optional_bind("summaryMethod")

  table_attrs[[":load"]] <- .el_optional_bind("load")

  table_attrs[[":highlight-selection-row"]] <- .el_optional_bind("highlightSelectionRow")


  table_content <- c(table_attrs, list(selection_col, data_col))

  el_widget(
    id     = ns_id,
    markup = htmltools::tag("el-table", table_content),
    data = list(
      tableData    = prep$rows,
      columns      = prep$columns,
      border       = border,
      selection    = selection,
      selected     = list(),
      selectedRows = list(),
    stripe = .el_or_na(stripe),
    size = .el_or_na(size),
    height = .el_or_na(height),
    maxHeight = .el_or_na(max_height),
    fit = .el_or_na(fit),
    showHeader = .el_or_na(show_header),
    highlightCurrentRow = .el_or_na(highlight_current_row),
    currentRowKey = .el_or_na(current_row_key),
    rowKey = .el_or_na(row_key),
    emptyText = .el_or_na(empty_text),
    defaultExpandAll = .el_or_na(default_expand_all),
    expandRowKeys = .el_or_na(expand_row_keys),
    defaultSort = .el_or_na(default_sort),
    tooltipEffect = .el_or_na(tooltip_effect),
    showSummary = .el_or_na(show_summary),
    sumText = .el_or_na(sum_text),
    selectOnIndeterminate = .el_or_na(select_on_indeterminate),
    indent = .el_or_na(indent),
    lazy = .el_or_na(lazy),
    treeProps = .el_or_na(tree_props),
    rowClassName = .el_or_na(row_class_name),
    rowStyle = .el_or_na(row_style),
    cellClassName = .el_or_na(cell_class_name),
    cellStyle = .el_or_na(cell_style),
    headerRowClassName = .el_or_na(header_row_class_name),
    headerRowStyle = .el_or_na(header_row_style),
    headerCellClassName = .el_or_na(header_cell_class_name),
    headerCellStyle = .el_or_na(header_cell_style),
    spanMethod = .el_or_na(span_method),
    summaryMethod = .el_or_na(summary_method),
    load = .el_or_na(load),
    highlightSelectionRow = .el_or_na(highlight_selection_row)
    ),
    methods = c(events$methods, list(
      handleSelectionChange = htmlwidgets::JS(sprintf(
        paste0(
          "function(selection) { var self = this; ",
          "self.selected = selection; ",
          "self.selectedRows = selection.map(function(r) { ",
          "return self.tableData.indexOf(r) + 1; }); ",
          "Shiny.setInputValue('%s_selected', self.selected); ",
          # Row numbers survive the JSON round-trip with their R types
          # intact, unlike the row objects themselves: a mixed-type row
          # is simplified to a character vector on the way back.
          "Shiny.setInputValue('%s_selected_rows', self.selectedRows); }"
        ),
        ns_id, ns_id
      ))
    )),
    mounted = .el_mounted_init(stats::setNames(
      c("selected", "selectedRows"),
      paste0(ns_id, c("_selected", "_selected_rows"))
    )),
    width      = width,
    slots      = slots,
    dependency = el_table_handler_dependency()
  )
}

#' Update Element UI Table
#'
#' @param session Shiny session object.
#' @param id Table ID (un-namespaced).
#' @param data New data: a data.frame or a list of rows.
#' @param columns New column configs; inferred from `data` when omitted.
#' @param border New border state.
#' @param selection New row-selection state.
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$go, {
#'     update_el_table(session, "tbl", data = head(mtcars, 10))
#'   })
#' }
#' @export
update_el_table <- function(session, id,
                            data = NULL,
                            columns = NULL,
                            border = NULL,
                            selection = NULL) {
  ns_id <- session$ns(id)
  msg <- list(id = ns_id)

  if (!is.null(data) || !is.null(columns)) {
    prep <- .el_table_prep(
      if (is.null(data)) list() else data,
      if (is.null(columns)) list() else columns
    )
    # Named for the Vue data field it targets: the shared updater assigns by
    # key, so a message field that does not match is refused.
    if (!is.null(data)) msg$tableData <- prep$rows
    # Send columns whenever they were inferred or cleaned, otherwise a new
    # data set would render against the previous column set.
    if (length(prep$columns)) msg$columns <- prep$columns
  }
  if (!is.null(border))    msg$border    <- border
  if (!is.null(selection)) msg$selection <- selection

  session$sendCustomMessage("updateElTable", msg)
  invisible(NULL)
}

#' Prepare Data for Element Table
#'
#' @param df Data frame
#' @param max_rows Max rows to show
#' @param add_name Add row names
#' @return List with data and columns
#'
#' @details
#' Superseded: [el_table()] now accepts a data.frame directly and infers its
#' columns, so this helper is only needed for its extra behaviour (dropping
#' incomplete rows, capping row count, prepending a row-name column).
#'
#' Note it drops rows with any `NA` via [stats::na.omit()] and overwrites a
#' column literally named `name` when `add_name = TRUE`.
#'
#' @examples
#' cfg <- el_table_config(head(iris, 3))
#' str(cfg$columns, max.level = 2)
#'
#' # Cap the rows and leave out the row-name column
#' el_table_config(iris, max_rows = 5, add_name = FALSE)
#' @export
el_table_config <- function(df, max_rows = NULL, add_name = TRUE) {
  if (!is.null(max_rows)) {
    df <- df[seq_len(min(max_rows, nrow(df))), , drop = FALSE]
  }
  df <- na.omit(df)
  original_names <- names(df)
  safe_names <- gsub("\\.", "_", original_names)
  names(df) <- safe_names

  data <- lapply(seq_len(nrow(df)), function(i) {
    row <- lapply(safe_names, function(col) {
      val <- df[i, col]
      if (is.factor(val)) as.character(val[[1]])
      else if (is.numeric(val)) as.numeric(val[[1]])
      else as.character(val[[1]])
    })
    names(row) <- safe_names
    if (add_name) row$name <- rownames(df)[i]
    row
  })

  columns <- list(list(prop = "name", label = "row_name", width = "150"))
  for (i in seq_along(safe_names)) {
    col_class <- class(df[[safe_names[i]]])[1]
    width <- if (col_class %in% c("numeric", "integer")) "100" else "120"
    columns <- c(columns, list(list(
      prop = safe_names[i],
      label = paste0(original_names[i], " (", col_class, ")"),
      width = width
    )))
  }
  list(data = data, columns = columns)
}
