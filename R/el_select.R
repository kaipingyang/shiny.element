
# Private dependency loader (not exported)
el_select_handler_dependency <- function() {
  .el_handler_dependency("select")
}

#' Element UI Select Component
#'
#' Creates an Element UI `<el-select>` component backed by a Vue instance.
#' Supports single and multiple selection, filtering, and all standard
#' Element UI select props.
#'
#' @param id Input ID. Auto-generated UUID if `NULL`.
#' @param choices Named character vector (`c(Label = value)`) or a list of
#'   `list(value = ..., label = ...)` items. Unnamed vectors are allowed; the
#'   element is used as both value and label.
#' @param selected Initial selected value(s). Use a character vector for
#'   multiple selection. Defaults to `""` (single) or `list()` (multiple).
#' @param multiple Whether multiple items can be selected. Default `FALSE`.
#' @param placeholder Placeholder text shown when nothing is selected.
#' @param disabled Whether the select is disabled. Default `FALSE`.
#' @param clearable Whether to show a clear button. Default `FALSE`.
#' @param filterable Whether typing filters the options. Default `FALSE`.
#' @param size Component size: `NULL`, `"medium"`, `"small"`, or `"mini"`.
#' @param multiple_limit Maximum number of items that can be selected when
#'   `multiple = TRUE`. `0` means unlimited. Default `0`.
#' @param collapse_tags Whether to collapse selected tags into a summary when
#'   `multiple = TRUE`. Default `FALSE`.
#' @param session Shiny session for module namespace support.
#'
#' @return An `htmltools` tagList containing the Vue-managed select component.
#'
#' @section Shiny input:
#' `input$<id>` — string (single) or character vector (multiple), updated on
#' each change.
#'
#' @examples
#' # Single-select from a named vector
#' el_select("sel1",
#'   choices  = c(Apple = "apple", Banana = "banana", Cherry = "cherry"),
#'   selected = "banana"
#' )
#'
#' # Shiny app example
#' if (interactive()) {
#'   library(shiny)
#'   library(shiny.element)
#'   ui <- el_page(
#'     el_select("fruit",
#'       choices  = c(Apple = "apple", Banana = "banana", Cherry = "cherry"),
#'       selected = "apple",
#'       clearable = TRUE
#'     ),
#'     verbatimTextOutput("selected")
#'   )
#'   server <- function(input, output, session) {
#'     output$selected <- renderPrint(input$fruit)
#'   }
#'   shinyApp(ui, server)
#' }
#'
#' @export
el_select <- function(
    id             = NULL,
    choices,
    selected       = NULL,
    multiple       = FALSE,
    placeholder    = NULL,
    disabled       = FALSE,
    clearable      = FALSE,
    filterable     = FALSE,
    size           = NULL,
    multiple_limit = 0,
    collapse_tags  = FALSE,
    session        = shiny::getDefaultReactiveDomain()
) {
  if (is.null(id)) id <- paste0("el_select_", uuid::UUIDgenerate())
  ns_id        <- if (!is.null(session)) session$ns(id) else id
  container_id <- paste0(ns_id, "_container")

  # Build el-option slot (v-for loop, rendered by Vue)
  option_slot <- htmltools::tag("el-option", list(
    "v-for"  = "opt in options",
    ":key"   = "opt.value",
    ":value" = "opt.value",
    ":label" = "opt.label"
  ))

  # Build el-select attributes
  select_attrs <- list(
    "v-model"         = "value",
    ":multiple"       = "multiple",
    ":disabled"       = "disabled",
    ":clearable"      = "clearable",
    ":filterable"     = "filterable",
    ":multiple-limit" = "multipleLimit",
    ":collapse-tags"  = "collapseTags",
    "@change"         = "handleChange"
  )
  select_attrs[[":placeholder"]] <- .el_optional_bind("placeholder")
  if (!is.null(size))        select_attrs[[":size"]]        <- "size"

  # Build Vue data
  vue_data <- list(
    value        = if (is.null(selected)) (if (multiple) list() else "") else selected,
    options      = .el_normalize_choices(choices),
    multiple     = multiple,
    disabled     = disabled,
    clearable    = clearable,
    filterable   = filterable,
    multipleLimit = multiple_limit,
    collapseTags  = collapse_tags
  )
  vue_data$placeholder <- if (is.null(placeholder)) NA else placeholder
  if (!is.null(size))        vue_data$size        <- size

  component_ui <- shiny::tagList(
    shiny::tags$div(
      id = container_id, style = .el_host_style(),
      htmltools::tag("el-select", c(select_attrs, list(option_slot)))
    ),
    vueR::vue(
elementId = ns_id, width = 0, height = 0,
      list(
        el      = paste0("#", container_id),
        data    = vue_data,
        methods = list(
          handleChange = htmlwidgets::JS(sprintf(
            "function(value) { Shiny.setInputValue('%s', value); }",
            ns_id
          ))
        ),
        mounted = .el_mounted_init(stats::setNames("value", ns_id))
      )
    )
  )

  htmltools::attachDependencies(component_ui, el_select_handler_dependency())
}


#' Update Element UI Select
#'
#' Server-side update for [el_select()]. Sends a custom message to update
#' reactive fields on the underlying Vue instance.
#'
#' @param session Shiny session object.
#' @param id Select input ID (un-namespaced).
#' @param value New selected value (string or character vector).
#' @param options New choices: named character vector or
#'   `list(list(value=, label=), ...)`.
#' @param disabled New disabled state.
#' @param placeholder New placeholder text.
#' @param clearable New clearable state.
#' @param filterable New filterable state.
#'
#' @export
update_el_select <- function(
    session,
    id,
    value       = NULL,
    options     = NULL,
    disabled    = NULL,
    placeholder = NULL,
    clearable   = NULL,
    filterable  = NULL
) {
  ns_id <- session$ns(id)
  msg   <- list(id = ns_id)
  if (!is.null(value))       msg$value       <- value
  if (!is.null(options))     msg$options     <- .el_normalize_choices(options)
  if (!is.null(disabled))    msg$disabled    <- disabled
  if (!is.null(placeholder)) msg$placeholder <- placeholder
  if (!is.null(clearable))   msg$clearable   <- clearable
  if (!is.null(filterable))  msg$filterable  <- filterable
  session$sendCustomMessage("updateElSelect", msg)
}
