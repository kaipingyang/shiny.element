#' Element Plus Back to Top
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
#' @param session Deprecated. Inside a module, wrap `id` in `ns()`, as for
#'   any Shiny input; a session given here namespaces `id` once more, with
#'   a warning.
#' @param slots Named list of Element slot contents, such as
#'   `list(title = shiny::tags$b("Bold"))`. A shiny.element component
#'   given here is absorbed rather than nested. For a scoped slot, write
#'   the template with [template()].
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
el_backtop <- function(
  id = NULL,
  content = NULL,
  target = NULL,
  visibility_height = NULL,
  right = NULL,
  bottom = NULL,
  width = NULL,
  slots = NULL,
  session = NULL
) {
  if (is.null(id)) {
    id <- .el_auto_id("el_backtop")
  }
  ns_id <- .el_ui_id(id, session)

  attrs <- list(
    ":target" = .el_optional_bind("target"),
    ":visibility-height" = .el_optional_bind("visibilityHeight"),
    ":right" = .el_optional_bind("right"),
    ":bottom" = .el_optional_bind("bottom")
  )
  events <- .el_event_bindings(ns_id, "click")
  attrs <- c(attrs, events$attrs)

  el_widget(
    id = ns_id,
    markup = htmltools::tag(
      "el-backtop",
      c(attrs, if (!is.null(content)) list(content))
    ),
    data = list(
      target = .el_or_na(target),
      visibilityHeight = .el_or_na(visibility_height),
      right = .el_or_na(right),
      bottom = .el_or_na(bottom)
    ),
    methods = events$methods,
    width = width,
    slots = slots
  )
}


#' Update Element Plus Back to Top
#'
#' Server-side update for [el_backtop()].
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
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
#' @inheritParams el_backtop
#' @details Every other argument of [el_backtop()] that can change once it is
#'   drawn is an argument here too, under the same name. One left `NULL`
#'   stays as it is; `NA` returns it to Element's default.
#' @export
update_el_backtop <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  visibility_height = NULL,
  right = NULL,
  bottom = NULL,
  target = NULL
) {
  .el_check_session(session)
  ns_id <- session$ns(id)
  msg <- list(id = ns_id)
  if (!is.null(visibility_height)) {
    msg$visibilityHeight <- visibility_height
  }
  if (!is.null(right)) {
    msg$right <- right
  }
  if (!is.null(bottom)) {
    msg$bottom <- bottom
  }
  msg <- c(
    msg,
    .el_update_props(
      "el_backtop",
      Filter(
        Negate(is.null),
        list(
          target = target
        )
      )
    )
  )
  .el_send_update(session, msg)
  invisible(NULL)
}
