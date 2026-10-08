#' Element Plus Splitter Panel
#'
#' One panel of an [el_splitter()].
#'
#' @param ... Its content: any Shiny UI. Components of this package are folded
#'   into this one's Vue instance, as [el_button_group()] folds its buttons.
#' @param id Component ID. Auto-generated if `NULL`.
#' @param size Size of the panel (in pixels or percentage). Element Plus's
#'   `size` (string / number).
#' @param min Minimum size of the panel (in pixels or percentage). Element
#'   Plus's `min` (string / number).
#' @param max Maximum size of the panel (in pixels or percentage). Element
#'   Plus's `max` (string / number).
#' @param resizable Whether the panel can be resized. Element Plus's
#'   `resizable` (boolean).
#' @param collapsible Whether the panel can be collapsed. Element Plus's
#'   `collapsible` (boolean).
#' @param width Component width, as a CSS unit.
#' @param slots Named list of Element slot contents: `start-collapsible`,
#'   `end-collapsible`. A scoped slot is written with [template()].
#'
#' @section Shiny inputs:
#' None: it reports nothing.
#'
#' @return A Shiny UI element.
#' @export
el_splitter_panel <- function(
  ...,
  id = NULL,
  size = NULL,
  min = NULL,
  max = NULL,
  resizable = NULL,
  collapsible = NULL,
  width = NULL,
  slots = NULL
) {
  .el_check_choices("el_splitter_panel", environment())
  if (is.null(id)) {
    id <- .el_auto_id("el_splitter_panel")
  }
  ns_id <- .el_ui_id(id, NULL)
  events <- .el_event_bindings(ns_id, character())
  .el_wrap_widget(
    "el-splitter-panel",
    ns_id,
    list(...),
    props = .el_props(list(
      size = size,
      min = min,
      max = max,
      resizable = resizable,
      collapsible = collapsible
    )),
    events = events,
    width = width,
    slots = slots
  )
}


#' @rdname el_splitter_panel
#' @section Updating from the server:
#' `update_el_splitter_panel()` changes a panel's settings: one inside an
#' [el_splitter()] is folded into the splitter's instance and still answers
#' to its own `id`. One left `NULL` stays as it is; `NA` returns it to
#' Element's default.
#'
#' `update_el_splitter_panel()` is called for its side effect and returns
#' `NULL` invisibly.
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$lock, {
#'     update_el_splitter_panel(session, "side", resizable = !input$lock)
#'   })
#' }
#' @export
update_el_splitter_panel <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  size = NULL,
  min = NULL,
  max = NULL,
  resizable = NULL,
  collapsible = NULL
) {
  .el_check_session(session)
  .el_send_props_update(
    session,
    id,
    "el_splitter_panel",
    list(
      size = size,
      min = min,
      max = max,
      resizable = resizable,
      collapsible = collapsible
    )
  )
}
