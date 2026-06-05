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
#' @param session Shiny session for module support.
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
    width        = 126,
    session      = shiny::getDefaultReactiveDomain()
) {
  if (is.null(id)) id <- paste0("el_progress_", uuid::UUIDgenerate())
  ns_id        <- if (!is.null(session)) session$ns(id) else id
  container_id <- paste0(ns_id, "_container")

  progress_attrs <- list(
    ":percentage"  = "percentage",
    ":type"        = "type",
    ":stroke-width" = "strokeWidth",
    ":text-inside" = "textInside",
    ":show-text"   = "showText",
    ":width"       = "width"
  )
  if (!is.null(status)) progress_attrs[[":status"]] <- "status"
  if (!is.null(color))  progress_attrs[[":color"]]  <- "color"

  vue_data <- list(
    percentage  = percentage,
    type        = type,
    strokeWidth = stroke_width,
    textInside  = text_inside,
    showText    = show_text,
    width       = width
  )
  if (!is.null(status)) vue_data$status <- status
  if (!is.null(color))  vue_data$color  <- color

  component_ui <- shiny::tagList(
    shiny::tags$div(
      id = container_id,
      htmltools::tag("el-progress", progress_attrs)
    ),
    vueR::vue(
      elementId = ns_id,
      list(
        el   = paste0("#", container_id),
        data = vue_data
      )
    )
  )

  htmltools::attachDependencies(component_ui, el_progress_handler_dependency())
}


#' Update Element UI Progress
#'
#' Server-side update for [el_progress()].
#'
#' @param session Shiny session object.
#' @param id Progress ID (un-namespaced).
#' @param percentage New percentage value (`0`–`100`).
#' @param type New progress type.
#' @param status New status theme.
#' @param color New custom colour string.
#' @param stroke_width New stroke width in pixels.
#' @param show_text New show-text flag.
#' @param text_inside New text-inside flag.
#'
#' @export
update_el_progress <- function(
    session,
    id,
    percentage   = NULL,
    type         = NULL,
    status       = NULL,
    color        = NULL,
    stroke_width = NULL,
    show_text    = NULL,
    text_inside  = NULL
) {
  ns_id <- session$ns(id)
  msg   <- list(id = ns_id)
  if (!is.null(percentage))   msg$percentage  <- percentage
  if (!is.null(type))         msg$type        <- type
  if (!is.null(status))       msg$status      <- status
  if (!is.null(color))        msg$color       <- color
  if (!is.null(stroke_width)) msg$strokeWidth <- stroke_width
  if (!is.null(show_text))    msg$showText    <- show_text
  if (!is.null(text_inside))  msg$textInside  <- text_inside
  session$sendCustomMessage("updateElProgress", msg)
}


#' Progress Handler Dependency
#' @keywords internal
el_progress_handler_dependency <- function() {
  htmltools::htmlDependency(
    name      = "el-progress-handler",
    version   = "1.0.0",
    src       = system.file("js", package = "shiny.element"),
    script    = "el-progress-handler.js",
    all_files = FALSE
  )
}
