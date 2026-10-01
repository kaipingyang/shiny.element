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
#' @param session Deprecated. Inside a module, wrap `id` in `ns()`, as for
#'   any Shiny input; a session given here namespaces `id` once more, with
#'   a warning.
#' @param debounce Debounce in ms while dragging, when `show_input = TRUE`. Default `300`.
#' @param input_size Size of the companion input when `show_input = TRUE`.
#' @param show_input_controls Whether the companion input shows its spinner buttons.
#' @param tooltip_class Extra class name for the value tooltip.
#' @param format_tooltip `htmlwidgets::JS()` function formatting the value shown in the tooltip.
#' @inheritParams el_widget
#' @param width Component width, as a CSS unit -- `"200px"`, `"50%"`, or a
#'   number taken as pixels. Element's own markup carries it, so it behaves
#'   like the `width` argument of a Shiny input.
#' @param slots Named list of Element slot contents, such as
#'   `list(title = shiny::tags$b("Bold"))`. A shiny.element component
#'   given here is absorbed rather than nested. For a scoped slot, write
#'   the template with [template()].
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
    label        = NULL,
    debounce     = NULL,
    input_size   = NULL,
    show_input_controls = NULL,
    tooltip_class = NULL,
    format_tooltip = NULL,
    label_position = c("top", "left", "right"),
    label_width = NULL,
    label_suffix = NULL,
    required = FALSE,
    error = NULL,
    show_message = TRUE,
    inline_message = FALSE,
    width        = NULL,
    slots        = NULL,
    session      = NULL
) {
  .el_check_choices("el_slider", environment())
  if (is.null(id)) id <- paste0("el_slider_", uuid::UUIDgenerate())
  ns_id        <- .el_ui_id(id, session)
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
  # Element only reads height in vertical mode, but the field has to exist
  # either way for update_el_slider() to be able to set it.
  slider_attrs[[":height"]] <- .el_optional_bind("height")
  slider_attrs[[":marks"]] <- .el_optional_bind("marks")
  slider_attrs[[":label"]] <- .el_optional_bind("label")
  slider_attrs[[":debounce"]] <- .el_optional_bind("debounce")
  slider_attrs[[":input-size"]] <- .el_optional_bind("inputSize")
  slider_attrs[[":show-input-controls"]] <- .el_optional_bind("showInputControls")
  slider_attrs[[":tooltip-class"]] <- .el_optional_bind("tooltipClass")
  slider_attrs[[":format-tooltip"]] <- .el_optional_bind("formatTooltip")

  # Forwarded to input$<id>_<event>; see .el_event_bindings().
  events <- .el_event_bindings(ns_id, c(
    "input"
  ))
  slider_attrs <- c(slider_attrs, events$attrs)

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
  vue_data$height <- if (!is.null(height)) height else if (vertical) "200px" else NA
  vue_data$marks <- .el_or_na(marks)
  vue_data$label <- .el_or_na(label)
  vue_data$debounce <- .el_or_na(debounce)
  vue_data$inputSize <- .el_or_na(input_size)
  vue_data$showInputControls <- .el_or_na(show_input_controls)
  vue_data$tooltipClass <- .el_or_na(tooltip_class)
  vue_data$formatTooltip <- .el_or_na(format_tooltip)

  el_widget(
    # Reported as the value changes, debounced, as Shiny's own inputs are
    rate = list(policy = "debounce", delay = 250),
    label = label, label_position = label_position,
    label_width = label_width, label_suffix = label_suffix, required = required,
    error = error, show_message = show_message, inline_message = inline_message,
    id     = ns_id,
    markup = htmltools::tag("el-slider", slider_attrs),
    data = vue_data,
    methods = c(events$methods, list(
      handleChange = htmlwidgets::JS(sprintf(
        "function(value) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s', value); }",
        ns_id
      ))
    )),
    mounted = .el_mounted_init(stats::setNames("value", ns_id)),
    width      = width,
    slots      = slots
  )
}


#' Update Element UI Slider
#'
#' Server-side update for [el_slider()]. Supports updating value, range bounds,
#' step size, and disabled state.
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id Slider ID (un-namespaced).
#' @param value New slider value. A single number or two-element vector for
#'   range mode.
#' @param min New minimum value.
#' @param max New maximum value.
#' @param step New step size.
#' @param disabled New disabled state.
#'
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$go, {
#'     update_el_slider(session, "score", value = 80)
#'   })
#' }
#' @export
update_el_slider <- function(
    session = shiny::getDefaultReactiveDomain(),
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
  .el_send_update(session, msg)
  invisible(NULL)
}
