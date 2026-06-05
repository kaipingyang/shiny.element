#' Element UI Input with Vue Instance
#'
#' Creates an Element UI input component (`<el-input>`) with a Vue instance,
#' supporting text, textarea, and password modes, plus clearable, prefix/suffix
#' icons, word-limit display, and autosize textarea.
#'
#' @param id Input ID. Auto-generated UUID if `NULL`.
#' @param value Initial input value. Default `""`.
#' @param placeholder Placeholder text. `NULL` means no placeholder attribute.
#' @param type Input type: `"text"` (default), `"textarea"`, `"password"`.
#' @param size Input size: `NULL`, `"medium"`, `"small"`, `"mini"`.
#' @param disabled Whether the input is disabled. Default `FALSE`.
#' @param readonly Whether the input is read-only. Default `FALSE`.
#' @param clearable Whether to show a clear button. Default `FALSE`.
#' @param show_password Whether to show the password toggle icon.
#'   Only meaningful when `type = "password"`. Default `FALSE`.
#' @param show_word_limit Whether to show a word-count badge.
#'   Requires `maxlength` to be set. Default `FALSE`.
#' @param maxlength Maximum character count. `NULL` means no limit.
#' @param rows Number of rows for `type = "textarea"`. `NULL` uses the default.
#' @param autosize Whether to auto-size the textarea height. Either `TRUE`/`FALSE`
#'   or a named list `list(minRows = 2, maxRows = 4)`. Default `FALSE`.
#' @param prefix_icon Icon class for the prefix slot (e.g. `"el-icon-search"`).
#'   `NULL` means no icon.
#' @param suffix_icon Icon class for the suffix slot (e.g. `"el-icon-date"`).
#'   `NULL` means no icon.
#' @param label ARIA `label` attribute for accessibility. `NULL` omits it.
#' @param session Shiny session for module support.
#'
#' @return An `htmltools` tagList with a Vue-managed input component.
#'
#' @section Shiny input:
#' `input$<id>` — string value of the input, updated on `change` event
#' (triggered on blur or Enter key press).
#'
#' @examples
#' # Basic text input
#' el_input("name", placeholder = "Enter your name")
#'
#' # Clearable search input with icon
#' el_input("search", placeholder = "Search...",
#'          clearable = TRUE, prefix_icon = "el-icon-search")
#'
#' # Shiny app example
#' if (interactive()) {
#'   library(shiny)
#'   library(shiny.element)
#'   ui <- el_page(
#'     el_input("txt", placeholder = "Type something"),
#'     verbatimTextOutput("val")
#'   )
#'   server <- function(input, output, session) {
#'     output$val <- renderPrint(input$txt)
#'   }
#'   shinyApp(ui, server)
#' }
#'
#' @export
el_input <- function(
    id              = NULL,
    value           = "",
    placeholder     = NULL,
    type            = "text",
    size            = NULL,
    disabled        = FALSE,
    readonly        = FALSE,
    clearable       = FALSE,
    show_password   = FALSE,
    show_word_limit = FALSE,
    maxlength       = NULL,
    rows            = NULL,
    autosize        = FALSE,
    prefix_icon     = NULL,
    suffix_icon     = NULL,
    label           = NULL,
    session         = shiny::getDefaultReactiveDomain()
) {
  if (is.null(id)) id <- paste0("el_input_", uuid::UUIDgenerate())
  ns_id        <- if (!is.null(session)) session$ns(id) else id
  container_id <- paste0(ns_id, "_container")

  # Always-present Vue binding attributes
  input_attrs <- list(
    "v-model"          = "value",
    ":type"            = "type",
    ":disabled"        = "disabled",
    ":readonly"        = "readonly",
    ":clearable"       = "clearable",
    ":show-password"   = "showPassword",
    ":show-word-limit" = "showWordLimit",
    ":autosize"        = "autosize",
    ":prefix-icon"     = "prefixIcon",
    ":suffix-icon"     = "suffixIcon",
    "@change"          = "handleChange"
  )

  # Conditional attributes (only add when not NULL)
  if (!is.null(size))        input_attrs[[":size"]]        <- "size"
  if (!is.null(maxlength))   input_attrs[[":maxlength"]]   <- "maxlength"
  if (!is.null(rows))        input_attrs[[":rows"]]        <- "rows"
  if (!is.null(placeholder)) input_attrs[[":placeholder"]] <- "placeholder"
  if (!is.null(label))       input_attrs[[":label"]]       <- "label"

  # Always-present Vue data fields
  vue_data <- list(
    value         = value,
    type          = type,
    disabled      = disabled,
    readonly      = readonly,
    clearable     = clearable,
    showPassword  = show_password,
    showWordLimit = show_word_limit,
    autosize      = autosize,
    prefixIcon    = prefix_icon,
    suffixIcon    = suffix_icon
  )

  # Conditional data fields (only add when not NULL)
  if (!is.null(size))        vue_data$size        <- size
  if (!is.null(maxlength))   vue_data$maxlength   <- maxlength
  if (!is.null(rows))        vue_data$rows        <- rows
  if (!is.null(placeholder)) vue_data$placeholder <- placeholder
  if (!is.null(label))       vue_data$label       <- label

  component_ui <- shiny::tagList(
    shiny::tags$div(
      id = container_id,
      htmltools::tag("el-input", input_attrs)
    ),
    vueR::vue(
      elementId = ns_id,
      list(
        el      = paste0("#", container_id),
        data    = vue_data,
        methods = list(
          handleChange = htmlwidgets::JS(sprintf(
            "function(value) { Shiny.setInputValue('%s', value); }",
            ns_id
          ))
        )
      )
    )
  )

  htmltools::attachDependencies(component_ui, el_input_handler_dependency())
}


#' Update Element UI Input
#'
#' Server-side update for [el_input()]. Sends a custom message to update
#' named fields on the Vue instance.
#'
#' @param session Shiny session object.
#' @param id Input ID (un-namespaced).
#' @param value New value string.
#' @param placeholder New placeholder text.
#' @param disabled New disabled state.
#' @param readonly New readonly state.
#' @param type New input type.
#' @param size New input size.
#' @param clearable New clearable state.
#' @param show_password New show-password toggle state.
#'
#' @export
update_el_input <- function(
    session,
    id,
    value        = NULL,
    placeholder  = NULL,
    disabled     = NULL,
    readonly     = NULL,
    type         = NULL,
    size         = NULL,
    clearable    = NULL,
    show_password = NULL
) {
  ns_id <- session$ns(id)
  msg   <- list(id = ns_id)
  if (!is.null(value))        msg$value        <- value
  if (!is.null(placeholder))  msg$placeholder  <- placeholder
  if (!is.null(disabled))     msg$disabled     <- disabled
  if (!is.null(readonly))     msg$readonly     <- readonly
  if (!is.null(type))         msg$type         <- type
  if (!is.null(size))         msg$size         <- size
  if (!is.null(clearable))    msg$clearable    <- clearable
  if (!is.null(show_password)) msg$showPassword <- show_password
  session$sendCustomMessage("updateElInput", msg)
}


#' Input Handler Dependency
#' @keywords internal
el_input_handler_dependency <- function() {
  htmltools::htmlDependency(
    name    = "el-input-handler",
    version = "1.0.0",
    src     = system.file("js", package = "shiny.element"),
    script  = "el-input-handler.js"
  )
}
