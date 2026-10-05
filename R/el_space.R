#' Element Plus Space
#'
#' Even spacing between its items, in a row or a column, wrapping if asked.
#'
#' @param ... Its content: any Shiny UI. Components of this package are folded
#'   into this one's Vue instance, as [el_button_group()] folds its buttons.
#' @param id Component ID. Auto-generated if `NULL`.
#' @param alignment Controls the alignment of items. Element Plus's
#'   `alignment` ('center' | 'normal' | 'stretch' | ...).
#' @param direction Placement direction. Element Plus's `direction`
#'   ('vertical' | 'horizontal').
#' @param spacer Spacer. Element Plus's `spacer` (string / number / VNode).
#' @param size Spacing size. Element Plus's `size` (`'default' | 'small' |
#'   'large' / number / [number, number]`).
#' @param wrap Auto wrapping. Element Plus's `wrap` (boolean).
#' @param fill Whether to fill the container. Element Plus's `fill` (boolean).
#' @param fill_ratio Ratio of fill. Element Plus's `fill-ratio` (number).
#' @param width Component width, as a CSS unit.
#' @param slots Named list of Element slot contents. A scoped slot is written
#'   with [template()].
#'
#' @section Shiny inputs:
#' None: it reports nothing.
#'
#' @return A Shiny UI element.
#' @examples
#' el_space(
#'   el_button("a", "One"),
#'   el_button("b", "Two"),
#'   el_button("c", "Three"),
#'   size = 20
#' )
#' @export
el_space <- function(
  ...,
  id = NULL,
  alignment = NULL,
  direction = NULL,
  spacer = NULL,
  size = NULL,
  wrap = NULL,
  fill = NULL,
  fill_ratio = NULL,
  width = NULL,
  slots = NULL
) {
  .el_check_choices("el_space", environment())
  if (is.null(id)) {
    id <- .el_auto_id("el_space")
  }
  ns_id <- .el_ui_id(id, NULL)
  events <- .el_event_bindings(ns_id, character())
  .el_wrap_widget(
    "el-space",
    ns_id,
    list(...),
    props = .el_props(list(
      alignment = alignment,
      direction = direction,
      spacer = spacer,
      size = size,
      wrap = wrap,
      fill = fill,
      fill_ratio = fill_ratio
    )),
    events = events,
    width = width,
    slots = slots
  )
}
