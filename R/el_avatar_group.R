#' Element Plus Avatar Group
#'
#' Avatars overlapping in a row, the overflow collapsed into a count.
#'
#' @param ... Its content: any Shiny UI. Components of this package are folded
#'   into this one's Vue instance, as [el_button_group()] folds its buttons.
#' @param id Component ID. Auto-generated if `NULL`.
#' @param size Control the size of avatars in this avatar-group. Element
#'   Plus's `size` (number / 'large' | 'default' | 'small').
#' @param shape Control the shape of avatars in this avatar-group. Element
#'   Plus's `shape` ('circle' | 'square').
#' @param collapse_avatars Whether to collapse avatars. Element Plus's
#'   `collapse-avatars` (boolean).
#' @param collapse_avatars_tooltip Whether show all collapsed avatars when
#'   mouse hover text of the collapse-avatar. To use this, `collapse-avatars`
#'   must be true. Element Plus's `collapse-avatars-tooltip` (boolean).
#' @param max_collapse_avatars The max avatars number to be shown. To use
#'   this, `collapse-avatars` must be true. Element Plus's
#'   `max-collapse-avatars` (number).
#' @param effect Tooltip theme, built-in theme: `dark` / `light`. Element
#'   Plus's `effect` ('dark' | 'light' / string).
#' @param placement Placement of tooltip. Element Plus's `placement` (enum).
#' @param popper_class Custom class name for tooltip. Element Plus's
#'   `popper-class` (string).
#' @param popper_style Custom style for tooltip. Element Plus's `popper-style`
#'   (string / object).
#' @param collapse_class Custom class name for the collapse-avatar. Element
#'   Plus's `collapse-class` (string).
#' @param collapse_style Custom style for the collapse-avatar. Element Plus's
#'   `collapse-style` (string / object).
#' @param width Component width, as a CSS unit.
#' @param slots Named list of Element slot contents. A scoped slot is written
#'   with [template()].
#'
#' @section Shiny inputs:
#' None: it reports nothing.
#'
#' @return A Shiny UI element.
#' @examples
#' el_avatar_group(
#'   el_avatar(src = "https://example.com/a.png"),
#'   el_avatar("B"),
#'   collapse_avatars = TRUE
#' )
#' @export
el_avatar_group <- function(
  ...,
  id = NULL,
  size = NULL,
  shape = NULL,
  collapse_avatars = NULL,
  collapse_avatars_tooltip = NULL,
  max_collapse_avatars = NULL,
  effect = NULL,
  placement = NULL,
  popper_class = NULL,
  popper_style = NULL,
  collapse_class = NULL,
  collapse_style = NULL,
  width = NULL,
  slots = NULL
) {
  .el_check_choices("el_avatar_group", environment())
  if (is.null(id)) {
    id <- paste0("el_avatar_group_", uuid::UUIDgenerate())
  }
  ns_id <- .el_ui_id(id, NULL)
  events <- .el_event_bindings(ns_id, character())
  .el_wrap_widget(
    "el-avatar-group",
    ns_id,
    list(...),
    props = .el_props(list(
      size = size,
      shape = shape,
      collapse_avatars = collapse_avatars,
      collapse_avatars_tooltip = collapse_avatars_tooltip,
      max_collapse_avatars = max_collapse_avatars,
      effect = effect,
      placement = placement,
      popper_class = popper_class,
      popper_style = popper_style,
      collapse_class = collapse_class,
      collapse_style = collapse_style
    )),
    events = events,
    width = width,
    slots = slots
  )
}
