#' Element Plus Scrollbar
#'
#' A scroll area with Element's own thin scrollbars.
#'
#' @param ... Its content: any Shiny UI. Components of this package are folded
#'   into this one's Vue instance, as [el_button_group()] folds its buttons.
#' @param id Component ID. Auto-generated if `NULL`.
#' @param height Height of scrollbar. Element Plus's `height` (string /
#'   number).
#' @param max_height Max height of scrollbar. Element Plus's `max-height`
#'   (string / number).
#' @param native Whether to use the native scrollbar style. Element Plus's
#'   `native` (boolean).
#' @param wrap_style Style of wrap container. Element Plus's `wrap-style`
#'   (string / CSSProperties | CSSProperties[] | string[]).
#' @param wrap_class Class of wrap container. Element Plus's `wrap-class`
#'   (string).
#' @param view_style Style of view. Element Plus's `view-style` (`string /
#'   CSSProperties | CSSProperties[] | string[]`).
#' @param view_class Class of view. Element Plus's `view-class` (string).
#' @param noresize Do not respond to container size changes, if the container
#'   size does not change, it is better to set it to optimize performance.
#'   Element Plus's `noresize` (boolean).
#' @param tag Element tag of the view. Element Plus's `tag` (string).
#' @param always Always show scrollbar. Element Plus's `always` (boolean).
#' @param min_size Minimum size of scrollbar. Element Plus's `min-size`
#'   (number).
#' @param role Role of view. Element Plus's `role` (string).
#' @param aria_label Aria-label of view. Element Plus's `aria-label` (string).
#' @param aria_orientation Aria-orientation of view. Element Plus's
#'   `aria-orientation` ('horizontal' | 'vertical').
#' @param tabindex Tabindex of wrap container. Element Plus's `tabindex`
#'   (number / string).
#' @param distance Trigger end-reached event distance(px). Element Plus's
#'   `distance` (number).
#' @param width Component width, as a CSS unit.
#' @param slots Named list of Element slot contents. A scoped slot is written
#'   with [template()].
#'
#' @section Shiny inputs:
#' - `input$<id>_scroll` -- Element Plus's `scroll` event.
#' - `input$<id>_end_reached` -- Element Plus's `end-reached` event.
#'
#' @section Element methods:
#' Callable with [el_call()]: `handleScroll()`, `scrollTo()`, `setScrollTop()`, `setScrollLeft()`, `update()`.
#'
#' @return A Shiny UI element.
#' @examples
#' el_scrollbar(height = "200px", lapply(1:20, function(i) shiny::tags$p(i)))
#' @export
el_scrollbar <- function(
  ...,
  id = NULL,
  height = NULL,
  max_height = NULL,
  native = NULL,
  wrap_style = NULL,
  wrap_class = NULL,
  view_style = NULL,
  view_class = NULL,
  noresize = NULL,
  tag = NULL,
  always = NULL,
  min_size = NULL,
  role = NULL,
  aria_label = NULL,
  aria_orientation = NULL,
  tabindex = NULL,
  distance = NULL,
  width = NULL,
  slots = NULL
) {
  .el_check_choices("el_scrollbar", environment())
  if (is.null(id)) {
    id <- paste0("el_scrollbar_", uuid::UUIDgenerate())
  }
  ns_id <- .el_ui_id(id, NULL)
  events <- .el_event_bindings(ns_id, c("scroll", "end-reached"))
  .el_wrap_widget(
    "el-scrollbar",
    ns_id,
    list(...),
    props = .el_props(list(
      height = height,
      max_height = max_height,
      native = native,
      wrap_style = wrap_style,
      wrap_class = wrap_class,
      view_style = view_style,
      view_class = view_class,
      noresize = noresize,
      tag = tag,
      always = always,
      min_size = min_size,
      role = role,
      aria_label = aria_label,
      aria_orientation = aria_orientation,
      tabindex = tabindex,
      distance = distance
    )),
    events = events,
    width = width,
    slots = slots
  )
}
