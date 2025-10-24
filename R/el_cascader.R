#' Element UI Cascader Widget
#'
#' @param id Cascader ID (auto-generated if NULL)
#' @param options Cascader options data (hierarchical list)
#' @param value Initial selected value
#' @param placeholder Placeholder text
#' @param props Configuration object for cascader behavior
#' @param clearable Whether clearable
#' @param filterable Whether filterable
#' @param disabled Whether disabled
#' @param size Size of cascader (medium, small, mini)
#' @param show_all_levels Whether to show all levels in input
#' @param collapse_tags Whether to collapse tags in multiple mode
#' @param separator Separator for display
#' @param debounce Debounce delay for filter
#' @param icon Icon for the cascader (shiny.tag or NULL)
#' @param session Shiny session for module support
#' @export
el_cascader <- function(id = NULL,
                        options = list(),
                        value = NULL,
                        placeholder = "Please select",
                        props = NULL,
                        clearable = FALSE,
                        filterable = FALSE,
                        disabled = FALSE,
                        size = NULL,
                        show_all_levels = TRUE,
                        collapse_tags = FALSE,
                        separator = " / ",
                        debounce = 300,
                        icon = NULL,
                        session = getDefaultReactiveDomain()) {
  if (is.null(id)) {
    id <- paste0("el_cascader_", uuid::UUIDgenerate())
  }
  ns_id <- if (!is.null(session)) session$ns(id) else id
  container_id <- paste0(ns_id, "_container")

  cascader_attrs <- list(
    ":options" = "options",
    "v-model" = "value",
    ":placeholder" = "placeholder",
    ":clearable" = "clearable",
    ":filterable" = "filterable",
    ":disabled" = "disabled",
    ":show-all-levels" = "showAllLevels",
    ":collapse-tags" = "collapseTags",
    ":separator" = "separator",
    ":debounce" = "debounce",
    "@change" = "handleChange"
  )
  if (!is.null(props)) cascader_attrs[[":props"]] <- "props"
  if (!is.null(size)) cascader_attrs[["size"]] <- size

  vue_data <- list(
    options = options,
    value = if(is.null(value)) list() else value,
    placeholder = placeholder,
    clearable = clearable,
    filterable = filterable,
    disabled = disabled,
    showAllLevels = show_all_levels,
    collapseTags = collapse_tags,
    separator = separator,
    debounce = debounce
  )
  if (!is.null(props)) vue_data$props <- props

  component_ui <- tagList(
    tags$div(
      id = container_id,
      tag("el-cascader", cascader_attrs)
    ),
    vueR::vue(
      elementId = ns_id,
      list(
        el = paste0("#", container_id),
        data = vue_data,
        methods = list(
          handleChange = htmlwidgets::JS(sprintf(
            "function(value) {\n  Shiny.setInputValue('%s_value', value);\n}", ns_id))
        )
      )
    )
  )

  htmltools::attachDependencies(
    component_ui,
    el_button_handler_dependency()
  )
}

#' Update Element UI Cascader
#'
#' @param session Shiny session object
#' @param id Cascader ID
#' @param options New cascader options
#' @param value New selected value
#' @param placeholder New placeholder text
#' @param clearable Whether clearable
#' @param filterable Whether filterable
#' @param disabled Whether disabled
#' @export
update_el_cascader <- function(session, id,
                               options = NULL,
                               value = NULL,
                               placeholder = NULL,
                               clearable = NULL,
                               filterable = NULL,
                               disabled = NULL) {
  ns_id <- session$ns(id)
  message <- list(id = ns_id)
  if (!is.null(options)) message$options <- options
  if (!is.null(value)) message$value <- value
  if (!is.null(placeholder)) message$placeholder <- placeholder
  if (!is.null(clearable)) message$clearable <- clearable
  if (!is.null(filterable)) message$filterable <- filterable
  if (!is.null(disabled)) message$disabled <- disabled

  session$sendCustomMessage('updateElCascader', message)
}

#' Convert a data.frame with custom value/label columns to Element-UI Cascader options list
#'
#' @param df Data frame with hierarchical columns
#' @param value_cols Character vector of value column names (e.g. c("value1", "value2", ...))
#' @param label_cols Character vector of label column names (e.g. c("label1", "label2", ...)), can be NULL or contain NA for levels without label
#' @return Nested list for cascader options
#' @export
df_to_cascader_options <- function(df, value_cols, label_cols = NULL) {
  n <- length(value_cols)
  build_level <- function(df, level) {
    if (level > n) return(NULL)
    split_df <- split(df, df[[value_cols[level]]])
    lapply(names(split_df), function(val) {
      item <- list(value = val)
      # 支持 label_cols 为 NULL 或部分为 NA，label 为空时 fallback 到 value
      if (!is.null(label_cols) && !is.na(label_cols[level])) {
        label_val <- split_df[[val]][[label_cols[level]]][1]
        item$label <- if (!is.na(label_val) && nzchar(label_val)) label_val else val
      } else {
        item$label <- val
      }
      if (level < n) {
        children <- build_level(split_df[[val]], level + 1)
        if (!is.null(children)) item$children <- children
      }
      item
    })
  }
  build_level(df, 1)
}
