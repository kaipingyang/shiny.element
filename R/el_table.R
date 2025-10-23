#' Element UI Table Component
#'
#' @param id Table ID (auto-generated if NULL)
#' @param data List of row data
#' @param columns List of column configs
#' @param selection Enable row selection
#' @param border Show table border
#' @param session Shiny session for module support
#' @export
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
  column_tags <- lapply(columns, function(col) {
    col_attrs <- list(prop = col$prop, label = col$label)
    if (!is.null(col$width)) col_attrs$width <- col$width
    htmltools::tag("el-table-column", col_attrs)
  })
  table_content <- c(
    list(":data" = "tableData", style = "width: 100%"),
    if (border) list(border = NA),
    if (selection) list(htmltools::tag("el-table-column", list(type = "selection", width = "55"))),
    column_tags
  )
  if (selection) table_content[["@selection-change"]] <- "handleSelectionChange"
  component_ui <- htmltools::tagList(
    htmltools::tags$div(
      id = container_id,
      htmltools::tag("el-table", table_content)
    ),
    vueR::vue(
      elementId = ns_id,
      list(
        el = paste0("#", container_id),
        data = list(tableData = data),
        methods = if (selection) list(
          handleSelectionChange = htmlwidgets::JS(sprintf(
            "function(selection) { Shiny.setInputValue('%s_selected', selection); }", ns_id
          ))
        ) else list()
      )
    )
  )
  htmltools::attachDependencies(
    component_ui,
    el_table_handler_dependency()
  )
}
#' Prepare Data for Element Table
#'
#' @param df Data frame
#' @param max_rows Max rows to show
#' @param add_name Add row names
#' @return List with data and columns
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
