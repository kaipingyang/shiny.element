#' Coerce table data to a list of rows
#'
#' Element Plus's `el-table` binds `:data` to an array of row objects. An R
#' data.frame serialised as it stands comes out column-wise, `{col: [...]}`,
#' which the component silently renders as an empty table.
#'
#' Column names are sanitised because `el-table-column`'s `prop` is resolved
#' as a dotted path (`getPropByPath`), so a column literally named
#' `Sepal.Length` would be looked up as `row$Sepal$Length` and come back empty.
#'
#' @param data A data.frame or an already row-shaped list.
#' @return A list of named lists, one per row.
#' @keywords internal
.el_table_rows <- function(data) .vue_rows(data)

#' Derive `el-table-column` configs from data
#'
#' @param data A data.frame or a row-shaped list.
#' @return A list of `list(prop=, label=)` configs.
#' @keywords internal
.el_table_infer_columns <- function(data) {
  if (is.data.frame(data)) {
    nms <- names(data)
  } else {
    if (!length(data)) {
      return(list())
    }
    nms <- names(data[[1]])
  }
  if (!length(nms)) {
    return(list())
  }

  # Row names carry no heading, as when R prints a data.frame
  labels <- ifelse(nms == "rowname", "", nms)
  Map(
    function(prop, label) list(prop = prop, label = label),
    gsub("\\.", "_", nms),
    labels,
    USE.NAMES = FALSE
  )
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
      class(columns)[1],
      ". Did you mean el_table(id = ..., data = ...)?",
      call. = FALSE
    )
  }
  lapply(columns, function(col) {
    if (!is.null(col$prop)) {
      col$prop <- gsub("\\.", "_", col$prop)
    }
    # A group header's columns, as Element nests el-table-column
    if (!is.null(col$children)) {
      col$children <- .el_table_sanitize_columns(col$children)
    }
    # The template reads each prop off the column object in camelCase, so a
    # snake_case key would be there but never looked at -- silently doing
    # nothing. Accept both, as the rest of the package does.
    snake <- grep("_", names(col), value = TRUE)
    for (key in setdiff(snake, "header_html")) {
      col[[.el_camel_case(key)]] <- col[[key]]
      col[[key]] <- NULL
    }
    if (!is.null(col$headerHtml)) {
      col$headerHtml <- .el_html_string(col$headerHtml, "headerHtml")
    }
    if (!is.null(col$header_html)) {
      col$headerHtml <- .el_html_string(col$header_html, "header_html")
      col$header_html <- NULL
    }
    # An editable column: its cells are an editor's template
    if (!is.null(col$editable)) {
      editable <- col$editable
      col$editable <- NULL
      editor <- col$editor
      col$editor <- NULL
      if (!isFALSE(editable)) {
        if (!is.null(col$cell)) {
          stop(
            "A column is `editable` or has a `cell` template, not both.",
            call. = FALSE
          )
        }
        if (is.null(col$prop)) {
          stop("An `editable` column needs a `prop`.", call. = FALSE)
        }
        col$cell <- .el_table_editor(col$prop, editable, editor)
        col$editableProp <- col$prop
      }
    }
    col
  })
}

