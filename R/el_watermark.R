#' Element Plus Watermark
#'
#' Text or an image repeated over its content, faintly.
#'
#' @param ... Its content: any Shiny UI. Components of this package are folded
#'   into this one's Vue instance, as [el_button_group()] folds its buttons.
#' @param id Component ID. Auto-generated if `NULL`.
#' @param watermark_width The width of the watermark, the default value of
#'   `content` is its own width. Element Plus's `width` (number).
#' @param height The height of the watermark, the default value of `content`
#'   is its own height. Element Plus's `height` (number).
#' @param rotate When the watermark is drawn, the rotation Angle, unit `°`.
#'   Element Plus's `rotate` (number).
#' @param z_index The z-index of the appended watermark element. Element
#'   Plus's `z-index` (number).
#' @param image Image source, it is recommended to export 2x or 3x image, high
#'   priority. Element Plus's `image` (string).
#' @param content Watermark text content. Element Plus's `content` (`string /
#'   string[]`).
#' @param font Text style. Element Plus's `font`.
#' @param gap The spacing between watermarks. Element Plus's `gap` (`[number,
#'   number]`).
#' @param offset The offset of the watermark from the upper left corner of the
#'   container. The default is `gap/2`. Element Plus's `offset` (`[number,
#'   number]`).
#' @param width Component width, as a CSS unit.
#' @param slots Named list of Element slot contents. A scoped slot is written
#'   with [template()].
#'
#' @section Shiny inputs:
#' None: it reports nothing.
#'
#' @return A Shiny UI element.
#' @examples
#' el_watermark(content = "Confidential", shiny::tags$div(style = "height: 300px"))
#' @export
el_watermark <- function(
  ...,
  id = NULL,
  watermark_width = NULL,
  height = NULL,
  rotate = NULL,
  z_index = NULL,
  image = NULL,
  content = NULL,
  font = NULL,
  gap = NULL,
  offset = NULL,
  width = NULL,
  slots = NULL
) {
  .el_check_choices("el_watermark", environment())
  if (is.null(id)) {
    id <- .el_auto_id("el_watermark")
  }
  ns_id <- .el_ui_id(id, NULL)
  events <- .el_event_bindings(ns_id, character())
  .el_wrap_widget(
    "el-watermark",
    ns_id,
    list(...),
    props = .el_props(
      list(
        watermark_width = watermark_width,
        height = height,
        rotate = rotate,
        z_index = z_index,
        image = image,
        content = content,
        font = font,
        gap = gap,
        offset = offset
      ),
      rename = c(watermark_width = "width")
    ),
    events = events,
    width = width,
    slots = slots
  )
}
