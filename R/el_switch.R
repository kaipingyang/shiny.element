#' Element UI Switch
#'
#' Creates an Element UI switch with Vue instance.
#'
#' @param id Switch ID. Auto-generated UUID if `NULL`.
#' @param value Initial switch state. Default `FALSE`.
#' @param disabled Whether the switch is disabled. Default `FALSE`.
#' @param width Switch width in pixels (integer).
#' @param active_text Text displayed when switch is on.
#' @param inactive_text Text displayed when switch is off.
#' @param active_color Background color when switch is on (e.g. `"#409EFF"`).
#' @param inactive_color Background color when switch is off.
#' @param active_value Value reported to Shiny when switch is on. Default `TRUE`.
#' @param inactive_value Value reported to Shiny when switch is off. Default `FALSE`.
#' @param session Deprecated. Inside a module, wrap `id` in `ns()`, as for
#'   any Shiny input; a session given here namespaces `id` once more, with
#'   a warning.
#' @param active_icon_class Icon class shown on the active side; overrides `active_text`.
#' @param inactive_icon_class Icon class shown on the inactive side; overrides `inactive_text`.
#' @param name Native `name` attribute of the inner checkbox.
#' @param validate_event Whether a change triggers form validation. Default `TRUE`.
#' @param slots Named list of Element slot contents, such as
#'   `list(title = shiny::tags$b("Bold"))`. A shiny.element component
#'   given here is absorbed rather than nested. For a scoped slot, write
#'   the template with [template()].
#'
#' @section Element methods:
#' Callable with [el_call()]:
#'
#' - `focus()` -- Focus the Switch component
#'
#' @return An `htmltools` tagList with a Vue-managed switch component.
#'
#' @section Shiny input:
#' `input$<id>` — the value of `active_value` (when on) or `inactive_value`
#' (when off), matching the types of those arguments.
#'
#' @examples
#' el_switch("sw1", value = TRUE)
#'
#' if (interactive()) {
#'   library(shiny)
#'   library(shiny.element)
#'   ui <- el_page(
#'     el_switch("sw1", active_text = "On", inactive_text = "Off"),
#'     verbatimTextOutput("state")
#'   )
#'   server <- function(input, output, session) {
#'     output$state <- renderPrint(input$sw1)
#'   }
#'   shinyApp(ui, server)
#' }
#'
#' @export
el_switch <- function(
    id             = NULL,
    value          = FALSE,
    disabled       = FALSE,
    width          = NULL,
    active_text    = NULL,
    inactive_text  = NULL,
    active_color   = NULL,
    inactive_color = NULL,
    active_value   = TRUE,
    inactive_value = FALSE,
    active_icon_class = NULL,
    inactive_icon_class = NULL,
    name           = NULL,
    validate_event = NULL,
    slots          = NULL,
    session        = NULL
) {
  if (is.null(id)) id <- paste0("el_switch_", uuid::UUIDgenerate())
  ns_id        <- .el_ui_id(id, session)
  container_id <- paste0(ns_id, "_container")

  switch_attrs <- list(
    "v-model"         = "value",
    ":disabled"       = "disabled",
    ":active-text"    = "activeText",
    ":inactive-text"  = "inactiveText",
    ":active-color"   = "activeColor",
    ":inactive-color" = "inactiveColor",
    ":active-value"   = "activeValue",
    ":inactive-value" = "inactiveValue",
    "@change"         = "handleChange"
  )
  switch_attrs[[":width"]] <- .el_optional_bind("width")
  switch_attrs[[":active-icon-class"]] <- .el_optional_bind("activeIconClass")
  switch_attrs[[":inactive-icon-class"]] <- .el_optional_bind("inactiveIconClass")
  switch_attrs[[":name"]] <- .el_optional_bind("name")
  switch_attrs[[":validate-event"]] <- .el_optional_bind("validateEvent")
  switch_tag <- htmltools::tag("el-switch", switch_attrs)

  vue_data <- list(
    value         = value,
    disabled      = disabled,
    activeText    = if (is.null(active_text))    "" else active_text,
    inactiveText  = if (is.null(inactive_text))  "" else inactive_text,
    activeColor   = if (is.null(active_color))   "" else active_color,
    inactiveColor = if (is.null(inactive_color)) "" else inactive_color,
    activeValue   = active_value,
    inactiveValue = inactive_value
  )
  vue_data$width <- .el_or_na(width)
  vue_data$activeIconClass <- .el_or_na(active_icon_class)
  vue_data$inactiveIconClass <- .el_or_na(inactive_icon_class)
  vue_data$name <- .el_or_na(name)
  vue_data$validateEvent <- .el_or_na(validate_event)
  el_widget(
    id      = ns_id,
    markup  = switch_tag,
    data    = vue_data,
    methods = list(
      handleChange = htmlwidgets::JS(sprintf(
        "function(value) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s', value); }", ns_id
      ))
    ),
    mounted    = .el_mounted_init(stats::setNames("value", ns_id)),
    slots      = slots,
    dependency = el_switch_handler_dependency()
  )
}


#' Update Element UI Switch
#'
#' Server-side update for [el_switch()]. Pass only the fields to change;
#' `NULL` fields are excluded from the update message.
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id Switch ID (un-namespaced).
#' @param value New switch value.
#' @param disabled New disabled state.
#' @param active_text New active text.
#' @param inactive_text New inactive text.
#' @param active_color New active background color.
#' @param inactive_color New inactive background color.
#'
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$go, {
#'     update_el_switch(session, "live", value = TRUE)
#'   })
#' }
#' @export
update_el_switch <- function(
    session = shiny::getDefaultReactiveDomain(),
    id,
    value          = NULL,
    disabled       = NULL,
    active_text    = NULL,
    inactive_text  = NULL,
    active_color   = NULL,
    inactive_color = NULL
) {
  ns_id <- session$ns(id)
  msg   <- list(id = ns_id)
  if (!is.null(value))         msg$value         <- value
  if (!is.null(disabled))      msg$disabled      <- disabled
  if (!is.null(active_text))   msg$activeText    <- active_text
  if (!is.null(inactive_text)) msg$inactiveText  <- inactive_text
  if (!is.null(active_color))  msg$activeColor   <- active_color
  if (!is.null(inactive_color)) msg$inactiveColor <- inactive_color
  session$sendCustomMessage("updateElSwitch", msg)
  invisible(NULL)
}


#' Switch Handler Dependency
#' @keywords internal
el_switch_handler_dependency <- function() {
  .el_handler_dependency("switch")
}
