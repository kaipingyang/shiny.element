#' Element Plus Splitter
#'
#' Panels side by side, or one above the other, resized by dragging the bars
#'   between them. Give it [el_splitter_panel()]s.
#'
#' @param ... Its content: any Shiny UI. Components of this package are folded
#'   into this one's Vue instance, as [el_button_group()] folds its buttons.
#' @param id Component ID. Auto-generated if `NULL`.
#' @param layout Layout direction of the splitter. Element Plus's `layout`
#'   ('horizontal' | 'vertical').
#' @param lazy Whether to enable lazy mode. Element Plus's `lazy` (boolean).
#' @param width Component width, as a CSS unit.
#' @param slots Named list of Element slot contents. A scoped slot is written
#'   with [template()].
#'
#' @section Shiny inputs:
#' - `input$<id>_resize_start` -- Element Plus's `resize-start` event.
#' - `input$<id>_resize` -- Element Plus's `resize` event.
#' - `input$<id>_resize_end` -- Element Plus's `resize-end` event.
#' - `input$<id>_collapse` -- Element Plus's `collapse` event.
#'
#' @return A Shiny UI element.
#' @examples
#' el_splitter(el_splitter_panel("Left", size = "30%"), el_splitter_panel("Right"))
#' @export
el_splitter <- function(
  ...,
  id = NULL,
  layout = NULL,
  lazy = NULL,
  width = NULL,
  slots = NULL
) {
  .el_check_choices("el_splitter", environment())
  if (is.null(id)) {
    id <- .el_auto_id("el_splitter")
  }
  ns_id <- .el_ui_id(id, NULL)
  events <- .el_event_bindings(
    ns_id,
    c("resize-start", "resize", "resize-end", "collapse"),
    # fires on every step of a drag
    throttle = "resize"
  )
  .el_wrap_widget(
    "el-splitter",
    ns_id,
    list(...),
    props = .el_props(list(
      layout = layout,
      lazy = lazy
    )),
    events = events,
    width = width,
    slots = slots
  )
}
