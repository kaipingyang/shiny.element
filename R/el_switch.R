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
#' @param session Shiny session for module support.
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
    session        = shiny::getDefaultReactiveDomain()
) {
  if (is.null(id)) id <- paste0("el_switch_", uuid::UUIDgenerate())
  ns_id        <- if (!is.null(session)) session$ns(id) else id
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
  if (!is.null(width)) switch_attrs[[":width"]] <- "width"

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
  if (!is.null(width)) vue_data$width <- width

  component_ui <- shiny::tagList(
    shiny::tags$div(id = container_id, switch_tag),
    vueR::vue(
      elementId = ns_id,
      list(
        el   = paste0("#", container_id),
        data = vue_data,
        methods = list(
          handleChange = htmlwidgets::JS(sprintf(
            "function(value) { Shiny.setInputValue('%s', value); }",
            ns_id
          ))
        )
      )
    )
  )

  htmltools::attachDependencies(component_ui, el_switch_handler_dependency())
}


#' Update Element UI Switch
#'
#' Server-side update for [el_switch()]. Pass only the fields to change;
#' `NULL` fields are excluded from the update message.
#'
#' @param session Shiny session object.
#' @param id Switch ID (un-namespaced).
#' @param value New switch value.
#' @param disabled New disabled state.
#' @param active_text New active text.
#' @param inactive_text New inactive text.
#' @param active_color New active background color.
#' @param inactive_color New inactive background color.
#'
#' @export
update_el_switch <- function(
    session,
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
}


#' Switch Handler Dependency
#' @keywords internal
el_switch_handler_dependency <- function() {
  htmltools::htmlDependency(
    name      = "el-switch-handler",
    version   = "1.0.0",
    src       = system.file("js", package = "shiny.element"),
    script    = "el-switch-handler.js",
    all_files = FALSE
  )
}