#' The cell template of an editable column
#'
#' The value as text; double-clicked, Element's editor for it, which Enter
#' or leaving it commits, Escape abandons and Tab commits, moving to the
#' next editable cell. The table's `startEdit()`, `commitEdit()` and
#' `cancelEdit()` do the rest.
#'
#' @param prop The column's prop, sanitised.
#' @param editable `TRUE` or the editor: `"input"`, `"number"`, `"select"`
#'   or `"date"`.
#' @param editor Props of the editor, `choices` for a select.
#' @return Markup, the column's `cell`.
#' @keywords internal
.el_table_editor <- function(prop, editable, editor = NULL) {
  kinds <- c("input", "number", "select", "date")
  if (isTRUE(editable)) {
    editable <- "input"
  }
  if (
    !is.character(editable) || length(editable) != 1L || !editable %in% kinds
  ) {
    stop(
      "`editable` is TRUE or one of ",
      paste(dQuote(kinds, FALSE), collapse = ", "),
      ".",
      call. = FALSE
    )
  }
  editor <- as.list(editor)
  js <- function(x) as.character(jsonlite::toJSON(x, auto_unbox = TRUE))
  # a value written into a template attribute: JSON with single quotes
  lit <- function(x) {
    gsub('"', "'", gsub("'", "\\\\u0027", js(x)), fixed = TRUE)
  }
  here <- sprintf("scope, %s", lit(prop))
  commit <- sprintf("commitEdit(false, %s)", here)
  choices <- editor$choices
  editor$choices <- NULL
  # the editor's own props, as Element names them
  props <- if (length(editor)) {
    stats::setNames(
      lapply(editor, js),
      paste0(":", gsub("_", "-", names(editor), fixed = TRUE))
    )
  }
  common <- c(
    list(
      `v-if` = sprintf("isEditing(%s)", here),
      `v-model` = "editing.value",
      size = "small",
      class = "el-table-edit-cell__editor",
      style = "width: 100%",
      `@keydown.tab.prevent` = sprintf("commitEdit(true, %s)", here),
      `@keyup.esc` = "cancelEdit()"
    ),
    props
  )
  field <- switch(
    editable,
    input = do.call(
      el$input,
      c(common, list(`@keyup.enter` = commit, `@blur` = commit))
    ),
    number = do.call(
      el$input_number,
      c(
        common,
        list(
          `controls-position` = "right",
          `@keyup.enter` = commit,
          `@blur` = commit
        )
      )
    ),
    select = do.call(
      el$select,
      c(
        common,
        list(
          `automatic-dropdown` = NA,
          `@change` = commit,
          # closed without a choice: the edit ends
          `@visible-change` = sprintf("$event || %s", commit),
          el$option(
            `v-for` = sprintf(
              "o in %s",
              lit(.el_normalize_choices(choices %||% character()))
            ),
            `:key` = "o.value",
            `:value` = "o.value",
            `:label` = "o.label"
          )
        )
      )
    ),
    date = do.call(
      el$date_picker,
      c(
        common,
        list(
          type = "date",
          `value-format` = "YYYY-MM-DD",
          `@change` = commit,
          `@blur` = commit
        )
      )
    )
  )
  htmltools::tags$div(
    class = "el-table-edit-cell",
    field,
    htmltools::tags$div(
      `v-else` = NA,
      class = "el-table-edit-cell__value",
      # an empty cell can still be double-clicked
      style = "min-height: 23px; cursor: text",
      `@dblclick` = sprintf("startEdit(%s)", here),
      sprintf("{{ scope.row[%s] }}", lit(prop))
    )
  )
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
    sprintf(idx, "row"),
    sprintf(col, "column")
  )
  cell_event <- sprintf(
    paste0(
      "function(row, column) { var prop = %s; ",
      "return {row_index: %s, row: row, column: prop, value: row[prop]}; }"
    ),
    sprintf(col, "column"),
    sprintf(idx, "row")
  )
  header_event <- sprintf(
    "function(column) { return {column: %s, label: column.label}; }",
    sprintf(col, "column")
  )
  sel_rows <- paste0(
    "(selection || []).map(function(r) { return window.shinyElement.rowIndex(vm, r); })"
  )

  list(
    "row-click" = row_event,
    "row-dblclick" = row_event,
    "row-contextmenu" = row_event,
    "cell-click" = cell_event,
    "cell-dblclick" = cell_event,
    "cell-mouse-enter" = cell_event,
    "cell-mouse-leave" = cell_event,
    "cell-contextmenu" = cell_event,
    "scroll" = paste0(
      "function(e) { ",
      "return {scroll_left: e.scrollLeft, scroll_top: e.scrollTop}; }"
    ),
    "header-click" = header_event,
    "header-contextmenu" = header_event,
    "select" = paste0(
      "function(selection, row) { var vm = this; return {rows: ",
      sel_rows,
      ", row_index: window.shinyElement.rowIndex(vm, row)}; }"
    ),
    "select-all" = paste0(
      "function(selection) { var vm = this; return {rows: ",
      sel_rows,
      "}; }"
    ),
    "sort-change" = "function(s) { return {column: s.prop, order: s.order}; }",
    "current-change" = sprintf(
      paste0(
        "function(row, old) { return {row_index: %s, row: row, ",
        "previous_index: %s}; }"
      ),
      sprintf(idx, "row"),
      sprintf(idx, "old")
    ),
    "header-dragend" = sprintf(
      paste0(
        "function(newWidth, oldWidth, column) { return {column: %s, ",
        "width: newWidth, previous_width: oldWidth}; }"
      ),
      sprintf(col, "column")
    ),
    "expand-change" = sprintf(
      paste0(
        "function(row, expanded) { var vm = this; return {row_index: %s, ",
        "expanded: Array.isArray(expanded) ? expanded.map(function(r) { ",
        "return window.shinyElement.rowIndex(vm, r); }) : expanded}; }"
      ),
      sprintf(idx, "row")
    )
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
  if (!is.data.frame(data)) {
    return(data)
  }
  # Row numbers are not names, whether automatic (1..n) or left over from a
  # subset (3, 7, 12) -- .row_names_info() calls head(iris)'s names real ones
  keep <- if (is.null(rownames)) {
    !all(grepl("^[0-9]+$", rownames(data)))
  } else {
    isTRUE(rownames)
  }
  if (!keep || "rowname" %in% names(data)) {
    return(data)
  }
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

#' Take the cell templates out of a table's columns
#'
#' A column's `cell` is markup, rendered once per row with `scope` -- `row`,
#' `column`, `$index` -- in reach. It cannot travel in the column object,
#' which is JSON in the Vue data, so it is lifted out into the template and
#' the column keeps a `cellKey` naming its branch there. `slot` decides
#' whether the column gets a default slot at all: a column without one must
#' have none, or Element's own rendering -- index numbers, formatters, the
#' tree's expand arrow -- would be replaced by an empty slot.
#'
#' The key is built from the column's prop or label, so that
#' [update_el_table()] given the same columns finds the same template.
#'
#' @param columns Sanitised column configs.
#' A group header's `children` are searched too, and `depths` records how
#' far down each template sits, so each level of the column template carries
#' only the branches it can use.
#'
#' @return A list: `columns`, without `cell`, `cells`, a named list of
#'   markup keyed by `cellKey`, and `depths`, the nesting level of each.
#' @keywords internal
.el_table_cells <- function(columns) {
  cells <- list()
  depths <- integer()
  lift <- function(columns, depth) {
    lapply(seq_along(columns), function(i) {
      col <- columns[[i]]
      # A group header's columns carry templates of their own, one level down
      if (!is.null(col$children)) {
        col$children <- lift(col$children, depth + 1L)
      }
      base <- if (!is.null(col$prop)) {
        col$prop
      } else if (!is.null(col$label)) {
        col$label
      } else {
        i
      }
      # a template for the cells, and one for the header cell
      keep <- function(kind) {
        key <- paste0(kind, "_", gsub("[^A-Za-z0-9_]", "_", base))
        if (key %in% names(cells)) {
          key <- paste0(key, "_", length(cells) + 1L)
        }
        cells[[key]] <<- col[[kind]]
        depths[[key]] <<- depth
        key
      }
      if (!is.null(col[["header"]])) {
        col$headerKey <- keep("header")
        col[["header"]] <- NULL
      }
      if (is.null(col[["cell"]])) {
        col$slot <- "none"
        return(col)
      }
      col$cellKey <- keep("cell")
      col[["cell"]] <- NULL
      col$slot <- "default"
      col
    })
  }
  columns <- lift(columns, 0L)
  list(columns = columns, cells = cells, depths = depths)
}

#' Normalise the data/columns pair for `el_table()`
#'
#' The columns a user wrote and the columns inferred from the data are kept
#' apart -- `columns` and `autoColumns` in the Vue data, the template showing
#' the first when there are any. A new data set then brings new inferred
#' columns without touching written ones: [update_el_table()] given only
#' `data` used to re-infer and send `columns`, which threw away every label,
#' formatter and cell template the table was created with.
#'
#' @param data A data.frame or a row-shaped list.
#' @param columns A list of column configs, possibly empty.
#' @return A list: `rows`, `columns` (as written, possibly empty), `auto`
#'   (inferred from `data`) and `cells` (the templates lifted out of
#'   `columns`).
#' @keywords internal
.el_table_prep <- function(data = list(), columns = list()) {
  cells <- .el_table_cells(.el_table_sanitize_columns(columns))
  list(
    rows = .el_table_rows(data),
    columns = cells$columns,
    auto = .el_table_cells(.el_table_infer_columns(data))$columns,
    cells = cells$cells,
    depths = cells$depths
  )
}

#' Element Plus Table Component
#'
#' Rows of data, with sorting, selection, fixed columns, cell templates and
#' row actions that report to the server.
#'
#' In a Shiny app a table is an output, as DT's and reactable's are: the
#' page holds [el_table_output()], the server renders `el_table()` into it
#' with [render_el_table()], and the output's id names the table's inputs.
#' Without Shiny -- R Markdown, Quarto, a pkgdown page -- `el_table()` is
#' placed as it is, with no id.
#'
#' `el_table()` returns the table's specification, drawn when it is placed
#' (as an htmlwidget is), so it can be piped to [el_on()] first.
#'
#' @param id The table's id. Leave it out: in an app the output's id is the
#'   table's. A table given an id in the UI still reports its inputs, but
#'   its data is then fixed in the page and `input$<id>_selection_change`
#'   gets its rows back through JSON rather than as R subsets them.
#' @param data A data.frame, or a list of rows (each a named list). A
#'   data.frame is converted to rows automatically and its column names are
#'   sanitised (`.` becomes `_`) so `el-table`'s dotted `prop` lookup works.
#'   A data.frame inside the rows, or in a list column, is rows too. A vector of one
#'   element travels as a single value, as in Shiny; wrap it in `I()` to
#'   keep it an array: `tags = I("red")`.
#' @param columns The columns, each an [el_table_column()] -- or a list of
#'   the same fields, `list(prop =, label =, width =)`.
#'   Inferred from `data` when omitted. Beyond Element's column attributes, a
#'   column may carry:
#'   * `type` -- `"index"` for row numbers, `"expand"` for a row that opens
#'     to show its `cell`, or `"selection"`.
#'   * `cell` -- markup for each cell, rendered once per row. `scope.row`,
#'     `scope.column` and `scope.$index` are in reach, and raw Element tags
#'     (`el$tag()`, `el$button()`) work: `el$tag(":type" = "scope.row.ok ?
#'     'success' : 'danger'", "{{ scope.row.status }}")`. A column without
#'     a `prop` -- a column of buttons -- is fine. See "Row actions" below.
#'   * `filter_icon` -- the filter's icon, by name.
#'   * `header_html` -- markup for the header cell, a string or htmltools
#'     tags, inserted unescaped, so pass only what you control.
#'   * `header` -- a template for the header cell, as `cell` is for the
#'     others: components and all, `scope.column` and `scope.$index` in
#'     reach. `el$input(size = "small", ...)` puts a search box there.
#'   * `children` -- the columns under a group header, as Element nests
#'     `el-table-column`: `list(label = "Address", children = list(...))`,
#'     as deep as you nest them; each child column takes `cell`, `header`
#'     and `header_html` as a top-level one does.
#' @param rownames Whether to show a data.frame's row names as the first
#'   column. `NULL` (the default) shows them when they carry something --
#'   `mtcars`' car names -- and leaves out automatic ones, which only count
#'   rows.
#' @param selection Enable row selection
#' @param border Draw vertical borders between columns and a frame around
#'   the table. Default `FALSE`, as in Element.
#' @param allow_drag_last_column Whether to allow drag the last column.
#'   Element Plus's `allow-drag-last-column` (boolean).
#' @param append_filter_panel_to Which element the filter panels appends to.
#'   Element Plus's `append-filter-panel-to` (string).
#' @param flexible Ensure main axis minimum-size doesn't follow the content.
#'   Element Plus's `flexible` (boolean).
#' @param native_scrollbar Whether to use native scrollbars. Element Plus's
#'   `native-scrollbar` (boolean).
#' @param preserve_expanded_content Whether to preserve expanded row content
#'   in DOM when collapsed. Element Plus's `preserve-expanded-content`
#'   (boolean).
#' @param row_expandable Enable expandable rows, works when the table has a
#'   column type="expand". Element Plus's `row-expandable` ((row: any, index:
#'   number) => boolean).
#' @param scrollbar_always_on Always show scrollbar. Element Plus's
#'   `scrollbar-always-on` (boolean).
#' @param scrollbar_tabindex Body scrollbar's wrap container tabindex. Element
#'   Plus's `scrollbar-tabindex` (string / number).
#' @param show_overflow_tooltip Whether to hide extra content and show them in
#'   a tooltip when hovering on the cell.It will affect all the table columns,
#'   refer to table tooltip-options. Element Plus's `show-overflow-tooltip`
#'   (boolean).
#' @param table_layout Sets the algorithm used to lay out table cells, rows,
#'   and columns. Element Plus's `table-layout` ('fixed' | 'auto').
#' @param tooltip_formatter Customize tooltip content when using
#'   `show-overflow-tooltip`. Element Plus's `tooltip-formatter` (Function).
#'   Give it as [JS()].
#' @param tooltip_options The options for the overflow tooltip, see the
#'   following tooltip component. Element Plus's `tooltip-options` (object).
#' @param session In `el_table()`, deprecated: inside a module, wrap `id` in
#'   `ns()`, as for any Shiny input; a session given here namespaces `id`
#'   once more, with a warning. In `update_el_table()`, the Shiny session, the
#'   current one by default, as for [shiny::updateTextInput()].
#' @param stripe Whether rows alternate background colour.
#' @param size Size: `"large"`, `"default"` or `"small"`; `NULL` follows the form or the page.
#' @param height Table height. Fixes the header and scrolls the body.
#' @param max_height Maximum table height, beyond which the body scrolls.
#' @param fit Whether column widths stretch to fill the table. Default `TRUE`.
#' @param show_header Whether the header row is shown. Default `TRUE`.
#' @param highlight_current_row Whether the clicked row stays highlighted;
#'   the row clicked arrives as `input$<id>_current_change`.
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
#' @param lazy Whether child rows of tree data are loaded on demand --
#'   from the server, unless `load` is given.
#' @param tree_props Field names for tree data, as `list(children =, hasChildren =)`.
#' @param row_class_name Class name for every row, or a JS function returning one.
#' @param row_style Inline style for every row, or a JS function returning one.
#' @param cell_class_name Class name for every cell, or a JS function returning one.
#' @param cell_style Inline style for every cell, or a JS function returning one.
#' @param header_row_class_name Class name for the header row, or a JS function returning one.
#' @param header_row_style Inline style for the header row, or a JS function returning one.
#' @param header_cell_class_name Class name for header cells, or a JS function returning one.
#' @param header_cell_style Inline style for header cells, or a JS function returning one.
#' @param span_method `JS()` function deciding row/column spans for merged cells.
#' @param summary_method `JS()` function returning the summary row's cells.
#' @param load `JS()` function loading child rows in the
#'   browser instead of from the server. Needs `lazy = TRUE`.
#' @param loading Whether to cover the table with Element's loading mask, as
#'   its `v-loading` does. [update_el_table()] turns it on and off around
#'   slow work.
#' @param loading_options How the mask looks, as a list with the names of
#'   [el_loading()]'s arguments -- `text`, `spinner`, `svg`, `svg_view_box`,
#'   `background`, `custom_class` -- Element's `element-loading-*`
#'   attributes.
#' @param slots Named list of Element slot contents, such as
#'   `list(empty = shiny::tags$b("Nothing yet"))`. A shiny.element component
#'   given here is absorbed rather than nested. For a scoped slot, write
#'   the template with [template()].
#' @param width Component width, as a CSS unit. Replaces the table's default
#'   `width: 100%`. For a fixed header use `height` instead.
#' @param events Element's table events to report besides the default ones,
#'   by Element's name: `c("row-dblclick", "cell-click")`. A named entry
#'   reports under that input instead: `c(picked = "cell-click")`. The same
#'   as piping to [el_on()].
#'
#' @section Shiny inputs:
#' Rendered into `el_table_output("tbl")`, the table reports:
#'
#' | Input | When | Value |
#' |---|---|---|
#' | `input$tbl_selection_rows` | on load, when the selection changes and when an edit renumbers it | the selected row numbers, integers, 1-based in the data; `NULL` with none |
#' | `input$tbl_selection_change` | rows ticked or unticked | the selected rows, `data[rows, , drop = FALSE]`: columns, types and row names as R holds them; `NULL` with none |
#' | `input$tbl_current_change` | the highlighted row changes (`highlight_current_row = TRUE`) | `list(row_index, row, previous_index)` |
#' | `input$tbl_sort_change` | a column is sorted | `list(column, order)`, `order` `"ascending"`, `"descending"` or `NULL` |
#' | `input$tbl_filter_change` | a column filter changes | the filters, `list(<column key> = values)` |
#' | `input$tbl_expand_change` | a row opens or closes | `list(row_index, expanded)`, `expanded` the open rows' numbers (or `TRUE`/`FALSE` for tree rows) |
#' | `input$tbl_cell_edit` | a cell of an editable column is changed (`el_table_column(editable =)`) | `list(row, column, value, old)`: the row number, the column's name in the data, the new value and the one it replaced, both of the column's type |
#'
#' Any other of Element's events -- `select`, `select-all`, `row-click`,
#' `row-dblclick`, `row-contextmenu`, `cell-click`, `cell-dblclick`,
#' `cell-contextmenu`, `cell-mouse-enter`, `cell-mouse-leave`,
#' `header-click`, `header-contextmenu`, `header-dragend`, `scroll` -- is
#' reported when asked for, with `events` or [el_on()], as
#' `input$tbl_<event>` in snake_case: a row event as `list(row_index, row,
#' column)`, a cell event with its `value` too, a header event as
#' `list(column, label)`, `scroll` as `list(scroll_left, scroll_top)` (at
#' most every 200 ms).
#'
#' An edit is shown at once and applied to the server's copy of the data,
#' so [el_table_data()] and `input$tbl_selection_change` see it; an
#' observer of `input$tbl_cell_edit` saves it, or refuses it by putting the
#' old value back: `update_el_table(session, "tbl", replace = row, at =
#' input$tbl_cell_edit$row)`.
#'
#' `input$tbl` itself is not used: Element's table has no value of its own
#' (no `v-model`), and the name stays free.
#'
#' Row numbers count rows of the data the table shows, whatever the user's
#' sort -- the data [el_table_data()] returns. Rendering the same data again
#' keeps the user's ticks, sort and open rows; new data clears the
#' selection, as Element does, unless rows carry a key: `row_key` and a
#' selection column with `reserve_selection = TRUE` keep the ticked rows
#' that are still there. Rows inserted, replaced or deleted with
#' [update_el_table()] leave the other rows' ticks alone.
#'
#' With tree data, `lazy = TRUE` and no `load` of your own, the server loads
#' a row's children when it is opened: `input$<id>_load` asks, with `key`
#' (the row's `row_key` field), `row` and `request`; answer with
#' [el_load_children()]. A row with children to load carries
#' `hasChildren = TRUE`.
#'
#' @section Row actions:
#' A button in a `cell` reports back with `rowAction()`:
#'
#' ```r
#' list(label = "", cell = el$button(size = "small",
#'   "@click" = "rowAction('edit', scope)", "Edit"))
#' ```
#'
#' sets `input$<id>_edit` to `list(row_index =, row =)` -- the 1-based row
#' number, to index your own data with, and the row as the table holds it. It
#' is an event input: clicking the same row twice reports twice.
#'
#' @section Element methods:
#' Callable with [call_el()]:
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
#' @return An `el_table` object, drawn as a table wherever UI goes.
#' @export
#' @examples
#' # A data.frame is enough -- columns are inferred
#' el_table(data = head(iris, 3))
#'
#' # Explicit columns
#' el_table(
#'   data = data.frame(name = c("A", "B"), value = c(1, 2)),
#'   columns = list(
#'     list(prop = "name", label = "Name"),
#'     list(prop = "value", label = "Value", width = "100")
#'   )
#' )
#'
#' # A Shiny app: the table is an output, its inputs named after it
#' if (interactive()) {
#'   library(shiny)
#'   library(shiny.element)
#'   ui <- el_page(
#'     el_input_number("n", value = 5, min = 1),
#'     el_table_output("flowers"),
#'     verbatimTextOutput("picked")
#'   )
#'   server <- function(input, output, session) {
#'     output$flowers <- render_el_table(
#'       el_table(data = head(iris, input$n), selection = TRUE) |>
#'         el_on("row-dblclick")
#'     )
#'     # the ticked rows, as R subsets them
#'     output$picked <- renderPrint(input$flowers_selection_change)
#'     observeEvent(input$flowers_row_dblclick, {
#'       el_message(message = paste("Row", input$flowers_row_dblclick$row_index))
#'     })
#'   }
#'   shinyApp(ui, server)
#' }
el_table <- function(
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
  events = NULL
) {
  .el_check_choices("el_table", environment())
  # Mistakes are reported here, where the table is written, not where it
  # is drawn
  args <- .el_table_args(id, data, columns)
  id <- args$id
  data <- args$data
  columns <- args$columns
  rm(args)
  .el_table_sanitize_columns(columns)
  .el_check_events(events, "el-table", .el_table_events)
  .el_loading_attrs(loading_options)
  .el_component(".el_table_tags", as.list(environment()), "el_table")
}

#' Draw a table from its specification
#' @noRd
.el_table_tags <- function(
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
  events = NULL
) {
  .el_check_choices("el_table", environment())
  args <- .el_table_args(id, data, columns)
  id <- args$id
  data <- args$data
  columns <- args$columns

  if (is.null(id)) {
    id <- .el_auto_id("el_table")
  }
  ns_id <- .el_ui_id(id, session)

  data <- .el_table_rownames(data, rownames)
  prep <- .el_table_prep(data, columns)
  named_selection <- if (is.null(events) || is.null(names(events))) {
    character()
  } else {
    names(events)[events == "selection-change" & nzchar(names(events))]
  }
  selection_input <- if (length(named_selection)) {
    named_selection[[1]]
  } else {
    paste0(ns_id, "_selection_change")
  }

  # Columns are rendered with v-for rather than baked into the markup, so
  # update_el_table() can change them -- Vue only tracks fields declared in
  # `data`, and a column set generated in R would be frozen at render time.
  selection_col <- htmltools::tag(
    "el-table-column",
    list(
      "v-if" = "selection",
      type = "selection",
      width = "55"
    )
  )
  # Every documented column prop is bound off the column object, so a user
  # writes list(prop = "x", sortable = TRUE, align = "center") and Element
  # sees it. An absent key reads back as undefined, which is Element's own
  # default -- the same fallback .el_optional_bind() arranges for props.
  # Cell templates: one branch per column that has one, under a slot whose
  # name is a field of the column -- "default" where there is a template,
  # "none" where Element should render the cell itself. The slot name is a
  # plain field, not an expression, because the browser parses this markup
  # before Vue does and would mangle quotes or spaces in an attribute name.
  # A column's default slot, in Vue 3: Element Plus renders a cell from it,
  # falling back to its own rendering when the slot gives nothing but
  # comments -- so every branch is a v-if. The same slot holds a group
  # header's child columns. Each level of nesting has the templates at that
  # level, read off its own column variable `v`.
  # Group headers nest as deep as the columns given -- and at least two
  # levels below the top, for columns update_el_table() may bring later
  depth_of <- function(columns) {
    if (!length(columns)) {
      return(0L)
    }
    max(vapply(
      columns,
      function(col) {
        if (length(col$children)) 1L + depth_of(col$children) else 0L
      },
      integer(1)
    ))
  }
  max_depth <- max(2L, depth_of(prep$columns))
  default_slot <- function(v, depth) {
    here <- names(prep$depths)[prep$depths == depth]
    here <- grep("^cell_", here, value = TRUE)
    branches <- list()
    if (depth < max_depth) {
      branches <- list(htmltools::tag(
        "template",
        list(
          "v-if" = sprintf("%s.children && %s.children.length", v, v),
          nested(v, paste0(v, "x"), depth + 1L)
        )
      ))
    }
    for (key in here) {
      cond <- sprintf("%s.cellKey === '%s'", v, key)
      branches <- c(
        branches,
        list(htmltools::tag(
          "template",
          c(
            stats::setNames(
              list(cond),
              if (length(branches)) "v-else-if" else "v-if"
            ),
            list(prep$cells[[key]])
          )
        ))
      )
    }
    htmltools::tag("template", c(list("v-slot:default" = "scope"), branches))
  }
  # A column may render its own header: give it header_html in the column
  # definition. It is inserted as markup, so only pass what you control.
  # A column's own filter icon, by name; otherwise Element's arrow
  filter_icon_slot <- function(v) {
    htmltools::tag(
      "template",
      c(
        stats::setNames(
          list(NA),
          sprintf("v-slot:[%1$s.filterIcon?'filter-icon':'no-filter-icon']", v)
        ),
        list(htmltools::HTML(sprintf(
          "<el-icon><component :is=\"%s.filterIcon\" /></el-icon>",
          v
        )))
      )
    )
  }
  # A column's `header` is a template, as its `cell` is -- components and
  # all, `scope.column` in reach; header_html is markup inserted as it is.
  header_slot <- function(v, depth) {
    here <- names(prep$depths)[prep$depths == depth]
    here <- grep("^header_", here, value = TRUE)
    branches <- lapply(seq_along(here), function(i) {
      htmltools::tag(
        "template",
        c(
          stats::setNames(
            list(sprintf("%s.headerKey === '%s'", v, here[[i]])),
            if (i == 1L) "v-if" else "v-else-if"
          ),
          list(prep$cells[[here[[i]]]])
        )
      )
    })
    html <- list(
      "v-html" = sprintf("%s.headerHtml", v)
    )
    html[[if (length(branches)) "v-else-if" else "v-if"]] <- sprintf(
      "%s.headerHtml",
      v
    )
    htmltools::tag(
      "template",
      c(
        list("v-slot:header" = "scope"),
        branches,
        list(
          htmltools::tag("span", rev(html)),
          htmltools::tag(
            "span",
            list("v-else" = NA, sprintf("{{%s.label}}", v))
          )
        )
      )
    )
  }

  # Every column prop, read off the column object `v`
  col_props <- function(v) {
    props <- c(
      prop = "prop",
      label = "label",
      width = "width",
      align = "align",
      "header-align" = "headerAlign",
      "class-name" = "className",
      "label-class-name" = "labelClassName",
      "column-key" = "columnKey",
      "min-width" = "minWidth",
      fixed = "fixed",
      resizable = "resizable",
      sortable = "sortable",
      "sort-by" = "sortBy",
      "sort-orders" = "sortOrders",
      "show-overflow-tooltip" = "showOverflowTooltip",
      filters = "filters",
      "filtered-value" = "filteredValue",
      "filter-multiple" = "filterMultiple",
      "filter-placement" = "filterPlacement",
      "reserve-selection" = "reserveSelection",
      index = "index",
      # Props taking a function: pass JS("function(...) {...}") in
      # the column definition and it is evaluated in the browser.
      formatter = "formatter",
      "filter-method" = "filterMethod",
      "filter-class-name" = "filterClassName",
      "tooltip-formatter" = "tooltipFormatter",
      "sort-method" = "sortMethod",
      "render-header" = "renderHeader",
      selectable = "selectable",
      type = "type"
    )
    stats::setNames(as.list(paste0(v, ".", props)), paste0(":", names(props)))
  }
  # A column with `children` is a group header, as Element nests
  # el-table-column: two levels below the top, each with its own header
  # and cell templates
  nested <- function(parent, v, depth) {
    htmltools::tag(
      "el-table-column",
      c(
        list(
          "v-for" = sprintf("%s in %s.children", v, parent),
          ":key" = sprintf("%s.prop || %s.label", v, v)
        ),
        col_props(v),
        list(
          header_slot(v, depth),
          filter_icon_slot(v),
          default_slot(v, depth)
        )
      )
    )
  }

  data_col <- htmltools::tag(
    "el-table-column",
    c(
      list(
        "v-for" = "col in (columns.length ? columns : autoColumns)",
        ":key" = "col.prop || col.label"
      ),
      col_props("col"),
      list(
        header_slot("col", 0L),
        filter_icon_slot("col"),
        default_slot("col", 0L)
      )
    )
  )

  table_attrs <- list(
    ":data" = "tableData",
    ":border" = "border",
    style = "width: 100%",
    "v-loading" = "loading",
    # Always bound: selection can be switched on later by update_el_table().
    "@selection-change" = "handleSelectionChange"
  )
  # element-loading-* on the table's root, where v-loading reads them as
  # the mask opens: a field, so update_el_table() can change them
  table_attrs[["v-bind"]] <- "loadingAttrs"

  # Element's events: the state changes every table reports, and any other
  # asked for with `events` or el_on() -- unnamed as <id>_<event>, named as
  # the input given
  asked <- if (is.null(events)) character() else events
  .el_check_events(asked, "el-table", .el_table_events)
  named <- if (is.null(names(asked))) {
    rep(FALSE, length(asked))
  } else {
    nzchar(names(asked))
  }
  inputs <- if (any(named)) {
    stats::setNames(names(asked)[named], unname(asked)[named])
  } else {
    character()
  }
  forwarded <- union(.el_table_default_events, unname(asked))
  forwarded <- setdiff(forwarded, "selection-change")
  events <- .el_event_bindings(
    ns_id,
    forwarded,
    shapes = .el_table_event_shapes(),
    # fires on every frame of a scroll
    throttle = intersect("scroll", forwarded),
    inputs = inputs
  )
  table_attrs <- c(table_attrs, events$attrs)

  table_attrs[[":stripe"]] <- .el_optional_bind("stripe")

  table_attrs[[":size"]] <- .el_optional_bind("size")

  table_attrs[[":height"]] <- .el_optional_bind("height")

  table_attrs[[":max-height"]] <- .el_optional_bind("maxHeight")

  table_attrs[[":fit"]] <- .el_optional_bind("fit")

  table_attrs[[":show-header"]] <- .el_optional_bind("showHeader")

  table_attrs[[":highlight-current-row"]] <- .el_optional_bind(
    "highlightCurrentRow"
  )

  table_attrs[[":current-row-key"]] <- .el_optional_bind("currentRowKey")

  table_attrs[[":row-key"]] <- .el_optional_bind("rowKey")

  table_attrs[[":empty-text"]] <- .el_optional_bind("emptyText")

  table_attrs[[":default-expand-all"]] <- .el_optional_bind("defaultExpandAll")

  table_attrs[[":expand-row-keys"]] <- .el_optional_bind("expandRowKeys")

  table_attrs[[":default-sort"]] <- .el_optional_bind("defaultSort")

  table_attrs[[":tooltip-effect"]] <- .el_optional_bind("tooltipEffect")

  table_attrs[[":show-summary"]] <- .el_optional_bind("showSummary")

  table_attrs[[":sum-text"]] <- .el_optional_bind("sumText")

  table_attrs[[":select-on-indeterminate"]] <- .el_optional_bind(
    "selectOnIndeterminate"
  )

  table_attrs[[":indent"]] <- .el_optional_bind("indent")

  table_attrs[[":lazy"]] <- .el_optional_bind("lazy")

  table_attrs[[":tree-props"]] <- .el_optional_bind("treeProps")

  table_attrs[[":row-class-name"]] <- .el_optional_bind("rowClassName")

  table_attrs[[":row-style"]] <- .el_optional_bind("rowStyle")

  table_attrs[[":cell-class-name"]] <- .el_optional_bind("cellClassName")

  table_attrs[[":cell-style"]] <- .el_optional_bind("cellStyle")

  table_attrs[[":header-row-class-name"]] <- .el_optional_bind(
    "headerRowClassName"
  )

  table_attrs[[":header-row-style"]] <- .el_optional_bind("headerRowStyle")

  table_attrs[[":header-cell-class-name"]] <- .el_optional_bind(
    "headerCellClassName"
  )

  table_attrs[[":header-cell-style"]] <- .el_optional_bind("headerCellStyle")

  table_attrs[[":span-method"]] <- .el_optional_bind("spanMethod")

  table_attrs[[":summary-method"]] <- .el_optional_bind("summaryMethod")

  table_attrs[[":load"]] <- "load === null ? elLoad : load" # the server, by default

  table_content <- c(table_attrs, list(selection_col, data_col))

  el_widget(
    props = .el_props(list(
      allow_drag_last_column = allow_drag_last_column,
      append_filter_panel_to = append_filter_panel_to,
      flexible = flexible,
      native_scrollbar = native_scrollbar,
      preserve_expanded_content = preserve_expanded_content,
      row_expandable = row_expandable,
      scrollbar_always_on = scrollbar_always_on,
      scrollbar_tabindex = scrollbar_tabindex,
      show_overflow_tooltip = show_overflow_tooltip,
      table_layout = table_layout,
      tooltip_formatter = tooltip_formatter,
      tooltip_options = tooltip_options
    )),
    id = ns_id,
    markup = htmltools::tag("el-table", table_content),
    data = list(
      tableData = prep$rows,
      columns = prep$columns,
      autoColumns = prep$auto,
      border = border,
      selection = selection,
      selected = list(),
      selectedRows = list(),
      # the cell an editable column is editing: row, prop, value, old
      editing = NULL,
      # rows ticked when the app was bookmarked, ticked again once drawn
      restoredRows = .el_restore(paste0(ns_id, "_selection_rows"), list()),
      loading = isTRUE(loading),
      loadingAttrs = .el_loading_attrs(loading_options),
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
      load = .el_or_na(load)
    ),
    methods = c(
      events$methods,
      list(
        elLoad = .el_lazy_load_method(ns_id, "table"),
        # Called from a cell template: rowAction('edit', scope) sets
        # input$<id>_edit to the row's number and the row.
        rowAction = JS(sprintf(
          paste0(
            "function(name, scope) { var se = window.shinyElement; ",
            "window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s_' + name, {row_index: se.rowIndex(this, scope.row), ",
            "row: window.shinyVue.plain(scope.row)}, {priority: 'event'}); }"
          ),
          ns_id
        )),
        # Editable columns (el_table_column(editable =)): one cell at a
        # time; a committed edit is shown at once and reported as
        # input$<id>_cell_edit, which the server applies to its copy
        isEditing = JS(paste0(
          "function(scope, prop) { var e = this.editing; ",
          "return !!e && e.row === scope.row && e.prop === prop; }"
        )),
        startEdit = JS(paste0(
          "function(scope, prop) { var self = this; ",
          "self.editing = {row: scope.row, prop: prop, value: scope.row[prop], ",
          "old: scope.row[prop]}; self.$nextTick(function() { ",
          "var root = self.$el && self.$el.querySelector ? self.$el : document; ",
          "var f = root.querySelector('.el-table-edit-cell__editor input, ",
          ".el-table-edit-cell__editor textarea'); if (f) f.focus(); }); }"
        )),
        cancelEdit = JS("function() { this.editing = null; }"),
        commitEdit = JS(sprintf(
          paste0(
            "function(move, scope, prop) { var e = this.editing; ",
            # a blur from an editor already left behind
            "if (!e || (scope && (e.row !== scope.row || e.prop !== prop))) return; ",
            "this.editing = null; ",
            "if (e.value !== e.old) { e.row[e.prop] = e.value; ",
            "window.Shiny && Shiny.setInputValue && Shiny.setInputValue(",
            "'%s_cell_edit:shiny.element.cell_edit', {table: '%s', ",
            "row: window.shinyElement.rowIndex(this, e.row), column: e.prop, ",
            "value: e.value, old: e.old}, {priority: 'event'}); } ",
            "if (!move) return; ",
            # Tab: the next editable cell, along the row and on to the next
            "var props = []; (function walk(cols) { (cols || []).forEach(function(c) { ",
            "if (c.editableProp) props.push(c.editableProp); walk(c.children); }); })",
            "(this.columns && this.columns.length ? this.columns : this.autoColumns); ",
            "var i = props.indexOf(e.prop), r = this.tableData.indexOf(e.row); ",
            "if (i < 0 || r < 0) return; ",
            "if (i + 1 < props.length) i++; else { i = 0; r++; } ",
            "if (r < this.tableData.length) ",
            "this.startEdit({row: this.tableData[r]}, props[i]); }"
          ),
          ns_id,
          ns_id
        )),
        # input$<id>_selection_rows: the selected rows' numbers, sent again
        # when an edit renumbers them
        reportSelection = JS(sprintf(
          paste0(
            "function() { var self = this; ",
            "self.selectedRows = (self.selected || []).map(function(r) { ",
            "return window.shinyElement.rowIndex(self, r); }); ",
            "window.Shiny && Shiny.setInputValue && Shiny.setInputValue(",
            "'%s_selection_rows:shiny.element.rows', self.selectedRows); }"
          ),
          ns_id
        )),
        # selection-change sends the row numbers, which the server turns
        # into the rows of the data it holds (the shiny.element.selection
        # handler) -- or, for a table it never rendered, the rows as they
        # are here
        handleSelectionChange = JS(sprintf(
          paste0(
            "function(selection) { var self = this; ",
            "self.selected = selection; self.reportSelection(); ",
            "window.Shiny && Shiny.setInputValue && Shiny.setInputValue(",
            "'%s:shiny.element.selection', {table: '%s', ",
            "rows: self.selectedRows, data: window.shinyVue.plain(selection)}, ",
            "{priority: 'event'}); }"
          ),
          selection_input,
          ns_id
        )),
        # update_el_table(insert =, replace =, delete =): the rows spliced
        # into the same array, which Element watches deeply -- the rows not
        # touched keep their ticks and open state
        shinyVueReceive = JS(paste0(
          "function(d) { if (!('tableEdit' in d)) return d; ",
          "var e = d.tableEdit, data = this.tableData, rows = e.rows || [], ",
          "at = e.at === null || e.at === undefined ? [] : [].concat(e.at); ",
          "delete d.tableEdit; ",
          "if (e.op === 'insert') { ",
          "var i = at.length ? at[0] - 1 : data.length; ",
          "data.splice.apply(data, [i, 0].concat(rows)); } ",
          "else if (e.op === 'replace') { ",
          "at.forEach(function(i, k) { data.splice(i - 1, 1, rows[k]); }); } ",
          "else if (e.op === 'delete') { ",
          "at.slice().sort(function(a, b) { return b - a; })",
          ".forEach(function(i) { data.splice(i - 1, 1); }); } ",
          "var self = this; this.$nextTick(function() { self.reportSelection(); }); ",
          "return d; }"
        ))
      )
    ),
    watch = list(
      restoredRows = list(
        immediate = TRUE,
        handler = JS(paste0(
          "function(rows) { var self = this; if (!rows || !rows.length) return; ",
          "self.$nextTick(function() { ",
          "var t = window.shinyVue.componentOf(self, 'ElTable'); if (!t) return; ",
          "rows.forEach(function(i) { var r = self.tableData[i - 1]; ",
          "if (r) t.toggleRowSelection(r, true); }); self.restoredRows = []; }); }"
        ))
      )
    ),
    mounted = .el_mounted_init(stats::setNames(
      "selectedRows",
      paste0(ns_id, "_selection_rows:shiny.element.rows")
    )),
    width = width,
    slots = slots
  )
}

#' @rdname el_table
#' @param insert Rows to insert -- a data.frame, or a list of rows -- before
#'   row `at`, or at the end.
#' @param replace Rows to put in place of rows `at`, one for each.
#' @param delete Numbers of the rows to delete.
#' @param at Where `insert` goes, one row number; which rows `replace`
#'   replaces. Row numbers count the rows the table shows, as
#'   `input$<id>_selection_rows` does.
#' @section Updating from the server:
#' Changes a table from the server, as [shiny::updateSelectInput()] does a
#' select: every argument of [el_table()] that can change once the table is
#' drawn, under the same name. One left `NULL` stays as it is; `NA` returns
#' a prop to Element's default. `rownames`, `slots`, `width`, `events` and
#' the `default_*` arguments, which are read only when the table is
#' created, are not here. A table in [el_table_output()] is reached by the
#' output's id; rendering it again with [render_el_table()] does the same
#' for any argument.
#'
#' **Rows.** `data` replaces them all; `insert`, `replace` and `delete`
#' change a few and send only those, one of them per call. The server's
#' copy of the data ([el_table_data()]) is changed as R would change it --
#' `rbind()` to insert, `data[at, ] <- replace`, `data[-delete, ]` -- and
#' the browser gets the rows as they then stand, so both hold the same
#' data. Rows not touched keep their ticks and open state; the selection's
#' row numbers are reported again, renumbered.
#'
#' Data that comes from reactive expressions is best rendered: the table is
#' patched in place either way, and one render is one source of the data.
#' An update suits a change an observer makes -- a row the user added,
#' edited or deleted. A render after an update leaves the update's rows in
#' place unless the render's own data changed.
#'
#' A column's `cell` template is part of the table's markup, made
#' when the table is. New columns given here keep the template of the
#' column with the same `prop` (or label) and may drop it, but cannot
#' bring a template the table was not created with.
#'
#' `update_el_table()` is called for its side effect and returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$go, {
#'     update_el_table(session, "tbl", data = head(mtcars, 10))
#'   })
#'   # any other argument of el_table()
#'   update_el_table(session, "tbl", stripe = TRUE, table_layout = "auto")
#'   # back to Element's default
#'   update_el_table(session, "tbl", stripe = NA)
#'   # a few rows, leaving the rest as they are
#'   update_el_table(session, "tbl", insert = head(mtcars, 1), at = 1)
#'   update_el_table(session, "tbl", replace = mtcars[3, ], at = 3)
#'   update_el_table(session, "tbl", delete = c(2, 5))
#' }
#' @export
update_el_table <- function(
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
) {
  .el_check_session(session)
  ns_id <- session$ns(id)
  props <- mget(
    c(
      "stripe",
      "size",
      "height",
      "max_height",
      "fit",
      "show_header",
      "highlight_current_row",
      "current_row_key",
      "row_key",
      "empty_text",
      "expand_row_keys",
      "tooltip_effect",
      "show_summary",
      "sum_text",
      "select_on_indeterminate",
      "indent",
      "lazy",
      "tree_props",
      "row_class_name",
      "row_style",
      "cell_class_name",
      "cell_style",
      "header_row_class_name",
      "header_row_style",
      "header_cell_class_name",
      "header_cell_style",
      "span_method",
      "summary_method",
      "load",
      "allow_drag_last_column",
      "append_filter_panel_to",
      "flexible",
      "native_scrollbar",
      "preserve_expanded_content",
      "row_expandable",
      "scrollbar_always_on",
      "scrollbar_tabindex",
      "show_overflow_tooltip",
      "table_layout",
      "tooltip_formatter",
      "tooltip_options"
    ),
    environment()
  )
  msg <- c(
    list(id = ns_id),
    .el_update_props("el_table", Filter(Negate(is.null), props))
  )

  edit <- .el_table_edit_args(data, insert, replace, delete, at)
  if (!is.null(edit)) {
    msg$tableEdit <- .el_table_edit(session, ns_id, edit)
  }
  if (!is.null(data) || !is.null(columns)) {
    if (!is.null(data)) {
      # the server keeps what the browser shows, for the table's inputs
      .el_table_data_set(session, ns_id, data)
      data <- .el_table_rownames(data, .el_table_rownames_of(session, ns_id))
    }
    prep <- .el_table_prep(
      if (is.null(data)) list() else data,
      if (is.null(columns)) list() else columns
    )
    # Named for the Vue data fields they target: the shared updater assigns
    # by key, so a message field that does not match is refused.
    if (!is.null(data)) {
      msg$tableData <- prep$rows
      # Shown only while the table has no written columns of its own
      msg$autoColumns <- prep$auto
    }
    # list() clears the written columns, going back to inferring them
    if (!is.null(columns)) msg$columns <- prep$columns
  }
  if (!is.null(border)) {
    msg$border <- border
  }
  if (!is.null(selection)) {
    msg$selection <- selection
  }
  if (!is.null(loading_options)) {
    msg$loadingAttrs <- .el_loading_attrs(loading_options)
  }
  if (!is.null(loading)) {
    msg$loading <- loading
  }

  .el_send_update(session, msg)
  invisible(NULL)
}

#' The one edit an update asks for, checked
#' @noRd
.el_table_edit_args <- function(data, insert, replace, delete, at) {
  given <- c(
    insert = !is.null(insert),
    replace = !is.null(replace),
    delete = !is.null(delete)
  )
  if (!any(given)) {
    if (!is.null(at)) {
      stop("`at` places `insert` or `replace`.", call. = FALSE)
    }
    return(NULL)
  }
  if (sum(given) > 1L || !is.null(data)) {
    stop(
      "Give one of `data`, `insert`, `replace` and `delete` at a time.",
      call. = FALSE
    )
  }
  op <- names(given)[given]
  rows <- switch(op, insert = insert, replace = replace, delete = NULL)
  if (op == "delete") {
    at <- delete
  }
  whole <- function(x) {
    is.numeric(x) && length(x) && !anyNA(x) && all(x == round(x)) && all(x >= 1)
  }
  n_rows <- function(x) if (is.data.frame(x)) nrow(x) else length(x)
  if (op == "insert" && !is.null(at) && (!whole(at) || length(at) != 1L)) {
    stop(
      "`at` is one row number: where the first row inserted goes.",
      call. = FALSE
    )
  }
  if (op != "insert") {
    if (is.null(at) || !whole(at)) {
      stop(
        if (op == "delete") {
          "`delete` takes row numbers."
        } else {
          "`replace` needs `at`, the row numbers it replaces."
        },
        call. = FALSE
      )
    }
    if (anyDuplicated(at)) {
      stop("`", op, "` names a row twice.", call. = FALSE)
    }
  }
  if (op == "replace" && n_rows(rows) != length(at)) {
    stop(
      "`replace` has ",
      n_rows(rows),
      " rows for ",
      length(at),
      " numbers in `at`.",
      call. = FALSE
    )
  }
  list(op = op, rows = rows, at = if (!is.null(at)) as.integer(at))
}

#' An edit applied to the data the server keeps, and the message for the
#' browser: the rows as they now stand on the server, so both sides agree
#' @noRd
.el_table_edit <- function(session, id, edit) {
  data <- .el_table_data(session, id)
  rows <- edit$rows
  at <- edit$at
  if (!is.null(data)) {
    n <- if (is.data.frame(data)) nrow(data) else length(data)
    last <- if (edit$op == "insert") n + 1L else n
    if (length(at) && any(at > last)) {
      stop(
        "The table has ",
        n,
        " rows; `",
        if (edit$op == "delete") "delete" else "at",
        "` names row ",
        max(at),
        ".",
        call. = FALSE
      )
    }
    data <- .el_table_apply_edit(data, edit)
    .el_table_data_set(session, id, data)
    # the rows as a render of the whole data would draw them -- with a
    # row-name column if the table has one
    drawn <- .el_table_rownames(data, .el_table_rownames_of(session, id))
    if (edit$op == "insert") {
      at <- at %||% (n + 1L)
      m <- if (is.data.frame(rows)) nrow(rows) else length(rows)
      rows <- .el_table_slice(drawn, at - 1L + seq_len(m))
    } else if (edit$op == "replace") {
      rows <- .el_table_slice(drawn, at)
    }
  } else if (!is.null(rows)) {
    rows <- .el_table_rownames(rows)
  }
  if (!is.null(rows)) {
    rows <- .el_table_rows(rows)
  }
  list(op = edit$op, rows = rows, at = if (length(at)) I(at))
}

#' Rows of a data.frame or of a list of rows
#' @noRd
.el_table_slice <- function(data, i) {
  if (is.data.frame(data)) data[i, , drop = FALSE] else data[i]
}

#' What R does to data: rbind() to insert, `[<-` to replace, `[-i]` to
#' delete
#' @noRd
.el_table_apply_edit <- function(data, edit) {
  at <- edit$at
  if (!is.data.frame(data)) {
    rows <- edit$rows
    if (is.data.frame(rows)) {
      rows <- lapply(seq_len(nrow(rows)), function(i) {
        as.list(rows[i, , drop = FALSE])
      })
    }
    return(switch(
      edit$op,
      insert = append(data, rows, after = (at %||% (length(data) + 1L)) - 1L),
      replace = {
        data[at] <- rows
        data
      },
      delete = data[-at]
    ))
  }
  n <- nrow(data)
  switch(
    edit$op,
    insert = {
      rows <- as.data.frame(edit$rows)
      at <- at %||% (n + 1L)
      bound <- rbind(data, rows)
      bound[
        c(
          seq_len(at - 1L),
          n + seq_len(nrow(rows)),
          seq_len(n - at + 1L) + at - 1L
        ),
        ,
        drop = FALSE
      ]
    },
    replace = {
      data[at, ] <- edit$rows
      data
    },
    delete = data[-at, , drop = FALSE]
  )
}

# Every event el-table emits, and the few a table reports unasked
.el_table_events <- c(
  "select",
  "select-all",
  "selection-change",
  "cell-mouse-enter",
  "cell-mouse-leave",
  "cell-click",
  "cell-dblclick",
  "cell-contextmenu",
  "row-click",
  "row-contextmenu",
  "row-dblclick",
  "header-click",
  "header-contextmenu",
  "sort-change",
  "filter-change",
  "current-change",
  "header-dragend",
  "expand-change",
  "scroll"
)
.el_table_default_events <- c(
  "selection-change",
  "current-change",
  "sort-change",
  "filter-change",
  "expand-change"
)


#' Element's element-loading-* attributes
#'
#' @param options A list named as [el_loading()]'s arguments, or `NULL`.
#' @return A named list of attributes.
#' @keywords internal
.el_loading_attrs <- function(options) {
  if (!length(options)) {
    return(stats::setNames(list(), character()))
  }
  known <- c(
    "text",
    "spinner",
    "svg",
    "svg_view_box",
    "background",
    "custom_class"
  )
  if (is.null(names(options)) || length(setdiff(names(options), known))) {
    stop(
      "`loading_options` takes ",
      paste0("`", known, "`", collapse = ", "),
      call. = FALSE
    )
  }
  stats::setNames(
    lapply(options, as.character),
    paste0("element-loading-", gsub("_", "-", names(options), fixed = TRUE))
  )
}
