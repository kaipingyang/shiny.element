#' Element UI Input Number
#'
#' A numeric input with increment/decrement buttons.
#'
#' @param id Input ID. Auto-generated UUID if `NULL`.
#' @param value Initial numeric value. Default `0`.
#' @param min Minimum allowed value. Default `-Inf`.
#' @param max Maximum allowed value. Default `Inf`.
#' @param step Step increment. Default `1`.
#' @param step_strictly Force the value to be a multiple of `step`. Default
#'   `FALSE`.
#' @param precision Decimal precision (non-negative integer). `NULL` for
#'   auto.
#' @param size Component size: `NULL`, `"medium"`, `"small"`, `"mini"`.
#' @param disabled Whether the component is disabled. Default `FALSE`.
#' @param controls Whether to show the +/- control buttons. Default `TRUE`.
#' @param controls_position Button layout: `""` (default, left-right) or
#'   `"right"` (both on the right).
#' @param placeholder Placeholder text. `NULL` for none.
#' @param label Accessible label text. `NULL` for none.
#' @param session Shiny session for module support.
#'
#' @return An `htmltools` tagList with a Vue-managed input-number component.
#'
#' @section Shiny input:
#' `input$<id>` — numeric value, updated on each valid change.
#'
#' @examples
#' el_input_number("n1", value = 5, min = 0, max = 100)
#' el_input_number("n2", value = 1.5, step = 0.5, precision = 1)
#'
#' @export
el_input_number <- function(
    id                = NULL,
    value             = 0,
    min               = -Inf,
    max               = Inf,
    step              = 1,
    step_strictly     = FALSE,
    precision         = NULL,
    size              = NULL,
    disabled          = FALSE,
    controls          = TRUE,
    controls_position = "",
    placeholder       = NULL,
    label             = NULL,
    session           = shiny::getDefaultReactiveDomain()
) {
  if (is.null(id)) id <- paste0("el_input_number_", uuid::UUIDgenerate())
  ns_id        <- if (!is.null(session)) session$ns(id) else id
  container_id <- paste0(ns_id, "_container")

  # Convert R Inf to JS-compatible large numbers
  js_min <- if (is.infinite(min) && min < 0) -1e308 else min
  js_max <- if (is.infinite(max) && max > 0)  1e308 else max

  num_attrs <- list(
    "v-model"           = "value",
    ":min"              = "min",
    ":max"              = "max",
    ":step"             = "step",
    ":step-strictly"    = "stepStrictly",
    ":disabled"         = "disabled",
    ":controls"         = "controls",
    ":controls-position"= "controlsPosition",
    "@change"           = "handleChange"
  )
  if (!is.null(size))        num_attrs[[":size"]]        <- "size"
  if (!is.null(precision))   num_attrs[[":precision"]]   <- "precision"
  if (!is.null(placeholder)) num_attrs[[":placeholder"]] <- "placeholder"
  if (!is.null(label))       num_attrs[[":label"]]       <- "label"

  vue_data <- list(
    value            = value,
    min              = js_min,
    max              = js_max,
    step             = step,
    stepStrictly     = step_strictly,
    disabled         = disabled,
    controls         = controls,
    controlsPosition = controls_position
  )
  if (!is.null(size))        vue_data$size        <- size
  if (!is.null(precision))   vue_data$precision   <- precision
  if (!is.null(placeholder)) vue_data$placeholder <- placeholder
  if (!is.null(label))       vue_data$label       <- label

  component_ui <- shiny::tagList(
    shiny::tags$div(
      id = container_id,
      htmltools::tag("el-input-number", num_attrs)
    ),
    vueR::vue(
      elementId = ns_id,
      list(
        el      = paste0("#", container_id),
        data    = vue_data,
        methods = list(
          handleChange = htmlwidgets::JS(sprintf(
            "function(val) { Shiny.setInputValue('%s', val); }",
            ns_id
          ))
        )
      )
    )
  )

  htmltools::attachDependencies(component_ui, el_input_number_handler_dependency())
}


#' Update Element UI Input Number
#'
#' Server-side update for [el_input_number()].
#'
#' @param session Shiny session object.
#' @param id Input ID (un-namespaced).
#' @param value New numeric value.
#' @param min New minimum.
#' @param max New maximum.
#' @param disabled New disabled state.
#'
#' @export
update_el_input_number <- function(session, id, value = NULL, min = NULL,
                                   max = NULL, disabled = NULL) {
  ns_id <- session$ns(id)
  msg   <- list(id = ns_id)
  if (!is.null(value))    msg$value    <- value
  if (!is.null(min))      msg$min      <- min
  if (!is.null(max))      msg$max      <- max
  if (!is.null(disabled)) msg$disabled <- disabled
  session$sendCustomMessage("updateElInputNumber", msg)
}


#' @keywords internal
el_input_number_handler_dependency <- function() {
  htmltools::htmlDependency(
    name      = "el-input-number-handler",
    version   = "1.0.0",
    src       = system.file("js", package = "shiny.element"),
    script    = "el-input-number-handler.js",
    all_files = FALSE
  )
}
