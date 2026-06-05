#' Element UI Slider Component
#'
#' Creates an Element UI slider with Vue instance, supporting single value and
#' range modes, marks, vertical orientation, and optional numeric input box.
#'
#' @param id Slider ID. Auto-generated UUID if `NULL`.
#' @param value Initial value. A single number, or `c(low, high)` when
#'   `range = TRUE`. When `range = TRUE` and a scalar is supplied, the upper
#'   bound is set to `max`.
#' @param min Minimum value. Default `0`.
#' @param max Maximum value. Default `100`.
#' @param step Step size. Default `1`.
#' @param range Whether to enable range selection. Default `FALSE`.
#' @param disabled Whether the slider is disabled. Default `FALSE`.
#' @param show_input Whether to display a numeric input box beside the slider
#'   (non-range mode only). Default `FALSE`.
#' @param show_stops Whether to display stop markers at each step. Default `FALSE`.
#' @param show_tooltip Whether to display the tooltip when dragging. Default `TRUE`.
#' @param vertical Whether to display in vertical orientation. Default `FALSE`.
#' @param height Height of the slider in vertical mode (e.g., `"200px"`).
#'   Defaults to `"200px"` when `vertical = TRUE` and not explicitly provided.
#' @param marks Named list of mark labels, e.g.,
#'   `list("0" = "0km", "50" = "50km")`. Default `NULL` (no marks).
#' @param session Shiny session for module support.
#'
#' @return An `htmltools` tagList with a Vue-managed slider component.
#'
#' @section Shiny input:
#' `input$<id>` — Number (`range = FALSE`) or two-element array
#' (`range = TRUE`), updated when the user finishes dragging.
#'
#' @examples
#' # Basic usage
#' el_slider("slider1", value = 30, min = 0, max = 100)
#'
#' # Range slider
#' el_slider("slider2", value = c(20, 80), range = TRUE)
#'
#' # Vertical slider with marks
#' el_slider("slider3", value = 50, vertical = TRUE, height = "200px",
#'           marks = list("0" = "0km", "50" = "50km", "100" = "100km"))
#'
#' # Shiny app example
#' if (interactive()) {
#'   library(shiny)
#'   library(shiny.element)
#'   ui <- el_page(
#'     el_slider("slider1", value = 50, min = 0, max = 100),
#'     verbatimTextOutput("val")
#'   )
#'   server <- function(input, output, session) {
#'     output$val <- renderPrint(input$slider1)
#'   }
#'   shinyApp(ui, server)
#' }
#'
#' @export
el_slider <- function(
    id           = NULL,
    value        = 0,
    min          = 0,
    max          = 100,
    step         = 1,
    range        = FALSE,
    disabled     = FALSE,
    show_input   = FALSE,
    show_stops   = FALSE,
    show_tooltip = TRUE,
    vertical     = FALSE,
    height       = NULL,
    marks        = NULL,
    session      = shiny::getDefaultReactiveDomain()
) {
  if (is.null(id)) id <- paste0("el_slider_", uuid::UUIDgenerate())
  ns_id        <- if (!is.null(session)) session$ns(id) else id
  container_id <- paste0(ns_id, "_container")

  # Normalize value for range mode
  if (range && length(value) == 1) value <- c(value, max)

  # Vue binding attributes
  slider_attrs <- list(
    "v-model"       = "value",
    ":min"          = "min",
    ":max"          = "max",
    ":step"         = "step",
    ":range"        = "range",
    ":disabled"     = "disabled",
    ":show-input"   = "showInput",
    ":show-stops"   = "showStops",
    ":show-tooltip" = "showTooltip",
    ":vertical"     = "vertical",
    "@change"       = "handleChange"
  )
  if (vertical || !is.null(height)) {
    slider_attrs[[":height"]] <- "height"
  }
  if (!is.null(marks)) {
    slider_attrs[[":marks"]] <- "marks"
  }

  # Vue data
  vue_data <- list(
    value       = if (range) as.list(value) else value[1],
    min         = min,
    max         = max,
    step        = step,
    range       = range,
    disabled    = disabled,
    showInput   = show_input,
    showStops   = show_stops,
    showTooltip = show_tooltip,
    vertical    = vertical
  )
  if (vertical || !is.null(height)) {
    vue_data$height <- if (!is.null(height)) height else "200px"
  }
  if (!is.null(marks)) {
    vue_data$marks <- marks
  }

  component_ui <- shiny::tagList(
    shiny::tags$div(
      id = container_id,
      htmltools::tag("el-slider", slider_attrs)
    ),
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

  htmltools::attachDependencies(component_ui, el_slider_handler_dependency())
}


#' Update Element UI Slider
#'
#' Server-side update for [el_slider()]. Supports updating value, range bounds,
#' step size, and disabled state.
#'
#' @param session Shiny session object.
#' @param id Slider ID (un-namespaced).
#' @param value New slider value. A single number or two-element vector for
#'   range mode.
#' @param min New minimum value.
#' @param max New maximum value.
#' @param step New step size.
#' @param disabled New disabled state.
#'
#' @export
update_el_slider <- function(
    session,
    id,
    value    = NULL,
    min      = NULL,
    max      = NULL,
    step     = NULL,
    disabled = NULL
) {
  ns_id <- session$ns(id)
  msg   <- list(id = ns_id)
  if (!is.null(value))    msg$value    <- value
  if (!is.null(min))      msg$min      <- min
  if (!is.null(max))      msg$max      <- max
  if (!is.null(step))     msg$step     <- step
  if (!is.null(disabled)) msg$disabled <- disabled
  session$sendCustomMessage("updateElSlider", msg)
}


# Slider handler dependency (internal)
el_slider_handler_dependency <- function() {
  htmltools::htmlDependency(
    name    = "el-slider-handler",
    version = "1.0.0",
    src     = system.file("js", package = "shiny.element"),
    script  = "el-slider-handler.js"
  )
}
