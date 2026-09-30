#' Element UI Date Picker Component
#'
#' Creates an Element UI date picker with Vue instance, supporting single date,
#' datetime, month, year, week, and date range selection modes.
#'
#' @param id Date picker ID. Auto-generated UUID if `NULL`.
#' @param value Initial value. A `Date` object, a string in the format matching
#'   `value_format`, or a two-element character vector for range types. `NULL`
#'   (default) leaves the picker empty.
#' @param type Picker type: `"date"` (default), `"datetime"`, `"daterange"`,
#'   `"datetimerange"`, `"month"`, `"year"`, `"week"`.
#' @param value_format Format string returned to Shiny when a date is selected.
#'   Uses Element UI format tokens (e.g., `"yyyy-MM-dd"`). Default
#'   `"yyyy-MM-dd"`.
#' @param format Display format shown in the input box. Uses Element UI format
#'   tokens. `NULL` (default) falls back to `value_format`.
#' @param placeholder Placeholder text for non-range types.
#' @param start_placeholder Placeholder for the start input in range types.
#' @param end_placeholder Placeholder for the end input in range types.
#' @param clearable Whether to show the clear button. Default `TRUE`.
#' @param disabled Whether the picker is disabled. Default `FALSE`.
#' @param editable Whether the user can type directly in the input. Default `TRUE`.
#' @param readonly Whether the picker is read-only. Default `FALSE`.
#' @param range_separator Separator string displayed between start and end in
#'   range types. Default `"-"`.
#' @param align Input alignment: `"left"` (default), `"center"`, `"right"`.
#' @param session Shiny session for module support.
#' @param size Input size: `"medium"`, `"small"` or `"mini"`.
#' @param name Native `name` attribute.
#' @param prefix_icon Icon class shown at the start of the input.
#' @param clear_icon Icon class of the clear button.
#' @param popper_class Extra class name for the picker panel.
#' @param default_value Date the panel opens on when nothing is selected.
#' @param default_time Time part used when a date is picked, as `"HH:mm:ss"`.
#' @param unlink_panels Whether the two panels of a range picker move independently.
#' @param picker_options Additional Element picker options, as a named list.
#' @param validate_event Whether a change triggers form validation. Default `TRUE`.
#' @param width Component width, as a CSS unit -- `"200px"`, `"50%"`, or a
#'   number taken as pixels. Element's own markup carries it, so it behaves
#'   like the `width` argument of a Shiny input.
#'
#' @section Element methods:
#' Callable with [el_call()]:
#'
#' - `focus()` -- Focus the Input component
#'
#' @return An `htmltools` tagList with a Vue-managed date picker component.
#'
#' @section Shiny input:
#' `input$<id>` — String for single-date types, or two-element array for range
#' types. The format is controlled by `value_format`.
#'
#' @examples
#' # Basic date picker
#' el_date_picker("dp1")
#'
#' # Pre-filled with today's date
#' el_date_picker("dp2", value = Sys.Date())
#'
#' # Date range picker
#' el_date_picker("dp3", type = "daterange",
#'                start_placeholder = "Start date",
#'                end_placeholder   = "End date")
#'
#' # Shiny app example
#' if (interactive()) {
#'   library(shiny)
#'   library(shiny.element)
#'   ui <- el_page(
#'     el_date_picker("dp1", placeholder = "Pick a date"),
#'     verbatimTextOutput("selected")
#'   )
#'   server <- function(input, output, session) {
#'     output$selected <- renderPrint(input$dp1)
#'   }
#'   shinyApp(ui, server)
#' }
#'
#' @export
el_date_picker <- function(
    id                = NULL,
    value             = NULL,
    type              = "date",
    value_format      = "yyyy-MM-dd",
    format            = NULL,
    placeholder       = NULL,
    start_placeholder = NULL,
    end_placeholder   = NULL,
    clearable         = TRUE,
    disabled          = FALSE,
    editable          = TRUE,
    readonly          = FALSE,
    range_separator   = "-",
    align             = "left",
    size              = NULL,
    name              = NULL,
    prefix_icon       = NULL,
    clear_icon        = NULL,
    popper_class      = NULL,
    default_value     = NULL,
    default_time      = NULL,
    unlink_panels     = NULL,
    picker_options    = NULL,
    validate_event    = NULL,
    width             = NULL,
    session           = shiny::getDefaultReactiveDomain()
) {
  if (is.null(id)) id <- paste0("el_date_picker_", uuid::UUIDgenerate())
  ns_id        <- if (!is.null(session)) session$ns(id) else id
  container_id <- paste0(ns_id, "_container")

  # Determine if this is a range-type picker
  is_range_type <- grepl("range", type)

  # Process initial value
  init_value <- if (is.null(value)) {
    if (is_range_type) list() else ""
  } else if (inherits(value, "Date")) {
    base::format(value, "%Y-%m-%d")
  } else if (is.character(value) && length(value) == 2) {
    as.list(value)
  } else {
    value
  }

  # Resolve display format
  display_format <- if (!is.null(format)) format else value_format

  # Vue binding attributes
  picker_attrs <- list(
    "v-model"          = "value",
    ":type"            = "type",
    ":value-format"    = "valueFormat",
    ":format"          = "displayFormat",
    ":clearable"       = "clearable",
    ":disabled"        = "disabled",
    ":editable"        = "editable",
    ":readonly"        = "readonly",
    ":range-separator" = "rangeSeparator",
    ":align"           = "align",
    "@change"          = "handleChange"
  )
  picker_attrs[[":placeholder"]] <- .el_optional_bind("placeholder")
  picker_attrs[[":start-placeholder"]] <- .el_optional_bind("startPlaceholder")
  picker_attrs[[":end-placeholder"]] <- .el_optional_bind("endPlaceholder")
  picker_attrs[[":size"]] <- .el_optional_bind("size")
  picker_attrs[[":name"]] <- .el_optional_bind("name")
  picker_attrs[[":prefix-icon"]] <- .el_optional_bind("prefixIcon")
  picker_attrs[[":clear-icon"]] <- .el_optional_bind("clearIcon")
  picker_attrs[[":popper-class"]] <- .el_optional_bind("popperClass")
  picker_attrs[[":default-value"]] <- .el_optional_bind("defaultValue")
  picker_attrs[[":default-time"]] <- .el_optional_bind("defaultTime")
  picker_attrs[[":unlink-panels"]] <- .el_optional_bind("unlinkPanels")
  picker_attrs[[":picker-options"]] <- .el_optional_bind("pickerOptions")
  picker_attrs[[":validate-event"]] <- .el_optional_bind("validateEvent")

  # Forwarded to input$<id>_<event>; see .el_event_bindings().
  events <- .el_event_bindings(ns_id, c(
    "blur",
    "focus"
  ))
  picker_attrs <- c(picker_attrs, events$attrs)
  # Vue data
  vue_data <- list(
    value          = init_value,
    type           = type,
    valueFormat    = value_format,
    displayFormat  = display_format,
    clearable      = clearable,
    disabled       = disabled,
    editable       = editable,
    readonly       = readonly,
    rangeSeparator = range_separator,
    align          = align
  )
  vue_data$placeholder <- if (is.null(placeholder)) NA else placeholder
  vue_data$startPlaceholder <- .el_or_na(start_placeholder)
  vue_data$endPlaceholder <- .el_or_na(end_placeholder)
  vue_data$size <- .el_or_na(size)
  vue_data$name <- .el_or_na(name)
  vue_data$prefixIcon <- .el_or_na(prefix_icon)
  vue_data$clearIcon <- .el_or_na(clear_icon)
  vue_data$popperClass <- .el_or_na(popper_class)
  vue_data$defaultValue <- .el_or_na(default_value)
  vue_data$defaultTime <- .el_or_na(default_time)
  vue_data$unlinkPanels <- .el_or_na(unlink_panels)
  vue_data$pickerOptions <- .el_or_na(picker_options)
  vue_data$validateEvent <- .el_or_na(validate_event)
  .el_widget(
    id     = ns_id,
    markup = htmltools::tag("el-date-picker", picker_attrs),
    data = vue_data,
    methods = c(events$methods, list(
      handleChange = htmlwidgets::JS(sprintf(
        "function(value) { Shiny.setInputValue('%s', value); }",
        ns_id
      ))
    )),
    mounted = .el_mounted_init(stats::setNames("value", ns_id)),
    width      = width,
    dependency = el_date_picker_handler_dependency()
  )
}


