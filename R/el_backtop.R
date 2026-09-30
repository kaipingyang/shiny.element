#' Element UI Back to Top
#'
#' A button that appears once the page has been scrolled down, and returns it
#' to the top when clicked.
#'
#' @param id Button ID. Auto-generated if `NULL`.
#' @param content Contents of the button. `NULL` for Element's own arrow icon.
#' @param target CSS selector of the element that scrolls. `NULL` for the page.
#' @param visibility_height Scroll distance in pixels before the button
#'   appears. Default `200`.
#' @param right Distance from the right edge, in pixels. Default `40`.
#' @param bottom Distance from the bottom edge, in pixels. Default `40`.
#' @param width Component width, as a CSS unit.
#' @param session Shiny session for module support.
#'
#' @section Shiny inputs:
#' - `input$<id>_click` -- fires each time the button is clicked.
#'
#' @return A Shiny UI element.
#' @examples
#' el_backtop("top")
#' el_backtop("top", visibility_height = 100, right = 20, bottom = 20)
#'
#' # Scrolling a panel rather than the page
#' el_backtop("panel_top", target = "#report")
#' @export
el_backtop <- function(id = NULL,
                       content = NULL,
                       target = NULL,
                       visibility_height = NULL,
                       right = NULL,
                       bottom = NULL,
                       width = NULL,
                       session = shiny::getDefaultReactiveDomain()) {
  if (is.null(id)) id <- paste0("el_backtop_", uuid::UUIDgenerate())
  ns_id <- if (!is.null(session)) session$ns(id) else id

  attrs <- list(
    ":target"            = .el_optional_bind("target"),
    ":visibility-height" = .el_optional_bind("visibilityHeight"),
    ":right"             = .el_optional_bind("right"),
    ":bottom"            = .el_optional_bind("bottom")
  )
  events <- .el_event_bindings(ns_id, "click")
  attrs <- c(attrs, events$attrs)

  el_widget(
    id     = ns_id,
    markup = htmltools::tag("el-backtop", c(attrs, if (!is.null(content)) list(content))),
    data   = list(
      target           = .el_or_na(target),
      visibilityHeight = .el_or_na(visibility_height),
      right            = .el_or_na(right),
      bottom           = .el_or_na(bottom)
    ),
    methods    = events$methods,
    width      = width,
    dependency = el_backtop_handler_dependency()
  )
}


#' Update Element UI Back to Top
#'
#' Server-side update for [el_backtop()].
#'
#' @param session Shiny session object.
#' @param id Button ID (un-namespaced).
#' @param visibility_height,right,bottom New values; `NULL` leaves one unchanged.
#'
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$compact, {
#'     update_el_backtop(session, "top", right = 10, bottom = 10)
#'   })
#' }
#' @export
update_el_backtop <- function(session, id, visibility_height = NULL,
                              right = NULL, bottom = NULL) {
  ns_id <- session$ns(id)
  msg <- list(id = ns_id)
  if (!is.null(visibility_height)) msg$visibilityHeight <- visibility_height
  if (!is.null(right))             msg$right            <- right
  if (!is.null(bottom))            msg$bottom           <- bottom
  session$sendCustomMessage("updateElBacktop", msg)
  invisible(NULL)
}


#' @keywords internal
el_backtop_handler_dependency <- function() {
  .el_handler_dependency("backtop")
}
