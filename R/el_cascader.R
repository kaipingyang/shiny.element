#' Element UI Cascader Widget
#'
#' Create a cascader (multi-level dropdown) input for Shiny using Element UI.
#'
#' @param id Cascader ID (auto-generated if NULL)
#' @param options Cascader options data (hierarchical list)
#' @param value Initial selected value
#' @param placeholder Placeholder text
#' @param props Configuration object for cascader behavior
#' @param clearable Whether clearable
#' @param filterable Whether filterable (searchable)
#' @param disabled Whether disabled
#' @param size Size of cascader (medium, small, mini)
#' @param show_all_levels Whether to show all levels in input
#' @param collapse_tags Whether to collapse tags in multiple mode
#' @param separator Separator for display
#' @param debounce Debounce delay for filter
#' @param icon Icon for the cascader (shiny.tag or NULL)
#' @param session Deprecated. Inside a module, wrap `id` in `ns()`, as for
#'   any Shiny input; a session given here namespaces `id` once more, with
#'   a warning.
#' @param popper_class Extra class name for the dropdown panel.
#' @param filter_method `htmlwidgets::JS()` function filtering the options as the user types.
#' @param before_filter `htmlwidgets::JS()` function called before filtering; returning `false` cancels it.
#' @param label A label shown with the component, as Shiny's inputs have:
#'   text or a tag. `NULL`, the default, shows none. It is the component's
#'   accessible name too.
#' @param label_position `"top"` (the default, as Shiny's labels sit) or
#'   `"left"`, beside the component as in a horizontal Element form.
#' @param width Component width, as a CSS unit -- `"200px"`, `"50%"`, or a
#'   number taken as pixels. Element's own markup carries it, so it behaves
#'   like the `width` argument of a Shiny input.
#' @param slots Named list of Element slot contents, such as
#'   `list(title = shiny::tags$b("Bold"))`. A shiny.element component
#'   given here is absorbed rather than nested. For a scoped slot, write
#'   the template with [template()].
#' @section Element methods:
#' Callable with [el_call()]:
#'
#' - `getCheckedNodes()` -- Get an array of currently selected node
#'
#' @return A Shiny UI element.
#' @export
#' @examples
#' # Basic cascader usage
#' cascader_options <- list(
#'   list(
#'     value = "guide",
#'     label = "Guide",
#'     children = list(
#'       list(value = "principle", label = "Principle"),
#'       list(value = "navigation", label = "Navigation")
#'     )
#'   ),
#'   list(
#'     value = "component",
#'     label = "Component",
#'     children = list(
#'       list(value = "basic", label = "Basic"),
#'       list(value = "form", label = "Form", disabled = TRUE)
#'     )
#'   )
#' )
#'
#' if (interactive()) {
#'   library(shiny)
#'   library(shiny.element)
#'   ui <- el_page(
#'     el_cascader(
#'       id = "cascader1",
#'       options = cascader_options,
#'       placeholder = "Please select",
#'       clearable = TRUE
#'     ),
#'     verbatimTextOutput("selected")
#'   )
#'   server <- function(input, output, session) {
#'     output$selected <- renderPrint(input$cascader1_value)
#'   }
#'   shinyApp(ui, server)
#' }
#'
#' # Advanced: custom props and update
#' custom_props <- list(
#'   expandTrigger = "hover",
#'   multiple = FALSE,
#'   checkStrictly = FALSE,
#'   emitPath = TRUE,
#'   lazy = FALSE,
#'   value = "value",
#'   label = "label",
#'   children = "children"
#' )
#'
#' # Update cascader options in server:
#' # update_el_cascader(session, "cascader1", options = new_options)
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
                        popper_class = NULL,
                        filter_method = NULL,
                        before_filter = NULL,
                        label = NULL,
                        label_position = c("top", "left"),
                        width   = NULL,
                        slots   = NULL,
                        session = NULL) {
  .el_check_choices("el_cascader", environment())
  if (is.null(id)) {
    id <- paste0("el_cascader_", uuid::UUIDgenerate())
  }
  ns_id <- .el_ui_id(id, session)
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
  cascader_attrs[[":props"]] <- .el_optional_bind("props")
  cascader_attrs[[":size"]] <- .el_optional_bind("size")
  cascader_attrs[[":popper-class"]] <- .el_optional_bind("popperClass")
  cascader_attrs[[":filter-method"]] <- .el_optional_bind("filterMethod")
  cascader_attrs[[":before-filter"]] <- .el_optional_bind("beforeFilter")

  # Forwarded to input$<id>_<event>; see .el_event_bindings().
  events <- .el_event_bindings(ns_id, c(
    "expand-change",
    "blur",
    "focus",
    "visible-change",
    "remove-tag"
  ))
  cascader_attrs <- c(cascader_attrs, events$attrs)

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
  vue_data$size <- .el_or_na(size)
  vue_data$props <- .el_or_na(props)
  vue_data$popperClass <- .el_or_na(popper_class)
  vue_data$filterMethod <- .el_or_na(filter_method)
  vue_data$beforeFilter <- .el_or_na(before_filter)
  el_widget(
    label = label, label_position = label_position,
    id     = ns_id,
    markup = tag("el-cascader", cascader_attrs),
    data = vue_data,
    methods = c(events$methods, list(
      handleChange = htmlwidgets::JS(sprintf(
        "function(value) {\n  window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s_value', value);\n}", ns_id))
    )),
    mounted = .el_mounted_init(stats::setNames("value", paste0(ns_id, "_value"))),
    width      = width,
    slots      = slots,
    dependency = el_cascader_handler_dependency()
  )
}

#' Update Element UI Cascader
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id Cascader ID
#' @param options New cascader options
#' @param value New selected value
#' @param placeholder New placeholder text
#' @param clearable Whether clearable
#' @param filterable Whether filterable
#' @param disabled Whether disabled
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$go, {
#'     update_el_cascader(session, "region", value = list("zj", "hz"))
#'   })
#' }
#' @export
update_el_cascader <- function(session = shiny::getDefaultReactiveDomain(), id,
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
  invisible(NULL)
}

#' Convert a data.frame with custom value/label columns to Element-UI Cascader options list
#'
#' @param df Data frame with hierarchical columns
#' @param value_cols Character vector of value column names (e.g. c("value1", "value2", ...))
#' @param label_cols Character vector of label column names (e.g. c("label1", "label2", ...)), can be NULL or contain NA for levels without label
#' @return Nested list for cascader options
#' @examples
#' df <- data.frame(
#'   province = c("Zhejiang", "Zhejiang", "Jiangsu"),
#'   city     = c("Hangzhou", "Ningbo", "Nanjing"),
#'   stringsAsFactors = FALSE
#' )
#' df_to_cascader_options(df, c("province", "city"))
#'
#' # Separate value and label columns
#' df$province_label <- paste(df$province, "Province")
#' df_to_cascader_options(df, c("province", "city"),
#'                        c("province_label", NA))
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
