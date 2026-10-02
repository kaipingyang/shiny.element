#' Element UI Cascader
#'
#' Pick a path through nested options -- a region, then a country, then a
#' city -- from a dropdown of side-by-side columns.
#'
#' @param id Cascader ID (auto-generated if NULL)
#' @param options Nested options, each `list(value =, label =, children =)`.
#'   [df_to_cascader_options()] builds them from a data.frame.
#' @param value Initially selected path, as a vector of values from the top
#'   level down -- or a list of paths with `props = list(multiple = TRUE)`.
#' @param placeholder Placeholder text
#' @param props Element's `props`, as a named list: `multiple`,
#'   `checkStrictly`, `expandTrigger` (`"click"` or `"hover"`), `lazy`,
#'   `lazyLoad`, and the field names `value`, `label`, `children`,
#'   `disabled`, `leaf`. With `lazy = TRUE` and no `lazyLoad` of your own,
#'   the server loads each column: see "Shiny inputs".
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
#' @param filter_method `JS()` function filtering the options as the user types.
#' @param before_filter `JS()` function called before filtering; returning `false` cancels it.
#' @inheritParams el_widget
#' @param width Component width, as a CSS unit -- `"200px"`, `"50%"`, or a
#'   number taken as pixels. Element's own markup carries it, so it behaves
#'   like the `width` argument of a Shiny input.
#' @param slots Named list of Element slot contents, such as
#'   `list(title = shiny::tags$b("Bold"))`. A shiny.element component
#'   given here is absorbed rather than nested. For a scoped slot, write
#'   the template with [template()].
#' @section Shiny inputs:
#' - `input$<id>` -- the selected path, on load and on change.
#' - `input$<id>_lazy_load` -- with `props = list(lazy = TRUE)`, a column to
#'   load: `level` (0 for the first), `value` and `path` of the option
#'   opened, and `request`. Answer with [el_load_children()], passing the
#'   input back; each child is `list(value =, label =, leaf = TRUE)` for one
#'   with nothing below.
#' - `input$<id>_expand_change`, `_blur`, `_focus`, `_visible_change`,
#'   `_remove_tag` -- Element's events.
#'
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
#'     output$selected <- renderPrint(input$cascader1)
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
                        label_position = c("top", "left", "right"),
                        label_width = NULL,
                        label_suffix = NULL,
                        required = FALSE,
                        error = NULL,
                        show_message = TRUE,
                        inline_message = FALSE,
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
  # props carries lazyLoad; without one of the user's, the server loads
  cascader_attrs[[":props"]] <- "elProps"
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
    label_width = label_width, label_suffix = label_suffix, required = required,
    error = error, show_message = show_message, inline_message = inline_message,
    id     = ns_id,
    markup = tag("el-cascader", cascader_attrs),
    data = vue_data,
    methods = c(events$methods, list(
      handleChange = JS(sprintf(
        "function(value) {\n  window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s', value);\n}", ns_id))
    )),
    mounted = .el_mounted_init(stats::setNames("value", ns_id)),
    computed = list(elProps = .el_lazy_props(ns_id)),
    width      = width,
    slots      = slots
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
#' @param label New label text, as for [shiny::updateTextInput()]. Only a
#'   component built with a `label` has one to change.
#' @param error An error message to show on the component, as Element's
#'   `error` does -- for a check only the server can make, such as whether
#'   a name is taken. `""` clears it.
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
                               disabled = NULL,
                               label = NULL, error = NULL) {
  .el_check_session(session)
  ns_id <- session$ns(id)
  message <- list(id = ns_id)
  if (!is.null(options)) message$options <- options
  if (!is.null(value)) message$value <- value
  if (!is.null(placeholder)) message$placeholder <- placeholder
  if (!is.null(clearable)) message$clearable <- clearable
  if (!is.null(filterable)) message$filterable <- filterable
  if (!is.null(disabled)) message$disabled <- disabled

  message <- .el_form_item_update(message, label, error)
  .el_send_update(session, message)
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
