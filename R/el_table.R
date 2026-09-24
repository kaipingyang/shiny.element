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

  Map(function(prop, label) list(prop = prop, label = label),
      gsub("\\.", "_", nms), nms, USE.NAMES = FALSE)
}

#' Align user-supplied column configs with sanitised data keys
#'
#' @param columns A list of column configs.
#' @return The same list with each `prop` sanitised.
#' @keywords internal
.el_table_sanitize_columns <- function(columns) {
  lapply(columns, function(col) {
    if (!is.null(col$prop)) col$prop <- gsub("\\.", "_", col$prop)
    col
  })
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
#' @param data A data.frame, or a list of rows (each a named list). A
#'   data.frame is converted to rows automatically and its column names are
#'   sanitised (`.` becomes `_`) so `el-table`'s dotted `prop` lookup works.
#' @param columns List of column configs, each `list(prop=, label=, width=)`.
#'   Inferred from `data` when omitted.
#' @param id Table ID (auto-generated if NULL)
#' @param selection Enable row selection
#' @param border Show table border
#' @param session Shiny session for module support
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
#' @return A Shiny UI element.
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
#' # Shiny app with row selection and server-side updates
#' if (interactive()) {
#'   library(shiny)
#'   library(shiny.element)
#'   ui <- el_page(
#'     el_table(id = "my_table", data = head(iris, 5), selection = TRUE),
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
el_table <- function(data = list(),
                     columns = list(),
                     id = NULL,
                     selection = FALSE,
                     border = TRUE,
                     session = shiny::getDefaultReactiveDomain()) {
  if (is.null(id)) {
    id <- paste0("el_table_", uuid::UUIDgenerate())
  }
  ns_id <- if (!is.null(session)) session$ns(id) else id
  container_id <- paste0(ns_id, "_container")

  prep <- .el_table_prep(data, columns)

  # Columns are rendered with v-for rather than baked into the markup, so
  # update_el_table() can change them -- Vue only tracks fields declared in
  # `data`, and a column set generated in R would be frozen at render time.
  selection_col <- htmltools::tag("el-table-column", list(
    "v-if" = "selection",
    type   = "selection",
    width  = "55"
  ))
  data_col <- htmltools::tag("el-table-column", list(
    "v-for"  = "col in columns",
    ":key"   = "col.prop",
    ":prop"  = "col.prop",
    ":label" = "col.label",
    ":width" = "col.width"
  ))

  table_content <- list(
    ":data"             = "tableData",
    ":border"           = "border",
    style               = "width: 100%",
    # Always bound: selection can be switched on later by update_el_table().
    "@selection-change" = "handleSelectionChange",
    selection_col,
    data_col
  )

  component_ui <- htmltools::tagList(
    htmltools::tags$div(
      id = container_id, style = .el_host_style(),
      htmltools::tag("el-table", table_content)
    ),
    vueR::vue(
elementId = ns_id, width = 0, height = 0,
      list(
        el = paste0("#", container_id),
        data = list(
          tableData    = prep$rows,
          columns      = prep$columns,
          border       = border,
          selection    = selection,
          selected     = list(),
          selectedRows = list()
        ),
        methods = list(
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
        ),
        mounted = .el_mounted_init(stats::setNames(
          c("selected", "selectedRows"),
          paste0(ns_id, c("_selected", "_selected_rows"))
        ))
      )
    )
  )
  htmltools::attachDependencies(
    component_ui,
    el_table_handler_dependency()
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
