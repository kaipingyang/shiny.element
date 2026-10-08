#' Element Plus Affix
#'
#' Content that stays fixed to the top or bottom of the viewport once scrolled
#'   to it.
#'
#' @param ... Its content: any Shiny UI. Components of this package are folded
#'   into this one's Vue instance, as [el_button_group()] folds its buttons.
#' @param id Component ID. Auto-generated if `NULL`.
#' @param offset Offset distance. Element Plus's `offset` (number).
#' @param position Position of affix. Element Plus's `position` ('top' |
#'   'bottom').
#' @param target Target container (CSS selector). Element Plus's `target`
#'   (string).
#' @param z_index `z-index` of affix. Element Plus's `z-index` (number).
#' @param teleported Whether affix element is teleported, if `true` it will be
#'   teleported to where `append-to` sets. Element Plus's `teleported`
#'   (boolean).
#' @param append_to Which element the affix element appends to. Element Plus's
#'   `append-to` (CSSSelector / HTMLElement).
#' @param width Component width, as a CSS unit.
#' @param slots Named list of Element slot contents. A scoped slot is written
#'   with [template()].
#'
#' @section Shiny inputs:
#' - `input$<id>_change` -- Element Plus's `change` event.
#' - `input$<id>_scroll` -- Element Plus's `scroll` event.
#'
#' @section Element methods:
#' Callable with [call_el()]: `update()`, `updateRoot()`.
#'
#' @return A Shiny UI element.
#' @examples
#' el_affix(el_button("top", "Stays on top"), offset = 120)
#' @export
el_affix <- function(
  ...,
  id = NULL,
  offset = NULL,
  position = NULL,
  target = NULL,
  z_index = NULL,
  teleported = NULL,
  append_to = NULL,
  width = NULL,
  slots = NULL
) {
  .el_check_choices("el_affix", environment())
  if (is.null(id)) {
    id <- .el_auto_id("el_affix")
  }
  ns_id <- .el_ui_id(id, NULL)
  events <- .el_event_bindings(
    ns_id,
    c("change", "scroll"),
    # fires on every frame of a scroll
    throttle = "scroll"
  )
  .el_wrap_widget(
    "el-affix",
    ns_id,
    list(...),
    props = .el_props(list(
      offset = offset,
      position = position,
      target = target,
      z_index = z_index,
      teleported = teleported,
      append_to = append_to
    )),
    events = events,
    width = width,
    slots = slots
  )
}


#' @rdname el_affix
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @section Updating from the server:
#' `update_el_affix()` changes the component from the server: every argument of
#' [el_affix()] that can change once it is drawn, under the same name. One left
#' `NULL` stays as it is; `NA` returns it to Element's default.
#'
#' `update_el_affix()` is called for its side effect and returns `NULL` invisibly.
#' @export
update_el_affix <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  offset = NULL,
  position = NULL,
  z_index = NULL,
  target = NULL,
  teleported = NULL,
  append_to = NULL
) {
  .el_check_session(session)
  .el_send_props_update(
    session,
    id,
    "el_affix",
    list(
      offset = offset,
      position = position,
      z_index = z_index,
      target = target,
      teleported = teleported,
      append_to = append_to
    )
  )
}
