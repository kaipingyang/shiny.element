#' Element UI Progress Component
#'
#' Creates an Element UI progress bar. This is a display-only component;
#' update it from the server with [update_el_progress()].
#'
#' @param id Progress ID. Auto-generated UUID if `NULL`.
#' @param percentage Progress percentage, `0`–`100`. Default `0`.
#' @param type Progress bar type: `"line"`, `"circle"`, or `"dashboard"`.
#'   Default `"line"`.
#' @param status Status theme: `NULL`, `"success"`, `"exception"`, or
#'   `"warning"`. `NULL` means no status colour. Default `NULL`.
#' @param stroke_width Stroke width in pixels. Default `6`.
#' @param text_inside Whether to display the percentage text inside the bar
#'   (only applies to `type = "line"`). Default `FALSE`.
#' @param show_text Whether to show the progress text. Default `TRUE`.
#' @param color Custom colour string (e.g. `"#409EFF"`). Overrides `status`
#'   colour when set. Default `NULL`.
#' @param width Width in pixels for `"circle"` and `"dashboard"` types.
#'   Default `126`.
#' @param duration Control the animation duration of indeterminate progress or
#'   striped flow progress. Element Plus's `duration` (number).
#' @param indeterminate Set indeterminate progress. Element Plus's
#'   `indeterminate` (boolean).
#' @param striped Stripe over the progress bar's color. Element Plus's
#'   `striped` (boolean).
#' @param striped_flow Get the stripes to flow. Element Plus's `striped-flow`
#'   (boolean).
#' @param session Deprecated. Inside a module, wrap `id` in `ns()`, as for
#'   any Shiny input; a session given here namespaces `id` once more, with
#'   a warning.
#' @param stroke_linecap Shape of the bar's ends: `"round"` (default), `"butt"` or `"square"`.
#' @param format `JS()` function `function(percentage)` returning the text shown.
#' @param slots Named list of Element slot contents, such as
#'   `list(title = shiny::tags$b("Bold"))`. A shiny.element component
#'   given here is absorbed rather than nested. For a scoped slot, write
#'   the template with [template()].
#'
#' @return An `htmltools` tagList with a Vue-managed progress component.
#'
#' @examples
#' # Basic line progress
#' el_progress("prog1", percentage = 60)
#'
#' # Circle progress with success status
#' el_progress("prog2", percentage = 100, type = "circle", status = "success")
#'
#' # Dashboard style with custom colour
#' el_progress("prog3", percentage = 75, type = "dashboard", color = "#67C23A")
#'
#' # Shiny app example
#' if (interactive()) {
#'   library(shiny)
#'   library(shiny.element)
#'   ui <- el_page(
#'     el_progress("prog1", percentage = 0),
#'     actionButton("go", "Advance")
#'   )
#'   server <- function(input, output, session) {
#'     observeEvent(input$go, {
#'       update_el_progress(session, "prog1", percentage = min(100, (input$go * 10)))
#'     })
#'   }
#'   shinyApp(ui, server)
#' }
#'
#' @export
el_progress <- function(
    id           = NULL,
    percentage   = 0,
    type         = "line",
    status       = NULL,
    stroke_width = 6,
    text_inside  = FALSE,
    show_text    = TRUE,
    color        = NULL,
    duration = NULL,
    indeterminate = NULL,
    striped = NULL,
    striped_flow = NULL,
    width        = 126,
    stroke_linecap = NULL,
    slots        = NULL,
    format       = NULL,
    session      = NULL
) {
  .el_check_choices("el_progress", environment())
  if (is.null(id)) id <- paste0("el_progress_", uuid::UUIDgenerate())
  ns_id        <- .el_ui_id(id, session)
  container_id <- paste0(ns_id, "_container")

  progress_attrs <- list(
    ":percentage"  = "percentage",
    ":type"        = "type",
    ":stroke-width" = "strokeWidth",
    ":text-inside" = "textInside",
    ":show-text"   = "showText",
    ":width"       = "width"
  )
  progress_attrs[[":status"]] <- .el_optional_bind("status")
  progress_attrs[[":color"]] <- "color"
  progress_attrs[[":stroke-linecap"]] <- .el_optional_bind("strokeLinecap")
  progress_attrs[[":format"]] <- .el_optional_bind("format")
  vue_data <- list(
    percentage  = percentage,
    type        = type,
    strokeWidth = stroke_width,
    textInside  = text_inside,
    showText    = show_text,
    width       = width
  )
  vue_data$status <- if (is.null(status)) NA else status
  # Element's ElProgress declares color as [String, Array, Function] with a
  # default of "" and calls .length on it, so JSON null throws in render.
  # The empty string is its own default and means the same thing.
  vue_data$color <- if (is.null(color)) "" else color
  vue_data$strokeLinecap <- .el_or_na(stroke_linecap)
  vue_data$format <- .el_or_na(format)
  el_widget(
    props = .el_props(list(
      duration = duration,
      indeterminate = indeterminate,
      striped = striped,
      striped_flow = striped_flow)),
    id     = ns_id,
    markup = htmltools::tag("el-progress", progress_attrs),
    data = vue_data,
    slots      = slots
  )
}


#' Update Element UI Progress
#'
#' Server-side update for [el_progress()].
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id Progress ID (un-namespaced).
#' @param percentage New percentage value (`0`–`100`).
#' @param type New progress type.
#' @param status New status theme.
#' @param color New custom colour string.
#' @param stroke_width New stroke width in pixels.
#' @param show_text New show-text flag.
#' @param text_inside New text-inside flag.
#'
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$go, {
#'     update_el_progress(session, "pct", percentage = 100)
#'   })
#' }
#' @export
update_el_progress <- function(
    session = shiny::getDefaultReactiveDomain(),
    id,
    percentage   = NULL,
    type         = NULL,
    status       = NULL,
    color        = NULL,
    stroke_width = NULL,
    show_text    = NULL,
    text_inside  = NULL
) {
  .el_check_session(session)
  ns_id <- session$ns(id)
  msg   <- list(id = ns_id)
  if (!is.null(percentage))   msg$percentage  <- percentage
  if (!is.null(type))         msg$type        <- type
  if (!is.null(status))       msg$status      <- status
  if (!is.null(color))        msg$color       <- color
  if (!is.null(stroke_width)) msg$strokeWidth <- stroke_width
  if (!is.null(show_text))    msg$showText    <- show_text
  if (!is.null(text_inside))  msg$textInside  <- text_inside
  .el_send_update(session, msg)
  invisible(NULL)
}