#' Update Element UI Date Picker
#'
#' Server-side update for [el_date_picker()]. Supports updating value, disabled
#' state, type, clearable, readonly, and placeholder text.
#'
#' @param session Shiny session object.
#' @param id Date picker ID (un-namespaced).
#' @param value New picker value (string or two-element vector for range types).
#' @param disabled New disabled state.
#' @param type New picker type.
#' @param clearable New clearable state.
#' @param readonly New readonly state.
#' @param placeholder New placeholder text (non-range types).
#'
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$go, {
#'     update_el_date_picker(session, "when", value = "2026-06-01")
#'   })
#' }
#' @export
update_el_date_picker <- function(
    session,
    id,
    value       = NULL,
    disabled    = NULL,
    type        = NULL,
    clearable   = NULL,
    readonly    = NULL,
    placeholder = NULL
) {
  ns_id <- session$ns(id)
  msg   <- list(id = ns_id)
  if (!is.null(value))       msg$value       <- value
  if (!is.null(disabled))    msg$disabled    <- disabled
  if (!is.null(type))        msg$type        <- type
  if (!is.null(clearable))   msg$clearable   <- clearable
  if (!is.null(readonly))    msg$readonly    <- readonly
  if (!is.null(placeholder)) msg$placeholder <- placeholder
  session$sendCustomMessage("updateElDatePicker", msg)
  invisible(NULL)
}


# Date picker handler dependency (internal)
el_date_picker_handler_dependency <- function() {
  .el_handler_dependency("date-picker")
}
